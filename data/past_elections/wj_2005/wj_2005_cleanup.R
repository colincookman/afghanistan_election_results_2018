library(XML)
library(pdftools)
library(readr)
library(tidyverse)
library(lubridate)
library(stringr)
library(ggrepel)
library(gsheet)

# ----------------------------------------------------------------------------------
# scrape the files
rm(list = ls())
url <- "http://d8680609.u106.forthost.com/reports.asp"

links <- getHTMLLinks(url)
links_data <- links[str_detect(links, "wj_bo_e.pdf")]
links_data <- paste0("http://d8680609.u106.forthost.com/", links_data)

for(i in seq_along(links_data)) {
  download.file(links_data[i], file.path("./raw/", destfile = basename(links_data[i])))
  Sys.sleep(1)
}

winners <- paste0("http://d8680609.u106.forthost.com/", links[11])
download.file(winners, file.path("./raw/", destfile = basename(winners)))

# ----------------------------------------------------------------------------------
# process the downloaded pdfs
rm(list = ls())
file_list <- list.files("./raw/", pattern = "certified_")

for(i in 1:length(file_list)) {
  
  # import files on list and convert to text lines
  target <- paste0("./raw/", file_list[i])
  province_import <- pdf_text(target)
  pdf_text <- toString(province_import)
  pdf_text <- read_lines(pdf_text)
  
  header_start <- grep("Afghanistan 2005 Elections", pdf_text) 
  header_end <- grep("Percentage of Votes", pdf_text)
  headers <- list()
  for(j in 1:length(header_start)){
    distance <- header_start[j]:header_end[j]
    headers <- c(headers, distance)
  }
  headers <- unlist(headers)
  footer_row <- grep("Page ", pdf_text)
  trailer_start <- grep("This list contains unofficial transliteration to Latin of candidate names.", pdf_text)
  trailer_end <- grep("endorsed by the individuals", pdf_text)
  #
  # pull out province for loaded district
  province_code <- str_split(target, "_")[[1]][2]
  province_name <- str_split(target, "_")[[1]][3]
  #
  # remove headers and footers from document
  pdf_text <- pdf_text[- c(headers, footer_row, trailer_start, trailer_end)]
  
  data <- Reduce(rbind, strsplit(trimws(pdf_text), "\\s{2,}"))
  # add a rownumber to first row
  rownames(data) <- 1:dim(data)[1]
  
  data <- as.data.frame(data)
  colnames(data) <- c("ballot_position", "candidate_name_eng", "candidate_code", "votes", "vote_share")
  data$province_code <- province_code
  data$province_name_eng <- str_to_upper(province_name)
  
  if(i == 1) {
    all_out <- data
  }else{
    all_out <- rbind(all_out, data)
  }

}

# ----------------------------------------------------------------------------------
# clean up the pdf data 

wj_2005 <- all_out

wj_2005$ballot_position <- as.numeric(as.character(wj_2005$ballot_position))
wj_2005$candidate_name_eng <- as.character(wj_2005$candidate_name_eng)
wj_2005$votes <- as.numeric(as.character(gsub(",", "", wj_2005$votes)))
wj_2005$vote_share <- as.character(gsub("\\.", "", wj_2005$vote_share))
wj_2005$vote_share <- (as.numeric(as.character(gsub("\\%", "", wj_2005$vote_share))))/10000 # ERROR??
wj_2005$candidate_code <- as.character(wj_2005$candidate_code)

# ----------------------------------------------------------------------------------
# designate the winning candidates

target <- paste0("./raw/", "wolesi_jirga_wc_e.pdf")
winners_import <- pdf_text(target)
pdf_text <- toString(winners_import)
pdf_text <- read_lines(pdf_text)

header_start <- grep("Afghanistan 2005 Elections", pdf_text)
header_end <- grep("Candidate ID", pdf_text)
headers <- list()
for(j in 1:length(header_start)){
  distance <- header_start[j]:header_end[j]
  headers <- c(headers, distance)
}
headers <- unlist(headers)
footer_row <- grep("Page ", pdf_text)
trailer_start <- grep("This list contains unofficial transliteration to Latin of candidate names.", pdf_text)
trailer_end <- grep("endorsed by the individuals", pdf_text)

