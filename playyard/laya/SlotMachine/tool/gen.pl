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
my $pswdArrRef = $json_obj->{pswd};
my $pswdCnt = @{$pswdArrRef};
$outStr.=pack('C', $pswdCnt);
for(my $i = 0; $i < $pswdCnt; $i++) {
    my $pswd = @{$pswdArrRef}[$i];
    my $pswdLen = length($pswd);
    $outStr.=pack('C', $pswdLen);
    for(my $i = 0; $i < $pswdLen; $i++) {
        my $pswdLetter = substr($pswd, $i, 1);
        $outStr.=pack('C', $letterMap{lc($pswdLetter)});
    }
}
$outStr.=pack('C', $json_obj->{bossLuckyMax});
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
my @allUsers = ();
my @stList = ();
my @bossList = ();
my @must = ();
for my $row (1..$row_max){
    my $nameCell = $worksheet->get_cell($row, 1);
    my $stateCell = $worksheet->get_cell($row, 3);
    next unless $nameCell && $stateCell;
    push @allUsers, encode("utf8", decode("CP936", $nameCell->value()));
    my $state = $stateCell->value();
    if(2 == $state) {
        push @stList, $row - 1;
    } elsif(1 == $state) {
        push @bossList, $row - 1;
    } elsif(3 == $state) {
        push @must, $row - 1;
    }
}
my $allUserCnt = @allUsers;
my $stListCnt = @stList;
my $bossListCnt = @bossList;
my $mustCnt = @must;
my $normalCnt = $allUserCnt - $stListCnt - $bossListCnt;
$outStr.=pack('C', $normalCnt);
$outStr.=pack('I', $allUserCnt);
for(@allUsers) {
    $outStr.=pack('a9', $_);
}
$outStr.=pack('C', $stListCnt);
for(@stList){
    $outStr.=pack('C', $_);
}
$outStr.=pack('C', $bossListCnt);
for(@bossList){
    $outStr.=pack('C', $_);
}
$outStr.=pack('C', $mustCnt);
for(@must){
    $outStr.=pack('C', $_);
}
print "allUserCnt: $allUserCnt, stListCnt: $stListCnt, bossListCnt: $bossListCnt\n";
open ( OUTFILE, ">", "out.tp" ) or die ("Son of bitch!\n");
binmode OUTFILE;
print OUTFILE $outStr;
close OUTFILE;
open ( CHKFILE, "<", "out.tp" ) or die ("Son of bitch!\n");
my @outContents = <CHKFILE>;
close CHKFILE;
copy("out.tp", "../bin/h5/res/out.tp")||warn "could not copy files :$!" ;