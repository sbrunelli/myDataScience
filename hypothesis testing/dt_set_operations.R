dt_unique       <- function(x){
  return(unique(x))
}

dt_union        <- function(x,y){
  z_rbind     <- rbind(x,y)
  z_unique    <- dt_unique(z_rbind)
  return(z_unique)
}

dt_intersect    <- function(x,y){
  zx          <- dt_unique(x)
  zy          <- dt_unique(y)
  
  z_rbind     <- rbind(zy,zx)
  ixDupe      <- which(duplicated(z_rbind))
  z           <- z_rbind[ixDupe,]
  return(z)
}

dt_setdiff      <- function(x,y){
  zx          <- dt_unique(x)
  zy          <- dt_unique(y)
  
  z_rbind     <- rbind(zy,zx)
  ixRangeX    <- (nrow(zy) + 1):nrow(z_rbind)
  ixNotDupe   <- which(!duplicated(z_rbind))
  ixDiff      <- intersect(ixNotDupe, ixRangeX)
  diffX       <- z_rbind[ixDiff,]
  return(diffX)
}