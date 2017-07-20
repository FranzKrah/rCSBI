library("rCSBI")
library("imager")
library("fields")
library("magick")


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







## Define path of calibration image
x <- "../../../../Downloads/rii_stomata/Aufnahme-124230-0001.tif"
## do the calibration once
cal <- calibration(x, cal.lenght = 20)
cal
## define the path of first image to measure
stomata1 <- measure(x, cal)
stomata1








