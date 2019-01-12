#!/usr/bin/perl
use JSON;
use Data::Dumper;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel::FmtUnicode;
use File::Copy ;
use Encode;

####写Excel
##创建一个新的xls文件，该模块只能先新建后写，不能对已有文件进行修改
my $workbook = Spreadsheet::WriteExcel->new('namelist.xls');    
##新建一个sheet，可以在括号内加入sheet名称，若不加，默认为sheet1
my $worksheet = $workbook->add_worksheet();
$worksheet->write(0, 0, decode("cp936", "姓名"));

my $pPath = "p";
opendir DH,$pPath or die("ERROR: [main] Son of bitch!\n");
my $cnt = 0;
foreach(readdir DH){    
    $curPath = $pPath."/$_";
    print "$curPath\n";
    if(-f $curPath && $curPath =~ /\d+(.+)\.jpg$/)
    {
        my $name = $1;
        print "get name $name\n";
        $cnt++;
        $worksheet->write($cnt, 0, decode("cp936", $name));
        copy($curPath, "../laya/assets/p/$name.jpg")||warn "could not copy files :$!" ;
    }
}
closedir DH;

##关闭workbook
$workbook->close(); 