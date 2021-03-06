## Author A. Mezghani
## Description Contains some rtools ...
## Created 14.11.2014

as.decimal <- function(x=NULL) {
    ## converts from degree min sec format to degrees ...
    ##x is in the form "49°17´38´´"
    if (!is.null(x)) {
        deg <-as.numeric(substr(x,1,2)) 
        min <- as.numeric(substr(x,4,5))
        sec <- as.numeric(substr(x,7,8))     
        x <- deg + min/60 + sec/3600
    }
    return(x)
}


## compute the percentage of missing data in x
missval <- function(x) sum(is.na(coredata(x)))/length(coredata(x))

## compute the quantile 95% of x
q95 <- function(x,na.rm=TRUE) quantile(x,probs=.95,na.rm=na.rm)

## compute the quantile 5% of x
q5 <- function(x,na.rm=TRUE) quantile(x,probs=.05,na.rm=na.rm)

## compute the quantile 5% of x
q995 <- function(x,na.rm=TRUE) quantile(x,probs=.995,na.rm=na.rm)

## compute the quantile 5% of x
q975 <- function(x,na.rm=TRUE) quantile(x,probs=.975,na.rm=na.rm)

## count the number of valid data points
nv <- function(x,...) sum(is.finite(x))

## Compute the coefficient of variation of x
cv <- function(x,na.rm=TRUE) {sd(x,na.rm=na.rm)/mean(x,na.rm=na.rm)}

stand <- function(x) (x - mean(x,na.rm=TRUE))/sd(x,na.rm=TRUE)



# Wrap-around for lag.zoo to work on station and field objects:
lag.station <- function(x,...) {
  y <- lag(zoo(x),...)
  y <- attrcp(x,y)
  class(y) <- class(x)
  invisible(y)
}

lag.field <- function(x,...) lag.station(x,...)
  
exit <- function() q(save="no")

filt <- function(x,...) UseMethod("filt")

filt.default <- function(x,n,type='ma',lowpass=TRUE) {
  
# A number of different filters using different window
# shapes.
#
# R.E. Benestad, July, 2002, met.no.
#
# ref: Press et al. (1989), Numerical Recipes in Pascal, pp. 466
#library(ts)

# Moving-average (box-car) filter
  ma.filt <- function(x,n) {
    y <- filter(x,rep(1,n)/n)
    y
  }

# Gaussian filter with cut-off at 0.025 and 0.975 of the area.
  gauss.filt <- function(x,n) {
    i <- seq(0,qnorm(0.975),length=n/2)
    win <- dnorm(c(sort(-i),i))
    win <- win/sum(win)
    y <- filter(x,win)
    y
  }

# Binomial filter
  binom.filt <- function(x,n) {
    win <- choose(n-1,0:(n-1))
    win <- win/max(win,na.rm=T)
    win[is.na(win)] <- 1
    win <- win/sum(win,na.rm=T)
    y <- filter(x,win)
    y
  }

# Parzen filter (Press,et al. (1989))
  parzen.filt  <-  function(x,n) {
    j <- 0:(n-1)
    win <- 1 - abs((j - 0.5*(n-1))/(0.5*(n+1)))
    win <- win/sum(win)
    y <- filter(x,win)
    y
  }

# Hanning filter (Press,et al. (1989))
  hanning.filt  <-  function(x,n) {
    j <- 0:(n-1)
    win <- 0.5*(1-cos(2*pi*j/(n-1)))
    win <- win/sum(win)
    y <- filter(x,win)
    y
  }

# Welch filter (Press,et al. (1989))
  welch.filt  <-  function(x,n) {
    j <- 0:(n-1)
    win <- 1 - ((j - 0.5*(n-1))/(0.5*(n+1)))^2
    win <- win/sum(win)
    y <- filter(x,win)
    y
  }

  y <- coredata(x)
  z <- eval(parse(text=paste(type,'filt(y,n)',sep='.')))
  hp <- as.numeric(y - coredata(z))
  if (!is.null(dim(x))) dim(hp) <- dim(x)
  if (lowpass) coredata(x) <- coredata(z) else
               coredata(x) <- hp
  attr(x,'history') <- history.stamp(x)
  return(x)
}
  
figlab <- function(x,xpos=0.001,ypos=0.001) {
  par(new=TRUE,fig=c(0,1,0,1),xaxt='n',yaxt='n',bty='n',mar=rep(0,4))
  plot(c(0,1),c(0,1),type='n')
  text(xpos,ypos,x,cex=1.2,pos=4,col='grey30')
}

ensemblemean <- function(x,FUN='rowMeans') {
  if (inherits(x,'pca')) z <- as.station(x) else z <- x
  ## Estimate the ensemble mean
  zz <- unlist(lapply(coredata(z),FUN=FUN))
  zm <- matrix(zz,length(index(z[[1]])),length(z))
  zm <- zoo(zm,order.by=index(z[[1]]))
  zm <- as.station(zm,param=varid(z),unit=unit(z),
                   loc=unlist(lapply(z,loc)),lon=unlist(lapply(z,lon)),
                   lat=unlist(lapply(z,lat)),alt=unlist(lapply(z,alt)),
                   longname=attr(x,'longname'),aspect=attr(x,'aspect'),
                   info='Ensemble mean ESD')
  invisible(zm)
}


propchange <- function(x,it0=c(1979,2013)) {
  z <- coredata(x)
  if (is.null(dim(z)))
      z <- 100*(z/mean(coredata(subset(x,it=it0)),na.rm=TRUE)) else
      z <- 100*t(t(z)/apply(coredata(subset(x,it=it0)),2,'mean',na.rm=TRUE))
  attributes(z) <- NULL
  z -> coredata(x)  
  x
}

