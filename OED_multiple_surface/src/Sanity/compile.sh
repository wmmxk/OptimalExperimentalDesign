#!/bin/bash
PKG_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'` \
PKG_LIBS=`Rscript -e 'Rcpp:::LdFlags()'`  \
PKG_CXXFLAGS=`Rscript -e 'RcppArmadillo:::CxxFlags()'` \
PKG_LIBS=`Rscript -e 'RcppArmadillo:::LdFlags()'`  \
R CMD SHLIB spdinv-arma.cpp
