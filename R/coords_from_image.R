#' Sample coordinates from image
#'
#' @param x is of class cimg
#' @param n is the number of coordinates (positive integer)
#'
#' @return coordinates x and y
#'
#'
#'
#' @examples
#' a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
#' xy <- coords_from_image(a.m, n = 2)
#'
#' @export


coords_from_image <- function(x, n){

  ## click the points you want
  cat("Please click ", n, " times in the image (do not click more)")

  ## plot image to console
  par(mar = c(0,0,0,0))
  plot(x)
  par(mar = c(4,4,4,4))


  ## click
  coord <- locator(n = n, type ="p")

  ## prepare output
  coord <- do.call(rbind, coord)
  coord <- as.data.frame(t(coord))

  return(coord)

}
