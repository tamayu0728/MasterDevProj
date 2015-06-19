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
Find::find("/Users/tamada/Desktop/修論Dev/レシピデータパース用素材/テストデータ/recipe/") do |path| 
	if FileTest.file?(path) && FileTest.readable?(path) then	# 開けるファイルであった場合
		File.open(path) do |f|			# ファイルの展開
			f.each_line do |line|	# ファイルを1行ずつ取り出す
				if line.include?("title_f20 fl")	#レシピタイトル抽出条件
					recipeCount = recipeCount + 1
					workArray.push(recipeCount)
					workArray.push(SplitLine(line))
				elsif line.include?("databox_w294_value_time") 	#調理時間抽出条件
					if !line.include?("style")
						workArray.push(SplitLine(line))
					end
				elsif line.include?("databox_w294_value_energy")	#摂取カロリー抽出条件
					workArray.push(SplitLine(line))
				elsif line.include?("databox_w294_value_vegetables")	#野菜摂取量抽出条件
					workArray.push(SplitLine(line))
				end
			end
			outputArray.push(workArray)
			workArray = Array.new
		end
	end
end

# ファイル書き出し
count = 0
File.open("data.txt", "w") do |f|
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
