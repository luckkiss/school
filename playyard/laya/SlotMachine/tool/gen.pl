#!/usr/bin/perl
use JSON;
use Data::Dumper;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel::FmtUnicode;
use File::Copy ;
use Encode;
open ( FILEHANDLER, "<:encoding(utf-8)", "config.json" ) or die ("Son of bitch!\n");
my @configContents = <FILEHANDLER>;
close FILEHANDLER;
my $configContent = join("\n", @configContents);
my $json = new JSON;
#或以转换字符集 my $json = JSON->new->utf8;
my $json_obj = $json->decode($configContent);
my $outStr = '';
my @allLetters = ('a'..'z');
my %letterMap = ();
for(my $i = 0, $len = @allLetters; $i < $len; $i++) {
    $letterMap{$allLetters[$i]} = $i;
}
my $pswdCnt = @{$json_obj};
$outStr.=pack('C', $pswdCnt);
for(my $i = 0; $i < $pswdCnt; $i++) {
    my $pswd = @{$json_obj}[$i];
    my $pswdLen = length($pswd);
    $outStr.=pack('C', $pswdLen);
    for(my $i = 0; $i < $pswdLen; $i++) {
        my $pswdLetter = substr($pswd, $i, 1);
        $outStr.=pack('C', $letterMap{lc($pswdLetter)});
    }
}
my $parser = Spreadsheet::ParseExcel->new();
my $formatter = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map=>"CP936");
my $workbook = $parser->parse('namelist.xls', $formatter);
if(!defined $workbook){
    die $parser->error(), "\n";
}
my $worksheet = $workbook->worksheet(0);
my ($row_min, $row_max) = $worksheet->row_range();
my ($col_min, $col_max) = $worksheet->col_range();
print "row_max: $row_max\n";
my @stList = ();
my @bossList = ();
$outStr.=pack('I', $row_max);
for my $row (1..$row_max){
    my $cell = $worksheet->get_cell($row, 0);
    next unless $cell;
    # print "Value=", $cell->value(), "\n";
    $outStr.=pack('a9', encode("utf8", decode("CP936", $cell->value())));
    
    $cell = $worksheet->get_cell($row, 1);
    if($cell) {
        my $flag = $cell->value();
        if(0 == $flag) {
            push @stList, $row - 1;
        } elsif(1 == $flag) {
            push @bossList, $row - 1;
        }
    }
}
my $stListCnt = @stList;
$outStr.=pack('C', $stListCnt);
for(@stList){
    $outStr.=pack('C', $_);
}
my $bossListCnt = @bossList;
$outStr.=pack('C', $bossListCnt);
for(@bossList){
    $outStr.=pack('C', $_);
}
open ( OUTFILE, ">", "out.tp" ) or die ("Son of bitch!\n");
binmode OUTFILE;
print OUTFILE $outStr;
close OUTFILE;
open ( CHKFILE, "<", "out.tp" ) or die ("Son of bitch!\n");
my @outContents = <CHKFILE>;
close CHKFILE;
my $outContent = $outContents[0];
my @outRst = unpack("CC${pswdLen}Ia${row_max}", $outContent);
print Dumper(@outRst);
copy("out.tp", "../bin/h5/res/out.tp")||warn "could not copy files :$!" ;