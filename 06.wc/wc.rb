# frozen_string_literal: true

require 'optparse'
OPTIONS = ARGV.getopts('l')

def main
  elements = generate_files_info.map { |file_info| builde_elements(file_info) }
  elements.each do |element|
    print element[:col].to_s.rjust(8) # 行数の出力
    unless OPTIONS['l']
      print element[:word].to_s.rjust(8) # 単語数の出力
      print element[:byte].to_s.rjust(8) # バイト数の出力
    end
    print " #{element[:path]}" "\n" # ファイルパスの出力
  end
  total_calc(elements) if ARGV.find { |a| File.file?(a) } && ARGV.size >= 2 # total値の出力
end

def builde_elements(file_info)
  read_file = file_info.read
  {
    col: read_file.count("\n"),
    word: read_file.split(/\s+/).size,
    byte: read_file.bytesize,
    path: File.path(file_info)
  }
end

def total_calc(elements)
  total_col = elements.sum { |element| element[:col] }
  total_word = elements.sum { |element| element[:word] }
  total_byte = elements.sum { |element| element[:byte] }
  if OPTIONS['l']
    puts "#{total_col.to_s.rjust(8)} total"
  else
    puts "#{total_col.to_s.rjust(8)}#{total_word.to_s.rjust(8)}#{total_byte.to_s.rjust(8)} total"
  end
end

# コマンド引数の処理
def generate_files_info
  files_info = []
  if ARGV.find { |a| File.file?(a) } # コマンド引数にファイルパスがあるかどうか
    ARGV.each do |file_path|
      files_info << File.open(file_path) if File.file?(file_path) # ファイルパスがある場合は、それぞれのパスを配列に格納
    end
  else
    files_info << $stdin.read # ファイルパスがない場合は、標準出力を配列に格納
  end
  files_info
end

main
