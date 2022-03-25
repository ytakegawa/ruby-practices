# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class BowlingTest < Minitest::Test
  def score(marks)
    game = Game.new(marks)
    game.score
  end

  def test_score1
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    assert_equal 139, score(marks)
  end

  def test_score2
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    assert_equal 164, score(marks)
  end

  def test_score3
    marks = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, score(marks)
  end

  def test_score4
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    assert_equal 134, score(marks)
  end

  def test_perfect_game
    marks = 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, score(marks)
  end
end
