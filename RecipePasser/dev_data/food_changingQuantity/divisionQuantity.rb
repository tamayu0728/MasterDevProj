# 文章のパース
outputArray = Array.new #データ出力用配列

File.open("/Users/tamada/Desktop/修論Dev/RecipePasser/dev_data/food_changingQuantity/data_new.txt") do |file|
	file.each_line do |recipeLine|
		foodArray = Array.new	#元データの配列
		foodArray = recipeLine.split(",")
		foodArray[2].chomp!	#改行コードの削除
		File.open("/Users/tamada/Desktop/修論Dev/RecipePasser/dev_data/food_changingQuantity/recipeQuantity.txt") do |quantityFile|
			quantityFile.each_line do |quantityLine|
				quantityArray = Array.new
				quantityArray = quantityLine.split(",")
				quantityArray[1].chomp!
				if foodArray[0].to_i == quantityArray[0].to_i && !quantityArray[1].to_s.include?("作")
					#1人分への変換
					p(foodArray)
					if foodArray[2].to_s.match(/\d+/)
						foodArray[2] = foodArray[2].to_i / quantityArray[1].to_i
						foodArray[2] = foodArray[2].to_s
					elsif foodArray[2].to_s.include?("g") && foodArray[2].length >= 2
						foodQuantity = foodArray[2].match(/\d+/).to_s	#正規表現で数字のみをマッチ
						foodArray[2] = foodQuantity.to_i / quantityArray[1].to_i
						foodArray[2] = foodArray[2].to_s
					end
				end
			end
		end
		outputArray.push(foodArray)	#出力ファイルへの書き出し
	end
end

# ファイル書き出し
count = 0
File.open("changing_data.txt", "w") do |f|
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