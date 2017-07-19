# install.packages("devtools")
library("devtools")
devtools::install_github("FranzKrah/rCSBI")


## Test Image for *Amanita muscaria*
install.packages(c("imager", "ggplot2"))
library("rCSBI")
library("imager")
a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
## click 10 points in the image you want to know the color values of
## or you can arrange the 10 points in a polygon way to extract
## all values in the polygon (next function pg = TRUE)
xy <- coords_from_image(x = a.m, n = 10)
## get the values
col <- color_from_coords(coord = xy, x = a.m, col.space = "HSL", pg = TRUE)
## print the values
head(col); dim(col)

### Plot range of mushroom
library("ggplot2")
ggplot(col,aes(value,col=cc))+geom_histogram(bins=30)+facet_wrap(~ cc, scales = "free")
