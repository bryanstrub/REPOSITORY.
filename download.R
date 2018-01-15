

download_main <- function(){
  print("Deleting old files")
  do.call(file.remove, list(list.files("C:/Users/bstrub/Documents/take_2/analysis_input/", full.names = TRUE)))
  
  
  print("Downloading Stocks")
  start.time <- Sys.time()

  stocks <- read.csv("C:/Users/bstrub/Documents/take_2/all_nyse_without_dash.csv", stringsAsFactors = FALSE)
  stocks <- stocks[1:10,] # just for dev
  # stocks$idcaps <- "MSFT" # just for dev
  pb <- txtProgressBar(min = 0, max = nrow(stocks), style = 3)
  n = 1
  for(id in stocks$idcaps){
    data <- tryCatch(download_stock(id), warning = function(w) w)
    if (is(data,"warning")){
      stop("warning found : ", all)
    }
    setTxtProgressBar(pb,n)
    n = n + 1
  }
  
  end.time <- Sys.time()
  cat("\n")
  print("Downloads finished")
  print(end.time - start.time)
  
}



download_stock <- function(id){
  path <- paste0("https://finance.yahoo.com/quote/",id,"/history?p=",id)
	page <- suppressWarnings(readLines(path))

	page <- page[grepl("HistoricalPriceStore",page)][1]

	page <- substr(page,regexpr("HistoricalPriceStore",page),nchar(page))
	page <- substr(page,regexpr("\\[",page) + 1,nchar(page))
	page <- substr(page,1,regexpr("\\]",page)-1)


	page <- strsplit(page,"\\{") %>% as.data.frame
	names(page)[1] <- "value"
	page <- page[!grepl("DIVIDEND",page$value),] %>% as.data.frame # why does this return a vector and I have to change it back to a data frame....
	names(page)[1] <- "value"

	page <- page[2:nrow(page),] %>% as.data.frame #WHYYYYYYYYYYYYYYYYYY

	names(page)[1] <- "value"

	page$value <- gsub("\\'","",page$value)

	page <- matrix(unlist(strsplit(page$value,"\\,")),ncol = 7, byrow = TRUE) %>% as.data.frame


	bindme <- lapply(names(page),function(n){
	  
		temp <- as.character(page[[n]])
		temp <- gsub("\\}","",temp)
		temp <- as.numeric(matrix(unlist(strsplit(temp,":")),ncol = 2, byrow = TRUE)[,2])
		return(temp)
		
	})
  
	page <- as.data.frame(bindme)
	names(page) <- c("date","open","high","low","close","volume","adj_close")
	page$id <- id
	
	
	write.csv(page,file.path("C:/Users/bstrub/Documents/take_2/analysis_input/",paste0(id,".csv")),row.names=FALSE,na="")

}


