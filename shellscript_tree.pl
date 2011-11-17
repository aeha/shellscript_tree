#!/usr/bin/perl

use strict;

# 引数チェック
if ($#ARGV < 0) {
	print "shellscript_tree.pl [file]\n";
	exit;
}

my @file_list = ();
my $f = 0;

#print $ARGV[0]."\n";

#-- 再帰実行 --#
reflexiveFile( $ARGV[0] );

#-------------------------------------------#
#■ディレクトリ配下を全て表示
#-------------------------------------------#
sub reflexiveFile(){
  my $file = shift;
  my $line = "";
#  my @file_list = ();
#  my @ofile = ();


  #-- 指定ファイルをOPENし、1行ずつサーチする --#
  if( -e $file ){
    if( $f == 0 ) {
      print "$file\n";
    } elsif( $f == 1 ) {
      print "├".'−'.$file."\n";
    } else {
      print "｜".&getFloreSpace( $f ).'└−'.$file."\n";
    }
  } else {
    # Fileが無かった場合、
    if( $f == 0 ) {
      print "$file (File Not Found)\n";
    } elsif( $f == 1 ) {
      print "├".'−'.$file." (File Not Found)\n";
    } else {
      print "｜".&getFloreSpace( $f ).'└−'.$file." (File Not Found)\n";
    }
    $f--;
    return;
  }

  open( IN, "<$file" ) or die("Can not open file:$file ($!)");
  my @tmp = <IN>;
  foreach $line( @tmp ) {
    if( $line =~ /^#/ ) {
      # 先頭が#のものは、コメントなので飛ばす
      next;
    }
    #print "$line\n";
    if( $line =~ /\.sh/ ){
      #print "matched\n";
      $f++;
      #my $hoge = &getShellFileName( $line );
      #print "sh found!!--->[$hoge] \n";
      # ファイル中に'.sh'の行が見つかった場合は、ファイルを引数に再帰的に呼び出し
      &reflexiveFile( &getShellFileName( $line ) );
    }
  }
  $f--;
  
  return;
}

#-------------------------------------------#
#■階層数のスペースを返却
#  1階層：半角スペース二つ
#-------------------------------------------#
sub getFloreSpace(){
  my $flore = shift;
  my $ret_str = "";
  
  for( my $i = 0; $i < $flore; $i++ ){
    $ret_str .= "  ";
  }
  
  return $ret_str;
}

#-------------------------------------------#
#■ファイル名を切り出し
#  現状はtrim・改行削除するのみ
#-------------------------------------------#
sub getShellFileName(){
  my $file_name = shift;
  #print "getShellFileName $file_name\n";

#  $file_name = chomp( $file_name );
  #$file_name =~ s/^\s*(.*?)\s*$/$1/; 
  $file_name =~ s/\r//;
  $file_name =~ s/\n//;
  
#  $file_name =~ /\/(.*\.sh)/;
  $file_name =~ /(\/.*)*\/(.*?\.sh)/;
  $file_name = $2;
  
#  print "$1\n";
  
  return $file_name;
}

