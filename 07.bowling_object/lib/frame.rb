# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :frame_index

  def initialize(first_mark, second_mark, third_mark, frame_index = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    @frame_index = frame_index
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == 10 unless final_frame?
  end

  def spare?
    @first_shot.score + @second_shot.score == 10 unless final_frame?
  end

  private

  def final_frame?
    @frame_index == 9
  end
end
