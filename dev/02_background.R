library("rCSBI")
library("imager")
library("fields")
a.m <- load.image("https://upload.wikimedia.org/wikipedia/commons/0/02/2006-10-25_Amanita_muscaria_crop.jpg")
## click 10 points in the image you want to know the color values of
## or you can arrange the 10 points in a polygon way to extract
## all values in the polygon (next function pg = TRUE)
xy <- coords_from_image(x = a.m, n = 20)
## get the values
col <- color_from_coords(coord = xy, x = a.m, col.space = "HSL")
## print the values
head(col); dim(col)

### Plot range of mushroom
library("ggplot2")
p1 <- ggplot(col$polygon ,aes(value,col=cc))+geom_histogram(bins=30)+facet_wrap(~ cc, scales = "free")
p2 <- ggplot(col$background ,aes(value,col=cc))+geom_histogram(bins=30)+facet_wrap(~ cc, scales = "free")
cowplot::plot_grid(p1, p2, nrow = 2, ncol = 1)


library("circular")
plot(as.circular(col$polygon[col$polygon$cc=="H",]$value, units = "degrees"))
