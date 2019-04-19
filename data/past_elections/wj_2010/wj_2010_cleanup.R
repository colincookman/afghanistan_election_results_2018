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

# scrape the originals from IEC to check against AED project?
# http://www.iec.org.af/results_10/eng/index.html

# ----------------------------------------------------------------------------------
# CANDIDATE LISTS ------------------------------------------------------------------
rm(list = ls())

# pull additional candidate metadata (incumbency / gender) from Afghan Election Data project -----------------

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

candidate_metadata <- read.csv("./raw/rough_candidate_data.csv", stringsAsFactors = F)
candidate_metadata$province_code = as.character(str_pad(candidate_metadata$province_code, 2, pad = "0", side = "left"))

wj_2010_prelim <- read.csv("./raw/prelim_af_candidate_ps_data_2010.csv", stringsAsFactors = F)
wj_2010_prelim$province_code = as.character(str_pad(wj_2010_prelim$province_code, 2, pad = "0", side = "left"))

cand_vote_data <- wj_2010_prelim %>% filter(electorate == "General") %>% group_by(province_code, candidate_id, voter_id, ballot_position) %>% summarize(
  prelim_votes = sum(votes, na.rm = TRUE)
)

unique_meta_data <- candidate_metadata[(!duplicated(candidate_metadata$prelim_votes)) == "TRUE", ]
unique_cand_votes <- cand_vote_data[(!duplicated(cand_vote_data$prelim_votes)) == "TRUE", ]

known_candidate_metadata <- left_join(unique_cand_votes, unique_meta_data, by = c("province_code", "prelim_votes"))

# candidates for which codes must be checked manually

unknown_candidate_metadata <- candidate_metadata %>% dplyr::select(province_code, candidate_name_eng, candidate_gender) %>%
  anti_join(unique_meta_data, by = "candidate_name_eng")

candidate_ids_missing_metadata <- cand_vote_data %>% dplyr::select(province_code, candidate_id, voter_id, ballot_position, prelim_votes) %>%
  anti_join(known_candidate_metadata, by = "candidate_id")

# write.csv(unknown_candidate_metadata, "./raw/missing_candidate_codes.csv", row.names = F)

missing_candidate_codes_corrected <- read.csv("./raw/WJ_2010_missing_candidate_codes.csv", stringsAsFactors = F)
missing_candidate_codes_corrected$province_code = as.character(str_pad(missing_candidate_codes_corrected$province_code, 2, pad = "0", side = "left"))
updated_candidate_metadata <- left_join(missing_candidate_codes_corrected, unknown_candidate_metadata)

all_known_candidate_metadata <- full_join(known_candidate_metadata, updated_candidate_metadata)

dupe_errors <- all_known_candidate_metadata[duplicated(all_known_candidate_metadata$candidate_id) | 
                                              duplicated(all_known_candidate_metadata$candidate_id, fromLast = T), ]

all_known_candidate_metadata_corrected <- anti_join(all_known_candidate_metadata, dupe_errors, by = "candidate_name_eng")
all_known_candidate_metadata_corrected$candidate_id <- as.character(all_known_candidate_metadata_corrected$candidate_id)

# write.csv(dupe_errors, "./raw/dupe_errors.csv", row.names = F)

# some manual fixes
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == " Ustad Musa Farior"] <- "11336178"
all_known_candidate_metadata_corrected$voter_id[all_known_candidate_metadata_corrected$candidate_name_eng == " Ustad Musa Farior"] <- "11336178"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Nafisa Bahar"] <- "7939516"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Sardar Barialay Amiri"] <- "3664602"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Muhammad Ibrhim Fidayi Shikhali"] <- "3716745"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Hayatullah"] <- "6984708"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Alhaj Maulawi Muhammad Asif Ghareeb Yar"] <- "10340752"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Hajji Abid Nazar"] <- "5794912"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Mir Alam Nasratyar"] <- "1691172"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Alhaj Muhammad Alam Aymaq"] <- "6984217"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Abdul Karim"] <- "102922678"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Eng. Mahmood Kalakani"] <- "7970926"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Ahmad Ali Rashid"] <- "5917527"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == " Puhandoy Abdul Munir Nigah"] <- "4766105"
all_known_candidate_metadata_corrected$voter_id[all_known_candidate_metadata_corrected$candidate_name_eng == " Puhandoy Abdul Munir Nigah"] <- "4766105"
all_known_candidate_metadata_corrected$candidate_id[all_known_candidate_metadata_corrected$candidate_name_eng == "Hajji Muhammad Hussain Hani A.K.A Hajji Shir"] <- "3674563"

