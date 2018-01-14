

analysis_main <- function(){
  
  files <- list.files("C:/Users/bstrub/Documents/take_2/analysis_input",full.names = TRUE)
  
  
  pb <- txtProgressBar(min = 0, max = length(files), style = 3)
  n = 1
  for (file in files){
    analysis(file)
    setTxtProgressBar(pb,n)
    n = n + 1
  }
  
}



analysis <- function(file){
  main <- read.csv(file,stringsAsFactors = FALSE)
  Sys.sleep(1)
}