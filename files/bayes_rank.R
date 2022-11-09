###rank likelihood setup --- 
###the code for treg uses the sbgcop code as base 
###and all supporting functions that are not related 
###to identifying causal effects defined in this paper 
###are directly from the R package sbgcop; they are reproduced
###here for consistency###
###full conditional for beta###
beta.post <- function(x,z,sxtxi = NULL,cvarbeta = NULL){
	#x is the data matrix
	#z is the latent variable
	#sxtxt is (n/(n+1))*(x^t x)^-1 is the scaled cov matrix
	#cvarbeta is the chol of sxtxi
	p <- dim(x)[2]
	ebeta <- sxtxi%*%t(x)%*%z
	if(is.null(cvarbeta))cvarbeta <- chol(sxtxi)
	ebeta + cvarbeta%*%rnorm(p)
}

z.post <- function(ez,z,rnks,urnks){
	#ez is the expectation vector of the z
	#z is the current value of the latent vector
	#rnks is the ranks
	#urnks is the unique ranks
	n <- length(z)
	for(r in sample(urnks)){
		ir <- (1:n)[rnks==r]

		lowerbound <- suppressWarnings(max(z[rnks<r]))
		upperbound <- suppressWarnings(min(z[rnks>r]))
		z[ir] <- qnorm(runif(length(ir), pnorm(lowerbound,ez[ir],1),pnorm(upperbound,ez[ir],1)),ez[ir],1)
	}
	z
}

rank.regress <- function(y,x,xpred=NULL,nscan,seed=1){
	set.seed(1)
	n <- length(y)
	p <- dim(x)[2]
	sxtxi <- solve(t(x)%*%x)*n/(n+1); cvarbeta <- chol(sxtxi)
	rnks <- match(y,sort(unique(y))); urnks <- sort(unique(rnks))
	if(!is.null(xpred))ypred <- NULL

	z <- qnorm(rank(y,ties.method="random")/(n+1))
	b <- matrix(0,p,1)
	BETA <- Z <- NULL
	for(ns in 1:nscan){
		b <- beta.post(x,z,sxtxi,cvarbeta)
		z <- z.post(x%*%b,z,rnks,urnks)
		if(ns%%(nscan/1000)==0){cat("\r",100*ns/nscan,"% done"); BETA <- cbind(BETA,b); Z <- cbind(Z,z)
		if(!is.null(xpred)){
			zpred <- xpred%*%b + rnorm(nrow(xpred))
			ypred <- cbind(ypred,quantile(rnks,pnorm(zpred,0,1),na.rm=TRUE,type=1))
		}
	}}
	list(BETA=BETA,Z=Z,ypred=ypred)
}

cutoffs <- function(z,ctfs){
	for(i in 1:(length(ctfs)-1)){
		if(z>=ctfs[i] & z<=ctfs[i+1])return(ctfs[i])}}
cutoffs <- Vectorize(cutoffs,"z")

treg<-function(y,X,NSCAN=50000,seed=1,tobs,nk,rho=0) {
	  set.seed(seed)
  n<-dim(X)[1] ; p<-dim(X)[2]
  Xnew <- (1-X); if(dim(X)[2]>1){Xnew <- X; Xnew[,1] <- 1-tobs}
    iXX<-solve(t(X)%*%X)  ; V<-iXX*(n/(n+1)) ; cholV<-chol(V); #cat(V,"\n")
    ranks<-match(y,sort(unique(y))) ; uranks<-sort(unique(ranks))

      z<-qnorm(rank(y,ties.method="random")/(n+1)); #cat(sum(z),"\n")
      b<-matrix(0,p,1) ; BETA<-matrix(NA,10000,p) ; Z<-matrix(NA,10000,n)
      TT <- matrix(NA,10000,2*(nk+1))
        ac<-0
        for(nscan in 1:NSCAN) {

		    ###update b
		    E<- V%*%( t(X)%*%z )
	    b<- cholV%*%rnorm(p) + E
	        ###


	        ###update z
	        mu<-X%*%b; #cat(sum(mu),"\n")
	        for(r in sample(uranks)) {
			      ir<-(1:n)[ranks==r]; #cat(sum(ir),"\n")
		   
		      lb<-suppressWarnings(max(z[ranks<r],na.rm=TRUE)) ; #cat(lb,"\n")
		            ub<-suppressWarnings(min(z[ranks>r],na.rm=TRUE)); #cat(ub,"\n")
		          
		            z[ir]<-qnorm(
					                runif( length(ir), pnorm(lb,mu[ir],1), pnorm(ub,mu[ir],1) ), 
							               mu[ir],1
							                   )
			                              }
		    ###

		    ###help mixing
		    zp<-z+rnorm(1,0,n^(-1/3)  )
		    lhr<- sum(dnorm(zp,mu,1,log=T) - dnorm(z,mu,1,log=T) )
		        if(log(runif(1))<lhr) { z<-zp ; ac<-ac+1}
		        ###

		     
		        ###output
		        if(nscan%%(NSCAN/10000)==0) { cat("\r",nscan/NSCAN,ac/nscan) 
			                        BETA[nscan/(NSCAN/10000),]<- t(b)
			                        Z[nscan/(NSCAN/10000),]<- z 
			                        #Zmis <- (1-tobs)%*%b+rnorm(length(y));
			                        Zmis <- Xnew%*%b + rho*(z-mu)+rnorm(n,sd=sqrt(1-rho^2))
			                        Ymis <- quantile(y,pnorm(Zmis,0,1),na.rm=TRUE,type=1)
						            TT[nscan/(NSCAN/10000),] <- getTT(Ymis,y,tobs,nk)
						                       }
			    ###

			                          }
	 

	list( BETA=BETA,Z=Z ,TT=TT)
	        }

