# Setting working dir
getwd()
setwd("/home/pankaj/MasterThesis")

#remove all the variables from the workspace
rm(list = ls())

# Building daily transcation graphs for similarity measure

# Reading daily bitcoin transcation csv file (graph.csv) created from SQL queries

# Reading file for creating graph1
f1=read.csv(file="./data/daily/T_2013_03_11.csv",head=TRUE,sep=",")

# Reading file for creating graph1
f2=read.csv(file="./data/daily/T_2013_03_10.csv",head=TRUE,sep=",")

library(igraph)

#Import a weighted edgelist is to just use the graph.data.frame() function
g1 <- simplify (graph.data.frame(f1, directed=TRUE, vertices = NULL), remove.multiple = F, remove.loops = T)
g2 <- simplify (graph.data.frame(f2, directed=TRUE, vertices = NULL), remove.multiple = F, remove.loops = T)

#Decide if two graphs are isomorphic
isomorphic(g1,g2, method = "vf2")

#Count the number of isomorphic mappings between two graphs

count_isomorphisms(g1, g2, vertex.color1 = NULL,vertex.color2 = NULL)

## Compute graph similarity (intersection of vertices and edges between the graphs)
#g_sim <- graph.intersection(g1, g2, byname = "auto", keep.all.vertices = FALSE)

g.union <- graph.union(g1, g2)
g.intersect <- graph.intersection(g1, g2, keep.all.vertices=F)

sim.index <- ecount(g.intersect)/ecount(g.union)
sim.index

# Calculate the diameter

#diameter(g2)
