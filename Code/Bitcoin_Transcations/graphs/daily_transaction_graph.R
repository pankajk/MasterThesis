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
#results = dbSendQuery(mydb, "SELECT user_from_key, user_key_to, value, date FROM user_edges LIMIT 100");
results = dbSendQuery(mydb, "SELECT transaction_from_key, transaction_to_key, value, date FROM transactions LIMIT 100");

# Return results from a custom object to a data.frame
data = fetch(results, n=-1);

# Print data frame to console
data;

# Write CSV in R
write.table(data, file = "graph.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")

# Clear the results and close the connection
dbClearResult(results);

# Bitcoin Transactional Network.

# Reading daily bitcoin transcation csv file (graph.csv) created from SQL queries
el=read.csv(file="graph.csv",head=TRUE,sep=",")

#Because the vertex IDs in this dataset are numbers, we make sure igraph knows these should be treated as characters. 
el[,2]=as.character(el[,2])
el[,1]=as.character(el[,1]) 

#igraph needs the edgelist to be in matrix format
el=as.matrix(el) 

library(igraph)
#We first create a network from the first two columns, which has the list of vertices
g=graph.edgelist(el[,1:2]) 

#We then add the edge weights to this network by assigning an edge attribute called 'weight'.
E(g)$weight=as.numeric(el[,3]) 

#plot(g,layout=layout.fruchterman.reingold,edge.width=E(g)$weight, vertex.size=1, edge.arrow.size=.2,vertex.label=NA)


# Much easier way to import a weighted edgelist is to just use the graph.data.frame() function

el=read.csv(file="graph.csv",head=TRUE,sep=",")
g2=graph.data.frame(el, directed=T)
E(g2)

# First attempt to plot igraph network object
plot(g2)

# fixing things by removing the loops in the graph

g2 <- simplify(g2, remove.multiple = F, remove.loops = T) 

plot(g2,vertex.size=1, edge.arrow.size=.2,vertex.label=NA)

############################################################################
#
# Avaliable layout for the igraph
#
#layouts <- grep("^layout\\.", ls("package:igraph"), value=TRUE) 
#
# Remove layouts that do not apply to our graph.
#
#layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama", layouts)]
#
#par(mfrow=c(3,3))
#
#for (layout in layouts) {
#  print(layout)
#  l <- do.call(layout, list(g2)) 
#  plot(g2, edge.arrow.mode=0, layout=l, main=layout) }
#
#dev.off()
##############################################################################

# Degree distrubution

dd <- degree.distribution(g2, cumulative=T, mode="all")
plot(dd, pch=19, cex=1, col="orange", xlab="Degree", ylab="Cumulative Frequency")



