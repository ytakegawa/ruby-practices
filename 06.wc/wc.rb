# frozen_string_literal: true

require "optparse"

def main
  elements = generate_files_info.map { |file_info| build_elements(file_info) }
  elements.each do |element|
    line = element[:line]
    word = element[:word]
    byte = element[:byte]
    path = element[:path]
    display_elements(line, word, byte, path)
  end
  total_calc(elements) if ARGV.find { |a| File.file?(a) } && ARGV.size >= 2 # total値の出力
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

def total_calc(elements)
  line = elements.sum { |element| element[:line] }
  word = elements.sum { |element| element[:word] }
  byte = elements.sum { |element| element[:byte] }
  path = "total"
  display_elements(line, word, byte, path)
end

def display_elements(line, word, byte, path) #line, word, byte, path, elements, options
  options = ARGV.getopts("l")
  print format(line) # 行数の出力
  unless options["l"]
    print format(word) # 単語数の出力
    print format(byte) # バイト数の出力
  end
  print " #{path}" "\n" # ファイルパスの出力
end

def format(value)
  value.to_s.rjust(8)
end

main
