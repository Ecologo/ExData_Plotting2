library(dplyr)
library(ggplot2)

if(!file.exists("NEI_data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                  destfile = "NEI_data.zip")
}

if(!file.exists("summarySCC_PM25.rds")){
    unzip("NEI_data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Across the United States, how have emissions from coal combustion-related sources changed from 
#1999–2008?

coalSourceSCC <- grepl("coal", SCC$EI.Sector, ignore.case = TRUE)

subSCC <- SCC[coalSourceSCC,]

subNEI <- filter(NEI, SCC %in% subSCC$SCC)

usaEmissionsYear <- aggregate(Emissions ~ year, subNEI, sum)

g <- ggplot(usaEmissionsYear, aes(as.factor(year), Emissions/1000, fill = year))
g + geom_col() + xlab("Year") + ylab("PM[2.5] Emission in kilotons") + 
    ggtitle("PM[2.5] Emissions from coal combustion-related sources in USA")

ggsave("plot4.png")