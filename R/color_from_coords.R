#' Sample colors from images based on coordinates
#'
#' @param coord data.frame with x (column 1) and y (column 2) coordinates for N samples. Usually the output of coords_from_image
#' @param x is of class cimg
#' @param col.space character, one of "HSL", "HSV", "HSI", "sRGB", "YUV", "Lab", "XYZ" of the putput color space model
#' @param pg logical if all values inside a polygone should be returned. In this case the points drawn are the vertices of the polygon.
#'
#' @return data.frame with color space values for each coordinate
#'
#'
#' @examples
#' #' a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
#' xy <- coords_from_image(a.m, n = 2)
#' col <- color_from_coords(coord = xy, x = a.m, col.space = "HSL")
#' col
#'
#' @import fields
#' @export


color_from_coords <- function(coord, x, pg,
  col.space = c("RGB", "HSL", "HSV", "HSI", "sRGB", "YUV", "Lab", "XYZ")){

  if(!col.space == "RGB"){
    ## define color space function
    fun <- paste0("RGBto", col.space)
    fun <- eval(parse(text = fun))

    ## convert color space of image
    x <- fun(x)
  }


  ## create data.frame
  amdf <- as.data.frame(x)

  if(pg){
    res <- amdf[in.poly(amdf, coord),]
  }

  if(!pg){
    ## get color values from image
    res <- list()
    for(i in 1:dim(coord)[1]){
      res[[i]] <- amdf[amdf$x %in% round(coord$x[i]) & amdf$y %in% round(coord$y[i]), ]
    }
    res <- as.data.frame(do.call(rbind, res))
  }

  ## set names
  res$cc <- factor(res$cc)
  if(col.space == "sRGB"){
    leves(res$cc) <- c("sR","sG", "sB")
  }else{
    nam <- strsplit(col.space, "")
    levels(res$cc) <- nam[[1]]
  }

  ## return result
  return(res)
}
