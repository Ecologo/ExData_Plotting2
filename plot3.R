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

#Of the four types of sources indicated by the \color{red}{\verb|type|}type (point, nonpoint, 
#onroad, nonroad) variable, which of these four sources have seen decreases in emissions from
#1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.

baltimoreNEI <- filter(NEI, fips == "24510")

baltimoreEmissionsPerYearAndType <- aggregate(Emissions ~ year + type,baltimoreNEI,sum)

g <- ggplot(baltimoreEmissionsPerYearAndType, aes(as.factor(year), Emissions, fill = type))

g + geom_col() + facet_grid(. ~ type) + xlab("Year") + ylab("PM[2.5] Emission in tons") +
    ggtitle("Baltimore City Emissions by Source Type")

ggsave("plot3.png")