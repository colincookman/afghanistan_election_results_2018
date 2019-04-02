library(XML)
library(pdftools)
library(readr)
library(tidyverse)
library(lubridate)
library(stringr)
library(ggrepel)
library(gsheet)
library(rvest)
library(RSelenium)
library(wdman)
library(seleniumPipes)

setwd("~/Google Drive/GitHub/afghanistan_election_results_2018/data/past_elections/wj_2010")

# ----------------------------------------------------------------------------------
# CANDIDATE LISTS ------------------------------------------------------------------
rm(list = ls())

# pull additional candidate info from Afghan Election Data project -----------------

base_url <- "https://2010.afghanistanelectiondata.org/"
province_urls <- paste0(base_url, "candidates/province_", 1:34)

province_data_list <- list()

for(i in (1:length(province_urls))){ 
  # for each province
  driver <- rsDriver(browser="chrome", port = 4444L, chromever="73.0.3683.68", verbose = FALSE)
  driver$client$navigate(province_urls[i])
  
  # make sure the province page has fully loaded
  webElem <- NULL
  while(is.null(webElem)){
  webElem <- tryCatch({driver$client$findElement(using = 'css', value = "tbody")},
  error = function(e){Sys.sleep(1)})
  }
  
  Sys.sleep(1.5)
  
  page_source <- driver$client$getPageSource()
      
  province_table <- page_source[[1]] %>% read_html()
  province_list_item <- province_table %>% html_nodes("tbody") %>% html_text()
      
  # add html data to a master list      
  province_data_list <- c(province_data_list, province_list_item)
        
  driver$client$close()
  driver$server$stop()
  Sys.sleep(1.5)
        
}

# unpack scrape results

for(i in (1:length(province_data_list))){ 

  race_data <- strsplit(province_data_list[[i]], "\n") %>% unlist() %>% .[!trimws(.) == ""]

  # clean up column errors due to blanks for zero votes

  row_ends <- grep("%)", race_data)
  row_count <- length(row_ends)
  row_starts <- c(1, (row_ends + 1))
  row_starts <- row_starts[-length(row_starts)]
  
  for(j in 1:row_count){
    candidate_data <- rbind(race_data[row_starts[j]:row_ends[j]]) %>% data.frame()
    
    if(length(candidate_data) != 11){
      colnames(candidate_data) <- c("prelim_winner", "final_winner", "incumbent", "candidate_name_eng", "candidate_name_eng_2", 
                                  "candidate_gender", "candidate_gender_2", 
                                  "pct_change_final_prelim", "change_in_votes_char")
      
      candidate_data$final_votes_numeric <- NA
      candidate_data$final_votes_char <- NA
      
      candidate_data <- candidate_data %>% select(
        prelim_winner, final_winner, incumbent, candidate_name_eng, candidate_name_eng_2, candidate_gender, candidate_gender_2,
        final_votes_numeric, final_votes_char, pct_change_final_prelim, change_in_votes_char
      )
      
      
       } else {
         
        colnames(candidate_data) <- c("prelim_winner", "final_winner", "incumbent", "candidate_name_eng", "candidate_name_eng_2", 
                                  "candidate_gender", "candidate_gender_2", "final_votes_numeric", "final_votes_char", 
                                  "pct_change_final_prelim", "change_in_votes_char")
       }
    
    if(j == 1) {
      candidates <- candidate_data
    } else {
      candidates <- rbind(candidate_data, candidates)
    }
    
    }
  
  candidates$province_code = as.character(str_pad(i, 2, pad = "0", side = "left"))
  
  if(i == 1) {
    out <- candidates
  } else {
    out <- rbind(out, candidates)
  }
}

# clean up
province_results <- out

# AED site does not follow IEC 2010 province codes in reporting results, so have to correct to match other sources
corrected_codes <- data.frame(c(1, 2, 3, 4, 5, 10, 12, 33, 16, 32, 6, 8, 11, 13, 14, 15, 17, 19, 18, 21, 31, 34, 30, 29, 7, 9, 20, 22, 23, 24, 25, 27, 28, 26))
corrected_codes$province_code <- (1:34)
colnames(corrected_codes) <- c("province_code_corrected", "province_code")
corrected_codes$province_code = as.character(str_pad(corrected_codes$province_code, 2, pad = "0", side = "left"))

