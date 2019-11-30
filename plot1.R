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

#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base
#plotting system, make a plot showing the total PM2.5 emission from all sources for each of the 
#years 1999, 2002, 2005, and 2008.

totalEmissionsPerYear <- aggregate(Emissions ~ year,NEI,sum)

png("plot1.png")

with(totalEmissionsPerYear,plot(year,Emissions/10^6, type = "l",ylab = "PM2.5 emissions (millions tons)", xlab = "Year", main = "United States"))

dev.off()
