#' @include dependencies.R generics.R RcppExports.R SpPartial.R
NULL

#' SpRarefy: An S4 class to represent spatially rarefied datasets
#'
#' This class is used to store replicates of spatially rarefied datasets.
#'
#' @slot data \code{SpatialPoints} or \code{SpatialPointsDataFrame} object with all records.
#' @slot samples \code{list} with indices for records in each replicate.
#' @slot cellsize \code{numeric} height and width of cells (m) used to sample records.
#' @slot call \code{call} used to generate object.
#' @slot grid \code{RasterLayer} used to rarefy data.
#' @export
#' @seealso \code{\link{call}}, \code{\link{data}}, \code{\link{samples}}, \code{\link{cellsize}}, \code{\link{nrep}}, \code{\link{plot}},\code{\link{summary}}, \code{\link{write}}.
SpRarefy <- setClass(
	"SpRarefy",
	representation(
		cellsize="numeric",
		grid="RasterLayer"
	),
	contains='SpPartial'
)

#' @export
#' @rdname cellsize
cellsize.SpRarefy <- function(x, ...) {
	return(x@cellsize)
}

#' Map for rarefied datasets
#' 
#' This function produces a map showing the distribution of occurrence records and the selected records.
#'
#' @param x \code{SpRarefy} object.
#' @param i "numeric" replicate dataset to plot.
#' @param ... not used.
#' @seealso \code{\link{spRarefy}}.
#' @method plot SpRarefy
#' @examples
#' # load data
#' data(Heteromys_anomalus_South_America)
#'
#' # make thinned dataset 
#' result <-spRarefy(
#'		Heteromys_anomalus_South_America,
#'		x.col = "LONG", 
#'      y.col = "LAT",
#'      200000,
#'		10
#'	)
#'
#' # show map
#' plot(result)
#'
#' @export
plot.SpRarefy<-function(x, i=1, ...) {
	tmp<-table(extract(x@grid, x@data))
	tmp2<-setValues(x@grid, NA)
	tmp2[as.numeric(names(tmp))]<-as.numeric(tmp)
	tmp2<-as.data.frame(rasterToPoints(tmp2, spatial=FALSE))
	idf<-as.data.frame(x[[i]]@coords)
	
	return(
		ggplot(
			tmp2,
			aes_string(x="x", y="y")
		) +
		geom_raster(
			aes(fill=layer),
		) +
		geom_point(
			data=idf,
			aes_string(x=names(idf)[1], y=names(idf)[2]),
			col="#ffffb3"
		) +
		theme_classic() +
		theme(
			legend.position="bottom",
			axis.title=element_blank(),
			axis.ticks=element_blank(),
			axis.text=element_blank(),
			axis.line=element_blank()
		) +
		coord_equal() +
		scale_fill_continuous(name="Frequency", guide = guide_legend()) +
		ggtitle('Occurrence records')
	)
}


#' Summarize rarefied datasets
#' 
#' \code{summary} method for \code{SpRarefy} objects.
#' 
#' @param object \code{SpRarefy} object.
#' @param ... not used.
#' @seealso \code{\link{spRarefy}}.
#' @examples
#' # load data
#' data(Heteromys_anomalus_South_America)
#'
#' # make thinned dataset 
#' result <-spRarefy(
#'		Heteromys_anomalus_South_America,
#'		x.col = "LONG", 
#'      y.col = "LAT",
#'      200000,
#'		10
#'	)
#'
#' # show map
#' summary(result)
#'
#' @export
summary.SpRarefy <- function(object, ...) {
	# init
	cat('SpThin object.\n\n')
	cat('Call:')
	print(object@call)
	cat('Cell size: ',object@cellsize[1], ', ', object@cellsize[2],'\n',sep="")
	cat('Number of replicates: ',length(object@samples),'\n',sep="")
	cat('Initial number of records: ',nrow(object@data@coords),'\n',sep="")
	cat('Best thinned dataset: ',which.max(sapply(object@samples,length)),' (', max(sapply(object@samples,length)),' records)', '\n',sep="")
}

#' Write rarefied dataset replicates to file.
#'
#' This function writes the spatially thinned replicates in a \code{SpRarefy} object to files on a computer.
#'
#' @param x \code{SpRarefy} object.
#' @param coords \code{logical} if \code{TRUE} only coordinates of thinned data will be be saved, otherwise all columns of thinned data will be saved.
#' @param dir \code{character} directory to save output files in.
#' @param base \code{character} base name to save output files in.
#' @param ... not used.
#' @seealso \code{\link{SpRarefy}}.
#' @examples
#' # load data
#' data(Heteromys_anomalus_South_America)
#'
#' # make rarefied dataset 
#' result <-spRarefy(
#'		Heteromys_anomalus_South_America,
#'		x.col = "LONG", 
#'      y.col = "LAT",
#'      200000,
#'		10
#'	)
#'
#' # save data to temporary directory
#' write.SpRarefy(result, dir=tempdir())
#'
#' # show files in temporary directory
#' dir(tempdir())
#
#' # remove files
#' unlink(dir(tempdir(), '^rarefy_.*.csv$'))
#'
#' @export
write.SpRarefy<-function(x, coords=FALSE, dir=getwd(), base='thin_') {
	write.spthin(x, coords=FALSE, dir=getwd(), base='thin_')
}


