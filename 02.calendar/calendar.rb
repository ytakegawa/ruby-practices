require "date"
require "optparse"
require "paint"

options = ARGV.getopts("m:", "y:")
year = (options["y"] || Date.today.year).to_i
# ありえない数字が引数に入力された場合の処理
if year < 1 || year > 9999
  puts "year #{year} not in range 1~9999"
  exit
end

month = (options["m"] || Date.today.month).to_i
# ありえない数字が引数に入力された場合の処理
if month < 1 || month > 12
  puts "#{month} is not a month number (1~12) "
  exit
end

start_day = Date.new(year, month, +1)
last_day = Date.new(year, month, -1)
today = Date.today

# 年月週の装飾
puts "       #{year}.#{month}"
puts "Su Mo Tu We Th Fr Sa"

# 最初の週の空欄表示
start_day_space = "   " * start_day.wday
print start_day_space

# カレンダー表示
(start_day..last_day).each do |d|
  # 今日の日付の背景色を反転させるため、今日の日付を判定する条件分岐
  if d == today
    painted_today = Paint[d.day, :inverse]
    # 日付が土曜日の場合は改行させるための条件分岐
    if d.saturday?
      printf("%2s\n", painted_today)
    else
      printf("%2s ", painted_today)
    end
  elsif d.saturday?
    printf("%2d\n", d.day)
  else
    printf("%2d ", d.day)
  end
end

# プログラムを実行したときに最後に表示される"%"を無くすため最後に改行入れる
puts ""
