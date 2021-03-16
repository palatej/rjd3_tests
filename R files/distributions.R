source("./R files/rjava_init.R")

randomsT<-function(df, n){
  .jcall("demetra/stats/r/Distributions", "[D", "randomsT", df, as.integer(n))
}

densityT<-function(df, x){
  .jcall("demetra/stats/r/Distributions", "[D", "densityT", df, x)
}

cdfT<-function(df, x){
  .jcall("demetra/stats/r/Distributions", "[D", "cdfT", df, x)
}

randomsChi2<-function(df, n){
  .jcall("demetra/stats/r/Distributions", "[D", "randomsChi2", df, as.integer(n))
}

densityChi2<-function(df, x){
  .jcall("demetra/stats/r/Distributions", "[D", "densityChi2", df, x)
}

cdfChi2<-function(df, x){
  .jcall("demetra/stats/r/Distributions", "[D", "cdfChi2", df, x)
}

randomsGamma<-function(shape, scale, n){
  .jcall("demetra/stats/r/Distributions", "[D", "randomsGamma", shape, scale, as.integer(n))
}

densityGamma<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "densityGamma", shape, scale, x)
}

cdfGamma<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "cdfGamma", shape, scale, x)
}

randomsInverseGamma<-function(shape, scale, n){
  .jcall("demetra/stats/r/Distributions", "[D", "randomsInverseGamma", shape, scale, as.integer(n))
}

densityInverseGamma<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "densityInverseGamma", shape, scale, x)
}

cdfInverseGamma<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "cdfInverseGamma", shape, scale, x)
}

randomsInverseGaussian<-function(shape, scale, n){
  .jcall("demetra/stats/r/Distributions", "[D", "randomsInverseGaussian", shape, scale, as.integer(n))
}

densityInverseGaussian<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "densityInverseGaussian", shape, scale, x)
}

cdfInverseGaussian<-function(shape, scale, x){
  .jcall("demetra/stats/r/Distributions", "[D", "cdfInverseGaussian", shape, scale, x)
}
