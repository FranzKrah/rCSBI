#' Sample colors from images based on coordinates
#'
#' @param coord data.frame with x (column 1) and y (column 2) coordinates for N samples. Usually the output of coords_from_image
#' @param x is of class cimg
#' @param col.space character, one of "HSL", "HSV", "HSI", "sRGB", "YUV", "Lab", "XYZ" of the putput color space model
#'
#' @return data.frame with color space values for each coordinate
#'
#' @import imager
#'
#' @examples
#' #' a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
#' xy <- coords_from_image(a.m, n = 2)
#' col <- HSL_from_coords(coord = xy, x = a.m, col.space = "HSL")
#' col
#'
#' @export


color_from_coords <- function(coord, x,
  col.space = c("HSL", "HSV", "HSI", "sRGB", "YUV", "Lab", "XYZ")){

  ## define color space function
  fun <- paste0("RGBto", col.space)
  fun <- eval(parse(text = fun))

  ## convert color space of image
  x.hsl <- fun(x)

  ## get color values from image
  res <- list()
  for(i in 1:length(coord)){
    res[[i]] <- at(x.hsl, x = am$x[i], y = am$y[i], cc = 1:3)
  }
  res <- as.data.frame(do.call(rbind, res))

  ## set names
  if(col.space == "sRGB"){
    names(res) <- c("sR","sG", "sB")
  }else{
    nam <- strsplit(col.space, "")
    names(res) <- nam[[1]]
  }

  ## return result
  return(res)
}