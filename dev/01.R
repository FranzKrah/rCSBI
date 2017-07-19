devtools::install_github("FranzKrah/rCSBI")

library("rCSBI")s

## Test Image for *Amanita muscaria*
library(imager)
a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
## click two points in the image you want to know the color values of
xy <- coords_from_image(a.m, n = 2)
## get the values
col <- color_from_coords(coord = xy, x = a.m, col.space = "HSL")
## print the values
col
