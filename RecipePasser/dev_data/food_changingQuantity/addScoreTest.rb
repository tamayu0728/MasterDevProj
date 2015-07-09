# 文章のパース
outputArray = Array.new #データ出力用配列
lineCount = 1
scoreArray = Array.new #全レシピの栄養素が入った配列
File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipeScore2.txt") do |scoreFile|
	scoreArray = scoreFile.read.split("\n")
	# p(scoreArray.count)
end

File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipe_name.txt") do |file|
	file.each_line do |recipeLine|
		recipeArray = Array.new	#レシピデータの配列
		recipeArray = recipeLine.split(",")
		recipeArray[4].chomp!	#改行コードの削除
		calcArray = Array.new
		scoreArray.each do |scoreLine|
			foodScoreArray = Array.new	#各レシピの栄養素が入った配列
			foodScoreArray = scoreLine.split(",")
			if recipeArray[0].to_i == foodScoreArray[0].to_i
				p(recipeArray[0])
				if calcArray.empty?()
					calcArray.push(foodScoreArray)
				else
					loopIn = 0
					addArray = Array.new
					calcArray.each do |arr|
						arr.zip(foodScoreArray).each do |a,b|
							if loopIn == 0
								addArray.push(recipeArray[0])
							elsif loopIn == 1
								addArray.push(recipeArray[1])
							else
								addArray.push(sprintf("%.2f",a.to_f + b.to_f))
							end
							loopIn = loopIn + 1
						end
					end
					calcArray = Array.new
					calcArray.push(addArray)
				end
			elsif (recipeArray[0].to_i + 1) == foodScoreArray[0].to_i
				break
			end
		end
		# p(scoreArray.count)
		if !calcArray.empty?()
			outputArray.push(calcArray)
		end
	end
end

#配列の削除
# p(scoreArray.find_index(scoreLine))
# scoreArray.delete_at(scoreArray.find_index(scoreLine))
# p(scoreArray)

File.open("test2.txt", "w") do |f|
	outputArray.each do |arr|
		f.write(arr.to_s + "\n")
	end
end