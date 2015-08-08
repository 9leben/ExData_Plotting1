library(sqldf)
library(dplyr)
library(lubridate)

## Check if file already exists. Download the zipfile and unzip it otherwise.
if (!file.exists("household_power_consumption.txt")) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL,  destfile = "household_power_consumption.zip", method = "curl", quiet = TRUE)
  unzip("household_power_consumption.zip")
  file.remove("household_power_consumption.zip")
}

## Read only the records in the specified data range (as character).
df <- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where ((Date == "1/2/2007") | (Date == "2/2/2007"))', sep = ";")

## Create a date-time combined variable. It will appear as a 10th variable, so far...
tmp_df <- mutate(df, datetime = dmy_hms(paste(Date, Time)))

## Select the new Date_Time variable as the first one, discard old Date and Time and keep the rest of the variables.
sf_dt <- select(tmp_df, c(10,3:9))

## Create Plot 4
### Open png device. The default size is 480x480 pixels
png(filename = "plot4.png")

### Adjust the parameters to make similar regions as the target graph.
par(mfrow = c(2,2), mar = c(4, 4, 3, 2) + 0.1, oma = c(1,0,1,0), cex = 0.8, pty = "m")

### Draw the first graph.
with(sf_dt, plot(datetime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

### Draw the second graph.
with(sf_dt, plot(datetime, Voltage, type = "l"))

### Draw the third graph.
with(sf_dt, plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(sf_dt, points(datetime, Sub_metering_2, type = "l", col = "red"))
with(sf_dt, points(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", lty = c(1,1,1), bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

### Draw the fourth graph.
with(sf_dt, plot(datetime, Global_reactive_power, type = "l"))

### Close graph device.
dev.off()
