require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil, frame_index)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    @frame_index = frame_index
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
    # if final_frame?
    #   @first_shot.score + @second_shot.score + @third_shot.score
    # else
    #   @first_shot.score + @second_shot.score
    # end
  end

  def strike?
    @first_shot.score == 10 && @second_shot.score == 0 && !final_frame?
  end

  def spere?
    @first_shot.score != 10 && @first_shot.score + @second_shot.score == 10 && !final_frame?
  end

  def next_frame_bonus
    if strike?
      @first_shot.score
    else
      @first_shot.score + @second_shot.score
    end
  end

  def next_first_shot_bonus
    @first_shot.score
  end

  def next_second_shot_bonus
    @second_shot.score
  end

  #private

  def final_frame?
    @frame_index == 9
  end
end