dupe_errors_fixed <- read.csv("./raw/dupe_errors.csv", stringsAsFactors = F)
dupe_errors_fixed$province_code = as.character(str_pad(dupe_errors_fixed$province_code, 2, pad = "0", side = "left"))
dupe_errors_fixed$candidate_id = as.character(dupe_errors_fixed$candidate_id)

all_known_candidate_metadata_corrected_with_dupes <- full_join(all_known_candidate_metadata_corrected, dupe_errors_fixed)

# cand_vote_data$candidate_id <- as.character(cand_vote_data$candidate_id)
# still_missing <- cand_vote_data %>% anti_join(all_known_candidate_metadata_corrected_with_dupes, by = "candidate_id")

code_metadata_key <- all_known_candidate_metadata_corrected_with_dupes %>% dplyr::select(province_code, candidate_id, voter_id, candidate_name_eng)

missing_metadata <- tibble(
c("22", "19", "01"),
c("8064473", "9746112", "5516772"),
c(NA, NA, NA),
c("Faizullah Faiz", "Eng. Zafar Khan", "Eng. Muhammad Salim Qayumi"))
colnames(missing_metadata) <- c("province_code", "candidate_id", "voter_id", "candidate_name_eng")
missing_metadata$voter_id <- as.character(missing_metadata$voter_id)

code_metadata_key <- full_join(code_metadata_key, missing_metadata)
code_metadata_key$voter_id[is.na(code_metadata_key$voter_id)] <- code_metadata_key$candidate_id[is.na(code_metadata_key$voter_id)]

code_metadata_key <- code_metadata_key %>% mutate(
  candidate_id_corrected = ifelse(candidate_id != voter_id, voter_id, candidate_id)
)

cand_vote_data$candidate_id <- as.character(cand_vote_data$candidate_id)
cand_vote_data$voter_id <- as.character(cand_vote_data$voter_id)
cand_vote_data <- cand_vote_data %>% mutate(
  candidate_id_corrected = ifelse(candidate_id != voter_id, voter_id, candidate_id)
)

all_candidate_vote_metadata <- left_join(code_metadata_key, candidate_metadata)
all_candidate_vote_metadata <- left_join(all_candidate_vote_metadata, cand_vote_data)
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "2915960"] <- 32
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "3664606"] <- 340
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "5423957"] <- 542
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "5749744"] <- 190
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "5794905"] <- 15
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "7939516"] <- 22
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "8758999"] <- 65

all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "579470200"] <- 13
all_candidate_vote_metadata$ballot_position[all_candidate_vote_metadata$candidate_id_corrected == "5516722"] <- 328

all_candidate_vote_metadata$electorate <- "General"

# MISSING KABUL CANDIDATE #127, Saranwal Hussain Bakshi
all_candidate_vote_metadata <- rbind(all_candidate_vote_metadata, 
                                     c("1", "3664609", "3664609", "Saranwal Hussain Bakshi", "3664609", "Male", "NA", "NA", "NA", "NA", "NA", "127", "General"))


all_candidate_vote_metadata$province_code <- as.character(str_pad(all_candidate_vote_metadata$province_code, 2, pad = "0", side = "left"))
all_candidate_vote_metadata$ballot_position <- as.numeric(all_candidate_vote_metadata$ballot_position)
all_candidate_vote_metadata <- all_candidate_vote_metadata %>% arrange(province_code, ballot_position)

write.csv(all_candidate_vote_metadata, "./raw/general_candidate_metadata.csv", row.names = F)

