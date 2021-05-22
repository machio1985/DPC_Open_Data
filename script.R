# library & setting  ------------
library(tidyverse)
library(stringi)
library(rvest)
library(readxl)
library(magrittr)
library(data.table)

dir.create(paste(getwd(),"/01.input",sep=""))
dir.create(paste(getwd(),"/02.output",sep=""))

# functions ---------      

#DLする時の処置
dl.dpc<-function(x){
  download.file(url = x,
                destfile = str_c(file_name,extension),
                quiet=TRUE)
}

#ファイルのカラム名を綺麗にする処置(怪しい)
clean_name<-function(x){
  x %>% 
    rename_all(funs(str_remove_all(.,"\r\n"))) %>%
    rename_all(funs(str_remove_all(.,"\n"))) %>%
    rename_all(funs(str_remove(.,"※[0-9]")))%>% 
    rename_all(funs(str_remove_all(.,"(\\...[0-9][0-9][0-9])"))) %>% 
    rename_all(funs(str_remove_all(.,"(\\...[0-9][0-9])"))) %>% 
    rename_all(funs(str_remove_all(.,"(\\...[0-9])")))
}

#セル内を綺麗にする処置(怪しい)
clean_sell<-function(x){
  x %>% 
    str_remove("\r\n") %>%
    str_remove_all("(\\...[0-9][0-9][0-9])") %>% 
    str_remove_all("(\\...[0-9][0-9])") %>% 
    str_remove_all("(\\...[0-9])")
}

#欠損セルを埋める処理
fill.colnames<-function(x){
  x %>% 
    mutate(tmp=if_else(tmp=="",NA_character_,as.character(tmp))) %>% 
    fill(tmp) %>% 
    mutate(tmp=if_else(is.na(tmp),"",tmp)) 
}

#カラム名が複数行に渡っているため、ファイル毎に取得する。
#3行に渡っている場合の処理
#extension で拡張子を指定しておく。xlsx / xls
make_data_skip2 <- function(){
  #1~3行のデータをそれぞれ取得
  suppressMessages(tmp1<-read_excel(str_c(file_name,extension),skip=0))
  suppressMessages(tmp2<-read_excel(str_c(file_name,extension),skip=1))
  suppressMessages(tmp3<-read_excel(str_c(file_name,extension),skip=2))
  
  suppressMessages(
    fix_colnames <- bind_cols(
      data.frame(tmp = colnames(tmp1) %>% clean_sell()) %>% fill.colnames(),
      data.frame(tmp = colnames(tmp2) %>% clean_sell()) %>% fill.colnames(),
      data.frame(tmp = colnames(tmp3) %>% clean_sell()) %>% fill.colnames()) %>% 
      mutate(tmp=str_c(tmp...2,tmp...1,tmp...3,sep="_"))#文字連結する
  )
  
  tmp3 <- tmp3 %>%  
    set_colnames(fix_colnames$tmp) %>% 
    rename_all(funs(str_remove_all(.,"(\\__)"))) %>% 
    gather(手術,値,-c("告示番号","通番","施設名")) %>% 
    filter(値!="-") %>% 
    filter(str_detect(手術,"件数")) %>% 
    mutate(file=str_remove_all(file_name,file.path(dir)))%>% 
    mutate(file=str_remove_all(file,"/")) %>% 
    mutate_all(funs(as.character(.)))
  
  write.csv(tmp3,str_c(file_name,".csv"),row.names = FALSE)
  file.remove(str_c(file_name,extension))
}


