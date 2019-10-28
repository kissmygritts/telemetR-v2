source('sandbox/scripts/telemetr-utilities.R')

# create dir to hold telemetr db if it doesn't already exist
create_telemetr_dir <- function (directory = '~') {
  dir_path <- paste(directory, '.telemetr', sep = '/')
  
  if (dir.exists(dir_path)) {
    warning('directory already exists - skip creating directory')
  } else {
    dir.create(dir_path)
  }
  
  return(dir_path)
}

# create_telemetr_dir()

# create telemetr database
create_telemetr_db <- function (directory = '~') {
  # check if .telemetr directory exists
  dir_path <- create_telemetr_dir(directory)
  db_path <- paste(dir_path, 'telemetr-db.sqlite3', sep = '/')
  
  
  if (!(file.exists(db_path))) {
    telemetry_db <- DBI::dbConnect(RSQLite::SQLite(), db_path)
    DBI::dbDisconnect(telemetry_db)
  } else {
    warning('telemetr-db.sqlite3 already exists - skip create database')
  }
}

# create_telemetr_db()

# bootstrap telemetr database
bootstrap_telemetr <- function (db_path = '~/.telemetr/telemetr-db.sqlite3') {
  
  ## read & chunk sql files
  bootstrap_sql <- readr::read_file('sandbox/scripts/sql/bootstrap-db.sql')
  sql_list <- chunk_multi_statement_sql(sql_statements = bootstrap_sql)
  
  ## execute statements
  ### connect to database
  db_conn <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  ### loop over bootstrap sql
  lapply(sql_list, function (x) {
    RSQLite::dbExecute(db_conn, x)
  })
  
  ### disconnect
  RSQLite::dbDisconnect(db_conn)
}

# bootstrap_telemetr()
# conn <- DBI::dbConnect(RSQLite::SQLite(), '~/.telemetr/telemetr-db.sqlite3')
# DBI::dbListTables(conn)
# DBI::dbDisconnect(conn)

delete_telemetr <- function (db_path = '~/.telemetr/telemetr-db.sqlite3', force = FALSE) {
  if (force) {
    file.remove(db_path)
  } else {
    warning('you must explicitly force deletion for safety')
  }
}

# delete_telemetr(force = T)
