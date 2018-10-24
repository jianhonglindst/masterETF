# Postgresql

## 在 Postgresql 使用 uuid

1. 使用語法 `select uuid_generate_v4()`測試看看能否正常生成`uuid`。
2. 如果產生`ERROR:  function uuid_generate_v4() does not exist`這個錯誤碼 ，則需要安裝`uuid-ossp`這個`EXTENSION`，語法如下: `CREATE EXTENSION "uuid-ossp";`
3. 如果要讓資料寫入時自動生成`uuid`，就在`default`的地方寫入`uuid_generate_v4()`即可。