#カラム名が複数行に渡っているため、ファイル毎に取得する。
#4行に渡っている場合の処理
make_data_skip3 <- function(){
  suppressMessages(tmp1<-read_excel(str_c(file_name,extension),skip=0))
  suppressMessages(tmp2<-read_excel(str_c(file_name,extension),skip=1))
  suppressMessages(tmp3<-read_excel(str_c(file_name,extension),skip=2))
  suppressMessages(tmp4<-read_excel(str_c(file_name,extension),skip=3))
  
  suppressMessages(
    fix_colnames<-bind_cols(
      data.frame(tmp = colnames(tmp1) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp2) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp3) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp4) %>% clean_sell) %>% fill.colnames) %>% 
      mutate(tmp=str_c(tmp...2,tmp...1,tmp...3,tmp...4,sep="_"))
  )
  
  tmp4 <- tmp4 %>%  
    set_colnames(fix_colnames$tmp) %>% 
    rename_all(funs(str_remove_all(.,"(\\___)"))) %>% 
    gather(手術,値,-c("告示番号","通番","施設名")) %>% 
    filter(値!="-") %>% 
    filter(str_detect(手術,"件数")) %>% 
    mutate(file=str_remove_all(file_name,file.path(dir)))%>% 
    mutate(file=str_remove_all(file,"/"))%>% 
    mutate_all(funs(as.character(.)))
  
  write.csv(tmp4,str_c(file_name,".csv"),row.names = FALSE)
  file.remove(str_c(file_name,extension))
}

#カラム名が複数行に渡っているため、ファイル毎に取得する。
#5行に渡っている場合の処理
make_data_skip4 <- function(){
  suppressMessages(tmp1<-read_excel(str_c(file_name,extension),skip=0))
  suppressMessages(tmp2<-read_excel(str_c(file_name,extension),skip=1))
  suppressMessages(tmp3<-read_excel(str_c(file_name,extension),skip=2))
  suppressMessages(tmp4<-read_excel(str_c(file_name,extension),skip=3))
  suppressMessages(tmp5<-read_excel(str_c(file_name,extension),skip=4))
  
  suppressMessages(
    fix_colnames<-bind_cols(
      data.frame(tmp = colnames(tmp1) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp2) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp3) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp4) %>% clean_sell) %>% fill.colnames,
      data.frame(tmp = colnames(tmp5) %>% clean_sell) %>% fill.colnames) %>% 
      mutate(tmp=str_c(tmp...2,tmp...1,tmp...3,tmp...4,tmp...5,sep="_"))
  )
  
  tmp5 <- tmp5 %>%  
    set_colnames(fix_colnames$tmp) %>% 
    rename_all(funs(str_remove_all(.,"(\\____)"))) %>% 
    gather(手術,値,-c("告示番号","通番","施設名")) %>% 
    filter(値!="-") %>% 
    filter(str_detect(手術,"件数")) %>% 
    mutate(file=str_remove_all(file_name,file.path(dir)))%>% 
    mutate(file=str_remove_all(file,"/"))%>% 
    mutate_all(funs(as.character(.)))
  
  write.csv(tmp5,str_c(file_name,".csv"),row.names = FALSE)
  file.remove(str_c(file_name,extension))
}

make_list <- function(){
  file_list  <- list.files(path = dir, full.names = T)
  tmp <- lapply(file_list,fread)
  dat  <- list()
  
  for(i in 1:length(tmp)){
    tmp2 <- tmp[[i]] %>% 
      mutate_all(as.character) %>% 
      mutate(値=as.numeric(値)) 
    
    dat<-bind_rows(dat,tmp2)
  }
  
  dat_fix <- dat %>% 
    mutate(手術=stri_trans_nfkc(手術),
             手術=str_remove_all(手術," "),
             手術=str_remove_all(手術,"　"),
             年次=str_sub(file,-3,-1),
             MDC=str_sub(file,-5,-4),
             集計内容=str_sub(file,1,-10)) %>%
    separate(手術,c("診断群分類","診断群分類コード","件数","手術","処置"),sep="_") %>% 
    select(-件数) %>% 
    mutate(
      手術=case_when(
        手術=="99" ~ "手術なし",
        手術=="97" ~ "その他手術あり",
        str_detect(手術,"輸血以外") ~ "その他手術あり_輸血以外再掲",
        TRUE~手術)) 
  
  write.csv(dat_fix,str_c("02.output/DPC_",year,".csv",sep="") , row.names = FALSE)
}


