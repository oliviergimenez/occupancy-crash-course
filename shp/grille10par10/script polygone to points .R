#####LA GRILLE
library(rgdal)
library(raster)
library(maptools)
library(sp)

setwd("C:/Users/lauret/Desktop/Stage M2")

####################### read .shp file
france<-readShapePoly("C:/Users/lauret/Desktop/Stage M2/Grille 10x10/grille_France.shp")
france<-readOGR("Grille 10x10/grille_France.shp", layer="grille_France")
plot(france)
names(france)
length(france$FID)

########################### read indices XY
points<-read.csv("Données Réseau/Table indices/indices5.csv")
nrow(points)
names(points)
length(which(points$Fia2==2))

###selectionne les coordonnées bizarres / outliers
length(which(points$Y<=20000)) #combien d'outliers
biz<-points[which(points$Y<=20000),] #selectionne les outliers
plot(biz, ad=T) #plot les outliers --> ne marche pas
warnings()
names(points)

### selectionne les R seulement
RR<-points[which(points$Fia2==2),]
plot(RR, ad=T, col='green')
coordinates(RR)<-~X+Y
writeOGR(RR, "c:/Users/lauret/Desktop/Stage M2/Grille 10x10", "RR", driver = "ESRI Shapefile")



####creer une .shp avec tous les points
coordinates(points)<-~X+Y
plot(points, ad=T)
class(points)
names(points)
nrow(points)

writeOGR(points, "c:/Users/lauret/Desktop/Stage M2/Grille 10x10", "points", driver = "ESRI Shapefile")

### polygons to points 
pts<-readOGR("Grille 10x10/points.shp", layer="points")
names(pts)
class(pts)
pts<-SpatialPoints(pts, proj4string = CRS(proj4string(france)))
#grille<-SpatialPolygons(france, proj4string = CRS(proj4string(pts)))

class(pts)
names(pts)

pol.pts<-over(pts, france)


res <- cbind(coordinates(pts), pol.pts)
colnames(res)<-c("X","Y", "Id")

indices5<-cbind(points,res)
names(indices5)
indices5<-indices5[,-5]
indices5<-indices5[,-4]
indices5<-indices5[,-1]

write.csv(indices5, "indices6.csv")
 plot(france)
plot(pts, ad=T)
length(unique(indices5$Id))
