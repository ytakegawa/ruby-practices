#!/bin/sh ruby
def output
  require "optparse"
  options = ARGV.getopts("a", "l", "r")
  options["a"] ? files = Dir.glob("*", File::FNM_DOTMATCH) : files = Dir.glob("*")
  files.reverse! if options["r"]
  if options["l"]
    output_file_info(files)
  else
    output_file(files)
  end
end

def output_file(files)
  max_bytesize = 20 #1ファイルの最大表示幅
  # ファイル名のbitesizeによって出力方法を分岐
  if files.all? { |file| file.bytesize <= max_bytesize }
    output_multiple_columns(files) # bitesizeが20未満の場合は、複数列に並べる
  else
    output_single_column(files) # bitesizeが20以上のファイルがある場合は縦一列に並べる
  end
end

def output_multiple_columns(files)
  generate_multiple_columns(files).each do |elements|
    max_bytesize = 20 #1ファイルの最大表示幅
    elements.each do |file|
      print file.ljust(max_bytesize)
    end
    puts
  end
end

def generate_multiple_columns(files)
  columns = 3 # 列数
  rows = (files.size / columns.to_f) # 行数の算出
  rows_round_up = rows.ceil # 小数点を切り上げた行数の算出
  rows_round_down = rows.floor # 小数点を切り捨てた行数の算出

  # 配列の中身を分割するための処理
  # まず、配列の要素数%列数=0でない場合、配列の要素を分割すると、分割した配列内の要素数は２種類に分類されるのでその分類を行う。
  split_array_1 = files.size % columns # ファイル数を行数で割り、余りを算出（配列の要素の分割１種類目）
  split_array_2 = columns - split_array_1 # 行数を余りで引く（配列の要素の分割２種類目）

  split_array_files = []
  # 1種類目の配列の中身の分割
  split_array_1.times do
    split_array_files << files[0, rows_round_up]
    files.shift(rows_round_up)
  end
  # 2種類目の配列の中身の分割
  split_array_2.times do
    split_array_files << files[0, rows_round_down]
    files.shift(rows_round_down)
  end

  # 分割した配列の行列を入れ替えるため、配列内の要素数を合わせる必要がある。よって、要素数に差異がある場合、空の文字列を追加する
  add_empty_object =
    split_array_files.each do |file|
      if file.size < rows_round_up
        number_of_empty_object = rows_round_up - file.size
        number_of_empty_object.times { file << " " }
      end
    end
  # 配列の行列を入れ替える
  add_empty_object.transpose
end

def output_single_column(files)
  puts files
end

def output_file_info(files) # -lオプションが指定された時のファイル出力プログラム
  require "etc"
  puts "total #{files.size}"
  convert_to_file_info(files).each.with_index do |f, i|
    print convert_to_permission(files)[i] + " "
    printf("%3d ", f.nlink)
    print Etc.getpwuid(f.uid).name + " "
    print Etc.getgrgid(f.gid).name + " "
    printf("%5d ", f.size)
    print f.atime.strftime("%a") + " "
    print f.atime.strftime("%d") + " "
    print f.atime.strftime("%k:%M") + " "
    print files[i]
    puts
  end
end

def convert_to_file_info(files)
  files.map { |f| File::Stat.new(Dir.pwd.to_s + "/" + f.to_s) } # File::Statを使ってディレクトリのファイルの情報を配列に組み込む
end

def convert_to_permission(files) # ファイル情報のmode値をファイルの種類とパーミッションの値に変換する
  file_type = { "file" => "-", "directory" => "d", "characterSpecial" => "c", "blockSpecial" => "b", "fifo" => "p", "link" => "l", "socket" => "s" }
  permission_type = { "0" => "---", "1" => "--x", "2" => "-w-", "3" => "-wx", "4" => "r--", "5" => "r-x", "6" => "rw-", "7" => "rwx" }
  convert_to_file_info(files).map do |file|
    array =
      file_type.fetch_values(file.ftype) <<
      file.mode.to_s(8).chars[-3, 3].map do |n| # mode値を配列にしてパーミッションを表す最後から3つ目の値を繰り返し処理する
        permission_type.fetch_values(n).join
      end
    array.join
  end
end

output
