// 掲示板のJavaScript
//-----------------------------------------------------------
// APIのURL
var API_URL = "./bbs-api.php";
// 初期化イベント ---- (*1)
window.onload = function () {
  // イベントの設定
  $("addButton").onclick = writeArticle;
  api("list", {}, showList); 
};
// 書込一覧の生成 ---- (*2)
function showList(res) {
  var list = res["data"];
  list.reverse(); // 記事を新しい順に並び変え
  $("log").innerHTML = "";
  var template = $("template");
  for (var i = 0; i < list.length; i++) {
    var row = list[i];
    if (row["status"] != "ok") continue;
    // テンプレートを複製する ---- (*3)
    var article = template.cloneNode(true);
    var title = article.querySelector(".title");
    var body = article.querySelector(".body");
    var name = article.querySelector(".name");
    var delButton = article.querySelector(".delButton");
    title.innerHTML = row["title"];
    body.innerHTML = row["body"];
    name.innerHTML = "(投稿者:" + row["name"] + ")";
    delButton.dataDeleteID = row["id"]; // + -----(*4)
    delButton.onclick = deleteArticle;  // |
    $("log").appendChild(article);
    article.style.display = "block";
  }
}
// 新規書込 ----- (*5)
function writeArticle() {
  var params = {
    "title": $("title").value,
    "name": $("name").value,
    "body": $("body").value
  };
  // 入力チェック ---- (*6)
  if (params["title"] == "") return;
  if (params["name"] == "") return;
  // APIの呼び出し --- (*7)
  api("add", params, function (o) {
    if (o["result"] != "ok") {
      alert("失敗:" + o["data"]); return;
    }
    alert("書き込みました。");
    $("title").value = $("body").value = "";
    api("list", {}, showList);
  });
}
// 削除ボタンを押した時----(*6)
function deleteArticle(e) {
  var target = e.target;
  var id = target.dataDeleteID;
  var pw = prompt("パスワードは?");
  api("delete", {"id":id, "password":pw},
    function (o) {
      if (o["result"] != "ok") {
        alert("失敗:" + o["data"]); return;
      }
      alert("削除しました");
      api("list", {}, showList);
    }); 
}
// サーバAPIにアクセスする-------(*7)
function api(name, params, callback) {
  // apiにアクセスするURLを組み立てる
  var url = API_URL + "?api=" + name;
  for (var i in params) {
    url += "&" + i + "=" + encodeURIComponent(params[i]);
  }
  // サーバと非同期通信する-----(*8)
  httpGet(url,
    function(xhr, json) {
      console.log(json);//-------(*9)
      var o = JSON.parse(json);
      callback(o);
    },
    function(xhr, status) {
      console.log("[ERROR]" + status );
    });
}
// Ajaxを手軽に行なう関数を定義したもの
function httpGet(url, onsuccess, onerror) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
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
// idのDOM要素を取得
function $(id){
  return document.getElementById(id);
}

