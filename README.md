# rCSBI
Color Sampling from Biological Images

## Install

install.packages("devtools")
library("devtools")

install_github("FranzKrah/rCSBI")
library("rCSBI")


## Example

a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
xy <- coords_from_image(a.m, n = 2)
col <- HSL_from_coords(coord = xy, x = a.m, col.space = "HSL")
col
