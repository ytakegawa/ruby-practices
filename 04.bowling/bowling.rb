all_scores = ARGV[0]
all_scores_splitting = all_scores.split(',')

STRIKE = 10
SPARE = 10

# 文字列のスコアを数字に並べ替える
# ストライクを表すXも数字に変換する
shots = []
all_scores_splitting.each do |score|
  if score == 'X' # ストライク
    shots << STRIKE
    shots << 0
  else
    shots << score.to_i
  end
end

# 配列の[10, 0]を[10]にする処理
frames = []
shots.each_slice(2) do |shot|
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
  frames.delete_at(10)
  frames.delete_at(10)
elsif frames[10] # 11番目のフレームが発生した場合の処理
  frames[9].concat(frames[10])
  frames.delete_at(10)
end

# スコアの合算プログラム
total_score = 0
frames.each_with_index do |frame, i|
  if i == 9 # 10フレームの処理
    total_score += frame.sum
  elsif frame[0] == STRIKE # ストライクの場合の処理
    if frames[i + 1][1].nil? # ストライクの次のフレームに２投目がない場合は2連続ストライクとみなす
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

puts total_score
