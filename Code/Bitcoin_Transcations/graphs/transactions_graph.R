# Setting working dir
getwd()
setwd("/home/pankaj/MasterThesis")

#remove all the variables from the workspace
rm(list = ls())

# Bitcoin Transactional Network.

# Reading daily bitcoin transcation csv file (graph.csv) created from SQL queries
g=read.csv(file="./data/daily/T_2013_04_10.csv",head=TRUE,sep=",")

library(igraph)

#Import a weighted edgelist is to just use the graph.data.frame() function
g1=graph.data.frame(g, directed=TRUE, vertices = NULL)

# fixing things by removing the loops in the graph

g2 <- simplify(g1, remove.multiple = F, remove.loops = T) 

png(filename="./Results/Daily_Transaction_2013_04_10.png")

plot(g2,vertex.size=0.5, edge.arrow.size=0.01,vertex.label=NA);

dev.off()

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

dd <- degree.distribution(g2, cumulative=F, mode="all");

png(filename="./Results/degree_distribution_2013_04_10.png")

plot(dd, pch=21, cex=1, log="xy", ylim=c(.01,10), col="red", xlab="Degree", ylab="Cumulative Frequency");

dev.off()


# plot and fit the power law distribution

fit_power_law = function(graph) {
  # calculate degree
  d = degree(graph, mode = "all")
  dd = degree.distribution(graph, mode = "all", cumulative = FALSE)
  degree = 1:max(d)
  probability = dd[-1]
  # delete blank values
  nonzero.position = which(probability != 0)
  probability = probability[nonzero.position]
  degree = degree[nonzero.position]
  reg = lm(log(probability) ~ log(degree))
  cozf = coef(reg)
  power.law.fit = function(x) exp(cozf[[1]] + cozf[[2]] * log(x))
  alpha = -cozf[[2]]
  R.square = summary(reg)$r.squared
  print(paste("Alpha =", round(alpha, 3)))
  print(paste("R square =", round(R.square, 3)))
  # plot
  plot(probability ~ degree, log = "xy", xlab = "Degree (log)", ylab = "Probability (log)", 
       col = 1, main = "Degree Distribution")
  curve(power.law.fit, col = "red", add = T, n = length(d))
}


fit_power_law(g2)



