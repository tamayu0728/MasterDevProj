// puzzle.js
// 変数の初期化 ------------- (*1)
var block_width = 32; // ブロック１つの大きさ
var canvas_width = 320; // キャンバスのサイズを指定
var canvas_height = 320;// 32px * 10
var blocks = []; // ブロックデータを表わす
var block_cols = canvas_width / block_width; // ブロックの列数
var block_rows = canvas_height / block_width;// ブロックの行数
var block_colors = [ // ブロックの色を定義 -------- (*2)
    "rgba(0,0,0,0)","rgba(255,0,0,0.9)",
    "rgba(0,255,0,0.9)","rgba(0,0,255,0.9)"];
var context; // 描画用のコンテキスト用
var x_table = [ 0, 1, 0, -1]; // 上右下左を表わすテーブル
var y_table = [-1, 0, 1,  0];
var image; // おまけ画像の表示用
var score = 0; // ゲームのスコア
// いろいろな初期設定 ---------------------------- (*3)
window.onload = function () {
  // キャンバスの初期化
  var canvas = document.getElementById("main");
  context = canvas.getContext("2d");
  // マウスイベントを設定
  canvas.onmousedown = canvasDownHandler;
  // ご褒美画像の読み込み
  image = new Image();
  image.src = "gohoubi.jpg";
  image.onload = function () {
    newGame(); // 読込完了でゲーム開始
  };
}
// 新規ゲーム
function newGame() {
  score = 0;
  initBlock();
  drawBlocks();
}
// ブロックを初期化する ---- (*4)
function initBlock() {
  for (var i = 0; i < block_cols * block_rows; i++) {
    blocks[i] = Math.floor(Math.random() * 3 + 1);
  }
}
// ブロックを描画する ----- (*5)
function drawBlocks() {
  // 画面を初期化
  context.clearRect(0,0,canvas_width,canvas_height);
  context.drawImage(image, 0, 0); // ご褒美画像を描画
  // ブロックを描画
  for (var y = 0; y < block_rows; y++) {
    for (var x = 0; x < block_cols; x++) {
      var v = blocks[x + y * block_cols];
      context.beginPath();
      context.fillStyle = block_colors[v];
      context.fillRect(
        x * block_width,
        y * block_width,
        block_width, block_width);
    }
  }
}
// ブロックをタッチしたときの処理 -------- (*6)
function canvasDownHandler(e) {
  e.preventDefault(); // ブラウザイベントをキャンセル---(*7)
  // タッチ座標を取得
  var px = e.clientX, py = e.clientY;
  // 実際にタッチされた座標を計算
  var r = e.target.getBoundingClientRect();
  px -= r.left;
  py -= r.top;
  // タッチされたセル番号を計算
  var x = Math.floor(px / block_width);
  var y = Math.floor(py / block_width);
  var bcolor = blocks[x + y * block_cols];
  if (bcolor == 0) return; // 既に空ならば処理しない
  // 隣接するブロックがあるかどうかテスト----(*8)
  var count = checkBlock(x, y, bcolor);
  if (count <= 1) return; // 隣接する色がなければ消せない
  if (count > 1) { // スコアに加算
    score += Math.pow(count,2);
    var info = document.getElementById("score");
    info.innerHTML = "SCORE " + score;
  }
  // ブロックを消す処理
  // 隣接するブロックを消す
  removeBlock(x, y, bcolor);
  drawBlocks();
  // 穴の空いた部分を寄せる処理を行う
  setTimeout(moveBlocks, 500);
}
// 隣接するブロックがあるかどうか調べる
function checkBlock(x, y, testColor) {
  return checkBlockRec(x, y, testColor, [], false);
}
// 隣接するブロックを消す
function removeBlock(x, y, removeColor) {
  checkBlockRec(x, y, removeColor, [], true);
}
// 再帰的にブロックをチェックする------(*9)
function checkBlockRec(x, y, color, footprint, flagRemove) {
  // 範囲外のブロックなら0を返す
  if (x < 0 || y < 0 || x >= block_cols || y >= block_rows) return 0;
  var i = x + y * block_cols;
  if (footprint[i]) return 0; // 既に訪問済みなら抜ける
  if (blocks[i] != color) return 0; // 同じ色でなければ抜ける
  footprint[i] = true; // 訪問済みフラグをセット
  if (flagRemove) blocks[i] = 0; // 消す
  console.log("foot:" + x + "," + y);
  var count = 1;
  for (var j = 0; j < 4; j++) { // 上下左右をチェック
    count += checkBlockRec(
      x + x_table[j], y + y_table[j],
      color, footprint, flagRemove);
  }
  return count;
}
// 穴の空いた部分のブロックを寄せる処理 ------ (*10)
function moveBlocks() {
  // ブロックを下側に落とす
  var tmp = createZeroArray(block_rows * block_cols);
  for (var x = 0; x < block_cols; x++) {
    var ny = block_rows - 1;
    for (var y = block_rows - 1; y >= 0 ; y--) {
      var v = blocks[x + y * block_cols];
      if (v == 0) continue;
      tmp[x + ny-- * block_cols] = v;
    }
  }
  blocks = tmp;
  drawBlocks(); //-------(*11)
  // ブロックを右側に寄せる
  tmp = createZeroArray(block_rows * block_cols);
  for (var y = 0; y < block_rows; y++) {
    var nx = block_cols - 1;
    for (var x = block_cols - 1; x >= 0 ; x--) {
      var v = blocks[x + y * block_cols];
      if (v == 0) continue;
      tmp[nx-- + y * block_cols] = v;
    }
  }
  blocks = tmp;
  // ちょっと待ってから描画する ---------(*12)
  setTimeout(drawBlocks, 500);
  // ゲームクリアか判定する
  if (checkGameClear()) {
    setTimeout(function(){
      alert("ゲームクリア! SCORE:" + score);
      newGame();
    }, 500);
  }
}
// ゲームクリアしたかどうか判定する関数-------(*13)
function checkGameClear() {
  for (var i = 0; i < blocks.length; i++) {
    if (blocks[i] != 0) return false;
  }
  return true;
}
// 指定要素個のゼロで初期化された配列を生成
function createZeroArray(n) {
  var r = [];
  for (var i = 0; i < n; i++) r[i] = 0;
  return r;
}




