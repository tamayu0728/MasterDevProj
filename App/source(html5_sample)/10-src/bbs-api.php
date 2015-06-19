<?php
// 掲示板のAPI ---- (*1)
define("FILE_BBS", "./bbs.log");   // ログの保存先
define("MASTER_PASSWORD", "1234"); // 削除用パスワード
// どのAPIを呼び出しているか確認 ---------(*2)
switch (get("api")) {
  case 'list':   apiList(); break;
  case 'add':    apiAdd(); break;
  case 'delete': apiDelete(); break;
  default:
    outputJSON("error", "unknown api");
}
// データの抽出 -----(*3)
function apiList() {
  $log = loadLogFile();
  outputJSON("ok", $log);
}
// データの追加 ------- (*4)
function apiAdd() {
  $log = loadLogFile();
  $id = count($log);
  array_push($log, array(
    "id"    => $id,
    "name"  => get("name"),
    "title" => get("title"),
    "body"  => get("body"),
    "status"=> "ok"
  ));
  $r = saveLogFile($log);
  if ($r) {
    outputJSON("ok", $id);
  } else {
    outputJSON("error", "ファイル書込エラー");
  }
}
// データの削除 ---------- (*5)
function apiDelete() {
  $id = intval(get("id", -1));
  $password = get("password");
  if ($password !== MASTER_PASSWORD) {
    outputJSON("error", "パスワードが違います");
    return;
  }
  if ($id < 0) {
    outpuJSON("error", "idの不正");
    return;
  }
  $log = loadLogFile();
  if (isset($log[$id]["status"])) {
    $log[$id]["status"] = "del";
  }
  $r = saveLogFile($log);
  outputJSON($r ? "ok":"error", $id);
}
// JSONで結果を出力する-----(*6)
function outputJSON($code, $data) {
  $result = array("result"=>$code,
    "data"=>$data);
  header('Content-Type: application/json; charset=utf8');
  echo json_encode($result);
}
// パラメータの取得
function get($name, $default = "") {
  return isset($_GET[$name]) ? $_GET[$name] : $default;
}
// ログファイルの読み込み------(*7)
function loadLogFile() {
  if (!file_exists(FILE_BBS)) return array();
  $raw = @file_get_contents(FILE_BBS);
  $log = unserialize($raw);
  if (!is_array($log)) return array();
  return $log;
}
// ログファイルの保存
function saveLogFile($log) {
  $raw = serialize($log);
  $r = @file_put_contents(FILE_BBS, $raw);
  return ($r !== FALSE); 
}

