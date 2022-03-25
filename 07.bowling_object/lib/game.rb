require_relative 'frame'
require 'byebug'

class Game
  def initialize(marks)
    @frames = marks_to_frames(marks)
  end

  def score
    #byebug
    point = 0
    @frames.each_with_index do |frame, i|
      this_frame = Frame.new(frame[0], frame[1], frame[2], i)
      bonus_point = 0
      if this_frame.strike?
        next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
        bonus_point += next_frame.next_frame_bonus
        if next_frame.strike?
          if next_frame.final_frame?
            bonus_point += next_frame.next_second_shot_bonus
          else
            after_next_frame = Frame.new(@frames[i + 2][0], @frames[i + 2][1], @frames[i + 2][2], i + 2)
            bonus_point += after_next_frame.next_first_shot_bonus
          end
        end
      elsif this_frame.spere?
        next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
        bonus_point += next_frame.next_first_shot_bonus
      end
      point += this_frame.score + bonus_point
    end
    point
  end

  private

  def marks_to_frames(marks)
    pins = marks.split(',')
    frames = []
    9.times do |i|
      frame = pins.shift(2)
      if frame.first == 'X'
        frames << ['X', '0']
        pins.unshift(frame.last)
      else
        frames << frame
      end
    end
    frames << pins
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
