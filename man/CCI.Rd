\name{CCI}
\alias{CCI}
\alias{stopCCI}
\title{Calculus Cyclone identification.}
\description{
Identifies cyclones (low pressure systems) in a gridded data set using a
Calculus Cyclone Identification (CCI) method (EMS04-A-00146, Benestad,
R.E.; Sorteberg, A.; Chen, D. 'Storm statistics derived using a
calculus-based cyclone identification method',
\url{http://www.cosis.net/members/meetings/sessions/oral_programme.php?p_id=110&s_id=1845}, European Meteorological Society AC2, Nice, Sept 28, 2004). Storms are identified with longitude, latitude, and date. Also returned are estimates of local minimum pressure, max pressure gradient near storm, max geostrophic and gradient windspeed near storm, and radius of the storm. The storm location is by means of finding where first derivatives of north--south and east--west gradients both are zero. The storm radius is estimated from the points of inflexion along the latitude and longitude lines running trough the centre of the storm. 

If a north-south or east-west sea level pressure (p) profile can be approximated as \deqn{p(\theta) = p_0 + \sum_{i=1}^{N_\theta} [ a_\theta(i) \cos(\omega_\theta(i) \theta) + b_\theta(i) \sin(\omega_\theta(i) \theta) ]}{p = p0 + sum [ a cos(w t) + b sin(w t) ]} 

Then the pressure gradient can be estimated as: \deqn{\frac{\partial \hat{p}(\theta)}{\partial \theta} = \sum_{i=1}^{N_\theta} \omega_\theta(i)[ -\hat{a}_\theta(i) \sin(\omega_\theta(i) \theta) + \hat{b}_\theta(i) \cos(\omega_\theta(i) \theta)]}{dp/dt = sum (w[ -a sin(w t) + b cos(w w)])}

The gradient in x and y directions are found after the transform
\deqn{\frac{d\hat{p}(x)}{dx} = \frac{1}{a \cos(\phi)} \frac{d\hat{p}(\theta)}{d\theta}}{dp/dx= 1/[a cos(t)] dp(t)/dt} and \deqn{\frac{d\hat{p}(y)}{dy} = \frac{1}{a} \frac{d\hat{p}(\phi)}{d\phi}}{dp/dy = 1/a dp/dt} (Gill, 1982).

This code is based on the CCI method of the R-package 'cyclones' and has
been adapted for 'esd'.

%% \code{stopCCI} signals the CCI process to stop in a safe manner by
%% removing the file '.CCI.run' in the run directory.

The maximum gradient wind (max.speed) is estimated as described in
Fleagle and Businger (1980) p. 163. (eq 4.27). 

Reference: Benestad \& Chen (2006) 'The use of a Calculus-based Cyclone Identification method for generating storm statistics', Tellus A, in press.
           Benestad (2005) 
} 
\usage{
CCI(Z,m=10,it=NULL,is=NULL,label=NULL,cyclones=TRUE,
                mindistance=1E6,dpmin=1E-3,pmax=NULL,rmin=1E4,rmax=2E6,
                accuracy=NULL,nsim=NULL,do.track=TRUE,fname="cyclones.rda",
                plot=FALSE,verbose=FALSE)
}
\arguments{
    \item{Z}{A field object.}
    \item{m}{Number of harmonics used for fit to profile (Fourier
           truncation), which decides the degree of smoothing of the
           field. Lower values of m result in greater smoothing.}
     \item{it}{A list providing time index, e.g. month.}
    \item{is}{A list providing space index, lon and/or lat.}
    \item{label}{Label for ID-purposes.}
    \item{cyclones}{TRUE: identifies cyclones, FALSE: anticyclones.}
    \item{mindistance}{Min distance between cyclones. Unit: m.}
    \item{dpmin}{Min pressure gradient at points of inflection around
      cyclone. Unit: Pa/m (10hPa/km).}
    \item{pmax}{Max pressure in center of cyclone. Unit: hPa.}
    \item{rmin}{Min average radius of cyclone. Unit: m.}
    \item{rmax}{Max average radius of cyclone. Unit: m.}
    \item{nsim}{Number of simultaneous cyclones identified and saved
      ordered according to depth/strength.}
    \item{do.track}{TRUE: tracks the cyclones with the 'track' function,
           FALSE: no tracking is applied.}
    \item{fname}{Name of output file.}
    \item{plot}{TRUE: show intermediate results as plots.}
    \item{verbose}{Print out diagnostics.}
    \item{accuracy}{Not yet finished.}
  }
\value{
  The CCI function returns an 'events' object (a data frame with spatio-temporal 
information) that is organized as follows: 
\code{as.events(X=data.frame(date,time,lon,lat,pcent,max.dspl,
      max.speed,radius,qf),label=label,...}, 
where \code{date} and \code{time} are vectors containing the date and time of each cyclone, 
\code{lon} and \code{lat} are the longitude and latitude of the cyclone centers (unit: degrees), 
\code{pcent} is the pressure at the center of each cyclone (unit: hPa),
\code{max.dpsl} is the maximum pressure gradient associated with each cyclone (unit: hPa/m), 
\code{max.speed} is the estimated maximum windspeed (unit: m/s), 
\code{radius} is the cyclone radius (unit: km), 
and \code{qf} is a kind of quality flag (1 = OK, 2 = less spatially precise,
identified after widening the pressure gradient zero-crossings).
}
\author{K.M. Parding & R.E. Benestad}
%% \examples{
%% \dontrun{
%% # Shell script for running in batch (background proccess)
%% #! /bin/bash
%% cat > paper20e.R << EOF
%% library(clim.pact)
%% library(cyclones)
%% source("cyclones/R/cyclones.R")

%% a<- Sys.info()
%% dir <- switch(substr(as.character(a[4]),1,9),
%%               "saragasso"="/data1/hirham/",
%%               "stratonim"="/data1/hirham/",
%%               "virvelvin"="/home/rasmusb/data/data1/")

%% filname.1 <- "/home/rasmusb/data/ERA40/era40_slp.nc"
%% fname.1 <- "data/cyclones_ERA40.Rdata"
%% vname.1 <- "msl"

%% print("===================<  ERA 15  >===================")
%% CCI(fname="data/cyclones_ERA40_r1.Rdata",dx=1,dy=1,fielddata=filname.1,
%%     vname=vname.1,label="ERA40: slp 1-degree res.",force365.25=TRUE,plot=FALSE)
%% EOF

%% nice R CMD BATCH --no-save paper20e.R paper20e.out
%% }
%% }
\keyword{manip}