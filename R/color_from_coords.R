#' Sample colors from images based on coordinates
#'
#' @param coord data.frame with x (column 1) and y (column 2) coordinates for N samples. Usually the output of coords_from_image
#' @param x is of class cimg
#' @param col.space character, one of "HSL", "HSV", "HSI", "sRGB", "YUV", "Lab", "XYZ" of the putput color space model
#' @param pg logical if all values inside a polygone should be returned. In this case the points drawn are the vertices of the polygon.
#'
#' @return list with three elements
#' @return points color values of points
#' @return polygon color values within the polygon spanned by the points
#' @return background color values no covered by the polygon
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


color_from_coords <- function(coord, x,
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

  ## polygon
  res_poly <- amdf[in.poly(amdf, coord),]

  ## non polygon
  res_npoly <- amdf[!in.poly(amdf, coord),]

  ## get color values from image
  res_points <- list()
  for(i in 1:dim(coord)[1]){
    res_points[[i]] <- amdf[amdf$x %in% round(coord$x[i]) & amdf$y %in% round(coord$y[i]), ]
  }
  res_points <- as.data.frame(do.call(rbind, res_points))

  ## set names
  res_poly$cc <- factor(res_poly$cc)
  res_npoly$cc <- factor(res_npoly$cc)
  res_points$cc <- factor(res_points$cc)
    if(col.space == "sRGB"){
    leves(res_poly$cc) <- c("sR","sG", "sB")
    leves(res_npoly$cc) <- c("sR","sG", "sB")
    leves(res_points$cc) <- c("sR","sG", "sB")
  }else{
    nam <- strsplit(col.space, "")
    levels(res_poly$cc) <- nam[[1]]
    levels(res_npoly$cc) <- nam[[1]]
    levels(res_points$cc) <- nam[[1]]
  }

  ## return result
  return(list(points = res_points, polygon = res_poly, background = res_npoly))
}
