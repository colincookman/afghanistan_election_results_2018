library(XML)
library(pdftools)
library(readr)
library(tidyverse)
library(stringr)
library(ggrepel)
library(gsheet)
setwd("~/Google Drive/GitHub/afghanistan_2005_scrape")
ifelse(!dir.exists(file.path("./raw")), dir.create(file.path("./raw")), FALSE)


# ----------------------------------------------------------------------------------
# scrape the files

url <- "http://d8680609.u106.forthost.com/reports.asp"

links <- getHTMLLinks(url)
links_data <- links[str_detect(links, "wj_bo_e.pdf")]
links_data <- paste0("http://d8680609.u106.forthost.com/", links_data)

for(i in seq_along(links_data)) {
  download.file(links_data[i], file.path("./raw/", destfile = basename(links_data[i])))
  Sys.sleep(1)
}

# ----------------------------------------------------------------------------------
# process the downloaded pdfs

file_list <- list.files("./raw/")

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
  data$province_name <- str_to_upper(province_name)
  
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

winners_link <- paste0("http://d8680609.u106.forthost.com/", links[11])
download.file(winners_link, file.path("./raw/", destfile = basename(winners_link)))
file_list <- list.files("./raw/")

target <- paste0("./raw/", file_list[36])
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
  certified_winner = "YES"
)

wj_2005 <-  left_join(wj_2005, winners, by = "candidate_code")
wj_2005$certified_winner[is.na(wj_2005$certified_winner)] <- "NO"


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

candidate_data <- candidate_data %>% select(
  province_code, province_name, candidate_code, candidate_name_eng, ballot_position, votes, vote_share, candidate_rank, certified_winner, total_votes_prov
)

candidate_data <- arrange(candidate_data, province_code, candidate_rank)
write.csv(candidate_data, "wj_2005_final_results.csv", row.names = F)

# ----------------------------------------------------------------------------------
# more calculations

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
