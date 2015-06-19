require "find.rb"

# 文章のパース
recipeCount = 0
outputArray = Array.new
Find::find("/Users/tamada/Desktop/修論Dev/レシピデータパース用素材/テストデータ/recipe/") do |path| 
	if FileTest.file?(path) && FileTest.readable?(path) then	# 開けるファイルであった場合
		File.open(path) do |f|			# ファイルの展開
			f.each_line do |line|	# ファイルを1行ずつ取り出す
				if line.include?("title_f20 fl")	# レシピタイトル抽出条件
					recipeCount = recipeCount + 1
					lineArray1 = line.split(">")
					lineWork1 = lineArray1[1];
					lineArray2 = lineWork1.split(/\s/)
					trueLine = lineArray2[0]
					output = recipeCount.to_s + "," + trueLine.to_s
					outputArray.push(output)
				end
			end	
		end
	end
end

# ファイル書き出し
File.open("data.txt", "w") do |f|
	outputArray.each do |i|
		f.write(i + "\n")
		p i
	end
end