province_results <- left_join(province_results, corrected_codes)
province_results$province_code_corrected = as.character(str_pad(province_results$province_code_corrected, 2, pad = "0", side = "left"))
  
province_results$prelim_winner <- as.character(province_results$prelim_winner)
province_results$final_winner <- as.character(province_results$final_winner)
province_results$incumbent <- as.character(province_results$incumbent)
province_results$candidate_name_eng <- as.character(province_results$candidate_name_eng)
province_results$candidate_name_eng_2 <- as.character(province_results$candidate_name_eng_2)
province_results$candidate_gender <- as.character(province_results$candidate_gender)
province_results$candidate_gender_2 <- as.character(province_results$candidate_gender_2)
province_results$final_votes_numeric <- as.numeric(as.character(province_results$final_votes_numeric))
province_results$final_votes_char <- as.numeric(as.character(gsub(",", "", province_results$final_votes_char)))
province_results$pct_change_final_prelim <- as.character(province_results$pct_change_final_prelim)
province_results$change_in_votes_char <- as.character(province_results$change_in_votes_char)

province_results$change_in_votes_numeric <- as.numeric(gsub("\\(.*?\\)", "", gsub(",", "", province_results$change_in_votes_char)))
province_results$final_votes_numeric[is.na(province_results$final_votes_numeric)] <- 0
province_results$prelim_votes_numeric <- province_results$final_votes_numeric - province_results$change_in_votes_numeric

# province_results$votes_check <- ifelse(province_results$final_votes_numeric != province_results$final_votes_char, "ERROR", "OK")
# province_results$name_check <- ifelse(province_results$candidate_name_eng != province_results$candidate_name_eng_2, "ERROR", "OK")
# province_results$gender_check <- ifelse(province_results$candidate_gender != province_results$candidate_gender_2, "ERROR", "OK")

province_results <- province_results %>% select(
  province_code_corrected, candidate_name_eng_2, candidate_gender_2, incumbent, final_votes_numeric, prelim_votes_numeric, prelim_winner, final_winner) %>% 
  arrange(province_code, desc(final_votes_numeric)) %>% 
  rename(province_code = province_code_corrected,
         candidate_name_eng = candidate_name_eng_2, 
         candidate_gender = candidate_gender_2, 
         final_votes = final_votes_numeric, 
         prelim_votes = prelim_votes_numeric)

write.csv(province_results, "./raw/rough_candidate_data.csv", row.names = F)

# find candidate codes in available prelim data, ommitting Kuchi candidates missing from other data source

wj_2010_prelim <- read.csv("./raw/prelim_af_candidate_ps_data_2010.csv", stringsAsFactors = F)
wj_2010_prelim$province_code = as.character(str_pad(wj_2010_prelim$province_code, 2, pad = "0", side = "left"))

prelim_cand_data <- wj_2010_prelim %>% filter(electorate == "General") %>% group_by(province_code, candidate_id, voter_id, ballot_position) %>% summarize(
  prelim_votes = sum(votes, na.rm = TRUE)
)

unique_meta_data <- province_results[(!duplicated(province_results$prelim_votes) | !duplicated(province_results$prelim_votes, fromLast = TRUE)) == "TRUE", ]
unique_candidate_votes <- prelim_cand_data[(!duplicated(prelim_cand_data$prelim_votes) | !duplicated(prelim_cand_data$prelim_votes, fromLast = TRUE)) == "TRUE", ]

candidate_meta_data <- left_join(unique_meta_data, unique_candidate_votes)

# candidates for which codes must be checked manually

missing_candidate_codes <- province_results %>% select(province_code, candidate_name_eng, candidate_gender) %>%
  anti_join(unique_meta_data, by = "candidate_name_eng")

write.csv(missing_candidate_codes, "./raw/missing_candidate_codes.csv", row.names = F)

# get translated party affiliation data from DI candidate lists --------------------



# add Kuchi metadata missing from AED site


# combined and write final candidate data csv

