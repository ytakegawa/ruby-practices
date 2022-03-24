class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    @mark = 10 if @mark == 'X'
    @mark.to_i
  end
end
