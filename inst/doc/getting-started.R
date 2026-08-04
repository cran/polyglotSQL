## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(polyglotSQL)
polyglot_version()

## -----------------------------------------------------------------------------
sql_transpile(
  "SELECT IFNULL(a, b) FROM t",
  from = "mysql",
  to = "postgres"
)

## -----------------------------------------------------------------------------
sql_transpile(
  "SELECT 1; SELECT IFNULL(a, b) FROM t;",
  from = "mysql",
  to = "postgres"
)

## -----------------------------------------------------------------------------
cat(sql_transpile(
  "SELECT id, COUNT(*) AS n FROM logs GROUP BY id HAVING COUNT(*) > 10",
  from = "generic", to = "snowflake", pretty = TRUE
))

## -----------------------------------------------------------------------------
head(sql_dialects(full = TRUE), 10)

## -----------------------------------------------------------------------------
cat(sql_format("select id,sum(x) total from t where y=1 group by id"))

## -----------------------------------------------------------------------------
sql_validate("SELECT FROM WHERE")

## -----------------------------------------------------------------------------
ast <- sql_parse("SELECT a, b FROM t WHERE x = 1")
ast

## -----------------------------------------------------------------------------
sql_generate(sql_parse("SELECT `col name` FROM t", dialect = "mysql"),
             dialect = "postgres")

## -----------------------------------------------------------------------------
tryCatch(
  sql_parse("SELECT ((( FROM"),
  polyglot_parse_error = function(e) conditionMessage(e)
)