# ----------------------------------------------------------------------------------
# FINAL RESULTS --------------------------------------------------------------------
# import and clean available final results data via DevelopmentSeed / NDI
# Afghan Election Data (https://afghanistanelectiondata.org/sites/default/files/wj_2010_final.zip)

rm(list = ls())

wj_2010_import <- read.csv("./raw/wj_2010_final.csv", stringsAsFactors = F)
wj_2010_final <- wj_2010_import

colnames(wj_2010_final) <- c("candidate_name_dari", "ballot_position", "council_code", "province_name_eng", "votes", "pc_name_eng", "pc_code", "pc_location", 
                       "ps_number", "ps_open_status", "ps_station_type", "status_unknown", "district_name_eng", "district_name_dari", "province_code", 
                       "voter_id", "candidate_id", "candidate_gender")

wj_2010_final$province_code <- as.character(str_pad(wj_2010_final$province_code, 2, pad = "0", side = "left"))
wj_2010_final$ps_number <- as.character(str_pad(wj_2010_final$ps_number, 2, pad = "0", side = "left"))
wj_2010_final$pc_code <- as.character(str_pad(wj_2010_final$pc_code, 7, pad = "0", side = "left"))
wj_2010_final$ps_open_status <- "YES"

wj_2010_final <- select(wj_2010_final, province_code, province_name_eng, district_name_eng, district_name_dari,
                        pc_code, pc_name_eng, pc_location, ps_number, ps_station_type, ps_open_status, 
                        candidate_id, voter_id, candidate_gender, candidate_name_dari, ballot_position, votes)

wj_2010_final$results_status <- "FINAL"
wj_2010_final$results_date <- mdy("11-24-2010")

# voter_id variable appears to be a Development Seed / NDI correction of IEC data entry errors on candidate ID codes?

wj_2010_final <- wj_2010_final %>% mutate(
  district_code = str_sub(pc_code, 1,4),
  district_number = str_sub(district_code, 3,4),
  pc_number = str_sub(pc_code, 5,7),
  ps_code = paste(pc_code, ps_number, sep = "-")
)

# SEPARATE OUT KUCHI ELECTORATE -- KUCHI CANDIDATES ON GENERAL BALLOT?

wj_2010_final <- select(wj_2010_final, results_status, results_date, province_code, province_name_eng, 
                        district_code, district_number, district_name_eng, district_name_dari,
                        pc_code, pc_name_eng, pc_location, pc_number,
                        ps_code, ps_number, ps_station_type, ps_open_status, 
                        candidate_id, voter_id, candidate_name_dari, ballot_position, candidate_gender, votes) %>%
  arrange(province_code, pc_code, ps_code, ballot_position)


# ADD FULL CANDIDATE AND PROVINCE/DISTRICT DATA
# ADD WINNER STATUS

write.csv(wj_2010_final, "final_af_candidate_ps_data_2010.csv", row.names = F)

wj_2010_final_lite <- select(wj_2010_final, ps_code, candidate_id, voter_id, votes)
  
write.csv(wj_2010_final_lite, "final_af_candidate_ps_data_2010_lite.csv", row.names = F)

# PRELIM RESULTS -------------------------------------------------------------------
rm(list = ls())

# combine all province files into one dataframe
results_files <- list.files("./raw/2010-preliminary-results_0", pattern = ".csv")
for(i in 1:length(results_files)){
  import <- read.csv(paste0("./raw/2010-preliminary-results_0/", results_files[i]), stringsAsFactors = F)
  import$electorate <- ifelse(basename(results_files[i]) == "kuchi.csv", "Kuchi", "General")
  
  if(i == 1) {
    out <- import
  } else {
    out <- rbind(out, import)
  }
  
}

wj_2010_prelim <- out

colnames(wj_2010_prelim) <- c("pc_code", "ps_number", "ps_station_type", "ballot_position", "votes", "votes_invalidated", 
                              "district_id", "district_name_eng", "province_name_eng", "province_code", "invalidated", 
                              "candidate_gender", "candidate_party_id", "voter_id", "candidate_id", "electorate")

