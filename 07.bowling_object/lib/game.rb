# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def score
    frames = marks_to_frames(@marks)
    point = 0
    frames.each_with_index do |frame, i|
      this_frame = Frame.new(frame[0], frame[1], frame[2], i)
      next_frame = Frame.new(frames[i + 1][0], frames[i + 1][1], frames[i + 1][2], i + 1) if this_frame.frame_index <= 8
      after_next_frame = Frame.new(frames[i + 2][0], frames[i + 2][1], frames[i + 2][2], i + 2) if this_frame.frame_index <= 7
      point += this_frame.score + add_bonus_point(this_frame, next_frame, after_next_frame)
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
        frames << %w[X 0]
        pins.unshift(frame.last)
      else
        frames << frame
      end
    end
    frames << pins
  end

  def add_bonus_point(this_frame, next_frame, after_next_frame = nil)
    return 0 if !this_frame.strike? && !this_frame.spare?

    return next_frame.first_shot.score if this_frame.spare?

    return next_frame.first_shot.score + after_next_frame.first_shot.score if next_frame.strike? && after_next_frame

    return next_frame.first_shot.score + next_frame.second_shot.score if next_frame.strike? && !after_next_frame

    next_frame.first_shot.score + next_frame.second_shot.score
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
