# x is the new coordinate and X the old.

SST <- sst.DNMI()
SLP <- slp.DNMI()

z <- regrid(SLP,is=SST,verbose=TRUE)

map(SLP)
dev.new()
map(z)

y <- lat(SLP)
for (i in 1:length(y)) lines(c(-180,360),rep(y[i],2),col="green",lty=2)

x <- lon(SLP)
for (i in 1:length(x)) lines(rep(x[i],2),c(-90,90),col="green",lty=2)

