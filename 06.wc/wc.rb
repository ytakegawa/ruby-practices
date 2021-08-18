# frozen_string_literal: true

require "optparse"

def main
  elements = command_arg_or_stdin_to_array.map { |object| build_elements(object) }
  elements.each do |element|
    line = element[:line]
    word = element[:word]
    byte = element[:byte]
    path = File.path(element[:path]) if File.file?(element[:path]) # $stdinの場合filepathが不要なので、path:の値がファイルオブジェクトの場合にpathを表示させる
    display_elements(line, word, byte, path)
  end
  total_calc(elements) if ARGV.size >= 2 # コマンド引数が2つ以上の場合、total値の出力
end

# コマンド引数をファイルオブジェクトにして配列に格納する。標準入力の場合はそのまま格納。
def command_arg_or_stdin_to_array
  array = []
  ARGV.size >= 1 ? ARGV.each { |arg| array << File.open(arg) } : array << $stdin
  array
end

def build_elements(object)
  txt_object = object.read
  {
    line: txt_object.count("\n"),
    word: txt_object.split(/\s+/).size,
    byte: txt_object.bytesize,
    path: object,
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
