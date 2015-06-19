var DB_NAME = "todo.db";
var DB_VER  = 100;
var db; // DBオブジェクトを記憶する変数
// 非同期でDBのオープンを要求する --------- (*1)
var req = indexedDB.open(DB_NAME, DB_VER);
// データベースのイベントを設定 ------ (*2)
req.onsuccess = function (e) {
  // DBオブジェクトを記憶
  db = e.target.result;
  showList();
};
req.onerror = onError;
function onError(e) {
  alert("Error:" + e.message);
}
// オブジェクトストアの作成----(*3)
req.onupgradeneeded = function (e) {
  var db = e.target.result;
  // オブジェクトストアの設定
  var store_name = "items";
  var store_opt = {
  	keyPath: "id",
  	autoIncrement: true
  };
  // オブジェクトストアを作成
  db.createObjectStore(
  	store_name, store_opt);
};
// アイテムの追加 ------- (*4)
function addItem() {
  // トランザクションを開始
  var tr = db.transaction(
  	["items"], "readwrite");
  // オブジェクトストアを得る
  var os = tr.objectStore("items");
  // 値を挿入する
  var req = os.put(
  	{ "title": $("title").value }
  );
  // イベントの設定
  req.onerror = onError;
  tr.oncomplete = function () {
    showList();
    $("title").value = "";
    $("title").focus();
  };
}
// アイテム一覧の表示-----(*5)
function showList() {
  // 画面を初期化
  $("list").innerHTML = "";
  // トランザクションを開始
  var tr = db.transaction(["items"]);
  // オブジェクトストアを得る
  var os = tr.objectStore("items");
  // カーソルを要求する
  var req = os.openCursor();
  // イベントを設定する
  req.onerror = onError;
  req.onsuccess = showListOnSuccess;
}
// レコードが一つずつ得られる ----(*6)
function showListOnSuccess(e) {
   // カーソルを得る
  var cur = e.target.result;
  if (!cur) return;
  // 値を得る
  var v = cur.value;
  // リストを追加
  var li = document.createElement("li");
  li.innerHTML = 
	"<button onclick='"+
	"rmItem(" + v.id + ")'>x" +
	"</button> " + 
	tohtml(v.title);
  $("list").appendChild(li);
  // カーソルを進める
  cur.continue();
}
// アイテムの削除
function rmItem(id) {
  // トランザクションを開始
  var tr = db.transaction(["items"],
  	"readwrite");
  // オブジェクトストアを得る
  var os = tr.objectStore("items");
  // 指定のIDを削除する
  var req = os.delete(id);
  req.onerror = onError;
  tr.oncomplete = showList;
}
function tohtml(t) {
  t = t.replace("&", "&amp;");
  t = t.replace(">", "&gt;");
  t = t.replace("<", "&lt;");
  return t;
}
function $(id) {
  return document.getElementById(id);
}


