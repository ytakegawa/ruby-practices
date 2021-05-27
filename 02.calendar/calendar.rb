require "date"
require "optparse"
require "paint"

#-y,-mオプションがない場合は、現在の年月を代入し、オプションがある場合は、入力値を年月に代入するプログラム
#オプションにありえない数字が入力された場合は、警告を表示しプログラム終了とする。
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

# 年月週の装飾
puts "       #{year}.#{month}"
puts "Su Mo Tu We Th Fr Sa"

# 最初の週の空欄表示
start_day_space = "   " * start_day.wday
print start_day_space

# カレンダー表示
(start_day..last_day).each do |d|
  if d.day <= 9
    print " "
  end
  if d.saturday?
    print "#{d.day}\n"
  else
    print "#{d.day} "
  end
end
