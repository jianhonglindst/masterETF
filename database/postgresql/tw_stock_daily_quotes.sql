-- ----------------------------
--  Table structure for tw_stock_daily_quotes
-- ----------------------------
CREATE TABLE IF NOT EXISTS"public"."tw_stock_daily_quotes" (
	"__uuid" uuid DEFAULT uuid_generate_v4(),
	"__create_time" timestamp(6) WITH TIME ZONE DEFAULT now(),
	"__update_time" timestamp(6) WITH TIME ZONE DEFAULT now(),
	"date" date,
	"stock_code" varchar COLLATE "default",
	"stock_name" varchar COLLATE "default",
	"trade_volume" numeric,
	"transaction" numeric,
	"trade_value" numeric,
	"opening_price" numeric,
	"highest_price" numeric,
	"lowest_price" numeric,
	"closing_price" numeric,
	"dir" varchar COLLATE "default",
	"change" numeric,
	"last_best_bid_price" numeric,
	"last_best_bid_volume" numeric,
	"last_best_ask_price" numeric,
	"last_best_ask_volume" numeric,
	"price_eaming_ration" numeric
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "public"."tw_stock_daily_quotes" IS '台灣證券交易所-每日收盤行情-MI_INDEX';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."__uuid" IS 'uuid';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."__create_time" IS '資料初始化時間';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."__update_time" IS '資料更新時間';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."date" IS '交易日期';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."stock_code" IS '證券代號';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."stock_name" IS '證券名稱';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."trade_volume" IS '成交股數';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."transaction" IS '成交筆數';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."trade_value" IS '成交金額';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."opening_price" IS '開盤價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."highest_price" IS '最高價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."lowest_price" IS '最低價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."closing_price" IS '收盤價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."dir" IS '漲跌訊號';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."change" IS '漲跌價差';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."last_best_bid_price" IS '最後揭示買價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."last_best_bid_volume" IS '最後揭示買量';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."last_best_ask_price" IS '最後揭示賣價';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."last_best_ask_volume" IS '最後揭示賣量';
COMMENT ON COLUMN "public"."tw_stock_daily_quotes"."price_eaming_ration" IS '本益比';

-- ----------------------------
--  Indexes structure for table tw_stock_daily_quotes
-- ----------------------------
CREATE UNIQUE INDEX  "idx_tw_stock_daily_quotes" ON "public"."tw_stock_daily_quotes" USING btree("date" "pg_catalog"."date_ops" ASC NULLS LAST, stock_code COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);

