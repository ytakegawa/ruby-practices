# frozen_string_literal: true

require "optparse"

def main
  options = ARGV.getopts("l")
  values = read_texts.map { |text_file| build_values(text_file) }
  values.each do |value|
    line, word, byte, path = %i[line word byte path].map { |key| value[key] }
    display_values(line, word, byte, path, options)
  end
  calc_total_num(values, options) if ARGV.size >= 2
end

def read_texts
  ARGV.size >= 1 ? ARGV.map { |path| [File.read(path), path] } : [[$stdin.read]]
end

def build_values(text_file)
  {
    line: text_file[0].count("\n"),
    word: text_file[0].split(/\s+/).size,
    byte: text_file[0].bytesize,
    path: text_file[1],
  }
end

def display_values(line, word, byte, path, options)
  print format_value(line)
  unless options["l"]
    print format_value(word)
    print format_value(byte)
  end
  puts " #{path}"
end

def format_value(value)
  value.to_s.rjust(8)
end

def calc_total_num(values, options)
  total_line, total_word, total_byte = %i[line word byte].map { |key| values.sum { |value| value[key] } }
  path = "total"
  display_values(total_line, total_word, total_byte, path, options)
end

main
