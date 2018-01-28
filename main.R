rm(list=ls())
cat("\014")

library(magrittr);library(utils)


code <- "C:/Users/bstrub/Documents/take_2/code"
file.path(code,"download.R") %>% source
file.path(code,"analysis.R") %>% source



download_main()

# analysis_main()