wj_2010_prelim <- select(wj_2010_prelim, electorate, province_code, province_name_eng, district_id, district_name_eng, pc_code, ps_number, ps_station_type,
                         invalidated, voter_id, candidate_id, candidate_party_id, candidate_gender, ballot_position, votes, votes_invalidated)

wj_2010_prelim$province_code <- as.character(str_pad(wj_2010_prelim$province_code, 2, pad = "0", side = "left"))
wj_2010_prelim$ps_number <- as.character(str_pad(wj_2010_prelim$ps_number, 2, pad = "0", side = "left"))
wj_2010_prelim$pc_code <- as.character(str_pad(wj_2010_prelim$pc_code, 7, pad = "0", side = "left"))

wj_2010_prelim$results_status <- "PRELIMINARY"
wj_2010_prelim$results_date <- mdy("10-20-2010")

wj_2010_prelim <- wj_2010_prelim %>% mutate(
  district_code = str_sub(pc_code, 1,4),
  district_number = str_sub(district_code, 3,4),
  pc_number = str_sub(pc_code, 5,7),
  ps_code = paste(pc_code, ps_number, sep = "-")
)

# drop unknown district ID variable and re-sort

wj_2010_prelim <- select(wj_2010_prelim, results_status, results_date, electorate, province_code, province_name_eng, 
                        district_code, district_number, district_name_eng,
                        pc_code, pc_number,
                        ps_code, ps_number, ps_station_type, invalidated,
                        candidate_id, voter_id, ballot_position, candidate_party_id, candidate_gender, votes, votes_invalidated) %>%
  arrange(province_code, pc_code, ps_code, ballot_position)

# NEED TO DECIPHER WHAT INVALIDATED VOTES MEANS HERE

# ADD FULL CANDIDATE AND PROVINCE / DISTRICT DATA
# ADD WINNER STATUS

# write csvs

# COMBINE FINAL AND PRELIM RESULTS -------------------------------------------------
rm(list = ls())

write.csv(wj_2010_prelim, "prelim_af_candidate_ps_data_2010.csv", row.names = F)

wj_2010_prelim_lite <- select(wj_2010_prelim, ps_code, candidate_id, voter_id, votes, votes_invalidated) # ??
  
write.csv(wj_2010_final_lite, "prelim_af_candidate_ps_data_2010_lite.csv", row.names = F)


# POLLING CENTER PLAN --------------------------------------------------------------
rm(list = ls())

pc_plan_import <- read.csv("./raw/iec_2010_centers.csv", stringsAsFactors = F)
pc_plan <- pc_plan_import
colnames(pc_plan) <- c("province_name_eng", "province_name_dari", "district_name_eng", "district_name_dari", "pc_location", "pc_location_dari",
                          "province_code", "district_number", "district_code", "pc_code", "est_voters", "ps_count", "ps_male", "ps_fem", "ps_kuchi", 
                       "access_notes")

pc_plan$province_code <- as.character(str_pad(pc_plan$province_code, 2, pad = "0", side = "left"))
pc_plan$district_code <- as.character(str_pad(pc_plan$district_code, 4, pad = "0", side = "left"))
pc_plan$district_number <- as.character(str_pad(pc_plan$district_number, 2, pad = "0", side = "left"))
pc_plan$pc_code <- as.character(str_pad(pc_plan$pc_code, 7, pad = "0", side = "left"))

pc_plan <- select(pc_plan, province_code, province_name_eng, province_name_dari, district_code, district_number, district_name_eng, district_name_dari,
                  pc_code, pc_location, pc_location_dari, ps_count, ps_male, ps_fem, ps_kuchi, est_voters, access_notes) %>% arrange(
                    province_code, district_code, pc_code
                  )

# reporting status

wj_2010_prelim <- read.csv("./prelim_af_candidate_ps_data_2010.csv", stringsAsFactors = F)
wj_2010_final <- read.csv("./final_af_candidate_ps_data_2010.csv", stringsAsFactors = F)




# ----------------------------------------------------------------------------------
# CREATE KEY FILES -----------------------------------------------------------------

# province key
# district key
# candidate key
# summary province pc-ps-candidate-votes table


