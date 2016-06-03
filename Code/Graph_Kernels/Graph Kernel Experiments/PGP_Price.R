## Deep kernels similariry Index and price correlation

# Setting working dir
getwd()
setwd("/home/pankaj/MasterThesis")

#remove all the variables from the workspace
rm(list = ls())

library(ggplot2)
library(reshape)


# read data
P=read.csv(file="./data/btc_usd/daily_price_march_april.csv",head=TRUE,sep=",")

colnames(P) <- tolower(colnames(P))

P$time <- as.Date( as.character( P$time ) )
names(P)
P

cor(P$close,P$p_gk_index)

# Scatterplot between two varibales
plot(P$deep_sim_index,P$close, main="Scatterplot", xlab="deep_Sim_Index ", ylab="Close", col=c("red","blue"),pch=19)

# Scatterplot between two varibales
plot(P$deep_sim_index,P$log_close, main="Scatterplot", xlab="deep_Sim_Index ", ylab="Close", col=c("red","blue"),pch=19)
#
ccf(P$deep_sim_index,P$close)



# Get into dataframe for ggplot
DF = data.frame(P)

str(DF)

# Plot the time series of market price

with(DF, plot(time, close, type="l", col="red3", 
              ylab="Price(USD))",
              ylim=c(0,1200)))

# Plot daily transcations

with(DF, plot(time, daily_transcations, type="l", col="red3", 
              ylab="Transcations",
              ylim=c(0,250000)))



#Plot tow graphs in same plot.


par(mar = c(5,5,2,5))

with(DF, plot(time, close, type="l", col="red3", 
             ylab="Price",
             ylim=c(0,250)))

par(new = T)
with(DF, plot(time, p_gk_index, type="l", col= "blue", ylim=c(0, 0.10),axes=F, xlab=NA, ylab=NA, cex=1.2))
axis(side = 4)
mtext(side = 4, line = 3, 'Propagation Similarity Index')
legend("topleft",
       legend=c("Price (USD)", "Propogation Similarity Metric"),
       lty=c(2,1), col=c("red3", "blue"))


