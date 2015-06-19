function showVersionInfo() {
  alert('ver.1.0');
}
function checkNewVersion() {
  applicationCache.update();
}
window.onload = function() {
  applicationCache.addEventListener(
    "updateready",
    function() {
      var b = confirm("新しいバージョンがあります。更新しますか？");
      if (b) {
        applicationCache.swapCache(); // キャッシュを更新
        location.reload();
      }
    });
  applicationCache.addEventListener(
    "cached",
    function() {
      alert("キャッシュしました");
    });
  applicationCache.addEventListener(
    "noupdate",
    function() {
      alert("アップデートはありません");
    });
  applicationCache.addEventListener(
    "obsolete ",
    function() {
      alert("マニフェストのエラーです");
    });
  applicationCache.addEventListener(
    "error",
    function() {
      alert("エラーです");
    });
};

