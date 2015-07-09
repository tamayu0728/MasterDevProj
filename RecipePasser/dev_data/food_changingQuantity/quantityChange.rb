# 文章のパース
outputArray = Array.new #データ出力用配列

File.open("/Users/tamada/Desktop/修論Dev/RecipePasser/dev_data/food_changingQuantity/data.txt") do |file|
	file.each_line do |recipeLine|
		loopIn = false
		foodArray = Array.new	#元データの配列
		foodArray = recipeLine.split(",")
		foodArray[2].chomp!	#改行コードの削除
		p(foodArray)
		if !recipeLine.include?("g")
			# sta_food1.txtの捜査
			File.open("/Users/tamada/Desktop/修論Dev/RecipePasser/dev_data/food_changingQuantity/changeDataFile/sta_food1.txt") do |changeFile|
				changeFile.each_line do |changeLine|
					changeArray = Array.new	#変換テーブルが入った配列
					changeArray = changeLine.split(",")
					if foodArray[1] == changeArray[1] && foodArray[2].to_s.include?(changeArray[2].to_s)
						foodQuantity = foodArray[2].match(/\d+/).to_s	#正規表現で数字のみをマッチ
						foodArray[2] = foodQuantity.to_i * changeArray[3].to_i	#g単位へ変換
						foodArray[2] = foodArray[2].to_s
						loopIn = true
					end
				end
			end
			if loopIn == false
				# sta_food2.txtの捜査
				File.open("/Users/tamada/Desktop/修論Dev/RecipePasser/dev_data/food_changingQuantity/changeDataFile/sta_food2.txt") do |changeFile|
					changeFile.each_line do |changeLine|
						changeArray = Array.new	#変換テーブルが入った配列
						changeArray = changeLine.split(",")
						if foodArray[1] == changeArray[1] && foodArray[2].to_s.include?(changeArray[2].to_s)
							foodQuantity = foodArray[2].match(/(\d+)/).to_s				#正規表現で数字のみをマッチ
							foodArray[2] = foodQuantity.to_i * changeArray[3].to_i	#g単位へ変換
							foodArray[2] = foodArray[2].to_s
						end
					end
				end
			end
		end
		outputArray.push(foodArray)	#出力ファイルへの書き出し
	end
end

# ファイル書き出し
count = 0
File.open("data_new.txt", "w") do |f|
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