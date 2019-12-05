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

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

vehicleSourceSCC <- grepl("Vehicles", SCC$EI.Sector, ignore.case = TRUE)

subSCC <- SCC[vehicleSourceSCC,]

subNEI <- filter(NEI, SCC %in% subSCC$SCC)

baltimoreNEI <- subset(subNEI, fips == "24510")

baltimoreEmissionsYear <- aggregate(Emissions ~ year, baltimoreNEI, sum)

g <- ggplot(baltimoreEmissionsYear, aes(as.factor(year), Emissions, fill = year))
g + geom_col() + xlab("Year") + ylab("PM[2.5] Emission in tons") + 
    ggtitle("PM[2.5] Emissions from vehicle sources in Baltimore, Maryland")

ggsave("plot5.png")