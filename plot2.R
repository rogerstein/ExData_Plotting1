# initialization
library(sqldf)

# if zipped data file is not found in the local folder, download it
if (!file.exists("exdata-data-household_power_consumption.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                "exdata-data-household_power_consumption.zip", method = "curl")

# if unzipped data file is not found in the local folder, unzip it
if (!file.exists("household_power_consumption.txt"))
  unzip("exdata-data-household_power_consumption.zip")

# read relevant dates only
dataset <- read.csv2.sql("household_power_consumption.txt", 
                      sql = "select * from file 
                      where Date in ('1/2/2007', '2/2/2007')")

# adds a column with proper datetime info
dataset$datetime <- strptime(paste(dataset$Date, dataset$Time), "%d/%m/%Y %H:%M:%S", tz = "UTC")

# plot 2
png(file = "plot2.png", 
    width = 480, height = 480,
    bg = "transparent")
plot(dataset$datetime, 
     dataset$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()