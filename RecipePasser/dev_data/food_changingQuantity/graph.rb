#---------------日本語表記のカウント---------------
# outputArray = Array.new
# zeroCount = 0
# wordArray = Array.new
# wordCountArray = Array.new
# quantityArray = Array.new
# File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food_changingQuantity/recipeQuantity.txt") do |f|
# 	quantityArray = f.read.split("\n")
# end
# quantityArray.each do |line|
# 	arr = Array.new
# 	arr = line.split(",")
# 	if !wordArray.include?(arr[1]) || wordArray.empty?
# 		wordArray.push(arr[1])
# 	end
# 	wordArray.sort!
# end
# wordArray.each do |word|
# 	loopCount = 0
# 	quantityArray.each do |recipeLine|
# 		arr = Array.new
# 		arr = recipeLine.split(",")
# 		if arr[1] == word
# 			loopCount = loopCount + 1
# 		end
# 	end
# 	wordCountArray.push(loopCount)
# end
# p(wordArray.zip(wordCountArray))
#-----------------------------------------


#---------------表記ゆれの変換---------------
#outputArray = Array.new
#count = 0
#wordArray = Array.new
#wordCountArray = Array.new
#dataArray = Array.new
#File.open("/Users/tamada/MasterDevProj/RecipePasser/dev_data/food_changingQuantity/data_new.txt") do |f|
#	dataArray = f.read.split("\n")
#end
#dataArray.each do |line|
#	arr = Array.new
#	arr = line.split(",")
#	if arr.count == 3 && arr[2].to_s.match(/\p{Han}/ || /\p{Hiragana}/ || /\p{Katakana}/) && !arr[2].include?("g")
#		count = count + 1
#		p(arr)
#		p(count)
#	end
#end
#p(count)
#-----------------------------------------


#---------------適合率の計算---------------
outputArray = Array.new
sum = 0
count = 0
dataArray = Array.new
upperArray = Array.new
lowerArray = Array.new
upperArray = [["a",0.0],["b",0.0],["c",0.0],["d",0.0],["e",0.0],["f",0.0],["g",0.0],["h",0.0],["i",0.0],["j",0.0]]
lowerArray = [["a",1.0],["b",1.0],["c",1.0],["d",1.0],["e",1.0],["f",1.0],["g",1.0],["h",1.0],["i",1.0],["j",1.0]]
File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/test2.txt") do |f|
	dataArray = f.read.split("\n")
end

File.open("/Users/tamada/MasterDevProj/RecipePasser/release_data/recipe_name.txt") do |file|
	file.each_line do |recipeLine|
		recipeArray = Array.new
		recipeArray = recipeLine.split(",")
		# p(recipeArray)
		dataArray.each do |dataLine|
			arr = Array.new
			arr = dataLine.split(",")
			if arr[0].to_s == recipeArray[0].to_s && arr[2].to_s != 0.00
				avg = 0
				str = arr[1]
				avg = arr[2].to_f / recipeArray[3].to_f
				# p(dataArray.find_index(dataLine))
				dataArray.delete_at(dataArray.find_index(dataLine))
				if avg > 1.0
					p(avg)
					avg = 1.0 / avg
				end
				if avg <= 0.2
					break
				else
					# if lowerArray[0].to_f > avg
					# 	lowerArray[0] = sprintf("%.5f",avg).to_f
					# 	lowerArray.sort!
					# 	lowerArray.reverse!
					# elsif upperArray[0].to_f < avg
					# 	upperArray[0] = sprintf("%.5f",avg).to_f
					# 	upperArray.sort!
					# end
					if lowerArray[0][1].to_f > avg
						lowerArray[0][0] = str
						lowerArray[0][1] = sprintf("%.5f",avg)
						lowerArray = lowerArray.sort {|a,b|
							a[1].to_f <=> b[1].to_f
						}
						lowerArray.reverse!
					elsif upperArray[0][1].to_f < avg
						upperArray[0][0] = str
						upperArray[0][1] = sprintf("%.5f",avg)
						upperArray = upperArray.sort {|a,b|
							a[1].to_f <=> b[1].to_f
						}
					end
        			# p(count)
        			# p(avg)
        			sum = sum + avg
        			count = count + 1
        			break
        		end
        	end
        end
    end
end

# p(lowerArray)
# p(upperArray)
p(count)
p(sprintf("%.2f",sum/count))
#-----------------------------------------


# wordArray.each do |word|
# 	loopCount = 0
# 	dataArray.each do |recipeLine|
# 		arr = Array.new
# 		arr = recipeLine.split(",")
# 		if arr[1] == word
# 			loopCount = loopCount + 1
# 		end
# 	end
# 	wordCountArray.push(loopCount)
# end
# p(wordArray.zip(wordCountArray))


# ファイル書き出し
# File.open("zero.txt", "w") do |f|
# 	f.write("食材：\n"+outputArray.to_s+"\n")
#     f.write("\n食材数："+outputArray.count.to_s+"\n")
# 	f.write("\nライン数：" + zeroCount.to_s + "\n")
# end