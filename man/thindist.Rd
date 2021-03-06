% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/SpThin.R, R/generics.R
\name{thindist.SpThin}
\alias{thindist}
\alias{thindist.SpThin}
\title{Distance used to thin data.}
\usage{
\method{thindist}{SpThin}(x)

thindist(x, ...)
}
\arguments{
\item{x}{\code{SpThin} object.}

\item{...}{not used.}
}
\value{
\code{numeric} distance (m) used to thin records.
}
\description{
This function returns the distance used to thin datasets contained in a \code{SpThin} object.
}
\seealso{
\code{\link{SpThin}}.
# make thinned dataset using simulated data
result <- spThin(
		runif(100, -5, -5),
		runif(100, -5, -5),
		dist=5,
		method='heuristic',
		1,
)

# show distance used to thin data
thindist(result)

export
}

