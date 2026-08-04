## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(polyglotSQL)

## -----------------------------------------------------------------------------
ast <- sql_parse("SELECT a, SUM(b) AS total FROM t GROUP BY a")
ast
str(ast$statements[[1]], max.level = 3, list.len = 4)

## -----------------------------------------------------------------------------
sql_tokenize("SELECT a FROM t WHERE x = 'hé'")

## -----------------------------------------------------------------------------
# 1. Syntax only (default)
sql_validate("SELECT FROM WHERE")

# 2. Strict syntax + semantic lint warnings
sql_validate("SELECT name, FROM employees", strict_syntax = TRUE)
sql_validate("SELECT *, category FROM products LIMIT 10", semantic = TRUE)

## -----------------------------------------------------------------------------
schema <- list(
  orders = c(o_id = "INT", o_user = "INT", o_total = "DECIMAL(10,2)"),
  users  = c(id = "INT", name = "TEXT")
)

sql_validate("SELECT o_missing FROM orders", schema = schema)

## -----------------------------------------------------------------------------
sql_source_tables(
  "WITH cte AS (SELECT id FROM base)
   SELECT * FROM cte JOIN other USING (id)"
)

## -----------------------------------------------------------------------------
lin <- sql_lineage(
  "WITH base AS (SELECT id, amount FROM payments)
   SELECT id, amount * 2 AS doubled FROM base"
)
lin

## -----------------------------------------------------------------------------
str(lin$columns[[2]]$tree, max.level = 2)

## -----------------------------------------------------------------------------
a <- sql_analyze(
  "WITH x AS (SELECT id FROM t)
   SELECT x.id, UPPER(name) AS shout FROM x JOIN u ON x.id = u.id"
)
a
vapply(a$projections, function(p) p$transformKind, character(1))

## -----------------------------------------------------------------------------
ol <- sql_openlineage(
  "INSERT INTO reports SELECT id, total FROM sales",
  namespace = "warehouse"
)
names(ol)

