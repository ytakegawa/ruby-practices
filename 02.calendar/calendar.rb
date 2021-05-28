require "date"
require "optparse"
require "paint"

options = ARGV.getopts("m:", "y:")
if options["y"] == nil
  year = Date.today.year
else
  if options["y"].to_i < 1 || options["y"].to_i > 9999
    puts "year #{options["y"].to_i} not in range 1~9999"
    exit
  else
    year = options["y"].to_i
  end
end

if options["m"] == nil
  month = Date.today.month
else
  if options["m"].to_i < 1 || options["m"].to_i > 12
    puts "#{options["m"].to_i} is not a month number (1~12) "
    exit
  else
    month = options["m"].to_i
  end
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
puts
