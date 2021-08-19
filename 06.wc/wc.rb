# frozen_string_literal: true

require "optparse"

def main
  options = ARGV.getopts("l")
  values = read_texts.map { |text_file| build_value(text_file) }
  values.each do |value|
    line = value[:line]
    word = value[:word]
    byte = value[:byte]
    path = value[:path]
    display_value(line, word, byte, path, options)
  end
  calc_total_num(values, options) if ARGV.size >= 2
end

def read_texts
  ARGV.size >= 1 ? ARGV.map { |path| [File.read(path), path] } : [[$stdin.read]]
end

def build_value(text_file)
  {
    line: text_file[0].count("\n"),
    word: text_file[0].split(/\s+/).size,
    byte: text_file[0].bytesize,
    path: text_file[1],
  }
end

def display_value(line, word, byte, path, options)
  print format_value(line) # 行数の出力
  unless options["l"]
    print format_value(word) # 単語数の出力
    print format_value(byte) # バイト数の出力
  end
  print " #{path}" "\n" # ファイルパスの出力
end

def format_value(value)
  value.to_s.rjust(8)
end

def calc_total_num(file_value, options)
  total_line = file_value.sum { |element| element[:line] }
  total_word = file_value.sum { |element| element[:word] }
  total_byte = file_value.sum { |element| element[:byte] }
  path = "total"
  display_value(total_line, total_word, total_byte, path, options)
end

main
