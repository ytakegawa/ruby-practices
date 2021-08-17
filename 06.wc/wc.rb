# frozen_string_literal: true

require "optparse"

def main
  options = ARGV.getopts("l")
  elements = generate_files_info.map { |file_info| build_elements(file_info) }
  elements.each do |element|
    print format(element[:line]) # 行数の出力
    unless options["l"]
      print format(element[:word]) # 単語数の出力
      print format(element[:byte]) # バイト数の出力
    end
    print " #{element[:path]}" "\n" # ファイルパスの出力
  end
  total_calc(elements, options) if ARGV.find { |a| File.file?(a) } && ARGV.size >= 2 # total値の出力
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

def build_elements(file_info)
  read_file = file_info.read
  {
    line: read_file.count("\n"),
    word: read_file.split(/\s+/).size,
    byte: read_file.bytesize,
    path: File.path(file_info),
  }
end

def total_calc(elements, options)
  total_line = elements.sum { |element| element[:line] }
  total_word = elements.sum { |element| element[:word] }
  total_byte = elements.sum { |element| element[:byte] }
  if options["l"]
    puts "#{format(total_line)} total"
  else
    puts "#{format(total_line)}#{format(total_word)}#{format(total_byte)} total"
  end
end

def format(value)
  value.to_s.rjust(8)
end

main
