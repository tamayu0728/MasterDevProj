require "find.rb"

# 文字列を分割するメソッド
def SplitLine(wordLine)
	lineArray1 = wordLine.split(">")
	lineWork1 = lineArray1[1];
	lineArray2 = lineWork1.split(/\s|</)
	modifideLine = lineArray2[0]
	return modifideLine
end

# 文章のパース
recipeCount = 0
workArray = Array.new
outputArray = Array.new
# フォルダのパスを入力
Find::find("/Users/tamada/Desktop/ゼミ用/研究プログラム用/テストデータ/recipe/") do |path| 
	if FileTest.file?(path) && FileTest.readable?(path) then	# 開けるファイルであった場合
		File.open(path) do |f|			# ファイルの展開
			workArray = Array.new
			f.each_line do |line|	# ファイルを1行ずつ取り出す
				if line.include?("title_f20 fl")	#レシピタイトル抽出条件
					recipeCount = recipeCount + 1
					workArray.push(recipeCount)
					# workArray.push(SplitLine(line))
				end

				if(workArray.empty? == false)
					if line.include?("tb_heading_recipe_item" && "ほんだし")
							workArray.push("ほんだし")
					end

					# if line.include?("tb_heading_recipe_item" && "味の素")
					# 	workArray.push("味の素")
					# end

					if line.include?("tb_heading_recipe_item" && "丸鶏がらスープ")
						workArray.push("丸鶏がらスープ")
					end

					if line.include?("tb_heading_recipe_item" && "味の素KKコンソメ")
							workArray.push("味の素KKコンソメ")
					end

					if line.include?("tb_heading_recipe_item" && "味の素KK中華あじ")
							workArray.push("味の素KK中華あじ")
					end

					if line.include?("tb_heading_recipe_item" && "ピュアセレクト")
						workArray.push("マヨネーズ")
					end

					if line.include?("tb_heading_recipe_item" && "きょうの大皿")
							workArray.push("きょうの大皿")
					elsif line.include?("tb_heading_recipe_item" && "Cook Do Korea")
							workArray.push("CookDoKorea")
					elsif line.include?("tb_heading_recipe_item" && "Cook Do")
							workArray.push("CookDo")
					end
				end
			end
			workArray.uniq!
			outputArray.push(workArray)
			p(workArray)
		end
	end
end

# ファイル書き出し
count = 0
File.open("space.txt", "w") do |f|
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
