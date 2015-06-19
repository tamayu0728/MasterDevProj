// 定期的に時間やメッセージを投げるだけのワーカー
var msg = ["Hello","こんにちは","元気ですか?"];
// メッセージを受信したとき --- (*1)
self.onmessage = function(e) {
  // タイマーを仕掛ける
  setInterval(showTime, 1000);
};
// 時間やメッセージを表示する
function showTime() {
  // 毎秒時刻を送信する ---(*2)
  var now = new Date();
  self.postMessage({
    mode:"clock",
    disp: now.toString()
  });
  // 10秒ごとメッセージを送信する---(*3)
  if (now.getSeconds() % 10 == 0) {
    var r = Math.floor(Math.random()*3);
    self.postMessage({
      mode:"info",
      disp: msg[r]
    });
  }
}
