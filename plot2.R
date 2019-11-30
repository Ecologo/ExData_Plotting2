library(dplyr)

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

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 
#1999 to 2008? Use the base plotting system to make a plot answering this question.

marylandNEI <- filter(NEI, fips == "24510")

marylandEmissionsPerYear <- aggregate(Emissions ~ year,marylandNEI,sum)

png("plot2.png")

with(marylandEmissionsPerYear,plot(year,Emissions/10^6, type = "l",ylab = "PM2.5 emissions (millions tons)", xlab = "Year", main = "Baltimore City, Maryland"))

dev.off()