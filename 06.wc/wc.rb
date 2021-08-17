# frozen_string_literal: true

require "optparse"

def main
  elements = generate_files_info.map { |file_info| build_elements(file_info) }
  elements.each do |element|
    line = element[:line]
    word = element[:word]
    byte = element[:byte]
    path = File.path(element[:path]) if File.file?(element[:path]) # $stdinの場合pathが不要なので、path:の値がファイルオブジェクトの場合にpathを表示させる
    display_elements(line, word, byte, path)
  end
  total_calc(elements) if ARGV.size >= 2 # コマンド引数が2つ以上の場合、total値の出力
end

# コマンド引数の処理
def generate_files_info
  files_info = []
  ARGV.size >= 1 ? ARGV.each { |file_path| files_info << File.open(file_path) } : files_info << $stdin
  files_info
end

def build_elements(file_info)
  read_file = file_info.read
  {
    line: read_file.count("\n"),
    word: read_file.split(/\s+/).size,
    byte: read_file.bytesize,
    path: file_info,
  }
end

def display_elements(line, word, byte, path)
  options = ARGV.getopts("l")
  print trim_space(line) # 行数の出力
  unless options["l"]
    print trim_space(word) # 単語数の出力
    print trim_space(byte) # バイト数の出力
  end
  print " #{path}" "\n" # ファイルパスの出力
end

def total_calc(elements)
  line = elements.sum { |element| element[:line] }
  word = elements.sum { |element| element[:word] }
  byte = elements.sum { |element| element[:byte] }
  path = "total"
  display_elements(line, word, byte, path)
end

def trim_space(value)
  value.to_s.rjust(8)
end

main
