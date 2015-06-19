// 計算を行なうワーカー ------(*1)
self.onmessage = function(e) {
  // パラメータを取得
  var data = e.data; //---------(*2)
  var a = data["a"];
  var b = data["b"];
  // かけ算を行なう
  var r = a * b;
  // 親に結果を送信する----(*3)
  self.postMessage({result:r});
};

