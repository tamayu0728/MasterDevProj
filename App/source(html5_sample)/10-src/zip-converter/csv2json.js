// 郵便番号CSVデータを読み込んで、JSON形式に変換
var CSVFILE = "KEN_ALL.CSV";
// ライブラリの利用
var fs  = require('fs');
var csv = require('csv');
var Iconv = require('iconv').Iconv;
var sjis = new Iconv('SHIFT_JIS', 'UTF-8//TRANSLIT//IGNORE');
// CSVファイルを詠み込んでUTF-8に変換する ---- (*1)
var text = fs.readFileSync(CSVFILE);
text = sjis.convert(text).toString('utf-8');
console.log("File Size:"+text.length);
// 変数の宣言
var kenno = 0, kenlist = [], res = [], fname = "";
// CSVを二次元配列変数に変換 ---(*2)
csv.parse(text, function(err, rows) {
  for (var i = 0; i < rows.length; i++) {
    var row = rows[i];
    var zip = row[2];
    var ken = row[6], shi = row[7], cho = row[8];
    var addr = shi + cho;
    addr = addr.replace("以下に掲載がない場合","");
    // 処理する都道府県が変わった?
    if (kenlist.indexOf(ken) < 0) {
      kenlist.push(ken);
      console.log("ken="+ken);
      if (fname != "") writeFile(fname, res);
      fname = kenno + ".json";
      res = [];
      kenno++;
    }
    res.push({'zip': zip, 'ken': ken, 'addr': addr});
  }
});
if (fname != "") writeFile(fname, res);
console.log("ok\n");
// ファイル書き出し
function writeFile(fname, list) {
  console.log("file:" + fname);
  var json = JSON.stringify(list);
  fs.writeFileSync(fname, json);
}

