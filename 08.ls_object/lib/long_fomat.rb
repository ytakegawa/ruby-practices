# frozen_string_literal: true

require 'etc'

class LongFormat
  FILE_TYPE = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  MODE_TYPE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_paths)
    @file_paths = file_paths
  end

  def show_files
    file_stats = @file_paths.map { |file_path| create_file_stat(file_path) }
    total_blocks = file_stats.map { |file_stat| file_stat[:blocks] }.sum
    max_size = %i[nlink username grpname bytesize].map do |key|
      find_max_size(file_stats, key)
    end

    puts "total #{total_blocks}"
    file_stats.each do |file_stat|
      print print_file_stat(file_stat, *max_size)
      puts
    end
  end

  private

  def create_file_stat(file_path)
    file_stat = File.stat(file_path)
    {
      path: file_path,
      type: format_file_type(file_stat),
      mode: format_mode_type(file_stat),
      nlink: file_stat.nlink.to_s,
      username: Etc.getpwuid(file_stat.uid).name,
      grpname: Etc.getgrgid(file_stat.gid).name,
      bytesize: file_stat.size.to_s,
      mtime: file_stat.mtime.strftime('%b %e %H:%M'),
      blocks: file_stat.blocks
    }
  end

  def format_file_type(file_stat)
    FILE_TYPE.fetch_values(file_stat.ftype)
  end

  def format_mode_type(file_stat)
    file_stat.mode.to_s(8).chars[-3, 3].map do |f| # mode値を配列にしてパーミッションを表す最後から3つ目の値を繰り返し処理する
      MODE_TYPE.fetch_values(f).join
    end
  end

  def find_max_size(file_stats, key)
    file_stats.map { |file_stat| file_stat[key].size }.max
  end

  def print_file_stat(file_stat, nlink_size, username_size, grpname_size, bytesize_size)
    [
      file_stat[:type],
      file_stat[:mode],
      "  #{file_stat[:nlink].rjust(nlink_size)}",
      " #{file_stat[:username].ljust(username_size)}",
      "  #{file_stat[:grpname].ljust(grpname_size)}",
      "  #{file_stat[:bytesize].rjust(bytesize_size)}",
      " #{file_stat[:mtime]}",
      " #{file_stat[:path]}"
    ].join
  end
end
