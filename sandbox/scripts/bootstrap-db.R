library(DBI)
library(RSQLite)

# init ----
db_path <- '~/.telemetr/telemetr-db.sqlite3'
db_conn <- DBI::dbConnect(RSQLite::SQLite(), '~/.telemetr/telemetr-db.sqlite3')
DBI::dbListTables(db_conn)

# 1. read sql from a file for bootstrapping db ----
sql_files <- readr::read_file('sandbox/scripts/sql/bootstrap-db.sql')
sql_files

# 2. create directory for sqlite database, if it doesn't exist ----
## create .telemetr dir
create_telemetr_dir <- function (directory = '~') {
  db_name <- 'telemetr-db.sqlite3'
  dir_path <- paste(directory, '.telemetr', sep = '/')
  # db_path <- paste(dir_path, db_name, sep = '/')
  
  if (dir.exists(dir_path)) {
    print('directory exists')
  } else {
    dir.create(dir_path)
    print('created directory')
  }
  
  return(dir_path)
}

## create telemetr database
create_telemetr_db <- function (directory = '~') {
  # check if .telemetr directory exists
  dir_path <- create_telemetr_dir(directory)
  db_path <- paste(dir_path, 'telemetr-db.sqlite3', sep = '/')
  
  
  if (!(file.exists(db_path))) {
    telemetry_db <- DBI::dbConnect(RSQLite::SQLite(), db_path)
    DBI::dbDisconnect(telemetry_db)
  } else {
    print('database exists')
  }
} 

# 3. bootstrap telemetr database
## read sql file
sql_files <- readr::read_file('sandbox/scripts/sql/bootstrap-db.sql')
sql_files

## DBI will only execute one statement at a time
statements <- stringr::str_split(sql_files, ';')
statements

stringr::str_count(statements[[1]])

sql_list <- lapply(statements, DBI::SQL)
class(sql_list)
length(sql_list)

## chunk multi statement sql file
chunk_multi_statement_sql <- function (sql_statements) {
  chunks <- stringr::str_split(sql_statements, ';')[[1]]
  sql <- lapply(seq_along(chunks), function (i) {
    if (nchar(chunks[i]) > 0) {
      DBI::SQL(chunks[i])
    }
  })
  Filter(function (x) {
    !(is.null(x))
  }, sql)
}

sql_files
sql_list <- chunk_multi_statement_sql(sql_files)
sql_list
sql_list[[1]]
create_telemetr_db()

## loop through sql_list and run queries
### connect to database & list tables
db_conn <- dbConnect(RSQLite::SQLite(), '~/.telemetr/telemetr-db.sqlite3')
RSQLite::dbListTables(db_conn)

### run sql statement
RSQLite::dbExecute(conn = db_conn, statement = sql_list[[1]])

### check table exists
RSQLite::dbListTables(db_conn)

### now try again
RSQLite::dbExecute(conn = db_conn, statement = sql_list[[2]])
RSQLite::dbListTables(db_conn)

### bootstrap database function
bootstrap_telemetr <- function (db_path = '~/.telemetr/telemetr-db.sqlite3') {
  
  ## read & chunk sql files
  bootstrap_sql <- readr::read_file('sandbox/scripts/sql/bootstrap-db.sql')
  sql_list <- chunk_multi_statement_sql(sql_statements = bootstrap_sql)
  
  ## execute statements
  ### connect to database
  db_conn <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  ### begin sql transaction
  
  
  ### loop over bootstrap sql
  rs <- lapply(sql_list, function (x) {
    RSQLite::dbExecute(db_conn, x)
  })
  
  RSQLite::dbDisconnect(db_conn)
}

## run bootstrap database code
create_telemetr_db()
bootstrap_telemetr()

db_conn <- DBI::dbConnect(RSQLite::SQLite(), db_path)
dbListTables(db_conn)

