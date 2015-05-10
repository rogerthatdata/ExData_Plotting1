plot2 <- function(makePNG = TRUE){
  # ------------------------------------------------------------
  # Load the required libraries
  # ------------------------------------------------------------
  library(sqldf)
  library(lubridate)
  library(utils)
  
  # ------------------------------------------------------------
  # Assign the default file variables
  # ------------------------------------------------------------
  sourcehtml <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  sourcezip <- "exdata-data-household_power_consumption.zip"
  sourcedir <- "exdata-data-household_power_consumption"
  file <- "household_power_consumption.txt"
  
  # ------------------------------------------------------------
  # Make sure the data file is available, if not try to fetch
  # it from the web.
  # ------------------------------------------------------------
  if (!file.exists(file)){
    
    # It doesn't exist as a text file so see if it's in the
    # expected unzipped subdirectory
    if (file.exists(paste(sourcedir, file, sep = "/"))) {
      
      # found it in the unzipped subdir so set the file path accordingly
      file <- paste(sourcedir, file, sep = "/")
    } else {
      # Doesn't exist there either so download it
      download.file(sourcehtml, sourcezip)    
      
      # If successfully downloaded then unzip else stop with an error message
      if (!file.exists(sourcezip)){
        stop("Data does not exists locally and an attempt to download from the web failed...")
      }  else {
        unzip(sourcezip)
        #file <- paste(sourcedir, file, sep = "/")
      }
    }
  }
  
  # ------------------------------------------------------------
  # Now read in the data for the desired two dates
  # ------------------------------------------------------------
  df <- read.csv.sql(file, header = TRUE, sep = ";", sql = "select * from file where Date == '1/2/2007' or Date == '2/2/2007'")
  
  df$Time <- as.POSIXct(strptime(paste(df$Date,df$Time), "%d/%m/%Y %H: %M: %S"))
  #df$Date <- as.Date(df$Date, "%d/%m/%Y")
  
  # ------------------------------------------------------------
  # Now print the graph
  # ------------------------------------------------------------
  # Make sure we didn't end up without a standard screen output device
  #if (dev.cur() == 1) dev.new()
  if (makePNG) {png(file = "plot2.png", width = 480, height = 480)}
  with(df, plot(Time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
  if (makePNG) {
    dev.off()
    # Make sure we didn't end up without a standard screen output device
    if (dev.cur() == 1) dev.new()
  }
}