### R01 #################################### -----------------------------------------------------------------
year<- "R01"
extension　<- "xlsx"
dir <- paste(getwd(),"/01.input/DPC_",year,sep="")
dir.create(dir)
url <- "https://www.mhlw.go.jp/content/12404000/"

# データ読み込み_施設概要表----------------- -----------------------------------------------------------------

contents<-"/施設概要_"
file_name <- str_c(file.path(dir),contents,year)
dl.dpc(str_c(url,"000758182.xlsx"))

tmp <- read_excel(str_c(file_name,extension)) %>% clean_name() %>% filter(!is.na(都道府県))
write.csv(tmp,str_c("01.input/施設概要_",year,".csv"),row.names = FALSE)
file.remove(str_c(file_name,extension))

# データ読み込み_疾患別手術別集計----------- -----------------------------------------------------------------

contents<-"/疾患別手術別集計_"

file_list <- list("000758261.xlsx",
                  "000758264.xlsx",
                  "000758265.xlsx",
                  "000758266.xlsx",
                  "000758267.xlsx",
                  "000758269.xlsx",
                  "000758271.xlsx",
                  "000758272.xlsx",
                  "000758274.xlsx",
                  "000758275.xlsx",
                  "000758276.xlsx",
                  "000758277.xlsx",
                  "000758278.xlsx",
                  "000758279.xlsx",
                  "000758280.xlsx",
                  "000758281.xlsx",
                  #17がない
                  "000758282.xlsx"
)

for(i in c(1:17)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
    } else if (i==17){
      file_name <- str_c(file.path(dir),contents,"MDC",i+1,year) # 17のファイルがないため
    } else {
      file_name <- str_c(file.path(dir),contents,"MDC",i,year)
      }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip3()
  Sys.sleep(10)
}

# データ読み込み_疾患別手術有無処置1別集計-- -----------------------------------------------------------------

contents<-"/疾患別手術有無処置1別集計_"

file_list <- list("000758327.xlsx",
                  "000758332.xlsx",
                  "000758335.xlsx",
                  "000758336.xlsx",
                  "000758338.xlsx",
                  "000758347.xlsx",
                  "000758348.xlsx",
                  "000758349.xlsx",
                  "000758350.xlsx",
                  "000758351.xlsx",
                  "000758352.xlsx",
                  "000758353.xlsx",
                  "000758354.xlsx",
                  "000758355.xlsx",
                  "000758358.xlsx",
                  "000758359.xlsx",
                  "000758360.xlsx",
                  "000758361.xlsx")

for(i in c(1:18)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
  } else {
    file_name <- str_c(file.path(dir),contents,"MDC",i,year) }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip4()
  Sys.sleep(10)
}



# データ読み込み_疾患別手術有無処置2別集計-- -----------------------------------------------------------------

contents<-"/疾患別手術有無処置2別集計_"

file_list <- list("000758381.xlsx",
                  "000758384.xlsx",
                  "000758385.xlsx",
                  "000758386.xlsx",
                  "000758387.xlsx",
                  "000758389.xlsx",
                  "000758390.xlsx",
                  "000758391.xlsx",
                  "000758395.xlsx",
                  "000758396.xlsx",
                  "000758398.xlsx",
                  "000758399.xlsx",
                  "000758400.xlsx",
                  "000758401.xlsx",
                  "000758403.xlsx",
                  "000758404.xlsx",
                  "000758416.xlsx",
                  "000758417.xlsx")

for(i in c(1:18)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
  } else {
    file_name <- str_c(file.path(dir),contents,"MDC",i,year) }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip4()
  Sys.sleep(10)
}

# データ整形/書き出し----------------------- -------------------------------------------------------------------
make_list()

