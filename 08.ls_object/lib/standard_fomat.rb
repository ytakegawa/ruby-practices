# frozen_string_literal: true

class StandardFomat
  def initialize(file_paths, column_num)
    @file_paths = file_paths
    @column_num = column_num
  end

  def show_files
    row_num = (@file_paths.size / @column_num.to_f).ceil
    max_length = @file_paths.max.size
    lines = Array.new(row_num) { [] }
    @file_paths.each_with_index do |path, i|
      line_num = i % row_num
      lines[line_num].push(path.ljust(max_length + 6)) # 6はfile間のスペースの数。
    end
    lines.each { |line| puts line.join }
  end
end
