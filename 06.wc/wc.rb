#!/bin/sh ruby
def output
  require "optparse"
  options = ARGV.getopts("l")
  generate_files_info.each.with_index do |file_info, i|
    if options["l"]
      printf("%8d", file_info.count("\n")) # 行数の出力
      print " "
      print ARGV[i]
      puts
    else
      printf("%8d", file_info.count("\n")) # 行数の出力
      printf("%8d", file_info.split(/\s+/).size) # 単語数の出力
      printf("%8d", file_info.bytesize) # バイト数の出力
      print " "
      print ARGV[i]
      puts
    end
  end
end

def generate_files_info # コマンド引数の処理
  files_info = []
  if ARGV.find { |a| File.file?(a) } # コマンド引数にファイルパスがあるかどうか
    ARGV.each do |file_path|
      files_info << File.open(file_path).read if File.file?(file_path) # ファイルパスがある場合は、それぞれのパスを配列に格納
    end
  else
    files_info << $stdin.read # ファイルパスがない場合は、標準出力を配列に格納
  end
  files_info
end

output
