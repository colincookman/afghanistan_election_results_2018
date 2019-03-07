# Afghan Parliamentary Elections Codebook

This readme file summarizes the major variables used in files hosted in the **[Afghan 2018 Parliamentary Election Results repository](https://github.com/colincookman/afghanistan_election_results_2018)**.

For more details about this dataset, please see the [primary project readme file](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/README.md).

For questions, suggestions, or to contribute further, please leave an issue request here on Github or contact [Colin Cookman](https://colincookman.wordpress.com/about/) by email or Twitter.

## [prelim_af_candidate_ps_data_2018.csv](https://drive.google.com/open?id=1o5Pzj4PgQnoLtZVC5cyDs7og50KWySeW)
- **electorate:** Either general candidates (in which case the constituency is the province) or Kuchi or Sikh / Hindu candidates (in which case the constituency is nationwide).
- **province_code:** Two-digit IEC numeric code for province. Kuchi and Sikh candidate results are listed under the provinces in which votes were cast.
- **province_name_eng:** Province name in English, as provided by IEC. (Due to the lack of standardized transliteration, this almost certainly will not consistently match other datasets.)
- **province_name_dari:** Province name in Dari, as provided by IEC.
- **province_name_pashto:** Province name in Pashto, as provided by IEC.
- **district_code:** Four-digit numeric code for district; the first two digits of the code correspond with the parent province. Due to ommitted 0 prefixes for provinces 1-9, some datasets may require padding for accurate matches. Note: major urban centers such as provincial capitalse may be further subdivided into *nahia* administrative units, which share the same district code.
- **district_number:** Final two digits of the district_code, corresponding to a unique district. (Districts numbers are sequential within, but not across, provinces.)
- **pc_code:** Seven-digit numeric code for a unique polling center, the local site for voters to cast ballots. The first two digits correspond to province_code, second two digits to district_code, and final three digits to a unique pc number within a province. Due to ommitted 0 prefixes for provinces 1-9, some datasets may require padding for accurate matches.
- **pc_number:** Final three digits of the pc_code, corresponding to a unique polling center within a province. PC numbers are sequential within but not across provinces.
- **pc_name_eng:** English-language IEC name for the polling center.
- **ps_code:** Unique code for each polling station, concatenating pc_code and ps_number.
- **ps_number:** Polling stations are the booths within polling centers where ballots are cast; centers may have as few as one or as many as 21 stations each. Polling station numbers are sequential within but not across polling centers.
- **candidate_code:** IEC numeric code for each contesting candidate, as reported on the IEC website. In most but not all cases, the initial one or two-digit prefix corresponds with the province in which the candidate ran. Candidate codes were included in some but not all IEC data releases; exact matches were generated using candidate names (which appear to be consistent within the website data) and ballot positions.
- **candidate_id:** Remainder of the candidate_code, stripping the provincial prefix. ID numbers appear to be randomly assigned, without evident pattern or categorization.
- **ballot_position:** Position the candidate appears on their respective provincial ballots (not results position, which is not consistent across all IEC pages).
- **candidate_name_eng:** IEC transliteration of the candidate's name in English-language results data (appears to be consistent within the website data, but may not match other sources.)
- **candidate_name_dari:** Dari version of the candidate's name (matched by candidate_code).
- **candidate_name_pashto:** Pashto version of the candidate's name (matched by candidate_code).
- **votes:** Votes received by the candidate in a given polling station (or in other aggregrated files, by polling center, district, or province).
- **preliminary_winner:** Binary variable noting whether the candidate was designated a winner by the IEC in its announcement of the preliminary results. Note that due to women's quotas, female winners will not necessarily correspond to their rank position.
- **results_date:**	Regardless of the date of publication, the IEC dated all results to November 23 2018, the beginning of its reporting process. In actual practice, the reporting process concluded on January 15 2019. On initial release, this dataset is based on observations from a scrape of results data conducted between February 20 - 25 2019.
- **results_status:** For use in differentiating preliminary and final election results, once the latter is released. All data in the initial dataset release is uncertified preliminary data.

## [pc_plan_vr_2018.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/pc_plan_vr_2018.csv)
- **province_name:** Province name in English, as provided by IEC. (Due to the lack of standardized transliteration, this almost certainly will not consistently match other datasets.)
- **province_code:** Two-digit IEC numeric code for province. Kuchi and Sikh constituencies vote nationwide in local polling centers and do not appear separately in this dataset.
- **district_name:** District name in English, as provided by IEC. (Due to the lack of standardized transliteration, this almost certainly will not consistently match other datasets.)
- **district_code:** Four-digit numeric code for district; the first two digits of the code correspond with the parent province. Due to ommitted 0 prefixes for provinces 1-9, some datasets may require padding for accurate matches.
- **pc_code:** Seven-digit numeric code for a unique polling center, the local site for voters to cast ballots. The first two digits correspond to province_code, second two digits to district_code, and final three digits to a unique pc number within a province. Due to ommitted 0 prefixes for provinces 1-9, some datasets may require padding for accurate matches.
- **pc_name:** English-language IEC name for the polling center.
- **pc_location:** Additional English-language location identifier provided by the IEC for the polling center. Precise longitude and latitude coordinates were unavailable as of initial publication.
- **assessment_status:** IEC categories for the polling center based on a security assessment conducted in January 2018, obtained by an election observer.  Explanations of the coding was unavailable. (See [primary readme](https://github.com/colincookman/afghanistan_election_results_2018#polling-center-plans-and-voter-registration-data) for more.)
- **pc_change_initial_final_plan:**	Comparison of the IEC's final polling center plan, published in late September 2018, with the earlier January 2018 assessment. "Added" PCs were added in the interim period, "dropped" were assessed previously but not included in the final plan, and otherwise "no change".
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
- **vr_final_all_total** Final total voter registration for the polling center after registration review process.