### H30 #################################### -----------------------------------------------------------------
year <- "H30"
extension　<- "xlsx"
dir  <- paste(getwd(),"/01.input/DPC_",year,sep="")
dir.create(dir)
url  <- "https://www.mhlw.go.jp/content/12404000/"

# データ読み込み_施設概要表----------------- -----------------------------------------------------------------
contents<-"/施設概要_"
file_name <- str_c(file.path(dir),contents,year)
dl.dpc(str_c(url,"000612770.xlsx"))

tmp <- read_excel(str_c(file_name,".xls")) %>% clean_name() %>% filter(!is.na(都道府県))
write.csv(tmp,str_c("01.input/施設概要_",year,".csv"),row.names = FALSE)
file.remove(str_c(file_name,extension))

# データ読み込み_疾患別手術別集計----------- -----------------------------------------------------------------
contents<-"/疾患別手術別集計_"

file_list <- list("000612849.xlsx",
                  "000612850.xlsx",
                  "000612851.xlsx",
                  "000612852.xlsx",
                  "000612853.xlsx",
                  "000612855.xlsx",
                  "000612864.xlsx",
                  "000612865.xlsx",
                  "000612866.xlsx",
                  "000612867.xlsx",
                  "000612868.xlsx",
                  "000612869.xlsx",
                  "000612870.xlsx",
                  "000612871.xlsx",
                  "000612872.xlsx",
                  "000612849.xlsx",
                  "000612873.xlsx",
                  "000612874.xlsx")

for(i in c(1:18)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
  } else {
    file_name <- str_c(file.path(dir),contents,"MDC",i,year)
  }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip3()
  Sys.sleep(10)
}



# データ読み込み_疾患別手術有無処置1別集計-- -----------------------------------------------------------------

contents<-"/疾患別手術有無処置1別集計_"

file_list <- list("000612879.xlsx",
                  "000612881.xlsx",
                  "000613995.xlsx",
                  "000612891.xlsx",
                  "000612897.xlsx",
                  "000612901.xlsx",
                  "000612904.xlsx",
                  "000612905.xlsx",
                  "000612906.xlsx",
                  "000612909.xlsx",
                  "000612910.xlsx",
                  "000612911.xlsx",
                  "000612912.xlsx",
                  "000612915.xlsx",
                  "000612917.xlsx",
                  "000612918.xlsx",
                  "000612919.xlsx",
                  "000612921.xlsx")

for(i in c(1:18)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
  } else {
    file_name <- str_c(file.path(dir),contents,"MDC",i,year)
  }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip4()
  Sys.sleep(10)
}

# データ読み込み_疾患別手術有無処置2別集計-- -----------------------------------------------------------------

contents<-"/疾患別手術有無処置2別集計_"

file_list <- list("000612928.xlsx",
                  "000612929.xlsx",
                  "000612930.xlsx",
                  "000612931.xlsx",
                  "000612932.xlsx",
                  "000612934.xlsx",
                  "000612904.xlsx",
                  "000612940.xlsx",
                  "000612945.xlsx",
                  "000612947.xlsx",
                  "000612951.xlsx",
                  "000612953.xlsx",
                  "000612958.xlsx",
                  "000612959.xlsx",
                  "000612961.xlsx",
                  "000612963.xlsx",
                  "000612964.xlsx",
                  "000612966.xlsx")

for(i in c(1:18)){
  cat("i:",i,"\n")
  if(i < 10){ 
    file_name <- str_c(file.path(dir),contents,"MDC0",i,year) 
  } else {
    file_name <- str_c(file.path(dir),contents,"MDC",i,year)
  }
  dl.dpc(str_c(url,file_list[i]))
  make_data_skip4()
  Sys.sleep(10)
}

# データ整形/書き出し----------------------- -------------------------------------------------------------------
make_list()

#合算------------

dat_dpc <- bind_rows(
  fread("02.output/DPC_H30.csv"),
  fread("02.output/DPC_R01.csv"),
)

write.csv(dat_dpc,"02.output/DPC_open_dataH30_R01.csv",row.names = F)
