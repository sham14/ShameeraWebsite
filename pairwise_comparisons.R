# function to calculate confidence intervals, effect size, and NHST and Bayes t-test for paired design 
TES <- function (x,y, paired){
  library('BayesFactor')
  
  # within-subjects (paired) or between-subjects comparison
  if (paired == TRUE){
    test <- t.test(x, y, paired=TRUE) # Do a t-test
    BF.test <- ttestBF(x, y, paired=TRUE) # Bayes equivalent of a t-test
    
    # effect size
    diff = test$estimate[[1]]
    dav <- abs((mean(x) - mean(y)) / ((sd(x)+sd(y))/2)) # Calculate dav
    gav <- dav*(1-(3/(4*(length(x)*2)-9))) # Coresponding Hedges g
    dz <- abs(test$statistic[[1]]/sqrt(length(x))) # Calculate dz  
    ES <- data.frame(dav = dav, gav = gav, dz = dz)
  }else{
    test <- t.test(x, y, paired=FALSE, var.equal = TRUE) # Do a t-test
    BF.test <- ttestBF(x, y, paired=FALSE) # Bayes equivalent of a t-test
    
    # effect size
    diff = test$estimate[[1]]-test$estimate[[2]] # numerical difference
    d <- abs(test$statistic[[1]]*sqrt(1/length(x)+1/length(y))) # Calculate d
    g <- d*(1-(3/(4*(length(x)+length(y))-9))) # Coresponding Hedges g
    ES <- data.frame(d = d, g = g)
  }
  
  descriptive <- data.frame(diff = diff, lowerCI = test$conf.int[[1]], upperCI = test$conf.int[[2]])
  NHST <- data.frame(df=test$parameter[[1]], t=test$statistic[[1]], p=test$p.value[[1]])
  BF <- data.frame(BayesF = exp(BF.test@bayesFactor[['bf']]))
  
  output <- cbind(descriptive, NHST, BF, ES)
  output <- round(output, 3)
  return(output)
}
