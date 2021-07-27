#!/bin/sh ruby
def generate
  require "optparse"
  options = ARGV.getopts("l")
  process_command_arguments.each.with_index do |info, i|
    if options["l"]
      printf("%8d", info.count("\n")) # 行数の出力
      print " "
      print ARGV[i]
      puts
    else
      printf("%8d", info.count("\n")) # 行数の出力
      printf("%8d", info.split(/\s+/).size) # 単語数の出力
      printf("%8d", info.bytesize) # バイト数の出力
      print " "
      print ARGV[i]
      puts
    end
  end
end

def process_command_arguments # コマンド引数の処理
  file_contents = []
  if ARGV.find { |a| File.file?(a) } # コマンド引数にファイルパスがあるかどうか
    ARGV.each do |file|
      file_contents << File.open(file).read if File.file?(file) # ファイルパスがある場合は、それぞれのパスを配列に格納
    end
  else
    file_contents << $stdin.read # ファイルパスがない場合は、標準出力を配列に格納
  end
  file_contents
end

generate
