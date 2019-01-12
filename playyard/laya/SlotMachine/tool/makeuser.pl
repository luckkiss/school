#!/usr/bin/perl
use JSON;
use Data::Dumper;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel::FmtUnicode;
use File::Copy ;
use Encode;

####дExcel
##����һ���µ�xls�ļ�����ģ��ֻ�����½���д�����ܶ������ļ������޸�
my $workbook = Spreadsheet::WriteExcel->new('namelist.xls');    
##�½�һ��sheet�������������ڼ���sheet���ƣ������ӣ�Ĭ��Ϊsheet1
my $worksheet = $workbook->add_worksheet();
$worksheet->write(0, 0, decode("cp936", "����"));

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

##�ر�workbook
$workbook->close(); 