require "find.rb"

def SplitLine(line)
	lineArray = Array.new
	lineArray = line.split(/\s|</)
	return lineArray[0]
end

# 文章のパース
recipeCount = 0
workArray = Array.new #作業用配列
outputArray = Array.new #データ出力用配列
# フォルダのパスを入力
Find::find("/Users/tamada/Desktop/ゼミ用/研究プログラム用/テストデータ/recipe/") do |path| 
	if FileTest.file?(path) && FileTest.readable?(path) then	# 開けるファイルであった場合
		File.open(path) do |f|			# ファイルの展開
			f.each_line do |line|	# ファイルを1行ずつ取り出す
				if line.include?("tb_heading_recipe")	#食材行抽出条件
					recipeCount = recipeCount + 1
					lineArray1 = Array.new
					lineArray1 = line.split("</tr>")
					lineArray1.each do |trLine|
						lineArray = Array.new
						lineArray = trLine.split(">")
						if lineArray[3] != nil && lineArray[6] != nil && !lineArray[3].include?("「") then
							workArray = Array.new
							foodName = SplitLine(lineArray[3])
							foodQuantity = SplitLine(lineArray[6])
							workArray.push(recipeCount,foodName,foodQuantity)
							outputArray.push(workArray)
						end
					end
				end
			end
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