require_relative 'frame'
require 'byebug'

class Game
  def initialize(marks)
    pins = marks.split(',')
    @frames = []
    9.times do |i|
      frame = pins.shift(2)
      if frame.first == 'X'
        @frames << ['X', '0']
        pins.unshift(frame.last)
      else
        @frames << frame
      end
    end
    @frames << pins
  end

  def score
    #byebug
    sum = 0
    @frames.each_with_index do |frame, i|
      this_frame = Frame.new(frame[0], frame[1], frame[2], i)
      unless this_frame.final_frame?
        bonus = 0
        if this_frame.strike?
          next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
          bonus = next_frame.next_frame_bonus
          if next_frame.strike?
            if next_frame.final_frame?
              bonus += next_frame.next_second_shot_bonus
            else
              after_next_frame = Frame.new(@frames[i + 2][0], @frames[i + 2][1], @frames[i + 2][2], i + 2)
              bonus += after_next_frame.next_first_shot_bonus
            end
          end
        elsif this_frame.spere?
          next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
          bonus = next_frame.next_first_shot_bonus
        end
        sum += this_frame.score + bonus
      else
        sum += this_frame.score
      end
    end
    sum
  end
end

game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')

p game.score
