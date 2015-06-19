//-----------------------------------------------
// 迷路ゲーム(JavaScript)
//-----------------------------------------------
// 広域変数の宣言
var DISP_ROW = 7; // 表示範囲の幅
var DISP_COL = 7; // 表示範囲の高さ
var TILE_W = 45;  // サイズの幅
var TILE_H = 45;  // サイズの高さ
var FILE_MAZE = "maze.csv"; // CSVファイル
var C_NONE = 0, C_WALL = 1, C_KEY = 2, 
    C_DOOR = 3, C_GOAL = 4;
var IMG_PLAYER = 5;
var images = []; // 画像オブジェクトの一覧
var maze = [], mazeOrg = []; // 迷路データを保持
var ctx; // 描画用コンテキスト
// プレイヤーデータ
var player = { x:1, y:1, mx:-1, my:-1, key:0 }; 
// 初期化イベント
window.onload = function () {
  // 描画コンテキストの取得
  ctx = $("main").getContext("2d");
  // イベントの設定
  $("main").onmousedown = mouseDownHandler;
  $("main").onmousemove = mouseMoveHandler;
  $("main").onmouseup = stopMoving;
  $("main").ontouchstart = touchHandler;
  $("main").ontouchmove = touchHandler;
  $("main").ontouchend = stopMoving;
  // 迷路と画像の読み込み
  loadMazeData(function(){
    loadImages(initGame);
  });
};
// 画像データの読込
function loadImages(callback) {
  var cnt = 0;
  images = [];
  for (var i = 0; i <= 5; i++) {
    var img = new Image();
    img.src = "maze-image/" + i + ".png";
    img.onload = function (e) {
      cnt++;
      if (cnt == 6) callback();
    };
    images.push(img);
  }
}
// ゲームデータの読込
function loadMazeData(callback) {
  // Ajaxを利用してCSVデータを読み込み
  httpGet(
    FILE_MAZE,
    function (xhr, csv) {
      mazeOrg = csvToArray(csv);
      callback(); 
    },
    function (xhr, stat) {
      alert("[ERROR] 迷路データの読込に失敗");
    });
}
// CSVデータをJSの二次元配列に変換
function csvToArray(csv) {
  var lines = csv.split("\r\n");
  var res = [];
  for (var i = 0; i < lines.length; i++) {
    var cells = lines[i].split(",");
    res.push(cells);
  }
  return res;
}
// ゲームの初期化イベント
function initGame() {
  // 迷路データをコピー
  maze = cloneArray(mazeOrg);
  player.x = 1;
  player.y = 1;
  player.key = 0;
  player.mx = player.my = -1;
  drawDisp();
  nextTurn();
}
// ゲームループ
function nextTurn() {
  if (!movePlayer()) return;
  drawDisp();
  setTimeout(nextTurn, 200);
}
// プレイヤーの移動処理
function movePlayer() {
  if (player.mx < 0 && player.my < 0) return true;
  // プレイヤーの移動方向を判定
  var x2 = DISP_COL * TILE_W / 2;
  var y2 = DISP_ROW * TILE_H / 2;
  var ax = player.mx - x2;
  var ay = player.my - y2;
  var x = player.x, y = player.y;
  if (Math.abs(ax) > Math.abs(ay)) {
    x += (ax > 0) ? 1 : -1;
  } else {
    y += (ay > 0) ? 1 : -1;
  }
  // 移動範囲にあるか？
  if (0 <= x && x <= maze[0].length &&
      0 <= y && y <  maze.length) {
      var c = maze[y][x];
      // ゲームイベントの処理
      if (c != C_WALL) {
        if (c == C_DOOR) {
          if (player.key == 0) {
            stopMoving();
            alert("ドアを開けるには鍵が必要です。");
            return true;
          }
          player.key--;
          maze[y][x] = C_NONE;
        }
        if (c == C_KEY) {
          stopMoving();
          alert("鍵を入手しました!");
          player.key++;
          maze[y][x] = C_NONE;
        }
        if (c == C_GOAL) {
          stopMoving();
          alert("祝!ゴールしました");
          initGame();
          return false;
        }
        player.x = x;
        player.y = y;
      }
  }
  return true;
}
function stopMoving() {
  player.mx = player.my = -1;
}
// 描画イベント
function drawDisp() {
  ctx.clearRect(0,0,320,320);
  for (var y = 0; y < DISP_ROW; y++) {
    for (var x = 0; x < DISP_COL; x++) {
      var px = player.x + x - 3;
      var py = player.y + y - 3;
      var xx = x * TILE_W;
      var yy = y * TILE_H;
      var c = -1;
      if (0 <= py && py < maze.length &&
          0 <= px && px < maze[0].length) {
        c = parseInt(maze[py][px]);
      }
      // 描画
      if (c >= 0) {
        ctx.drawImage(images[c], xx, yy);
      } else {
        ctx.fillStyle = "black";
        ctx.fillRect(xx, yy, TILE_W, TILE_H);
      }
      ctx.strokeStyle = "gray";
      ctx.strokeRect(xx, yy, TILE_W, TILE_H);
      // プレイヤーを描画
      if (x == 3 && y == 3)
        ctx.drawImage(images[IMG_PLAYER], xx, yy);
    }
  }
}
// Ajaxを手軽に行なう関数を定義したもの
function httpGet(url, onsuccess, onerror) {
  // XMLHttpRequestのオブジェクトを作成
  var xhr = new XMLHttpRequest();
  // 非同期通信でURLをセット
  xhr.open('GET', url, true);
  // 通信状態が変化したときのイベント
  xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) { //通信完了
      if (xhr.status == 200) { //HTTPステータス200
        onsuccess(xhr, xhr.responseText);
      } else {
        onerror(xhr, xhr.status);
      }
    }
  };
  xhr.send(''); // 通信を開始
  return xhr;
}
// マウスイベントの処理
function mouseDownHandler(e) {
  calcXY(e, e);
}
function mouseMoveHandler(e) {
  if (player.mx < 0 && player.my < 0) return;
  calcXY(e, e);
}
// タッチイベントの処理
function touchHandler(e) {
  calcXY(e, e.touches[0]);
}
// 座標を計算する
function calcXY(e, pos) {
  e.preventDefault();
  var r = e.target.getBoundingClientRect();
  player.mx = pos.clientX - r.left;
  player.my = pos.clientY - r.top;
}
// 配列変数のコピー
function cloneArray(a) {
  var b = [];
  for (var i = 0; i < a.length; i++) {
    var v = a[i];
    if (typeof(v) == "object") {
      v = cloneArray(v);
    }
    b[i] = v;
  }
  return b;
}
// DOMオブジェクトの取得
function $(id){
  return document.getElementById(id);
}



