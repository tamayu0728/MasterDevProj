outputArray = Array.new
sportArray = Array.new
nutrientArray = Array.new
multNum = 0
quantity = 0;
newOutput = Array.new
File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/sports.txt") do |f|
	sportArray = f.read.split("\n")
end
File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/standardNutrient.txt") do |f|
	nutrientArray = f.read.split("\n")
end

sportArray.each do |sportLine|
	sportsLineArray = Array.new
	sportsLineArray = sportLine.split(",")
	# sportsLineArray[1].chomp!
	sportsNutrient = Array.new
	sportsNutrient.push(sportsLineArray[0])
	sportsNutrient2 = Array.new
	sportsNutrient2.push(sportsLineArray[0])
	nutrientArray.each do |nutrientLine|
		nArray = Array.new
		nArray = nutrientLine.split(",")
		# nArray.chomp!
		if nArray[0].to_s == "エネルギー"
			multNum = sportsLineArray[1].to_f / nArray[1].to_f
			sportsNutrient.push(sprintf("%.2f",sportsLineArray[1].to_f)) 
			sportsNutrient2.push(sprintf("%.2f",sportsLineArray[1].to_f)) 
		else
			sportsNutrient.push(sprintf("%.2f",nArray[1].to_f * multNum)) 
			sportsNutrient2.push(sprintf("%.2f",multNum)) 
		end
	end
	outputArray.push(sportsNutrient)
end

sportsNutrient = Array.new

endurance = ["長距離走","マラソン","クロスカントリー","登山","トライアスロン","サイクリング","水泳(長距離)","スケート(長距離)"];
highPower = ["短距離走","スキー","スケート(短距離)","水泳(短距離)","野球","ソフトボール","跳躍","フェンシング","空手","アーチェリー"];
musclePower = ["ハンマー投げ","槍投げ","砲丸投げ","ウェイトリフティング","筋力トレーニング"];
mixPower = ["中距離走","バドミントン","バレーボール","スノーボード","テニス" ,"バスケットボール","サッカー","ラグビー","アメリカンフットボール","ホッケー","アイスホッケー"];
wightControll = ["ボクシング","レスリング","柔道","エアロビクス","ヨット","ボート"];

outputArray.each do |line|
	dataArray = Array.new
	dataArray = line
	if endurance.include?(line[0])
		dataArray[3] = 0.00.to_s
		for num in 7..15 do
			dataArray[num] = 0.00.to_s
		end
	elsif highPower.include?(line[0])
		dataArray[4] = 0.00.to_s
		dataArray[5] = 0.00.to_s
		for num in 16..26 do
			dataArray[num] = 0.00.to_s
		end
	elsif wightControll.include?(line[0])
		dataArray[4] = 0.00.to_s
		dataArray[5] = 0.00.to_s
	elsif musclePower.include?(line[0])
		dataArray[4] = 0.00.to_s
		dataArray[5] = 0.00.to_s
		for num in 16..26 do
			dataArray[num] = 0.00.to_s
		end
	end
	newOutput.push(dataArray)
end

p(newOutput)

# ファイル書き出し
File.open("sportsScore.txt", "w") do |f|
	newOutput.each do |arr|
		arr.each do |word|
			if word != arr[arr.count-1]
				f.write(word.to_s + ",")
			else
				f.write(word.to_s + "\n")
			end
		end
	end
end

# File.open("recipeScore.txt", "w") do |f|
# 	outputArray.each do |arr|
# 		f.write(arr.to_s + "\n")
# 	end
# end