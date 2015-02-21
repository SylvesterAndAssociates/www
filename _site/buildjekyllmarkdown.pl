#!/usr/bin/env perl

use strict;
use warnings;
use File::Find;
use HTML::TreeBuilder;
use Cwd;
use v5.10;
use HTML::PrettyPrinter;
use XML::LibXML;
use HTML::Tidy;
#use XML::LibXML::PrettyPrint;
use XML::LibXML::PrettyPrint qw(print_xml);
#my $tidy = HTML::Tidy->new();
#$tidy->ignore( type => TIDY_WARNING, type => TIDY_INFO );
#$tidy->ignore( text => qr/DOCTYPE/ );
#my $hpp = new HTML::PrettyPrinter ('linelength' => 130,
                                     #'uppercase' => 1,
                                     #'quote_attr' => 1);
#$hpp->allow_forced_nl(2);
#$hpp->set_nl_before(2,qw(body table));
#$hpp->set_nl_after(2,qw(table));
#$hpp->set_nl_before(2,qw(div));
#$hpp->set_nl_after(2,qw(div));
#$hpp->set_force_nl(2,qw(body head div));             # for tags
#$hpp->set_force_nl(2,qw(@SECTIONS));             # as above
#$hpp->set_nl_inside(2,'default!');
my $parser = XML::LibXML->new();
#@ARGV = qw(.) unless @ARGV;
my @DIRLIST = qw( en zh );

sub process_file {
    my $file = $_;
    my $cwd = getcwd;
    if ($file =~ /\.html$/) {
        #print "$cwd/$file\n";
        my $newmarkdownfile = "$file";
        $newmarkdownfile =~ s/html$/md/;
        say $newmarkdownfile;
        # $root = HTML::TreeBuilder->new_from_file( $file );
        my $root = HTML::TreeBuilder->new( );
        my $success = $root->parse_file( $file );
        my $title = '';
        my $body = '';
        my $background = '';
        #my $rootarray_ref = $hpp->format($root);
        #print @$rootarray_ref;
        #say "success = $success";
        #my @selectDivs = $root->look_down( _tag => 'table', class => 'contentpaneopen');
        #foreach my $node (@selectDivs) {
            #say $node->as_text;
        #}
        my @backgroundUrlDiv = $root->look_down( _tag => 'div');
        foreach my $node (@backgroundUrlDiv) {
            my $dom = $parser->load_html(string => $node->as_HTML);
            my $pp = XML::LibXML::PrettyPrint->new_for_html(indent_string => "  ");
            $pp->pretty_print($dom); # modified in-place
            my $string3 = $dom->toString;
            $string3 =~ s/<\?xml version="1.0"\?>\n//g;
            #say "$string3";
            my @strings = split("\n", $string3);
            my @grepped = grep(/background:\ url/, @strings);
            foreach my $line (@grepped) {
              # say $line . "\n";
              my @strings1 = split(" ", $line);
              my @grepped1 = grep(/url/, @strings1);
              foreach my $line1 (@grepped1) {
                $line1 =~ s/^url\('//;
                $line1 =~ s/'\)$//;
                #say $line1 . "\n";
                $background = $line1;
              }
            }


        }
        my @contentheading = $root->look_down( _tag => 'td', class => 'contentheading');
        foreach my $node (@contentheading) {
            #say $node->as_text;
            my $dom = $parser->load_html(string => $node->as_HTML);
            my $pp = XML::LibXML::PrettyPrint->new_for_html(indent_string => "  ");
            $pp->pretty_print($dom); # modified in-place
            my $string3 = $dom->toString;
            $string3 =~ s/<\?xml version="1.0"\?>\n//g;
            #say "$string3";
            $title = $node->as_text;
            #my @strings = split("\n", $string3);
            #my @grepped = grep(/<td/, @strings);
            #foreach my $line (@grepped) {
              #$body .= $line . "\n";
            #}
        }
        my @contentimg = $root->look_down( _tag => 'div', class => 'staff_img');
        foreach my $node (@contentimg) {
            #say $node->as_HTML;
          # format the source
          #my $noderoot = HTML::TreeBuilder->new_from_content($node->as_HTML );
          #my $linearray_ref = $hpp->format($node);
          #print @$linearray_ref;
          #my $dom = $parser->load_html(string => $node->as_HTML);
          my $dom = $parser->load_xml(string => $node->as_HTML);
          my $pp = XML::LibXML::PrettyPrint->new_for_html(indent_string => "  ");
          $pp->pretty_print($dom); # modified in-place
          my $string2 = $dom->toString;
          $string2 =~ s/<\?xml version="1.0"\?>\n//g;
          #say $string2;
          $body .= $string2 . "\n";
          #print_xml $node->as_HTML;
          #say $tidy->clean( $node->as_HTML );
          #$tidy->parse( my $testnode, $node->as_HTML );
          #for my $message ( $tidy->messages ) {
              #print $message->as_string;
          #}

        }
        my @contentpaneopen = $root->look_down( _tag => 'table', class => 'contentpaneopen');
        foreach my $node (@contentpaneopen) {
          #say $node->as_text;
            my @ptags = $node->look_down( _tag => 'p' );
            foreach my $ptag (@ptags) {
                #say $ptag->as_text;
                $body .= "\n";
                $body .= $ptag->as_text . "\n";
            }
            $body .= "\n";
        }
        $root->delete();
        my $str = '';
        $str .= '---' . "\n";
        $str .= "    title: $title" . "\n";
        $str .= "    layout: default" . "\n";
        $str .= "    background_url: $background" . "\n";
        $str .= '---' . "\n";
        $str .= $body . "\n";
        open FILE, ">$cwd/$newmarkdownfile" or die $!;
        print FILE $str;
        close FILE;
        say $str;
    }
}
#find(\&process_file, @ARGV);
find(\&process_file, @DIRLIST);
