use Data::Dumper;
use Encode;
use File::Basename;
use HTML::LinkExtor;
use LWP::Simple;
use POSIX;

use utf8;
use encoding "utf8", STDOUT => 'gbk';

my ($_pageUrl, $_indexName, $_savePath, $_logFile) = @ARGV;

# 抓取记录
my $codeListUrl = 'http://quote.eastmoney.com/stocklist.html';
# 取出根目录
$root=~s/\Q$_indexName\E$//;
# 根据根目录设置保存目录
my $saveRootPath=$root;
$saveRootPath=~s/^http(?:s?):\/\/[^\/]+/$_savePath/;

# 开始抓取主页
my $hour_min_sec=strftime("%H:%M:%S",localtime());
logText("[$hour_min_sec] 开始抓取...\n");
extractPage($root, $_pageUrl);

# 显示扫描结果
$hour_min_sec=strftime("%H:%M:%S",localtime());
logText("[$hour_min_sec] 抓取结束！\n");

# 写日志文件
open ( LOGFILE, ">", "$_logFile" ) or die ("ERROR: [main] Can't open $_logFile - $!\n");
binmode LOGFILE, ':utf8';
print LOGFILE @logContent;
close LOGFILE;

exit 0;

sub extractPage
{
	my ($inFilePath, $subPathUrl) = @_;
	my $crtUrl = $subPathUrl;
	if($crtUrl=~/^\/\//)
	{
	  $crtUrl = 'http:'.$crtUrl;
	}
	else
	{
	  if($_pageUrl ne $subPathUrl)
  	{
  		my $realSubUrl=$subPathUrl;
  		if($subPathUrl=~/^\//)
  		{
  			# /开头表示是从根目录开始
  			$crtUrl=$root;			
  		}
  		else
  		{
  			my $preCnt=0;
  			while($realSubUrl=~s/^\.\.\///)
  			{
  				# 回溯到上级目录
  				$preCnt++;
  			}
  			$crtUrl = $inFilePath;
  			if($preCnt>0)
  			{
  				$crtUrl=~s/(?:[^\/]+\/){$preCnt}$//;
  			}
  			if($crtUrl!~/\/$/)
  			{
  				$crtUrl.="\/";
  			}
  		}
  		$realSubUrl=~s/^\///;
  		$crtUrl.=$realSubUrl;
  	}
	}
	
	if($grabHash{$crtUrl})
	{
		return;
	}
	$grabHash{$crtUrl}=1;
	logText("[$hour_min_sec] 正在抓取页面：$crtUrl...\n");
	
	# 保存当前网页
	my $savePath;
	if($_pageUrl eq $subPathUrl)
	{
		$savePath="index.html";
	}
	else
	{
		$savePath=$subPathUrl;
	}
	
	# 计算出保存路径
	my $saveFilePath=$saveRootPath;
	if($saveFilePath!~/\/$/)
	{
		$saveFilePath.="\/";
	}
	# 去掉开头的斜杠
	$savePath=~s/^\///;
	# 去掉结尾的?参数
	$savePath=~s/\?.*$//;
	$saveFilePath.=$savePath;
	# 检查目录
	my($saveFileName, $saveFileOnlyPath, $saveFileSuffix)=fileparse($saveFilePath);
	if(!(-e $saveFileOnlyPath))
	{
		$saveFileOnlyPath=~s/\//\\/g;
		`mkdir $saveFileOnlyPath`
	}
	
	# 请求并保存文件
	$status = getstore($crtUrl, $saveFilePath);
	unless(is_success($status))
	{
		logText("[GETSTORE] $crtUrl, in $inFilePath, as $subPathUrl\n");
		return;
	}
	
	# 对于文本类型的文件解析其内容
	if($_pageUrl ne $subPathUrl && 0==isTextUrl($crtUrl))
	{
		return;
	}
	
	logText("[PROFILE] $saveFilePath\n");
	open ( THSIFILE, "<", "$saveFilePath" ) or die ("ERROR: [extractPage] Can't open $saveFilePath - $!\n");
	my @thisFileContent=<THSIFILE>;
	$html = join("", @thisFileContent);
	#$html = do { local $/; <THSIFILE>; };
	close THSIFILE;
	
	if($crtUrl=~/\.(?:css)(?:(?:\?|\#).*)?$/)
	{
	  # CSS文件中的url无法抓出，自己写方法
	  while($html=~/url\((.*)\)/g)
	  {
	    extractPage($crtPath, $1);
	  }
	}
	else
	{
	  $link_extor = HTML::LinkExtor->new();
  	$link_extor->parse($html);
  	
  	# 继续处理子链接页面
  	# 首先获取当前文件所在的路径
  	my $crtPath=$crtUrl;
  	$crtPath=~s/[^\/]*$//;
  	my @subLinks = $link_extor->links();
  	foreach(@subLinks)
  	{	
  		my $linkTag = @$_[0];
  		my $linkUrl = @$_[2];
  		if($linkUrl=~/http(?:s?):\/\//)
  		{
  			#logText("[SKIPPED HTTP] $linkUrl\n");
  			next;
  		}
  		if($linkTag eq "a" && $linkUrl=~/^javascript:/)
  		{
  			#logText("[SKIPPED JS] $linkUrl\n");
  			next;
  		}
  		if($linkTag eq "object")
  		{
  			#logText("[SKIPPED OBJ] $linkUrl\n");
  			next;
  		}
  		if(0==isFileUrl($linkUrl))
  		{
  			logText("[SKIPPED TYPE] $linkUrl\n");
  			next;
  		}
  		extractPage($crtPath, $linkUrl);
  	}
	}
}

sub isTextUrl()
{
	my ($thisUrl) = @_;
	if($thisUrl=~/\.(?:html|htm|shtml|shtm|xhtml|dhtml|asp|aspx|jsp|php|cgi|css|js)(?:(?:\?|\#).*)?$/)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub isFileUrl()
{
	my ($thisUrl) = @_;
	if($thisUrl=~/\.\w+(?:(?:\?|\#).*)?$/)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

##
# 保存网页文件
##
sub saveFile
{
	my ($savePath, $content) = @_;
	my $saveFilePath=$saveRootPath;
	if($saveFilePath!~/\/$/)
	{
		$saveFilePath.="\/";
	}
	# 去掉开头的斜杠
	$savePath=~s/^\///;
	# 去掉结尾的?参数
	$savePath=~s/\?.*$//;
	$saveFilePath.=$savePath;
	# 检查目录
	my($fileName, $path, $suffix)=fileparse($saveFilePath);
	if(!(-e $path))
	{
		$path=~s/\//\\/g;
		`mkdir $path`
	}
	
	open ( OUTFILE, ">", "$saveFilePath" ) or die ("ERROR: [saveFile] Can't open $saveFilePath - $!\n");
	binmode OUTFILE, ':utf8';
	print OUTFILE $content;
	close OUTFILE;
}

sub logText
{
	my ($text)=@_;
	print $text;
	push(@logContent, $text);
}