# 文章のパース
outputArray = Array.new #データ出力用配列
loopIn = false
readLine = 0
File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipe_name.txt") do |file|
	file.each_line do |recipeLine|
		addRecipeAarry = Array.new
		recipeArray = Array.new	#元データの配列
		recipeArray = recipeLine.split(",")
		recipeArray[4].chomp!	#改行コードの削除
		# p(recipeArray)
		File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipeScore1.txt") do |scoreFile|
			#配列の削除
			scoreFile.delete_if do |item|
				scoreArray.index(item) <= readLine
			end
			readCount = 0
			scoreFile.each_line do |scoreLine|
				readCount++
				scoreArray = Array.new
				scoreArray = scoreLine.split(",")
				scoreArray.last.chomp!
				if recipeArray[0].to_i == scoreArray[0].to_i
					#計算して配列へプッシュ
					addRecipeAarry.push(scoreArray)
				elsif (recipeArray[0].to_i + 1) == scoreArray[0].to_i
					readline = readCount
					break
				end
			end
			if addRecipeAarry.count != 0
			outputArray.push(addRecipeAarry)	#出力ファイルへの書き出し
			end
		end
	end
end

File.open("test.txt", "w") do |f|
	outputArray.each do |arr|
		f.write(arr.to_s + "\n")
	end
end