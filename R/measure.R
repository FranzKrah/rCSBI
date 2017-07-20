#' Measure objects in images
#'
#' @param x image of class \code{magick-image} or a local path to image or URL
#' @param cal is a calibration numeric of pixel corresponding to a scale bar in the image. Usually output from \link{calibration}
#'
#' @import magick
#' @import imager
#'
#' @export

measure <- function(x, cal){

  if(inherits(x, "character")){
    x <- image_read(x)
  }
  x <- image_convert(x, format = "jpeg")

  x2 <- magick2cimg(x)
  plot(x2)

  crop <- readkey(text ="Do you want to crop the image? (y/n)")

  if(crop == "y"){
    meta <- image_info(x)
    w <- meta$width
    h <- meta$height

    cat(" Click 4 edge points surrounding the aread you want to zoom in ", "\n\n")

    xy <- coords_from_image(x = x, n = 4)

    ## calculate Geometry Specifications
    ## for details see https://www.imagemagick.org/Magick++/Geometry.html
    minx <- which(xy$x == min(xy$x))[1]
    maxy <- which(xy$y == max(xy$y))[1]
    minx <- xy$x[minx]
    maxy <- xy$y[maxy]
    maxy <- h - maxy

    hc <- maxy
    wc <- minx
    w = max(xy$x) - min(xy$x)
    h = max(xy$y) - min(xy$y)

    x <- image_crop(x, geometry = paste(w, "x", h, "+", wc , "+", hc, sep =""))
    plot(x)
  }


  cat(" Click start and end points of your measurements. ", "\n",
    "The output will always assume two succeeding points to be 1 measurement!", "\n",
    "Then click 'Finish' when you are done.")

  xy <- coords_from_image(x = x, n = 100)

  ## distance of measurements

  xy <- split(xy, rep(1:(dim(xy)[1]/2), each = 2))

  res <- lapply(xy, function(x) {
    x1_hat <- diff(x[,1])
    y1_hat <- diff(x[,2])
    sqrt((x1_hat^2 + y1_hat^2))/cal
  })

  res <- unlist(res)
  return(res)
}
