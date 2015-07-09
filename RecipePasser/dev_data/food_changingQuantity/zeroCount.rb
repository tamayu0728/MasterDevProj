# 文章のパース
outputArray = Array.new #データ出力用配列
zeroCount = 0
File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food_changingQuantity/changing_data.txt") do |file|
	file.each_line do |recipeLine|
		recipeFoodArray = Array.new	#元データの配列
		recipeFoodArray = recipeLine.split(",")
		recipeFoodArray[2].chomp!	#改行コードの削除
		# p(recipeFoodArray)
		if recipeFoodArray[2].to_i == 0 || !recipeFoodArray[2].to_s.match(/\d+/)
			zeroCount = zeroCount + 1
			p(zeroCount)
			if outputArray.empty? || !outputArray.include?(recipeFoodArray[1])
				outputArray.push(recipeFoodArray[1])
			end
		end
	end
end

# ファイル書き出し
File.open("zero.txt", "w") do |f|
	f.write("食材：\n"+outputArray.to_s+"\n")
    f.write("\n食材数："+outputArray.count.to_s+"\n")
	f.write("\nライン数：" + zeroCount.to_s + "\n")
end