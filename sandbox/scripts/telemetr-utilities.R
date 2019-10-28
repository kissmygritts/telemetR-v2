# chunk mulitline sql file into an R list of sql statements to 
# be run in sequence

chunk_multi_statement_sql <- function (sql_statements) {
  chunks <- stringr::str_split(sql_statements, ';')[[1]]
  chunks <- chunks[1:length(chunks) - 1]
  
  # get table names from sql
  table_names <- extract_table_from_sql(chunks)
  
  # create list of sql statements
  sql <- lapply(seq_along(chunks), function (i) {
    if (nchar(chunks[i]) > 0) {
      DBI::SQL(chunks[i])
    }
  })
  
  names(sql) <- table_names
  return(sql)
  # filter list of all null or na items
  # return(Filter(function (x) {
  #   !(is.null(x))
  # }, sql))
}

extract_table_from_sql <- function (sql_list) {
  pattern <- 'table (.*) \\('
  stringr::str_match(unlist(sql_list), pattern)[, 2]
}

# sql_files <- readr::read_file('sandbox/scripts/sql/bootstrap-db.sql')
# sql <- chunk_multi_statement_sql(sql_files)
# sql