# add Kuchi metadata missing from AED site
# kuchi_vote_data <- wj_2010_prelim %>% filter(electorate == "Kuchi") %>% 
#  dplyr::select(candidate_id, voter_id, ballot_position) %>% unique()

all_candidate_vote_metadata <- read.csv("./raw/general_candidate_metadata.csv", stringsAsFactors = F)
all_candidate_vote_metadata$candidate_id_corrected <- as.character(all_candidate_vote_metadata$candidate_id_corrected)
all_candidate_vote_metadata$candidate_id <- as.character(all_candidate_vote_metadata$candidate_id)
all_candidate_vote_metadata$voter_id <- as.character(all_candidate_vote_metadata$voter_id)
all_candidate_vote_metadata$province_code = as.character(str_pad(all_candidate_vote_metadata$province_code, 2, pad = "0", side = "left"))

all_candidate_vote_metadata <- dplyr::select(all_candidate_vote_metadata, 
                                             electorate, province_code, candidate_id_corrected, ballot_position, candidate_name_eng, 
                                             incumbent, candidate_gender, prelim_winner, final_winner) %>% 
  arrange(electorate, province_code, ballot_position) %>% 
  rename(candidate_code = candidate_id_corrected)

kuchi_candidate_metadata <- read.csv("./raw/kuchi_candidate_metadata.csv", stringsAsFactors = F)
kuchi_candidate_metadata$candidate_id <- as.character(kuchi_candidate_metadata$candidate_id)
kuchi_candidate_metadata$incumbent <- as.character(kuchi_candidate_metadata$incumbent)
kuchi_candidate_metadata$prelim_winner <- as.character(kuchi_candidate_metadata$prelim_winner)
kuchi_candidate_metadata$final_winner <- as.character(kuchi_candidate_metadata$final_winner)

kuchi_candidate_metadata <- kuchi_candidate_metadata %>% 
  rename(candidate_code = candidate_id) %>%
  mutate(province_code = "35") %>%
  dplyr::select(electorate, province_code, candidate_code, ballot_position, candidate_name_eng, incumbent, candidate_gender, prelim_winner, final_winner)

combined <- full_join(all_candidate_vote_metadata, kuchi_candidate_metadata)
write.csv(combined, "./data/keyfiles/candidate_key_2010.csv", row.names = F)

# get candidate names in Dari from IEC ---------------------------------------------

province_numbers <- 1:34
results_urls <- paste0("http://www.iec.org.af/results_10/eng/BOResults.html?ballotprID=", province_numbers)

race_data_list <- list()

# settings for silent background browsing
eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))

selServ <- selenium(verbose = F)

driver <- rsDriver(browser="chrome", port = 4444L, chromever="73.0.3683.68", verbose = FALSE)#, extraCapabilities = eCaps)
  
driver$client$navigate(results_urls[1])
  
province_list <- xml2::read_html(driver$client$getPageSource()[[1]]) %>%
    rvest::html_nodes("#provinceid") %>%
    rvest::html_children() %>%
    rvest::html_text() %>%
    dplyr::data_frame(province = .)          
  
    province_list <- province_list %>%
    dplyr::mutate(list_position = 1:length(province_list$province),
                  x = stringr::str_c("#provinceid > option:nth-child(", list_position, ")")
                  )
    
    province_list <- province_list[-c(1:2), ]
    
    for(j in (1:length(province_list$x))){
    province_target <- as.character(province_list[j, 3])
    element <- driver$client$findElement(using = 'css selector', province_target)
    element$clickElement()
    Sys.sleep(1.5)
    
    page_source <- driver$client$getPageSource()
    
    page_html <- page_source[[1]] %>% read_html()
  
    race_data_list_item <- page_html %>% html_nodes("tr") %>% html_text()

    race_data_list <- c(race_data_list, list(race_data_list_item))
    Sys.sleep(1.5)
    }

driver$client$close()
driver$server$stop()

