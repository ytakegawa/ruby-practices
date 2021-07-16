def generate(files)
  max_bitesize = 20 #1ファイルの最大表示幅
  # ファイル名のbitesizeによって出力方法を分岐
  if files.all? { |file| file.bytesize <= max_bitesize }
    multiple_column_output(files) # bitesizeが20未満の場合は、複数列での表示にする。
  else
    single_column_output(files) # bitesizeが20以上のファイルがある場合は縦一列に並べるように分岐させる
  end
end

def multiple_column_output(files)
  max_bitesize = 20 #1ファイルの最大表示幅
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
  transposition_files = add_empty_object.transpose

  # 配列を出力する
  transposition_files.each do |file|
    file.each do |f|
      space = " " * (max_bitesize - f.bytesize)
      print f + space
    end
    puts
  end
end

def single_column_output(files)
  files.each { |file| puts file }
end

# -lオプションが指定された時のファイル出力プログラム
def file_info_generate(files)
  require "etc"
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

# File::Statを使ってディレクトリのファイルの情報を配列に組み込む
def convert_to_file_info(files)
  files.map { |f| File::Stat.new(Dir.pwd.to_s + "/" + f.to_s) }
end

# ファイル情報のmode値をファイルの種類とパーミッションの値に変換する
def convert_to_permission(files)
  permission = []
  convert_to_file_info(files).each do |file|
    file_name_array = file.mode.to_s(8).chars
    file_name_array.unshift("0") if file.mode.to_s(8).size < 6 # mode値が６未満の場合、配列の先頭に0を加える
    file_name_array_slice = file_name_array.each_slice(3).to_a
    permission <<
      case file_name_array_slice[0] # ファイルの種類への変換
      when ["0", "1", "0"]
        ["p"]
      when ["0", "2", "0"]
        ["c"]
      when ["0", "4", "0"]
        ["d"]
      when ["0", "6", "0"]
        ["b"]
      when ["1", "0", "0"]
        ["-"]
      when ["1", "2", "0"]
        ["l"]
      when ["1", "4", "0"]
        ["s"]
      end
    permission <<
    file_name_array_slice[1].map do |f| # パーミッション値への変換
      case f
      when "0"
        "---"
      when "1"
        "--x"
      when "2"
        "-w-"
      when "3"
        "-wx"
      when "4"
        "r--"
      when "5"
        "r-x"
      when "6"
        "rw-"
      when "7"
        "rwx"
      end
    end
  end
  permission.each_slice(2).map { |p| p.flatten.join } # ファイルの種類とパーミッション値をjoinして配列に返す
end

if __FILE__ == $PROGRAM_NAME
  require "optparse"
  options = ARGV.getopts("a", "l", "r")
  options["a"] ? files = Dir.glob("*", File::FNM_DOTMATCH) : files = Dir.glob("*")
  files.reverse! if options["r"]
  if options["l"]
    file_info_generate(files)
  else
    generate(files)
  end
end
