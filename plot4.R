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

# plot 4
png(file = "plot4.png", 
    width = 480, height = 480,
    bg = "transparent")
par(mfrow=c(2,2))
hist(dataset$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")

with(dataset, plot(datetime, Voltage, type = "l"))

plot(dataset$datetime, 
     dataset$Sub_metering_1, 
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(dataset$datetime, dataset$Sub_metering_2, type = "l", col = "red")
lines(dataset$datetime, dataset$Sub_metering_3, type = "l", col = "blue")
legend("topright", 
       legend = names(dataset)[7:9], 
       lty = 1,
       col = c("black", "red", "blue"))

with(dataset, plot(datetime, Global_reactive_power,  type = "l"))
dev.off()
