#' Calibration of an image based on the scale bar
#'
#' @param x image of class \code{magick-image} or a local path to image or URL
#' @param cal.length length or scale bar
#'
#' @return numeric of pixel values corresponding to the cal.length
#'
#'
#' @import magick
#' @import imager
#'
#' @export

calibration <- function(x, cal.lenght){

  ## x needs to be a file path or an object of class magick-image

  if(inherits(x, "character")){
    x <- image_read(x)
  }
  x <- image_convert(x, format = "jpeg")

  readkey <- function(text)
  {
    cat (text)
    line <- readline()
    return(line)
  }

  x2 <- magick2cimg(x)
  plot(x2)

  crop <- readkey(text ="Do you want to crop the image? (y/n)")

  if(crop == "y"){
    meta <- image_info(x)
    w <- meta$width
    h <- meta$height

    cat(" Click 4 edge points surrounding the aread you want to zoom in ")

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


  forcal <- coords_from_image(x = x, n = 2)

  cal <- abs(forcal$x[1] - forcal$x[2])
  cal <- cal/cal.lenght

  graphics.off()

  return(cal)
}