pdf_text <- pdf_text[- c(headers, footer_row, trailer_start, trailer_end)]

data <- Reduce(rbind, strsplit(trimws(pdf_text), "\\s{2,}"))
rownames(data) <- 1:dim(data)[1]
data <- as.data.frame(data)
colnames(data) <- c("province", "ballot_position", "candidate_name_eng", "candidate_code")

winners <- data
winners <- winners %>% select(candidate_code) %>% mutate(
  final_winner = "YES"
)

wj_2005 <-  left_join(wj_2005, winners, by = "candidate_code")
wj_2005$final_winner[is.na(wj_2005$final_winner)] <- "NO"


province_data <- wj_2005 %>% group_by(province_code) %>% summarize(
  total_votes_prov = sum(votes, na.rm = TRUE)
)

candidate_data <- left_join(wj_2005, province_data)

candidate_data <- candidate_data %>% mutate(
  vote_share = votes / total_votes_prov
)

candidate_data <- candidate_data %>% group_by(province_code) %>% mutate(
  candidate_rank = dense_rank(desc(votes))
)

# ----------------------------------------------------------------------------------
# reorganize and export

candidate_data$electorate <- ifelse(candidate_data$province_name_eng == "KUCHI", "Kuchi", "General")
candidate_data$province_code[candidate_data$electorate == "Kuchi"] <- "35"
candidate_data$results_status <- "FINAL"
candidate_data$results_date <- mdy("11-08-2005")

candidate_data <- candidate_data %>% select(
  results_status, results_date, electorate, province_code, province_name_eng, 
  candidate_code, candidate_name_eng, ballot_position, votes, final_winner
)

candidate_data <- arrange(candidate_data, province_code, ballot_position)

write.csv(candidate_data, "final_af_candidate_province_data_2005.csv", row.names = F)

# correct to add a constituency code

wj_2005 <- read.csv("./data/past_elections/wj_2005/final_af_candidate_province_data_2005.csv", stringsAsFactors = F)
wj_2005$province_code <- as.character(str_pad(wj_2005$province_code, 2, pad = "0", side = "left"))

wj_2005 <- wj_2005 %>% mutate(
  constituency_code = ifelse(electorate == "General", paste0("G-", province_code), "K-01")
) %>% dplyr::select(-province_code)

write.csv(wj_2005, "./data/past_elections/wj_2005/final_af_candidate_province_data_2005.csv", row.names = F)

# ----------------------------------------------------------------------------------
# optional more calculations

seats_per_prov <- as.data.frame(c(1:34, 95))
colnames(seats_per_prov) <- "province_code"
seats_per_prov$province_code <- as.character(str_pad(seats_per_prov$province_code, 2, pad = "0", side = "left"))
seats_per_prov$general_seats <-  c(24, 3, 4, 3, 3, 10, 3, 1, 8, 3, 8, 3, 5, 4, 3, 1, 7, 7, 7, 3, 8, 4, 4, 3, 2, 2, 8, 4, 6, 6, 3, 12, 4, 1, 7)
seats_per_prov$female_seats <-   c(9, 1, 2, 2, 1, 4, 1, 1, 2, 1, 3, 1, 1, 1, 1, 1, 2, 2, 2, 1, 3, 1, 2, 1, 1, 1, 3, 1, 3, 2, 1, 5, 1, 1, 3)

candidate_data <- left_join(candidate_data, seats_per_prov)

candidate_data <- candidate_data %>% 
  group_by(province_code) %>%
  select(everything()) %>%
  arrange(province_code, desc(candidate_rank)) %>%
  mutate(
    rank_MOV = votes - (dplyr::lag(votes, n = 1, default = NA)),
    rank_MOV_pct = rank_MOV / total_votes_prov,
    first_runner_up = ifelse((candidate_rank == general_seats + 1), "YES", "NO"),
    threshold_MOV = votes - (votes[candidate_rank == general_seats]),
    threshold_MOV_pct = threshold_MOV / total_votes_prov
  )
