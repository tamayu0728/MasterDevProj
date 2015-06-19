// データベースの変数
var db;
// 初期イベント-----(*1)
window.onload = function () {
  // DBを開く
  db = openDatabase(
    "todo.db","1.0","todo",1024*1024*10);
  // テーブルを作成
  db.transaction(function(tr) {
    tr.executeSql(
      "CREATE TABLE IF NOT EXISTS "+
      "items(" + 
      "  id INTEGER PRIMARY KEY,"+
      "  title TEXT"+
      ")", [],
      function(){ showItems(); },
      sqlError);
  });
};
// アイテムの一覧を表示 -------(*2)
function showItems() {
  $("list").innerHTML = "";
  db.transaction(function(tr){
    tr.executeSql(
      "SELECT * FROM items", [],
      showItemsOnResult,
      sqlError);
  });
  $("item").focus();
}
function showItemsOnResult(rt, rs) {
  var html = "";
  for(var i = 0; i < rs.rows.length; i++) {
    var row = rs.rows.item(i);
    html += "<li><button onclick='rmItem("+
      row.id + ")'>x</button> " +
      tohtml(row.title) + "</li>";
  }
  $("list").innerHTML = html;
}
// アイテムを追加 ----(*3)
function addItem() {
  var title = $("item").value;
  $("item").value = "";
  db.transaction(function(tr){
    tr.executeSql(
      "INSERT INTO items"+
      "(title)VALUES(?)",[title],
      function() { showItems(); },
      sqlError);
  });
}
// アイテムを削除
function rmItem(id) {
  db.transaction(function(tr) {
    tr.executeSql(
      "DELETE FROM items "+
      "WHERE id=?", [id],
      function(){ showItems(); }, sqlError
    );
  });
}
function sqlError(tr, e) {
  alert("ERROR:" + e.message);
}
// HTMLに変換する
function tohtml(t) {
  t = t.replace("&", "&amp;");
  t = t.replace("<", "&lt;");
  t = t.replace(">", "&gt;");
  return t;
}
function $(id) {
  return document.getElementById(id);
}



