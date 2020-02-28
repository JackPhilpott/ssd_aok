library(koboloadeR)
library(dplyr)
library(stringr)
#library(intervalr)
source("scripts/functions/keys.R")
#library(intervalr)
#install.packages("taskscheduleR")


# MONTHLY INPUT - ONLY PART OF SCRIPT WHICH SHOULD REALLY BE UPDATED ------

output_final_folder<-"01_Settlement_Mapping"
assessment_year_month<- "2020_02"
date_script_ran<-Sys.Date() %>% stringr::str_replace_all("-","_")



filename_short<-paste0(date_script_ran,"_New_Settlements_in_Kobo_Data.csv")
#UNLESS THE RPROJ IS MOVED TO THE DROPBOX THE AMOUNT OF "../../.." WILL HAVE TO CHANGE DEPENDING ON WHOS COMPUTER THIS IS STORED ON.
dqm_folder_path<-"../../../../../Dropbox (SSD REACH)/REACH South Sudan upscale/12_AoK/06_AoK_Data_Analysis/10_Data_Quality_Monitoring/"

output_file_full_path<-paste0(dqm_folder_path,assessment_year_month,"/",output_final_folder,"/",filename_short)



# THIS SHOULD NOT CHANGE --------------------------------------------------


# KOBO_datasets <- kobo_datasets(user = c(keys[1],keys[2]), api="kobohr")
aok_data<-kobo_data_downloader(formid = 489385,user =  c(keys[1],keys[2]), api="kobohr", check = FALSE)

colnames(aok_data)<-gsub("\\/", ".", colnames(aok_data))

aok_other_settlement<- aok_data %>%
  filter(!is.na(D.info_settlement_other)) %>%
  filter(D.info_settlement_other!= "n/a") %>%
  select(uuid="_uuid" ,
         A.base,
         A.enumerator_id,
         D.info_county,
         D.info_settlement_other) %>% arrange(A.base)


aok_other_settlement$lat <- NA
aok_other_settlement$long <- NA

write.csv(aok_other_settlement,output_file_full_path)
