# 文章のパース
outputArray = Array.new #データ出力用配列
deleteArray = Array.new
loopIn = false
readLine = 0
# File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food/data.txt") do |file|
# 	file.each_line do |recipeLine|
# 		addRecipeAarry = Array.new
# 		recipeArray = Array.new	#元データの配列
# 		recipeArray = recipeLine.split(",")
# 		recipeArray[4].chomp!	#改行コードの削除
# 		# p(recipeArray)
# 		File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipeScore1.txt") do |scoreFile|
# 			#配列の削除
# 			scoreFile.delete_if do |item|
# 				scoreArray.index(item) <= readLine
# 			end
# 			readCount = 0
# 			scoreFile.each_line do |scoreLine|
# 				readCount++
# 				scoreArray = Array.new
# 				scoreArray = scoreLine.split(",")
# 				scoreArray.last.chomp!
# 				if recipeArray[0].to_i == scoreArray[0].to_i
# 					#計算して配列へプッシュ
# 					addRecipeAarry.push(scoreArray)
# 				elsif (recipeArray[0].to_i + 1) == scoreArray[0].to_i
# 					readline = readCount
# 					break
# 				end
# 			end
# 			if addRecipeAarry.count != 0
# 			outputArray.push(addRecipeAarry)	#出力ファイルへの書き出し
# 			end
# 		end
# 	end
# end


recipeDataArray = Array.new
spiceDataArray = Array.new
File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food/data.txt") do |file|
	recipeDataArray = file.read.split("\n")
end
File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/recipe/spice.txt") do |file|
	spiceDataArray = file.read.split("\n")
end

spiceDataArray.each do |spiceline|
	recipeListArr = Array.new
	recipeListArr = spiceline.split(",")
	readCount = 0
	recipeDataArray.each do |recipeLine|
		readCount = readCount + 1
		arr = Array.new
		arr = recipeLine.split(",")
		if recipeListArr[0].to_i == arr[0].to_i
			recipeListArr.push(arr[1])
		elsif recipeListArr[0].to_i == arr[0].to_i
			readline = readCount
			break
		end
	end
	p(recipeListArr)
	outputArray.push(recipeListArr)
	#配列の削除
	# recipeDataArray.delete_if do |item|
	# 	recipeDataArray.index(item) <= readLine
	# end
end



File.open("study_data.txt", "w") do |f|
	outputArray.each do |arr|
		f.write(arr.to_s + "\n")
	end
end