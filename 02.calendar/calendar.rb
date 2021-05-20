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

today = Date.today
start_day = Date.new(year, month, +1)
last_day = Date.new(year, month, -1)

puts "       #{year}.#{month}"
puts "Su Mo Tu We Th Fr Sa"

#カレンダーの日付を整列させるプログラム
(start_day..last_day).each do |d|
  painted_today = Paint[d.day, :inverse]
  if d == today && d.day == 1 && d.saturday?
    puts "                   #{painted_today}"
  elsif d == today && d.day == 1
    position_of_start_day = d.cwday
    case position_of_start_day
    when 1
      print "    #{painted_today} "
    when 2
      print "       #{painted_today} "
    when 3
      print "          #{painted_today} "
    when 4
      print "             #{painted_today} "
    when 5
      print "                #{painted_today} "
      #when 6
      #print "                   #{d.day}"
    when 7
      print " #{painted_today} "
    end
  elsif d == today && d.saturday?
    if d.day <= 9
      puts " #{painted_today} "
    else
      puts painted_today
    end
  elsif d == today
    if d.day <= 9
      print " #{painted_today} "
    else
      print "#{painted_today} "
    end
  elsif d.day == 1 && d.saturday?
    puts "                   #{d.day}"
  elsif d.day == 1
    position_of_start_day = d.cwday
    case position_of_start_day
    when 1
      print "    #{d.day} "
    when 2
      print "       #{d.day} "
    when 3
      print "          #{d.day} "
    when 4
      print "             #{d.day} "
    when 5
      print "                #{d.day} "
      #when 6
      #print "                   #{d.day}"
    when 7
      print " #{d.day} "
    end
  elsif d.saturday?
    if d.day <= 9
      puts " #{d.day} "
    else
      puts d.day
    end
  else
    if d.day <= 9
      print " #{d.day} "
    else
      print "#{d.day} "
    end
  end
end