for(i in (1:length(race_data_list))){ 

  race_data <- strsplit(race_data_list[[i]], "\n") %>% unlist() %>% .[!trimws(.) == ""]
  candidate_start <- as.numeric(grep("Ballot NoCandidate", race_data)[3])
  candidate_end <- as.numeric(grep("Archive", race_data)[1])
  race_data_trimmed <- race_data[-c(1:candidate_start, (candidate_end-1):length(race_data))]
  
  for(j in 1:length(race_data_trimmed)){
    candidate_data <- gsub(",", "", race_data_trimmed[j])
    # find and remove hidden no-break space symbol
    candidate_data <- gsub("[$,\xc2\xa0]", " ", candidate_data)
    ballot_position <- as.numeric(str_split(candidate_data, " ")[[1]][1])
    votes <- as.numeric(str_split(candidate_data, " ")[[1]][length(str_split(candidate_data, " ")[[1]])])
    candidate_name_dari <- as.character(trimws(gsub("[[:digit:]]+", "", candidate_data)))
    
    candidate_row <- cbind(ballot_position, candidate_name_dari, votes) %>% data.frame()
    colnames(candidate_row) <- c("ballot_position", "candidate_name_dari", "votes")
    
    if(j == 1) {
      candidates <- candidate_row
    } else {
      candidates <- rbind(candidate_row, candidates)
    }
    
    }
  
  candidates$province_code = i
  
  if(i == 1) {
    out <- candidates
  } else {
    out <- rbind(out, candidates)
  }
}

out$ballot_position <- as.numeric(as.character(out$ballot_position))
out$candidate_name_dari <- as.character(out$candidate_name_dari)
out$votes <- as.numeric(as.character(out$votes))
out$province_code <- as.character(out$province_code)

dari_candidate_names <- out %>% dplyr::select(province_code, ballot_position, candidate_name_dari, votes) %>% arrange(province_code, ballot_position)

candidate_key <- read.csv("./data/keyfiles/candidate_key_2010.csv", stringsAsFactors = F)
candidate_key$province_code <- as.character(candidate_key$province_code)

candidate_key_with_dari <- left_join(candidate_key, dplyr::select(dari_candidate_names, province_code, ballot_position, candidate_name_dari))
missing_dari_names <- filter(candidate_key_with_dari, is.na(candidate_name_dari))
# write.csv(missing_dari_names, "./raw/missing_dari_names.csv", row.names = F)
# found_dari_names <- read.csv("./raw/found_dari_names.csv", stringsAsFactors = F)
# found_dari_names$province_code <- as.character(found_dari_names$province_code)

dari_names_split <- unlist(dari_names) %>% str_split("\n") %>% data.frame()
colnames(dari_names_split) <- "candidate_name_dari"
dari_names_split$candidate_name_dari <- trimws(as.character(dari_names_split$candidate_name_dari))

missing_dari_names_with_names <- missing_dari_names %>% dplyr::select(-candidate_name_dari)
missing_dari_names_with_names <- cbind(missing_dari_names_with_names, dari_names_split)

all_candidate_dari_names <- filter(candidate_key_with_dari, !is.na(candidate_name_dari)) %>% full_join(missing_dari_names_with_names) %>% 
  dplyr::select(electorate, province_code, candidate_code, 
                ballot_position, candidate_name_eng, candidate_name_dari,
                incumbent, candidate_gender, prelim_winner, final_winner)

all_candidate_dari_names$candidate_name_eng <- trimws(all_candidate_dari_names$candidate_name_eng)
all_candidate_dari_names$province_code <- as.character(str_pad(all_candidate_dari_names$province_code, 2, pad = "0", side = "left"))

all_candidate_dari_names <- all_candidate_dari_names %>% arrange(electorate, province_code, ballot_position)

# get party affiliations from IEC / DI candidate lists --------------------
# also get Kuchi and Saranwal Bakshi prelim / final winner status and incumbency if possible


# combined and write final candidate data csv

#-----------------------------------------------------------------------------------
# PRELIM RESULTS -------------------------------------------------------------------
rm(list = ls())
candidate_key <- read.csv("./data/keyfiles/candidate_key_2010.csv", stringsAsFactors = F)
candidate_key$province_code <- as.character(str_pad(candidate_key$province_code, 2, pad = "0", side = "left"))

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

