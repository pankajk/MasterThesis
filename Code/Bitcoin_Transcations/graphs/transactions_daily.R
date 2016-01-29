# Setting working dir
getwd()
setwd("/home/pankaj/MasterThesis")

# Load the SQLite library
library("RSQLite");

# Assign the sqlite datbase and full path to a variable
dbfile = "/home/pankaj/blockchain";

# Instantiate the dbDriver to a convenient object
sqlite = dbDriver("SQLite");

# Assign the connection string to a connection object
mydb = dbConnect(sqlite, dbfile);

# Request a list of tables using the connection object
dbListTables(mydb);

# Assign the results of a SQL query to an object
# Get daily data
results = dbSendQuery(mydb, "SELECT transaction_from_key, transaction_to_key, value FROM transactions WHERE date LIKE '%20130310%'");

# Return results from a custom object to a data.frame
data = fetch(results, n=-1);

# Print data frame to console
data;

# Write CSV in R
write.table(data, file = "./data/daily/T_2013_03_10.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")

# Clear the results and close the connection
dbClearResult(results);



