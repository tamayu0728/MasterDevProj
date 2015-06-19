<?php
// 必要なヘッダを設定 ----- (*1)
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
// 現在時刻を一秒ごとに送信 --- (*2)
$id = 1000;
for (;;) {
  $now = date("H:i:s");
  echo "id: $id\n";   // --- (*3)
  echo "data: $now\n";// 
  echo "\n";          //
  $id++;
  ob_flush(); flush(); // ---(*4)
  sleep(1);
}