wj_2010_prelim <- dplyr::select(wj_2010_prelim, electorate, province_code, province_name_eng, district_id, district_name_eng, pc_code, ps_number, ps_station_type,
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

wj_2010_prelim <- dplyr::select(wj_2010_prelim, results_status, results_date, electorate, province_code, province_name_eng, 
                        district_code, district_number, district_name_eng,
                        pc_code, pc_number,
                        ps_code, ps_number, ps_station_type, invalidated,
                        candidate_id, voter_id, ballot_position, candidate_party_id, candidate_gender, votes, votes_invalidated) %>%
  arrange(province_code, pc_code, ps_code, ballot_position)

# NOTE: AED ascribes the wrong candidate codes to Kuchi candidates in the results data, 
# have to use ballot position identifiers instead and replace with corrected

kuchi_metadata <- candidate_key %>% filter(electorate == "Kuchi") %>% dplyr::select(-province_code, -candidate_gender)
kuchi_votes <- wj_2010_prelim %>% filter(electorate == "Kuchi") %>% dplyr::select(-candidate_id, -voter_id)
kuchi_votes <- left_join(kuchi_votes, kuchi_metadata)
kuchi_votes$candidate_code <- as.character(kuchi_votes$candidate_code)

general_metadata <- candidate_key %>% filter(electorate == "General") %>% dplyr::select(-province_code, -candidate_gender)
general_metadata$candidate_code <- as.character(general_metadata$candidate_code)

wj_2010_prelim_with_metadata <- wj_2010_prelim %>% filter(electorate == "General") %>%
  mutate(candidate_code = ifelse(candidate_id == voter_id, as.character(candidate_id), as.character(voter_id))) 

# correct for duplicate candidate code 5794702 / 579470200
wj_2010_prelim_with_metadata$candidate_code[wj_2010_prelim_with_metadata$ballot_position == 13] <- gsub("5794702", "579470200", wj_2010_prelim_with_metadata$candidate_code[wj_2010_prelim_with_metadata$ballot_position == 13])

wj_2010_prelim_with_metadata <- wj_2010_prelim_with_metadata %>% left_join(general_metadata) %>% full_join(kuchi_votes)

wj_2010_prelim_with_metadata <- wj_2010_prelim_with_metadata %>% arrange(electorate, province_code, ps_code, ballot_position)
wj_2010_prelim_with_metadata <- wj_2010_prelim_with_metadata %>% rename(
  ps_type = ps_station_type
)


# NEED TO DECIPHER WHAT INVALIDATED VOTES MEANS HERE

# ADD PC NAME / KEYFILE DATA

# ADD ZERO VOTE COUNTS FOR PS THAT LEFT THOSE BLANK - CONFIRM NO PS DID PARTIAL 0 / BLANKS

wj_prelim_results_data <- wj_2010_prelim_with_metadata %>% dplyr::select(
  results_date, results_status, electorate, province_code, province_name_eng, 
  district_code, district_number, district_name_eng,
  pc_code, pc_number, 
  ps_code, ps_number, ps_type,
  candidate_code, ballot_position, candidate_name_eng, 
  candidate_party_id, incumbent, prelim_winner, final_winner,
  votes #, votes_invalidated, invalidated ??
)

# write csvs

write.csv(wj_2010_prelim_with_metadata, "./data/prelim_af_candidate_ps_data_2010.csv", row.names = F)

wj_2010_prelim_lite <- select(wj_2010_prelim, ps_code, candidate_code, votes, votes_invalidated) # ??
  
write.csv(wj_2010_final_lite, "prelim_af_candidate_ps_data_2010_lite.csv", row.names = F)

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

# ----------------------------------------------------------------------------------
# COMBINE FINAL AND PRELIM RESULTS -------------------------------------------------

# ----------------------------------------------------------------------------------
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

# pc key
# province key and 2018 rosetta
# district key and 2018 rosetta
# candidate key
# summary province pc-ps-candidate-votes table


