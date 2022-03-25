require_relative 'frame'

class Game
  def initialize(marks)
    @frames = marks_to_frames(marks)
  end

  def score
    point = 0
    @frames.each_with_index do |frame, i|
      this_frame = Frame.new(frame[0], frame[1], frame[2], i)
      if this_frame.strike?
        next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
        point += next_frame.first_shot.score
        if next_frame.strike?
          if next_frame.final_frame?
            point += next_frame.second_shot.score
          else
            after_next_frame = Frame.new(@frames[i + 2][0], @frames[i + 2][1], @frames[i + 2][2], i + 2)
            point += after_next_frame.first_shot.score
          end
        end
        point += next_frame.second_shot.score
      elsif this_frame.spare?
        next_frame = Frame.new(@frames[i + 1][0], @frames[i + 1][1], @frames[i + 1][2], i + 1)
        point += next_frame.first_shot.score
      end
      point += this_frame.score
    end
    point
  end

  private

  def marks_to_frames(marks)
    pins = marks.split(',')
    frames = []
    9.times do
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
