use Data::Dumper;
use Encode;
use File::Basename;
use File::Path;
use POSIX;
use XML::Simple;

use utf8;
#use encoding "utf8", STDOUT => 'gbk';    # 多线程的print会报错，故注释掉

my ($arg_jsPath, $arg_printLog, $arg_logPath) = @ARGV;

# 检查参数 - 代码源路径
(defined $arg_jsPath) or die('ERROR: [main] arg_jsPath not defined!');
(-e $arg_jsPath) or die("ERROR: [main] $arg_jsPath not exist!");

my $hour_min_sec = strftime("%H:%M:%S", localtime());
print "[$hour_min_sec] start confusing, please wait...\n";

# 检查参数 - log文件路径
if(not defined $arg_logPath) {
    -e 'log' or mkdir 'log';
    $arg_logPath = 'log\\log'.strftime("%Y%m%d%H%M%S", localtime()).'.log';
}

# 打开log文件准备写入
open ( LOGFILE, ">", "$arg_logPath" ) or die ("ERROR: [main] Can't open $arg_logPath - $!\n");
binmode LOGFILE, ':utf8';

my $logContent = '';

# 打开文件并逐行扫描
open ( INFILE, '<:encoding(utf-8)', $arg_jsPath ) or die ("ERROR: [main] Can't open $arg_jsPath - $!\n");
my @contents=<INFILE>;
close INFILE;

my $lineCnt = scalar(@contents);
for(my $i = 0; $i < $lineCnt; $i++) {
    my $line = $contents[$i];
    my $lineNum = $1 + 1;
    tlog("($lineNum/$lineCnt)\n");
    # 先对字符串进行保护替换
    my $savedStringCnt = 0;
    my @savedStringList = ();
    while($line =~ s/((['"])(\\\2|.)*?\2)/___STRING$savedStringCnt/) {
        $savedStringCnt++;
        push @savedStringList, $1;
    }
    
    # 提取函数名并替换
    
}

my @rdnStrArr = ();
my %rdnStrMap = ();
my @rdnStrLen = 3;
buildRandom();
$hour_min_sec = strftime("%H:%M:%S", localtime());
tlog("[$hour_min_sec] random string list built.\n");

my @noConfusedList = ('break', 'else', 'new', 'var', 'case', 'finally' , 'return', 'void' , 'catch'  , 'for'  , 'switch' , 'while' , 'continue', 'function'  , 'this' , 'with' , 'default' , 'if' , 'throw' , 'delete' , 'in' , 'try' , 'do' , 'instranceof', 'typeof', 'abstract' , 'enum'   , 'int' , 'short' , 'boolean'  , 'export'  , 'interface', 'static', 'byte'  , 'extends' , 'long' , 'super' , 'char' , 'final'  , 'native'  , 'synchronized' , 'class'  , 'float' , 'package'  , 'throws' , 'const'  , 'goto'  , 'private' , 'transient' , 'debugger' , 'implements'  , 'protected' , 'volatile' , 'double'  , 'import'  , 'public');

# 提取字符串进行保护避免被混淆
my @savedStringList = ();
my $savedStringCnt = 0;

$textContent = join "\n", @contents;
my $outPath = $arg_jsPath;
$outPath =~ s/\.js$/.sim.js/;
open ( OUTFILE, '>', $outPath ) or die ("ERROR: [main] Can't open $outPath - $!\n");
binmode OUTFILE, ':utf8';
print OUTFILE $textContent;
close OUTFILE;


# 写日志
print LOGFILE $logContent;
close LOGFILE;

$hour_min_sec=strftime("%H:%M:%S", localtime());
print "[$hour_min_sec] Confusion finished!\n";

exit 0;

sub getRandomStr
{
    my ($src) = @_;
    
    my $rndStr = $src;
    if(exists $rdnStrMap{$src}) {
        $rndStr = $rdnStrMap{$src};
    } else {
        my $arrLen = scalar(@rdnStrArr);
        print "arrLen = $arrLen\n";
        if($arrLen > 0) {
            my $rndIdx = int(rand($arrLen));
            $rndStr = $rdnStrArr[$rndIdx];
            splice @rdnStrArr, $rndIdx, 1;
            $rdnStrMap{$src} = $rndStr;
        }
    }
    return $rndStr;
}

sub buildRandom
{
    my @preDataSource = ('a'..'z', 'A'..'Z', '_');
    my @dataSource = (0..9, 'a'..'z', 'A'..'Z', '_');
    foreach my $pp1 (@preDataSource) {
        foreach my $pp2 (@dataSource) {
            my $s = $pp1.$pp2;
            foreach my $pp3 (@dataSource) {
                push @rdnStrArr, $s.$pp3;
            }
        }
    }
}

sub lcFirst
{
    my ($str) = @_;
    my $first = substr($str, 0, 1);
    my $end = substr($str, 1);
    return lc($first).$end;
}

sub tlog
{
    my $logText = shift;
    $logContent.=$logText;
    1 == $arg_printLog and print $logText;
}