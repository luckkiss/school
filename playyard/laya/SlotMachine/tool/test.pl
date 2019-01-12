#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel::FmtUnicode;

####��Excel
my $parser = Spreadsheet::ParseExcel->new();
##��Excel�������ַ������ַ�����ָ������ֹ����
my $formatter = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map=>"CP936");    
my $workbook = $parser->parse('namelist.xls', $formatter);
if(!defined $workbook){
    die $parser->error(), "\n";
}

for my $worksheet($workbook->worksheets()){
    ##�кŵ���Сֵ����Сֵ
    my ($row_min, $row_max) = $worksheet->row_range();    
    ##�кŵ���Сֵ�����ֵ
    my ($col_min, $col_max) = $worksheet->col_range();    

    for my $row ($row_min..$row_max){
        for my $col ($col_min..$col_max){
            my $cell = $worksheet->get_cell($row, $col);
            next unless $cell;

            print "Value=", $cell->value(), "\n";
        }
    }
}