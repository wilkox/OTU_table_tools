#Get arguments
TidyTable <- commandArgs(trailingOnly = TRUE)[1]
OutputPath <- commandArgs(trailingOnly = TRUE)[2]

#Load libraries
message("Loading libraries...")
library(wilkoxmisc)
library(reshape2)

#Read in OTU table
message("Reading tidy table...")
OTUCounts <- read.tidy(TidyTable)

#Cast
message("Writing cast table...")
OTUCounts <- dcast(OTUCounts, OTU ~ Sample, value.var = "Count", fill = 0)

#Write
write.tidy(OTUCounts, OutputPath)
