library(roxygen2); # Read in the roxygen2 R package
roxygenise();      # Builds the help files


test_data

?studydata

library(devtools);
load_all(".");


devtools::document()

#df<-readRDS(file = "test_data.rds")
#head(df)


load("./data/test_data")

df$abc =1;


load(test_data)


df2<-studydata(df, "2019-12-17", "Start", "Death", "Gender", "Age", "Id")


getwd()

studydata


df<-studydata(df, "2018-12-17", "Start", "Death", "Gender", "Age", "Id")


test_data






library(devtools);
devtools::install("c:/R/expstudy")
library(ExpDataProcess)
studydata


getwd()
data(package = "expstudy")


test_data

df$abc =1;


df2<-studydata(test_data, "2019-12-17", "Start", "Death", "Gender", "Age", "Id")


getwd()
setwd("c:/R/expstudy/")
setwd("c:/R/expstudy/data")
df<-readRDS(file = "test_data.rds")
head(df)
save(df, file="test.RData")

load("./data/test_data.Rdata")

saveRDS(test_data, file="./data/test_data.rds")



saveRDS(Female_NS, file="./data/vbt.2015.F.NS.ANB.rds")
saveRDS(Female_S, file="./data/vbt.2015.F.S.ANB.rds")
saveRDS(Male_NS, file="./data/vbt.2015.M.NS.ANB.rds")
saveRDS(Male_S, file="./data/vbt.2015.M.S.ANB.rds")


Male_NS = read.csv("./data/vbt.2015.M.NS.ANB.csv",stringsAsFactors = F)
Male_S  = read.csv("./data/vbt.2015.M.S.ANB.csv",stringsAsFactors = F)
Female_NS = read.csv("./data/vbt.2015.F.NS.ANB.csv",stringsAsFactors = F)
Female_S = read.csv("./data/vbt.2015.F.S.ANB.csv",stringsAsFactors = F)



### install package from folder

install.packages("c:/R/expstudy/", repos = NULL, type = "source")
