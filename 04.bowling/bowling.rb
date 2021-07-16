#!/usr/bin/env ruby
# frozen_string_literal: true
STRIKE = 10
SPARE = 10

# スコアの合算プログラム
def calc_score(pinfall)
  total_score = 0
  frames = all_scores_to_frames(pinfall)
  frames.each_with_index do |frame, i|
    if i == 9 # 10フレームの処理
      total_score += frame.sum
    elsif frame[0] == STRIKE # ストライクの場合の処理
      if frames[i + 1][1].nil?
        # ↑ストライクの次のフレームに２投目がない場合は2連続ストライクとみなす
        # 理由:9フレームでストライクがきて10フレームで連続ストライクが発生した場合、9フレームから2フレーム先の１投目をスコアに加えるという処理になり、
        # 9フレームの2フレーム先（11フレーム）が存在しないことでエラーとなるため、これを回避すべくこのような実装にした。
        total_score += STRIKE + STRIKE + frames[i + 2][0]
      else
        total_score += STRIKE + frames[i + 1][0, 2].sum
      end
    elsif frame.sum == SPARE # スペアの場合の処理
      total_score += SPARE + frames[i + 1][0]
    else
      total_score += frame.sum
    end
  end
  total_score
end

# 配列をフレームごとに分け、[10, 0]を[10]にする処理
def all_scores_to_frames(pinfall)
  frames = []
  pinfalls = all_scores_to_i(pinfall)
  pinfalls.each_slice(2) do |shot|
    frames <<
      if shot[0] == STRIKE
        [shot.shift]
      else
        shot
      end
  end
  # 10フレームを超えたフレームが発生した場合の処理
  if frames[11] # 11番目,12番目のフレームが発生した場合の処理
    frames[9].concat(frames[10], frames[11])
    frames.pop(2)
  elsif frames[10] # 11番目のフレームが発生した場合の処理
    frames[9].concat(frames[10])
    frames.pop(1)
  end
  frames
end

# 文字列のスコアを数字に並べ替える
# ストライクを表すXも数字に変換する
def all_scores_to_i(pinfall)
  shots = []
  pinfalls = all_scores_splitting(pinfall)
  pinfalls.each do |score|
    if score == "X" # ストライク
      shots << STRIKE
      shots << 0
    else
      shots << score.to_i
    end
  end
  shots
end

# コマンド引数のボウリングスコアの中身を1投づつの配列に分ける
def all_scores_splitting(pinfall)
  pinfall.split(",")
end

if __FILE__ == $PROGRAM_NAME
  puts "SCORE: #{calc_score(ARGV[0])}"
end
