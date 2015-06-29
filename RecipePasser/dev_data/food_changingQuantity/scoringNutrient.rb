# 文章のパース
outputArray = Array.new #データ出力用配列

File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food_changingQuantity/changing_data.txt") do |file|
	file.each_line do |recipeLine|
		scoreArray = Array.new
		loopFlag = false
		recipeFoodArray = Array.new	#元データの配列
		recipeFoodArray = recipeLine.split(",")
		# if recipeFoodArray[2].to_s.include?("\n")
			recipeFoodArray[2].chomp!	#改行コードの削除
		# end
		p(recipeFoodArray)
		File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food_changingQuantity/foodstuff.txt") do |foodDataFile|
			foodDataFile.each_line do |foodDataLine|
				foodDataArray = Array.new
				foodDataArray = foodDataLine.split(",")
				# p(foodDataArray)
				foodDataArray.last.chomp!
				if recipeFoodArray[1].to_s.include?(foodDataArray[0].to_s) && recipeFoodArray[2].to_s.match(/\d+/)
					# p(foodDataArray)
					divNumber = recipeFoodArray[2].to_f / 100.0
					loopCount = 0
					foodDataArray.each do |quantity|
						if loopCount == 0
							scoreArray.push(recipeFoodArray[0]) #idの挿入
							scoreArray.push(recipeFoodArray[1])	#食材名の挿入
						else
							scoreArray.push(sprintf("%.2f",quantity.to_f * divNumber))
						end
						loopCount = loopCount + 1
					end
					break
				end
			end
			break
		end
		if scoreArray.count != 0
			outputArray.push(scoreArray)	#出力ファイルへの書き出し
		end
	end
end

# ファイル書き出し
File.open("recipeScore.txt", "w") do |f|
	outputArray.each do |arr|
		arr.each do |word|
			if word != arr[arr.count-1]
				f.write(word.to_s + ",")
			else
				f.write(word.to_s + "\n")
			end
		end
	end
end

File.open("recipeScore.txt", "w") do |f|
	outputArray.each do |arr|
		f.write(arr.to_s + "\n")
	end
end