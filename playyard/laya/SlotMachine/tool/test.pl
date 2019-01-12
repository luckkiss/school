#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel::FmtUnicode;

####读Excel
my $parser = Spreadsheet::ParseExcel->new();
##对Excel内中文字符进行字符编码指定，防止乱码
my $formatter = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map=>"CP936");    
my $workbook = $parser->parse('namelist.xls', $formatter);
if(!defined $workbook){
    die $parser->error(), "\n";
}

for my $worksheet($workbook->worksheets()){
    ##行号的最小值和最小值
    my ($row_min, $row_max) = $worksheet->row_range();    
    ##列号的最小值和最大值
    my ($col_min, $col_max) = $worksheet->col_range();    

    for my $row ($row_min..$row_max){
        for my $col ($col_min..$col_max){
            my $cell = $worksheet->get_cell($row, $col);
            next unless $cell;

            print "Value=", $cell->value(), "\n";
        }
    }
}