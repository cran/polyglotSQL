## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(polyglotSQL)

## -----------------------------------------------------------------------------
# MySQL constructs -> PostgreSQL
sql_transpile(
  "SELECT IFNULL(a, b), DATE_FORMAT(d, '%Y-%m-%d') FROM t LIMIT 5",
  from = "mysql", to = "postgres"
)

# T-SQL pagination and date functions -> PostgreSQL
sql_transpile(
  "SELECT TOP 10 name, GETDATE() AS now FROM users ORDER BY name",
  from = "tsql", to = "postgres"
)

# BigQuery -> Snowflake: quoting and safe casts
sql_transpile(
  "SELECT `user id`, SAFE_CAST(x AS INT64) FROM `proj.dataset.tbl`",
  from = "bigquery", to = "snowflake"
)

## -----------------------------------------------------------------------------
queries <- c(
  orders  = "SELECT IFNULL(status, 'unknown') AS status FROM orders",
  daily   = "SELECT DATE(created_at) AS d, COUNT(*) FROM events GROUP BY DATE(created_at)",
  users   = "SELECT id, CONCAT(first, ' ', last) AS full_name FROM users"
)

vapply(queries, sql_transpile, character(1),
       from = "mysql", to = "duckdb")

## -----------------------------------------------------------------------------
migrate <- function(sql, from, to) {
  tryCatch(
    list(ok = TRUE, sql = sql_transpile(sql, from = from, to = to)),
    polyglot_error = function(e) list(ok = FALSE, error = conditionMessage(e))
  )
}
migrate("SELECT IFNULL(a, b) FROM t", "mysql", "postgres")

## -----------------------------------------------------------------------------
sql_diff(
  "SELECT a FROM t",
  "SELECT a, b FROM t WHERE a > 1"
)

## -----------------------------------------------------------------------------
out <- sql_transpile("SELECT IFNULL(a, b) FROM t", from = "mysql", to = "postgres")
sql_validate(out, dialect = "postgres")$valid

