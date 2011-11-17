#!/usr/bin/perl

use strict;

# ���������å�
if ($#ARGV < 0) {
	print "shellscript_tree.pl [file]\n";
	exit;
}

my @file_list = ();
my $f = 0;

#print $ARGV[0]."\n";

#-- �Ƶ��¹� --#
reflexiveFile( $ARGV[0] );

#-------------------------------------------#
#���ǥ��쥯�ȥ��۲�������ɽ��
#-------------------------------------------#
sub reflexiveFile(){
  my $file = shift;
  my $line = "";
#  my @file_list = ();
#  my @ofile = ();


  #-- ����ե������OPEN����1�Ԥ��ĥ��������� --#
  if( -e $file ){
    if( $f == 0 ) {
      print "$file\n";
    } elsif( $f == 1 ) {
      print "��".'��'.$file."\n";
    } else {
      print "��".&getFloreSpace( $f ).'����'.$file."\n";
    }
  } else {
    # File��̵���ä���硢
    if( $f == 0 ) {
      print "$file (File Not Found)\n";
    } elsif( $f == 1 ) {
      print "��".'��'.$file." (File Not Found)\n";
    } else {
      print "��".&getFloreSpace( $f ).'����'.$file." (File Not Found)\n";
    }
    $f--;
    return;
  }

  open( IN, "<$file" ) or die("Can not open file:$file ($!)");
  my @tmp = <IN>;
  foreach $line( @tmp ) {
    if( $line =~ /^#/ ) {
      # ��Ƭ��#�Τ�Τϡ������ȤʤΤ����Ф�
      next;
    }
    #print "$line\n";
    if( $line =~ /\.sh/ ){
      #print "matched\n";
      $f++;
      #my $hoge = &getShellFileName( $line );
      #print "sh found!!--->[$hoge] \n";
      # �ե��������'.sh'�ιԤ����Ĥ��ä����ϡ��ե����������˺Ƶ�Ū�˸ƤӽФ�
      &reflexiveFile( &getShellFileName( $line ) );
    }
  }
  $f--;
  
  return;
}

#-------------------------------------------#
#�����ؿ��Υ��ڡ������ֵ�
#  1���ء�Ⱦ�ѥ��ڡ������
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
#���ե�����̾���ڤ�Ф�
#  ������trim�����Ժ������Τ�
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

