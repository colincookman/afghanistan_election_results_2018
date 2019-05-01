# Results for Afghanistan 2018 Parliamentary Elections

This repository hosts election results data for the 2018 Afghan parliamentary elections for the Wolesi Jirga (the lower house of parliament), as reported by the [Independent Election Commission of Afghanistan (IEC)](http://www.iec.org.af/). 

The primary output, collecting in tidy format for all candidate results reported across all polling stations for which the IEC released data, can be found in the files **[prelim_af_candidate_ps_data_2018.csv](https://drive.google.com/open?id=1Oqzv-O671w7jwEiWWlMVV7QMtQmRGVNS)** and  **[final_af_candidate_ps_data_2018.csv](https://drive.google.com/open?id=1b7Flah6nrRsJaL3jaibz0h6QWh5yPCoN)**, comprising preliminary results and final certified results, respectively. These files are too large for Github (approximately 975 MB apiece) and are hosted remotely on Google Drive. 

A "lightweight" version of the [preliminary](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_ps_data_2018_lite.csv) and [final](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/final_results/final_af_candidate_ps_data_2018_lite.csv) results data (approximately 94 MB each), which includes only the polling station ID, candidate ID, and vote variables, is also available. Accompanying [keyfiles](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/keyfiles) can be joined to expand the lightweight dataframe as needed.

This data is being released open to the public for the purposes of contributing to public understanding of the elections and to allow for the analysis of available IEC reporting. Please read all accompanying documentation and link, cite, and credit as appropriate.

## Summary of files
Each row in the primary dataset represents a candidate's vote total for each polling station. This data has also been re-aggregated into **polling center** ([prelim](https://drive.google.com/open?id=1pIYYZSmnj8Gkx4d_bEI-SR_BJZt5r24U) / [final]())- (both remote hosted due to size, or see lightweight versions - [prelim](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_pc_data_lite.csv) / [final](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/final_results/final_af_candidate_pc_data_lite.csv)), **district** ([prelim](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_district_data.csv) / [final](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/final_results/final_af_candidate_district_data.csv))-, and **provincial** ([prelim](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_province_data.csv) / [final](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/final_results/final_af_candidate_province_data.csv))-level summaries. Each dataset reports a separate vote total row for each contesting candidate, and includes zero counts, but may not include data (such as polling centers or candidates) in cases where the IEC did not report any results at all. (See section on [caveats and gaps](https://github.com/colincookman/afghanistan_election_results_2018#caveats-gaps-and-errors) below for validity checks and investigation of possible gaps in the data.)

For some keyfiles, see:

- **[all_pc_ps_candidate_vote_counts.csv]()** for a summary count by province of reported polling centers, polling stations, candidates and votes in the preliminary and final results;
- **[candidate_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/candidate_key.csv)** for a list of all candidates for which the IEC reported results, grouped by electorate, with unique ID codes, names in English, Dari, and Pashto, and IEC-designated preliminary and final winner status, as well as official party affiliation, gender, and incumbency status;
- **[ps_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/ps_key.csv)** for a list of all unique polling station codes, polling center codes, district codes, and province codes;
- **[pc_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/pc_key.csv)** for a list of all planned polling centers, polling station counts, reporting status in the preliminary and final results, and voter registration data (see [note on sourcing](https://github.com/colincookman/afghanistan_election_results_2018#polling-center-plans-and-voter-registration-data));
- **[district_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/district_key.csv)** for a list of all unique districts as reported by the IEC (as well as the 21 subdivisions of Kabul); see also [district_code_keyfile](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/district_data/district_code_keyfile.csv) for a key used to track district codes (which are not consistently sequenced) across election cycles and datasets, drawing on the work of the [Afghanistan District Maps project](https://mapsynch.maps.arcgis.com/apps/MapSeries/index.html?appid=fe0f16a7b8da4157a7d7f9451a802d74#);
- **[province_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/province_key.csv)** for a list of provinces and constituencies, their codes, names in English, Dari, and Pashto, and number of general / female reserved seats per constituency.

For a brief explanation of some of the main variables used, please see [this codebook](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/CODEBOOK.md).

## Summary of results data
Although there is *substantial* inter- and intra-provincial variation within the dataset, some national-level summary statistics from the available results data:

- **Total number of candidates reporting results:** 2543
- **Total votes recorded in preliminary results:** 3659470
- **Total votes recorded for winning candidates:** 1302057 (35.58% of total)
- **Total voters registered at polling centers planned to open:** 8778577
- **Total votes recorded in preliminary results as a percentage of total voter registration (aka "turnout"):** 41.69%
- **Number of polling centers planned to open:** 5106
- **Number of planned polling centers not reporting votes:** 467 (9.14%)
- **Voter registration for polling centers not reporting, as a share of total voter registration:** 6.72%
- **Mean winning candidate's share of votes recorded for their constituency:** 5.32%
- **Median winning candidate's share of votes recorded for their constituency:** 4.11%
- **Mean share of votes recorded for all candidates in their respective constituencies:** 1.33%
- **Median share of votes recorded for all candidates in their respective constituencies:** 0.41%
- **Difference between mean first runner-up vote total and threshold required for a general election seat:** 562 votes
- **Difference between median first runner-up vote total and threshold required for a general election seat:** 191 votes
- **Difference between mean candidate vote total and threshhold required for a general election seat:** 3095 votes
- **Difference between median candidate vote total and threshhold required for a general election seat:** 3236 votes

Some initial visualizations and analysis of the available data can be found in the [graphics subfolder](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/graphics).

## Background to the election
The Wolesi Jirga's five-year term in office last expired in June 2015, but members' terms in office were [extended indefinitely](https://www.nytimes.com/2015/06/20/world/asia/afghan-parliaments-term-is-extended-after-squabbles-delay-elections.html) amidst [ongoing negotiations within the Afghan government](http://muse.jhu.edu/article/702129) over changes to election administration and other broader electoral reform debates. After multiple delays, the elections were ultimately held  on October 20 2018 in 33 provinces and for the  Kuchi (nomadic peoples) and Hindu / Sikh minority constituencies (for which there was [only one candidate](https://www.bbc.com/news/av/world-asia-45886493/afghanistan-elections-i-want-to-fulfil-my-slain-father-s-dreams)). (Kuchi and Sikh voters used the same polling center locations as other general voters but cast separate ballots for their respective nationwide constituencies.) 

Following the [assassination](https://www.nytimes.com/2018/10/18/world/asia/kandahar-afghanistan-attack.html) of Kandahar provincial police chief Abdul Raziq two days prior to election day, voting was delayed in that province and held a week later, on October 27 2018. Elections for Ghazni province - whose electoral results were the subject of a [monthslong political standoff following the 2010 elections](https://foreignpolicy.com/2010/12/02/ghaznis-election-drama-its-the-system/) - remain indefinitely postponed, and as of current writing are planned to be held during the [next round of national elections](http://www.iec.org.af/pdf/timeline-1397.pdf) for the presidency in September 2019.

Afghan parliamentary elections are held under the [Single Non-Transferrable Vote system](https://areu.org.af/archives/publication/1211), in which each province (and the Kuchi and Hindu/Sikh groups) serves as single constituency electing multiple members. ([Electoral reform debates](https://www.afghanistan-analysts.org/afghanistans-incomplete-new-electoral-law-changes-and-controversies/) over the preceding years have included proposals for the creation of single member districts, or some form of proportional representation, but these changes were not adopted.) A set quota of female winners per province is also guaranteed under law. For more background, see the [Electoral Law](http://www.iec.org.af/pdf/legalframework/law/electorallaw_eng.pdf) or summaries by the [International Foundation for Electoral Systems](https://www.ifes.org/sites/default/files/2018_ifes_afghanistan_parliamentary_elections_faqs_final.pdf) or the [Afghan Analysts Network](https://www.afghanistan-analysts.org/afghanistan-election-conundrum-16-basic-facts-about-the-parliamentary-elections/), among other resources.

The 2018 parliamentary elections are Afghanistan's first to link voter registration to a specific polling center. At the demand of some opposition political parties, the IEC agreed to introduce a [biometric voter verification process](https://www.afghanistan-analysts.org/afghanistan-elections-conundrum-21-biometric-testing-likely-to-spawn-host-of-new-problems/) at polling centers prior to voters casting their ballots, although reports indicate widespread technical and procedural problems with implementation of this system. The IEC and ECC ultimately appear to have [adopted a procedure](http://www.iec.org.af/media-section/press-releases/1401-press-20181030-en) that would still accept votes cast in the absence of biometric verification in most cases.

Preliminary election results were initially scheduled to be finalized by early November 2018, with final certification due in December 2018, but the tabulation process was repeatedly delayed. After collecting polling station forms and ballot boxes centrally in Kabul, the IEC began publicly releasing preliminary results in tranches starting on November 23 2018, and completed the preliminary reporting process on January 15 2019. The publication of results for Kabul, which elects the largest delegation to parliament, were repeatedly delayed and the last batch to be announced. The Electoral Complaints Commission, a separate body tasked with adjudicating complaints, initially [invalidated all results for Kabul province](https://www.reuters.com/article/us-afghanistan-election/afghan-election-complaint-body-says-vote-in-capital-kabul-invalid-idUSKBN1O50WU?feedType=RSS&feedName=worldNews) on December 6 2018, but later reversed its action and subsequently cooperated with the IEC in reviewing the remainder of the preliminary results. 

Beginning January 20 2019, shortly after the completion of the publication of the preliminary results, the IEC began releasing final certified results data for provinces in tranches. On February 13 2019, President Ashraf Ghani issued an executive order [modifying Afghanistan's electoral law and firing all members of the IEC and ECC commissions](https://www.afghanistan-analysts.org/afghanistans-2019-elections-3-new-electoral-commissioners-amendments-to-the-electoral-law/), in part in response to allegations of fraud and mismanagement of the parliamentary elections and in anticipation of presidential elections scheduled to take place in July (which were subsequently postponed until September). The IEC secretariat [halted the certification of the final results](https://www.tolonews.com/index.php/elections-2019/probe-iec-iecc-claims-considered-%E2%80%98critical%E2%80%99-ago) for the remaining 17 out of 35 constituencies until a new commission was sworn in. Commission members were elected in a vote by the already registered presidential candidates on March 1 2019, chosen by the president, and [sworn in](https://www.tolonews.com/afghanistan/new-election-commissioners-sworn) on March 4 2019.

The remaining provincial results were subsequently released in further tranches. On April 26 2019, approximately six months after the elections were held, President Ghani [inaugurated the opening of the new parliamentary session](https://www.khaama.com/newly-elected-afghan-parliament-inaugurated-after-last-years-troubled-election-03809/), with results for Kabul (which elects the largest provincial delegation to parliament) and Paktia provinces still uncertified at the time. Paktia results were announced the following week, but on April 28 2019 the Electoral Complaints Commission released a statement saying it was [preparing to invalidate the recounting and certification process for Kabul](https://www.tolonews.com/elections-2019/iecc-rejects-results-kabul%E2%80%99s-recounted-votes), leaving the final status of its votes unclear.

## Primary sources for this dataset
All 2018 election results in this repository were drawn from the [IEC results website](http://www.iec.org.af/results/en/home) over the December 2018 - April 2019 period. Once cleaned up enough to be legible, the underlying R code used to scrape, clean, and reorganize all data will also be published in the near future to allow for replication of results.

### Candidate data
The IEC's pre-election candidate lists can be found [here](http://www.iec.org.af/cn-list-2018). The IEC also published lists of [disqualified candidates](http://www.iec.org.af/cn-disqualified-2018). (Both sets are mirrored in the repository [here](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/raw/candidate_lists).) However, checking these lists against results data and other sources reporting on disqualifications found that most if not all of the candidates appearing on the IEC's pre-election "disqualified" lists were in fact eligible to, and did, contest the elections. For a correct list of candidate disqualifications, see this [Afghan Analysts Network report](https://www.afghanistan-analysts.org/afghanistan-election-conundrum-15-a-contested-disqualification-of-candidates/), or the original Electoral Complaints Commission Dari-language disqualification announcement [here](http://iecc.gov.af/Content/files/Decisions/Decision%20-%20investigation%20complaints-objection.pdf).

Candidates were assigned ballot symbols, but these do not appear to have been shared across parties or provinces. Almost all candidates contested without a formal party affiliation. Candidates were assigned unique ID codes, which the IEC reported in its results data but not in any of the earlier pre-election candidate lists.

Through a data cleaning process of matching candidates by names, votes, and wherever available ID codes, a key file consolidating all available metadata (unique candidate code, name, gender, party affiliation, and win status) for eligible contesting candidates has been generated, and can be found **[here](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/candidate_key.csv)**. (See [caveats below](https://github.com/colincookman/afghanistan_election_results_2018#missing-candidate-data), however, about possible unobserved gaps in the available candidate data.)

### Polling center plans
For the IEC's pre-election plans for polling centers, see [this list](http://www.iec.org.af/pdf/pclist-2018/allpc1397-en.pdf) (or in Dari [here](http://www.iec.org.af/pdf/pclist-2018/allpc1397.pdf)), which was published September 27 2018.

The published pre-election polling center plan does not appear to have been final, as some polling centers reported results despite having been dropped from pre-election planning lists. The file **[prelim_pcs_reporting_not_planned.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/prelim_pcs_reporting_not_planned.csv)** highlights those polling centers (35, or 0.68% of 5106 planned) mentioned in the preliminary results but that had originally been dropped in the pre-election polling center plan document.

The file **[pc_plan_vr_2018.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/pc_plan_vr_2018.csv)** notes (in the column *pc_change_initial_final_plan*) polling centers that were either added to or dropped from the final pre-election plan when compared against an IEC polling center security assessment completed in January 2018, which was obtained from an election observer.

The author received a dataset of latitude / longitude coordinates for 7413 polling centers from an election observer (ommitting 38 centers from the known universe of centers, all of which were dropped in the pre-election plan, and did not report any results). Although polling centers are public sites, this location data was shared with the request that it not be published in raw format so as to avoid any potential security risk to the physical polling center locations. Accordingly, absent reporting of this information by another source, the raw coordinate data will not be included in this dataset. However, coordinate data was used to calculate nearest neighbor distances for the five closest polling centers for each respective center (in kilometers using the Vincenty ellipsoid formula, and in lat/lon decimal degrees), which can be found in the file **[pc_plan_nearest_neighbor_coordinates.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/pc_plan_nearest_neighbor_coordinates.csv)** and may be used for further geospatial analysis of results.

### Voter registration data
Public, provisional pre-election voter registration data by polling center can be found (in Dari only) [here](http://www.iec.org.af/fa/vrlist-bypc-1397-fa). The detailed voter registration data used for this project (which includes changes between preliminary voter registration and finalized registration after an IEC [voter list review process](https://ariananews.af/iec-drops-more-than-600000-registered-ids/) conducted in October) was also obtained from an election observer.

Voter registration data was missing for 2347 polling centers (31.6% of 7413 total reviewed), most of which were to have been dropped in the final plan. 78 planned polling centers (1.5% of 5106 planned) were also missing voter registration data in this source, and 9 polling centers (0.19% of 4674 polling centers reporting results) reported results despite the absence of voter registration data.

### Vote disqualification
The IEC initially released voter disqualification data in a machine readable format (viewable in Wayback reference [here](https://web.archive.org/web/20181130021502/http://www.iec.org.af/results/en/home/preliminaryresult_disqualified_by_pc)), but midway through the preliminary results reporting process removed this (very limited) data from its website and replaced it with a [collection of zipped files](http://www.iec.org.af/results/en/home/preliminaryresult_disqualified_by_pc) containing scans of polling stations where results had been invalidated. (As of initial publication, only zip files for 28 of the 36 provinces or nationwide constituencies have been released, despite the publication of all final results.) 

These files are also **[mirrored here](https://drive.google.com/open?id=1XyAUCgTYD95pZ_Q19hPqfSBxy-rEecQA)** but at this stage have not been processed into a machine-readable format for further analysis. As of this writing the ECC has not published its own detailed disqualification reporting.

For a summary of net changes between available preliminary and final results, see [FILE TBD](), although differences between the preliminary and final may also potentially be the result of data entry gaps and not necessarily disqualification decisions.

### Polling station results forms
As part of its preliminary results reporting, the IEC also released scanned images of most polling station results forms, which were downloaded as part of the data scrape process and may potentially be used as a visual check on the machine-readable results. Those images are too large to host in Github, but are **[mirrored here](https://drive.google.com/open?id=1XxZJnQZaxjva_Ki7QSEa7W9X70qyYESr)**. For a full list of files, see [ps_scan_file_list.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scan_file_list.csv).

Links to some scanned forms did not work in some cases; these observed file breaks are logged in the file [ps_scans_broken_links.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scans_broken_links.csv). Some polling centers also failed to include links to scanned forms. The file **[ps_scans_reporting_check.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scans_reporting_check.csv)** offers a province-level summary of the difference between polling stations reporting in the preliminary results and scanned forms missing from the IEC website. Notably, no polling station scans were available for Paktia province, either due to broken file links or otherwise missing links.

These lists may not be exhaustive, and full analysis of the scanned images has yet to be undertaken. As a note of caution, some preliminary comparisons suggest that in at least some cases the polling station scans are mislabeled on the IEC's website, and filenames or link titles may not correspond to the actual polling station scan.

### Historical election data
Historical data for the results of the [2010](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/past_elections/wj_2010) and [2005](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/past_elections/wj_2005) parliamentary elections, drawing in part on previous work by the [Afghanistan Election Data project](https://afghanistanelectiondata.org/open/data) (a project of the [National Democratic Institute](https://www.ndi.org/asia/afghanistan) and [Development Seed](https://developmentseed.org/)) and [Democracy International](https://web.archive.org/web/20110107115208/http://afghan2010.com/), is also included for reference in the past elections subfolder of this project.

These datasets have been restructured to allow for joining with the current available 2018 data (and cleaned to correct some errors related to candidate codes or the Kuchi electorate). The code used in this process is included for reference; however, some additional manual cleaning of old data was also undertaken that may not be fully reflected in this code, and caution in advised in running it through without careful checks on the process. (The raw final results file for the 2010 elections is too large to host on Github, but can be accessed directly via the Afghanistan Election Data project [here](https://afghanistanelectiondata.org/sites/default/files/wj_2010_final.zip).)

Full polling station ([preliminary](https://drive.google.com/open?id=1sjSuedaifvAcQQkHRLUhWqWoaeNrMi8Z) / [final](https://drive.google.com/open?id=1K-z751rQvdcu9UJ0mJLrMzHz8QFCrBN7)) and polling center ([preliminary](https://drive.google.com/open?id=1H73tdgJMxxSYY9Vc3I1Yg6YjCV-G62Uf) / [final](https://drive.google.com/open?id=1BBjig6n7UpK8lJSP6j3HM6qRYunJ9xlY))-level datasets for the 2010 preliminary and final results are too large to be hosted on Github, and are mirrored here; lightweight versions of the files are also included in their respective data subfolders. 

Polling center- or -station level results for the 2005 elections are currently unavailable. (If you have access to such information and would be willing to share, please get in touch.) Although the electoral system used for presidential elections is not directly comparable to the parliamentary SNTV system, additional data for the 2004, 2009, and 2014 Afghan presidential elections may be added to this dataset in the future to allow for further cross-election cycle analysis.

### Other data
For a parallel election results data collection effort, see the [Development Seed Afghan Elections Data project](https://github.com/developmentseed/af-elections-data) and the [Afghanistan Election Data project](https://afghanistanelectiondata.org/front).

For a comprehensive resource on Afghanistan's district administrative boundaries (which are a subject of periodic political disputes, and have not been officially standardized across datasets or official government documents), their relationship to one another, and changes over time, see [this resource by Map Sync](https://mapsynch.maps.arcgis.com/apps/MapSeries/index.html?appid=fe0f16a7b8da4157a7d7f9451a802d74#). 

The Map Sync project also collects district population data estimates drawn from Afghanistan Central Statistics Organization estimates for the 2018-19 Solar Year, published in June 2018; a 2016 'Landscan' estimate used by Resolute Support / US Forces-Afghanistan and the Special Inspector for Afghanistan Reconstruction; a 2017 population estimate by iMAPP; and a 2016-17 CSO / UN Office for the Coordination Humanitarian Affairs population estimate. This population data is mirrored here in the file **[district_population_data.csv](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/district_data/district_population_data.csv)**. 

Dstrict and provincial boundaries and codes *do not correspond* across the 2005, 2010, and 2018 election periods. There is also no consistent English transliteration standard for district, provincial, or individual candidate names across (and in some cases within) election periods. IEC district codes for the 2018 election appear to match the most recent CSO-published figures (both encompassing 421 districts), which should allow for data joins with election results and voter registration data. The [district_code_keyfile](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/district_data/district_code_keyfile.csv) can be used to make comparisons across election cycles, but will require further manipulation of results data to account for district splits. 

For mapping purposes, UN OCHA has published a set of shapefiles for district boundaries, which can be found on the [Humanitarian Data Exchange](https://data.humdata.org/dataset/afg-admin-boundaries) and is also included in the [district data subfolder](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/district_data/administrative_boundaries) of this project for reference; further transformations will be required to re-base 2018 districts or election results data to match these district boundaries, however. For an unofficial, ArcGIS-only version of the 421 districts used in the most recent CSO and IEC data, see [this Map Sync map](https://mapsynch.maps.arcgis.com/home/item.html?id=b660fd5ee9c744bfaebff04c8cf15aab).

## Caveats, gaps, and errors
This repository remains a work in progress and caution is advised when using it for analysis. The author cannot verify the accuracy of, or account for any discrepancies in, the underlying data, and makes no guarantees as to its completeness. The results collected at this point may be further altered by legal complaints and other disputes and adjudication processes.

Due to the very narrow margins of victory separating winners and runners-up under the SNTV system, disqualification decisions (or revisions during the results adjudication and final certification process) can have a significant determinative impact on electoral outcomes. Although more details may be released, there is currently very little transparent reporting on these decisions, despite the months-long process of counting, review, and reporting. As noted earlier, candidates and some observer groups have highlighted concerns over the fairness or accuracy of the results announced by the IEC, alleging manipulation to favor certain candidates, contributing to the removal of the IEC and ECC in mid-February before the final certification of all results. 

The author *cannot adjudicate or verify these charges* and is presenting this dataset ***solely*** for the purposes of contributing to public understanding of the elections and to allow for the analysis of available IEC reporting, *not* to validate or invalidate the available data or to make claims as to how that data may correspond to individual or collective voter actions in practice.

### Missing candidate data
Three candidates (in Parwan, Mohammadzadah Parsa (candidate code 3-1465-31); in Bamiyan, Mir Hussain Ibrahimi (10-1249-91), and Mohammad Hassan Ranjbar (10-1706-67)) were ommitted entirely from the initial preliminary results reporting, but were included in final results reporting data. (Their candidate metadata has been retroactively added to the master candidate key, but they do not appear in any of the preliminary results files, even as zero counts.) 

An investigation of available ballot number sequences and reported results found some further gaps in the IEC's reporting in both the preliminary and final results, which may potentially be indicative of additional missing candidate data not reported in either set of results. These ballot number sequence gaps are logged in the file **[missing_ballot_numbers_in_data.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/validity_checks/missing_ballot_numbers_in_data.csv)**. Because the IEC did not include ballot position or candidate code data on its pre-election list of candidates, these potentially missing candidates in the sequenced cannot be definitively ID'ed and matched to other metadata from the other IEC lists.

### Data entry errors
As of initial publication, the IEC's reporting on results for the Kuchi electorate produced some apparent data entry errors. In both preliminary and final results, reporting for Kuchi constituency votes at polling center 0903077 (Hazrat Ali Doshi High School in Dushi, Baghlan) included duplicate data from the votes received by general electorate candidates in the same polling center. (This also appears to have resulted in the erroneous inclusion of non-Kuchi candidates in the IEC's ["Results by Ballot Order" constituency-wide summary](http://www.iec.org.af/results/en/home/preliminaryresult_by_province/35/1) for the Kuchi constituency.) This duplicate non-Kuchi data has been removed from the dataset published here and the Kuchi results at that polling center retained.

Additionally, in both preliminary and final results, the polling center 3301007 (Boys High School in Farah city, Farah) reported data for general electorate candidates in the Kuchi results, but did not otherwise report Kuchi candidate results for that polling center. The duplicate general electorate candidate data has been removed from the dataset published here.

In [four cases in the preliminary results](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/validity_checks/prelim_iec_tabulation_check.csv), all for candidates in Farah province, the IEC's reported constituency-wide sums of votes did not match a calculation of the available polling station-level data, although this involved undercounts by the IEC of at maximum two votes, and was not determinative in altering candidate rank or winner status.

Caution is again advised that other less evident data entry errors may also be present in the dataset. While all efforts were taken to ensure a complete capture of the published IEC results data, doing so required processing through approximately ####### sub-pages of the results website, and some omissions may still be present in the data captured here.

### Polling centers that did not report results
The file **[prelim_pcs_planned_not_reporting.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/prelim_pcs_planned_not_reporting.csv)** lists polling centers (467, or 9.14% of 5106 planned) that were to have opened according to the IEC's September pre-election polling center plan but which did not report any results in the preliminary data, whether due to closure on election day, data entry gaps, or other reasons.

In districts where some polling centers reported results and others did not, the IEC initially (as of mid-December) generated blank results subpages for the polling centers that did not report results. As of the final data scrape (February-April 2019), however, those blank polling center pages appear to have been hidden on the IEC website and do not appear in the list of available polling centers under each parent district, requiring a check against the polling center plan to identify gaps.

### Other missing data
Polling stations (within each polling center) should in theory be designated for either male, female, or Kuchi or Sikh / Hindu voters (or in some cases, mixed stations). (In 2010, polling station classifications do not appear to have been fully enforced, with some votes for Kuchi candidates reported from general electorate-designated polling stations and vice versa). 

The IEC has not publicly released a list categorizing the 2018 polling stations, and unlike in 2010 did not publish a count of planned polling stations per polling center in advance of the elections that would allow for identification of reporting gaps within polling centers. (The [pc_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/pc_key.csv) includes a count of reporting polling stations per polling center, based on preliminary results.) Where available, scanned polling station forms do indicate their respective voter categories and may potentially be processed for this purpose. If you have access to a comprehensive list of polling station categorization in a machine-readable format and would be willing to share, please get in touch.

## Contact and acknowledgements
Feedback, corrections, or suggestions for further expansion or collaboration are greatly appreciated. For questions, suggestions, or to contribute further, please leave an issue request here on Github or contact [Colin Cookman](https://colincookman.wordpress.com/about/) by email or Twitter.

Although I alone am responsible for any errors in this project, I am grateful to Asma Ebadi and Lucy Stevenson-Yang for their research and coding assistance, to Scott Smith, Andrew Wilder, Scott Worden and many other colleagues at the U.S. Institute of Peace for their guidance, support, and mentorship.