getTT <- function(Ymis,Yobs,Tobs,nk){
		FS <- matrix(NA,nrow=length(Ymis),ncol=2)
		FS[Tobs==0,1] <- Yobs[Tobs==0]
		FS[Tobs==0,2] <- Ymis[Tobs==0]
		FS[Tobs==1,1] <- Ymis[Tobs==1]
		FS[Tobs==1,2] <- Yobs[Tobs==1]

		##overall median
		# overallmed <- median(FS[,2]-FS[,1])
		ll <- NULL;
		for(i in 1:nk){
			if(length(FS[FS[,1]==i,2])>0)
				ll <- c(ll,median(FS[FS[,1]==i,2]))
			if(length(FS[FS[,1]==i,2])==0)ll <- c(ll,NA)
		}
		# overallmode <- as.numeric(names(which.max(table(FS[,2]-FS[,1]))))
		# mm <- NULL;
		# for(i in 1:nk){
			# if(length(FS[FS[,1]==i,2])>0)
				# mm <- c(mm,as.numeric(names(which.max(table(FS[FS[,1]==i,2])))))
			# if(length(FS[FS[,1]==i,2])==0)mm <- c(mm,NA)
		# }
		# return(c(overallmed,ll,overallmode,mm))
	return(ll)
}

display_outcome <- function(TT,nk){
	for(i in 0:(nk)){
		print(paste("output: ",i))
		print(table(TT[,(i+1)]))
	}
}

pull_output <- function(TT,nk){
	tmp <- NULL
	for(i in 0:(nk)){
		tmp <- c(tmp,which.max(table(TT[,(i+1)])))
	}
	tmp
}

gen.data <- function(n,p,lvls,type="quant",seed1=1,seed2=NULL,err.dist="normal"){
	beta <- rep(1,p)
	set.seed(seed1)
	XX <- cbind(1,matrix(rnorm(n*(p-2)),nrow=n),sample(0:1,n,rep=TRUE))
	set.seed(seed2)
	if(err.dist=="normal")
	ZZ <- XX%*%beta + rnorm(n)
	if(err.dist=="exp")
		ZZ <- XX%*%beta + rexp(n)
	if(err.dist=="pois")
		ZZ <- XX%*%beta + rpois(n,2)
	if(type=="quant")
	ctfs <- c(min(ZZ)-1,quantile(ZZ,seq(0,1,length=lvls+1)[-c(1,lvls+1)]),max(ZZ)+1)
	if(type=="random")ctfs = c(min(ZZ)-1,sort(runif(lvls-1,min(ZZ),max(ZZ))),max(ZZ)+1)
	YY <- cutoffs(ZZ,ctfs)
	list(YY=YY,beta=beta,XX=XX,ZZ=ZZ)
}

repeat.experiment <- function(n,p,lvls,NEXP){
	require("MASS")
	bmout  <- NULL; bsdout <- NULL; bmopout <- NULL; bsdopout <- NULL
	for(i in 1:NEXP){
	vv <- gen.data(n,p,lvls,type="random",err.dist="normal")
	uu <- treg(vv$YY,vv$XX[,-1],10000)
	bmout <- cbind(bmout,colMeans(uu$BETA)); bsdout <- cbind(bsdout,apply(uu$BETA,2,sd))
	ll <- tryCatch(polr(as.factor(vv$YY)~vv$XX,method="probit",Hess=TRUE))
	bmopout <- cbind(bmopout,coef(ll)); bsdopout <- cbind(bsdopout,sqrt(diag(solve(ll$Hessian))[1:2]))
	cat("finished experiment number ",i,"\n")
	}
	return(list(bmout=bmout,bsdout=bsdout,bmopout=bmopout, bsdopout=bsdopout))
}



