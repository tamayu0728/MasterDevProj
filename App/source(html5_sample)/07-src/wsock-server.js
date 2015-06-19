// WebSocket サーバー側コード
// ---
var ws = require("websocket.io");
var WS_PORT = 8888; // Socketのポート番号
var server = ws.listen(WS_PORT, function() {
  console.log("Server Start Port=" + WS_PORT);
});
// クライアントからの接続イベント
server.on('connection', function(socket) {
  // クライアントからメッセージを受信したとき
  socket.on('message', function(msg) {
    console.log("message: " + msg);
    // 全てのクライアントに送信
    server.clients.forEach(function(client) {
      client.send(msg);
    });
  });
  socket.on('error', function(err) {
    console.log('error:' + err);
  });
});

