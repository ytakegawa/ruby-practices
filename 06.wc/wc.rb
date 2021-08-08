# frozen_string_literal: true
# !/bin/sh ruby
require "optparse"
OPTIONS = ARGV.getopts("l")

def main
  output
  total_calc if ARGV.find { |a| File.file?(a) } && ARGV.size >= 2
end

def output
  generate_files_info.map.with_index do |file_info, i|
    if OPTIONS["l"]
      print file_info.count("\n").to_s.rjust(8) # 行数の出力
      print " #{ARGV[i]}" "\n"
    else
      print file_info.count("\n").to_s.rjust(8) # 行数の出力
      print file_info.split(/\s+/).size.to_s.rjust(8) # 単語数の出力
      print file_info.bytesize.to_s.rjust(8) # バイト数の出力
      print " #{ARGV[i]}" "\n"
    end
  end
end

def total_calc
  total_col = 0
  total_word = 0
  total_byte = 0
  generate_files_info.map do |file_info|
    total_col += file_info.count("\n")
    total_word += file_info.split(/\s+/).size
    total_byte += file_info.bytesize
  end
  if OPTIONS["l"]
    puts "#{total_col.to_s.rjust(8)} total"
  else
    puts "#{total_col.to_s.rjust(8)}#{total_word.to_s.rjust(8)}#{total_byte.to_s.rjust(8)} total"
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

main
