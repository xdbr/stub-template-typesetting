require 'rake'
require 'rake/clean'

CLEAN.include FileList['main.*']
CLEAN.exclude 'main.pandoc'
CLEAN.exclude 'main.idx'

directory "tmp"

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

INPUT = 'chapters/*.pandoc'
OUTPUT = 'main.latex'
VERBOSE = ENV['VERBOSE'] || false
PREREQUISITES = [
  # {
  #   name: 'perl module App::pandoc::preprocess',
  #   check: 'perl -MApp::pandoc::preprocess -e1'
  # },
  {
    name: 'pandoc',
    check: 'which pandoc'
  },
  {
    name: 'ditaa',
    check: 'which ditaa'
  },
  {
    name: 'rdfdot',
    check: 'which rdfdot'
  },
  {
    name: 'dot',
    check: 'which dot'
  },
]

namespace :check do
  desc "check prerequisites"
  task :prerequisites do
    PREREQUISITES.each do |prereq|
      verbose(VERBOSE) do
        sh "#{prereq[:check]}" do |ok, status|
          unless ok
            fail "check:prerequisites error: #{prereq[:name]} is not installed or available."
          end
        end
      end
    end
  end
end

namespace :typeset do
  desc "Typeset final"
  task :final => 'tmp' do
    verbose(VERBOSE) do
      cmd = %q[
        perl -i -pe 's{\|}{\/}g' bibliography.bib \
        && cat main.pandoc \
        | gpp \
          -x \
          -U "<#" ">" "\B" "|" ">" "<" ">" "#" "" \
          -DLATEX \
          -DPAGEREFS \
          -DMINITOC \
          -DMAKEINDEX \
          -DSIDENOTES \
          -DPARTS \
        | ppp \
        | pandoc \
          --smart \
          --standalone \
          --number-sections \
          --toc \
          --chapters \
          --toc-depth=2 \
          --bibliography bibliography.bib \
          --variable=lang:ngerman \
          --variable header-includes='\usepackage{sidenotes}' \
          --variable header-includes='\usepackage{makeidx}' \
          --variable header-includes='\usepackage{minitoc}' \
          --variable include-before='\dominitoc' \
          --variable header-includes='\makeindex' \
          --variable documentclass=book \
          --to latex \
          --output ] + %Q[ #{OUTPUT} \\
          && latexmk -xelatex #{OUTPUT} \\
          && makeindex main \\
          && latexmk -xelatex #{OUTPUT} \\
          && latexmk -c #{OUTPUT}
        ]
      # --variable header-includes='\usepackage{etoc}' \
      # --variable header-includes='\counterwithin*{chapter}{part}' \
      # --variable header-includes='\usepackage{chngcntr}' \
      # --variable header-includes='\usepackage{todonotes}' \
      # --variable header-includes='\usepackage{todonotes}' \
      # --variable header-includes='\usetikzlibrary{calc}' \
      # --variable header-includes='\usepackage{tikz}' \
      # --variable header-includes='\usepackage{xcolor}' \
      # --variable header-includes='\usepackage{xkeyval}' \
      # --variable header-includes='\usepackage{ifthen}' \
      # --variable header-includes='\usepackage{graphicx}' \
      puts "Typesetting final version"
      puts "Running cmd: #{cmd}"
      sh cmd do |ok, status|
        fail "error typesetting." unless ok
      end
    end
  end

  desc "Typeset draft"
  task :draft  => 'tmp' do
    verbose(VERBOSE) do
      cmd = %q[
        perl -i -pe 's{\|}{\/}g' bibliography.bib && \
        cat main.pandoc | \
        gpp \
          -x \
          -U "<#" ">" "\B" "|" ">" "<" ">" "#" "" \
          -DLATEX \
          -DPAGEREFS \
          -DMINITOC \
          -DMAKEINDEX \
          -DSIDENOTES \
          -DPARTS | \
        pandoc \
          --smart \
          --standalone \
          --number-sections \
          --toc \
          --chapters \
          --bibliography bibliography.bib \
          --variable=lang:ngerman \
          --variable header-includes='\usepackage{sidenotes}' \
          --variable header-includes='\usepackage{makeidx}' \
          --variable header-includes='\usepackage{minitoc}' \
          --variable header-includes='\makeindex' \
          --variable include-before='\dominitoc' \
          --variable links-as-notes \
          --variable fontsize=10pt,draft \
          --variable documentclass=book \
          --output ] + %Q[ #{OUTPUT} ]
      #     && \\
      #   xelatex #{OUTPUT}
      # ] 
      puts "Typesetting draft version"
      puts "Running cmd: #{cmd}"
      sh cmd do |ok, status|
        fail "error typesetting." unless ok
      end
    end
  end
  desc "Typeset html"
  task :html  => 'tmp' do
    verbose(VERBOSE) do
      cmd = %q[
        perl -i -pe 's{\|}{\/}g' bibliography.bib \
        && cat main.pandoc \
        | gpp \
          -x \
          -U "<#" ">" "\B" "|" ">" "<" ">" "#" "" \
          -DPAGEREFS \
          -DMINITOC \
          -DMAKEINDEX \
          -DSIDENOTES \
          -DPARTS \
        | ppp \
        | pandoc \
          --smart \
          --standalone \
          --number-sections \
          --toc \
          --chapters \
          --css 'http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css' \
          --section-divs \
          --variable include-before='<div class="container container-fluid"><div class="row"><div class="col-md-8">' \
          --variable include-after='</div></div></div>' \
          --toc-depth=2 \
          --bibliography bibliography.bib \
          --to html5 \
          --output main.html ]
      puts "Typesetting html version"
      puts "Running cmd: #{cmd}"
      sh cmd do |ok, status|
        fail "error typesetting." unless ok
      end
    end
  end
end

desc "Open document in PDF viewer"
task :open do
  if OS.mac?
    %x{ open main.pdf }
  elsif OS.linux?
    %x{ ${DISPLAY} main.pdf }
  else
     print "Unable to open Document"
  end
end

desc "Action :typeset"
task :default => ['check:prerequisites', 'typeset:final', 'clean', :open]