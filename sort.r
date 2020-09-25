#Please use getwd() to find out your working directory
#Then put the "example.csv" file there.
#If the file is named something other than "example.csv" please
#update the variable inpfile below with the appropriate name.
#Then just run this script in its entirety. It will produce
#an output csv file in the working directory.

rm(list = ls())


mypath <- getwd()
mypath <- "/home/owner/Downloads"
inpfile <- "example.csv"

inpdat <- read.table(paste0(mypath, "/", inpfile), sep = "\t", header = TRUE)

for(i in 1:length(unique(inpdat$type))){
  
  #i <- 1
  curdat <- subset(inpdat, type == unique(inpdat$type)[i])
  type_count <- nrow(curdat)
  curdat$type_count <- rep(type_count, nrow(curdat))
  
  if(i == 1){
    outdat <- curdat
  } else{
    outdat <- rbind(outdat, curdat)
  }
  
}


outdat <- outdat[with(outdat, order(type_count)), ]
outdat <- outdat[ , 1:3]

#Writing the output
write.table(outdat, paste0(getwd(), "/", sub("\\.csv", "", inpfile, perl = TRUE), "_fixed.csv"), 
            row.names = FALSE, quote = FALSE, sep = "\t")

rm(inpdat, outdat, curdat, i, inpfile, mypath, type_count)
