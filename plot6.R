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

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
#sources in Los Angeles County, California (fips=="06037"). Which city has seen greater changes 
#over time in motor vehicle emissions?

vehicleSourceSCC <- grepl("Vehicles", SCC$EI.Sector, ignore.case = TRUE)

subSCC <- SCC[vehicleSourceSCC,]
subFips <- tibble(fips = c("24510", "06037"), county = c("Baltimore", "Los Angeles"))

subNEI <- filter(NEI, SCC %in% subSCC$SCC & fips %in% subFips$fips)

subNEI <- merge(subNEI, subFips)

countyEmissionsYear <- aggregate(Emissions ~ year + county, subNEI, sum)

g <- ggplot(countyEmissionsYear, aes(as.factor(year), Emissions, fill = year, label=round(Emissions/1000,2)))
g + geom_col() + facet_grid(.~county) + xlab("Year") + ylab("PM[2.5] Emission in tons") + geom_label(aes(fill = year),colour = "white", fontface = "bold")
    ggtitle("PM[2.5] Emissions from vehicle sources in Baltimore, Maryland")

ggsave("plot6.png")