# Afghan Parliamentary Elections Codebook

This readme file summarizes the major variables used in files hosted in the **[Afghan 2018 Parliamentary Election Results repository](https://github.com/colincookman/afghanistan_election_results_2018)**.

For more details about this dataset, please see the [primary project readme file](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/README.md).

If you have questions about a variable definition or source, please feel free to contact the author. For additional questions, suggestions, or to contribute further, please leave an issue request here on Github or contact [Colin Cookman](https://colincookman.wordpress.com/about/) by email or Twitter.

## General Variables
- **results_date:**	Regardless of the date of publication, the IEC dated all preliminary results to November 23 2018, the beginning of its reporting process. (In actual practice, the preliminary results reporting process concluded on January 15 2019.) Final results reporting dates appear to accurately correspond with the date of release.
- **results_status:** For use in differentiating preliminary and final election results.
- **electorate:** Either general candidates (in which case the constituency is the province) or Kuchi or Sikh / Hindu candidates (in which case the constituency is nationwide).
- **constituency_code:** Unique codes for each constituency, grouping provincial candidates (general electorate) and nationwide Kuchi and Sikh candidates.

## Province and District Variables
- **province_code:** Two-digit IEC numeric code for province, reflecting the location where votes were cast (Kuchi and Sikh candidate results are listed under the location in the which votes were cast, but are aggregated into a single nationwide constituency by constituency_code). (Note: province codes do not correspond between election periods; see [district_code_keyfile.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/district_data/district_code_keyfile.csv) to join.)
- **province_name_eng:** Province name in English, as provided by IEC. (Due to the lack of standardized transliteration, this almost certainly will not consistently match other datasets.)
- **province_name_dari:** Province name in Dari, as provided by IEC.
- **province_name_pashto:** Province name in Pashto, as provided by IEC.
- **district_code:** Four-digit numeric code for district; the first two digits of the code correspond with the parent province. (Note: district codes do not correspond between election periods; see [district_code_keyfile.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/district_data/district_code_keyfile.csv) to join.)
- **district_number:** Final two digits of the district_code, corresponding to a unique district. (Districts numbers are sequential within, but not across, provinces.)
- **provincial_capital:** Binary variable for districts designated as provincial capitals. (District number one in all provinces.)
- **pop_18_19_421_CSO:** Afghan Central Statistics Organization population estimate for 2018-19 using 421 district boundaries, via [Map Sync](https://mapsynch.maps.arcgis.com/apps/MapSeries/index.html?appid=fe0f16a7b8da4157a7d7f9451a802d74) Afghanistan District Maps project.
- **pop_18_19_407_CSO:** CSO population estimate for 2018-19, regrouped to 407 districts, via Map Sync.
- **pop_18_19_399_CSO:** CSO population estimate for 2018-19, regrouped to 399 districts, via Map Sync. 
- **pop_16_17_414_CSO_OCHA:** Afghan Central Statistics Organization population estimate for 2016-17 using 414 district boundaries, via Map Sync.
- **pop_16_17_407_CSO_OCHA:** CSO population estimate for 2016-17, regrouped to 407 districts, via Map Sync.
- **pop_16_17_399_CSO_OCHA:** CSO population estimate for 2016-17, regrouped to 399 districts, via Map Sync.
- **pop_16_17_399_Landscan:** Landscan population estimate for 2016-17 for 407 districts, regrouped to 399 districts, via Map Sync.
- **pop_17_18_399_iMMAP_AGCHO:** iMMAP population estimated for 2017-18 for 399 districts, via Map_Sync.

## Polling Center and Polling Station Variables
- **pc_code:** Seven-digit numeric code for a unique polling center, the local site for voters to cast ballots. The first two digits correspond to province_code, second two digits to district_code, and final three digits to a unique pc number within a province. Due to ommitted 0 prefixes for provinces 1-9, some datasets may require padding for accurate matches.
- **pc_number:** Final three digits of the pc_code, corresponding to a unique polling center within a province. PC numbers are sequential within but not across provinces.
- **pc_name_eng:** English-language name for the polling center, as provided by IEC.
- **pc_location:** Additional English-language location identifier provided by the IEC for the polling center.
- **ps_code:** Unique code for each polling station, concatenating pc_code and ps_number.
- **ps_number:** Polling stations are the voting booths within polling centers where ballots are cast; centers may have as few as one or as many as 21 stations each. Polling station numbers are sequential within but not across polling centers.
- **prelim_ps_count:** Count of reporting polling stations per polling center in preliminary results. Because the IEC did not publish a pre-election directory of polling stations per polling center, there is no benchmark to check these counts against to confirm completeness of reporting.
- **final_ps_count:** Count of reporting polling stations per polling center in final results.
- **prelim_results_status:** Binary variable for whether the IEC reported results for the polling center in the preliminary results data.
- **final_results_status:** Binary variable for whether the IEC reported results for the polling center in the final results data.
- **assessment_status:** IEC categories for the polling center based on a security assessment conducted in January 2018, obtained by an election observer. (See [primary readme](https://github.com/colincookman/afghanistan_election_results_2018#polling-center-plans-and-voter-registration-data) for more.)
- **pc_change_initial_final_plan:**	Comparison of the IEC's final polling center plan, published in late September 2018, with the earlier January 2018 assessment. "Added" PCs were added in the interim period, "dropped" were assessed previously but not included in the final plan, and otherwise "no change".
- **planned_2018:** Binary variable for whether the polling center was planned to open prior to election day (i.e., all polling centers not categorized as 'dropped' in the January 2018 assessment).

## Voter registration variables
- **vr_prelim:** Preliminary total voter registration per polling station, as reported in an unpublished IEC dataset on voter registration obtained by an election observer. (See [primary readme](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/README.md) for more.)
- **vr_total_removed:**	Total voter registrations removed from the polling center rolls following an IEC voter registration review process conducted in early October 2018, as reported by IEC in voter registration dataset.
- **vr_removed_spoiled_IDs:**	Voter registrations removed for spoiled voter IDs, as reported by IEC in voter registration dataset.
- **vr_removed_no_tazkera:** Voter registrations removed for lack of a tazkera (ID card), as reported by IEC in voter registration dataset.
- **vr_removed_no_DOB:** Voter registrations removed for lack of date of birth, as reported by IEC in voter registration dataset.
- **vr_removed_closed_PC:**	Voter registrations removed as a result of the polling center being closed, as reported by IEC in voter registration dataset.
- **vr_removed_lost_book:**	Voter registrations removed as a result of "lost books", as reported by IEC in voter registration dataset.
- **vr_removed_duplicates:** Voter registrations removed as a result of duplicate voter registration, as reported by IEC in voter registration dataset.
- **vr_removed_underage:** Voter registrations removed as a result of the registered voter being under the age of franchise (18), as reported by IEC in voter registration dataset.
- **vr_general_total:**	Final total voter registration for the polling center after registration review process, excluding Kuchi and Sikh/Hindu voters.
- **vr_general_male:** Final total male voter registration for the polling center after registration review process, excluding Kuchi and Sikh/Hindu voters.
- **vr_general_fem:**	Final total female voter registration for the polling center after registration review process, excluding Kuchi and Sikh/Hindu voters.
- **vr_final_kuchi:**	Final total Kuchi voter registration for the polling center after registration review process.
- **vr_final_sikh:** 	Final total Sikh / Hindu voter registration for the polling center after registration review process.
- **vr_final_all_male:** Final total male voter registration for the polling center after registration review process.
- **vr_final_all_fem:**	Final total female voter registration for the polling center after registration review process.
- **vr_final_all_total:** Final total voter registration for the polling center after registration review process.

- **nn_1_pc_code:** Nearest neighboring polling center to the polling center, calculated using available latitude and longitude coordinates. (See [note on sourcing](https://github.com/colincookman/afghanistan_election_results_2018#geospatial-data).)
- **nn_1_distance_km:** Direct distance between polling center and its nearest neighbor in kilometers as calculated by the Vincenty ellipsoid formula. (An as-the-crow-flies distance that does not correspond with actual physical travel routes between points.)
- **nn_1_distance_degree:** Direct distance between polling center and its nearest neighbor in lat/lon decimal degrees.
- **nn_2_, nn_3_ etc:** Second, third, etc-nearest polling center to the polling center.


## Candidate Variables
- **candidate_code:** An IEC-generated numeric code for each contesting candidate, as reported on the IEC website. In most but not all cases, the initial one or two-digit prefix corresponds with the province in which the candidate ran. Candidate codes were included in some but not all IEC data releases; exact matches were generated using candidate names (which appear to be consistent within the website data) and ballot positions.
- **ballot_position:** Position the candidate appears on their respective provincial ballots (not results position, which is not consistent across all IEC pages), as assigned by the IEC.
- **candidate_name_eng:** IEC transliteration of the candidate's name in English-language results data (appears to be consistent within the website data, but may not match other sources.)
- **candidate_name_dari:** Dari version of the candidate's name (matched by candidate_code).
- **candidate_name_pashto:** Pashto version of the candidate's name (matched by candidate_code).
- **candidate_gender:** Male or female, based on a visual check of the candidate's photo in published IEC candidate lists.
- **party_name_dari:** Dari-language version of the candidate's official party registration, if any, drawn from published IEC candidate lists. Standardized to correct some inconstituencies in spelling.
- **party_eng_transliterated:** Unofficial Romanized transliteration of the party's Dari-language name.
- **party_eng_transated:** Unofficial English transliteration of the party's full name. Where available, derived from the Afghan Ministry of Justice's list of officially registered political parties ([Dari](http://moj.gov.af/fa/page/registered-political-parties-and-social-organizations/1700), [English](http://moj.gov.af/en/page/registered-political-parties-and-social-organizations/1700)).
- **registered_party_number:** Sequence position in MOJ's list of officially registered political parties, where available.
- **votes:** Votes received by the candidate in a given polling station (or in other aggregrated files, by polling center, district, or province).
- **winner**: Binary variable noting whether the candidate was designated a winner by the IEC in its announcement of the preliminary or final results. Note that due to women's quotas, female winners will not necessarily correspond to their rank position. (The candidate key also includes distinct preliminary_winner and final_winner variables.)
- **past_winner, prelim_winner_2010, final_winner_2010, final_winner_2005:** Binary variable for candidates who were previously designated as either preliminary or final winners in the 2010 parliamentary elections, or final winners in the 2005 parliamentary elections (no preliminary results data available). See also subfolders with [past election results](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/past_elections).
- **past_winners_matched_to_2010_codes:** Corresponding candidate code for candidates who were past winners (in either preliminary or final results) in 2010, matched to 2018 candidates by name, province, and in some cases candidate photos. Note that as of initiale publication non-winning 2010 candidates were not matched in this dataset, but some may have re-run in 2018.
- **past_winners_matched_to_2005_codes:** Corresponding candidate code for candidates who were past winners in 2005, matched to 2018 candidates by name, province, and in some cases candidate photos. Note that as of initiale publication non-winning 2005 candidates were not matched in this dataset, but some may have re-run in 2018.
