# Preliminary Results for Afghanistan 2018 Parliamentary Elections

This repository hosts preliminary election results data for the 2018 Afghan parliamentary elections for the Wolesi Jirga (the lower house of parliament), as reported by the [Independent Election Commission of Afghanistan (IEC)](http://www.iec.org.af/). 

The primary output, collecting in tidy format all candidate results reported across all polling stations for which the IEC has released data, can be found in the file **[prelim_af_candidate_ps_data_2018.csv](https://drive.google.com/open?id=1o5Pzj4PgQnoLtZVC5cyDs7og50KWySeW)**. This file is too large for Github (approximately 975 MB) and is hosted remotely on Google Drive. A "lightweight" version of the file (approximately 94 MB), which includes only the polling station ID, candidate ID, and vote variables, [is also available](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_ps_data_2018_lite.csv).

A separate file collecting final results certified by the IEC will be released once the IEC completes its process of publishing those results, but as of initial publication this repository is only hosting the preliminary results data.

This data is being released open to the public for the purposes of contributing to public understanding of the elections and to allow for the analysis of available IEC reporting. Please read all accompanying documentation and link, cite, or credit as appropriate.

## Summary of files
Each row in the primary dataset represents a candidate's vote total for each polling station. This data has also been re-aggregated into [polling center](https://drive.google.com/open?id=1ciHpGd23uUnNtEE6mZw_ssI49GssWkzN)- ([lightweight version](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_pc_data_lite.csv)), [district](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_district_data.csv)-, and [provincial](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/preliminary_results/prelim_af_candidate_province_data.csv)-level summaries (again, with a separate vote total row for each contesting candidate). 

For some keyfiles, see:

- **[prelim_pc_ps_candidate_vote_counts.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/prelim_pc_ps_candidate_vote_counts.csv)** for a summary count by province of polling centers, polling stations, candidates and votes;
- **[candidate_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/candidate_key.csv)** for a list of all candidates for which the IEC reported results, with their unique ID codes, electorate, and names in English, Dari, and Pashto, and IEC-designated preliminary winner status;
- **[ps_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/ps_key.csv)** for a list of all unique polling station codes, polling center codes, district codes, and province codes;
- **[pc_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/ps_key.csv)** for a list of all planned polling centers, polling station counts, reporting status in the preliminary results, and voter registration data (see [note on sourcing](https://github.com/colincookman/afghanistan_election_results_2018#polling-center-plans-and-voter-registration-data));
- **[district_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/district_key.csv)** for a list of all unique districts as reported by the IEC (as well as the 21 subdivisions of Kabul), and their status as provincial capitals or not;
- **[province_key.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/keyfiles/province_key.csv)** for a list of provinces and constituencies, their codes, names in English, Dari, and Pashto, and male / female seats per constituency.

For a brief explanation of the main variables used, please see [this codebook](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/codebook.md).

## Summary of preliminary results data
Although there is *substantial* inter- and intra-provincial variation within the dataset, some national-level summary statistics from the available preliminary results data:

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

Following the [assassination](https://www.nytimes.com/2018/10/18/world/asia/kandahar-afghanistan-attack.html) of Kandahar provincial police chief Abdul Raziq two days prior to election day, voting was delayed in that province and held a week later, on October 27 2018. Elections for Ghazni province - whose electoral results were the subject of a [monthslong political standoff following the 2010 elections](https://foreignpolicy.com/2010/12/02/ghaznis-election-drama-its-the-system/) - remain indefinitely postponed, and as of current writing are planned to be held during the [next round of national elections](http://www.iec.org.af/pdf/timeline-1397.pdf) for the presidency in July 2019.

Afghan parliamentary elections are held under the [Single Non-Transferrable Vote system](https://areu.org.af/archives/publication/1211), in which each province (and the Kuchi and Hindu/Sikh groups) serves as single constituency electing multiple members. ([Electoral reform debates](https://www.afghanistan-analysts.org/afghanistans-incomplete-new-electoral-law-changes-and-controversies/) over the preceding years have included proposals for the creation of single member districts, or some form of proportional representation, but these changes were not adopted.) A set quota of female winners per province is also guaranteed under law. For more background, see the [Electoral Law](http://www.iec.org.af/pdf/legalframework/law/electorallaw_eng.pdf) or summaries by the [International Foundation for Electoral Systems](https://www.ifes.org/sites/default/files/2018_ifes_afghanistan_parliamentary_elections_faqs_final.pdf) or the [Afghan Analysts Network](https://www.afghanistan-analysts.org/afghanistan-election-conundrum-16-basic-facts-about-the-parliamentary-elections/), among other resources.

The 2018 parliamentary elections are Afghanistan's first to link voter registration to a specific polling center. At the demand of some opposition political parties, the IEC agreed to introduce a [biometric voter verification process](https://www.afghanistan-analysts.org/afghanistan-elections-conundrum-21-biometric-testing-likely-to-spawn-host-of-new-problems/) at polling centers prior to voters casting their ballots, although reports indicate widespread technical and procedural problems with implementation of this system. The IEC and ECC ultimately appear to have [adopted a procedure](http://www.iec.org.af/media-section/press-releases/1401-press-20181030-en) that would still accept votes cast in the absence of biometric verification in most cases.

Preliminary election results were initially scheduled to be finalized by early November, with final certification due in December, but the tabulation process was repeatedly delayed. After collecting ballots centrally in Kabul, the IEC began publicly releasing preliminary results in tranches starting on November 23 2018, and completed the preliminary reporting process on January 15 2019. The publication of results for Kabul, which elects the largest delegation to parliament, were repeatedly delayed and the last batch to be announced. The Electoral Complaints Commission, a separate body tasked with adjudicating complaints, initially [invalidated all results for Kabul province](https://www.reuters.com/article/us-afghanistan-election/afghan-election-complaint-body-says-vote-in-capital-kabul-invalid-idUSKBN1O50WU?feedType=RSS&feedName=worldNews) on December 6 2018, but later reversed its action and subsequently cooperated with the IEC in reviewing the remainder of the results. Beginning January 20 2019, shortly after the completion of the publication of the preliminary results, the IEC began releasing final certified results data for provinces in tranches, although these may yet be subject to change.

On February 13 2019, President Ashraf Ghani issued an executive order [modifying Afghanistan's electoral law and firing all members of the IEC and ECC commissions](https://www.afghanistan-analysts.org/afghanistans-2019-elections-3-new-electoral-commissioners-amendments-to-the-electoral-law/), in part in response to allegations of fraud and mismanagement of the parliamentary elections and in anticipation of presidential elections scheduled to take place in July. The IEC secretariat [halted the certification of the final results](https://www.tolonews.com/index.php/elections-2019/probe-iec-iecc-claims-considered-%E2%80%98critical%E2%80%99-ago) for the remaining 17 out of 35 constituencies until a new commission was sworn in. Commission members were elected in a vote by the registered presidential candidates on March 1 2019, chosen by the president, and [sworn in](https://www.tolonews.com/afghanistan/new-election-commissioners-sworn) on March 4 2019.

## Primary sources for this dataset
All 2018 election results in this repository were drawn from the [IEC results website](http://www.iec.org.af/results/en/home), in a website scrape pass that was finalized over February 20-25 2019. The underlying R code used to scrape, clean, and reorganize all data will be published upon the completion of the IEC's release of final certified results data, to allow for replication of results. To request advance access for parallel code testing, please contact the author directly.

### Polling station results forms
As part of its reporting, the IEC also released scanned images of polling station results forms in most polling centers, which were downloaded as part of the data scrape process and may be used as a visual check on the machine-readable results. Those images are too large to host in Github, but are **[mirrored here](https://drive.google.com/open?id=1XxZJnQZaxjva_Ki7QSEa7W9X70qyYESr)**. For a full list of files, see [ps_scan_file_list.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scan_file_list.csv).

Links to some polling scans were not working in some cases; these observed file breaks are logged in the file [ps_scans_broken_links.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scans_broken_links.csv). The file **[ps_scans_reporting_check.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/scan_reports/ps_scans_reporting_check.csv)** offers a province-level summary of the difference between polling stations reporting in the results and scanned forms missing from the IEC website. Notably, no polling station scans were available for Paktia province, either due to broken file links or otherwise missing links.

These lists may not be exhaustive, and full analysis of the scanned images has yet to be undertaken. As a note of caution, some preliminary comparisons suggest that in many cases the polling station scans are mislabeled on the IEC's website.

### Candidate data
The IEC's pre-election candidate lists can be found in English [here](http://www.iec.org.af/cn-list-2018) (or in Dari [here](http://www.iec.org.af/fa/cn-list-1397-fa)). (A list of disqualified candidates can also be found here - [English](http://www.iec.org.af/cn-disqualified-2018), [Dari](http://www.iec.org.af/fa/cn-disqualified-1397-fa).)

Candidates were assigned unique ID codes, which the IEC reported in results data but not in any earlier pre-election candidate lists. Candidates were also assigned ballot symbols, but these do not appear to have been shared across parties or provinces. Almost all candidates contested without a formal party affiliation. 

Although the coding process has not been completed at the time of release, this repository will be updated in the future to include candidate gender data and party affiliation along with the results data.

### Polling center plans and voter registration data
For the IEC's pre-election plans for polling centers, see [this list](http://www.iec.org.af/pdf/pclist-2018/allpc1397-en.pdf) (or in Dari [here](http://www.iec.org.af/pdf/pclist-2018/allpc1397.pdf)), which was published September 27 2018. 

The published pre-election polling center plan does not appear to have been final, as some polling centers reported results despite have earlier having been dropped from pre-election planning lists. The file **[prelim_pcs_reporting_not_planned.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/prelim_pcs_reporting_not_planned.csv)** highlights those polling centers (35, or 0.68% of 5106 planned) mentioned in the preliminary results but that had originally been dropped in the pre-election polling center plan document.

The file **[pc_plan_vr_2018.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/pc_plan_vr_2018.csv)** (which combines the polling center plan with voter registration data) also notes (in the column *pc_change_initial_final_plan*) polling centers that were either added to or dropped from the final plan when compared against an IEC polling center security assessment completed in January 2018, which was also obtained from an election observer.

Public, provisional pre-election voter registration data by polling center can be found (in Dari only) [here](http://www.iec.org.af/fa/vrlist-bypc-1397-fa). The detailed voter registration data used for this project (which includes changes between preliminary voter registration and finalized registration after an IEC [voter list review process](https://ariananews.af/iec-drops-more-than-600000-registered-ids/) conducted in October) was obtained from an election observer.

Voter registration data was missing for 2347 polling centers (31.6% of 7413 total reviewed), most of which were to have been dropped in the final plan. 78 planned polling centers (1.5% of 5106 planned) were also missing voter registration data in this source, and 9 polling centers (0.19% of 4674 polling centers reporting results) reported results despite the absence of voter registration data.

### Vote disqualification
The IEC initially released voter disqualification data in a machine readable format (viewable in Wayback reference [here](https://web.archive.org/web/20181130021502/http://www.iec.org.af/results/en/home/preliminaryresult_disqualified_by_pc)), but midway through the process removed this (very limited) data from its website and replaced it with a [collection of zipped files](http://www.iec.org.af/results/en/home/preliminaryresult_disqualified_by_pc) containing scans of polling stations where results had been invalidated. (As of initial publication, only zip files for 28 of the 36 provinces or nationwide constituencies had been released.) 

These files are also **[mirrored here](https://drive.google.com/open?id=1XyAUCgTYD95pZ_Q19hPqfSBxy-rEecQA)** but at this stage have not been processed into a machine-readable format for further analysis.

As of this writing the ECC has not published its own detailed disqualification reporting.

### Historical election data
Historical data for the results of the 2010 and 2005 parliamentary elections, drawing in part on previous work by the [Afghanistan Election Data project](https://afghanistanelectiondata.org/open/data) (a project of the [National Democratic Institute](https://www.ndi.org/asia/afghanistan) and [Development Seed](https://developmentseed.org/)), is also included in the [data subfolder](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/past_elections/) of this project for reference. (The final results file for the 2010 elections is too large to host on Github, but can be accessed via the Afghanistan Election Data project [here](https://afghanistanelectiondata.org/sites/default/files/wj_2010_final.zip).) Code for restructuring these datasets to join with the current available 2018 data will be added in the near future. Polling center- or -station level results for the 2005 elections are currently unavailable, however. (If you have access to such information and would be willing to share, please get in touch.)

Note that district (and in some cases provincial) boundaries and codes *do not necessarily correspond* across the 2005, 2010, and 2018 election periods, and polling center code numbers *are not necessarily consistent* across election periods. There is also *no consistent English transliteration standard* for district, provincial, or individual candidate names across (and in some cases within) election periods.

### Other data
Supplementary data on [population estimates](https://data.humdata.org/dataset/afg-est-pop) (generated in the absence of any census data) or [district boundaries](https://data.humdata.org/dataset/afg-admin-boundaries) can be found in the Humanitarian Data Exchange or other resources and is also included in the [data subfolder](https://github.com/colincookman/afghanistan_election_results_2018/tree/master/data/) of this project for reference.

## Caveats, gaps, and errors
This repository remains a work in progress and caution is advised when using it for analysis. The author cannot verify the accuracy of, or account for any discrepancies in, the underlying data. This data is provisional and current only as of February 25 2019. The results collected at this point may be further altered by recounts, legal complaints, and other disputes and adjudication processes. 

Due to the very narrow margins of victory separating winners and runners-up under the SNTV system, disqualification decisions (or revisions during the results adjudication and final certification process) can have a significant determinative impact on electoral outcomes. Although more details may be released during the final certification process, there is currently very little transparent reporting on these decisions, despite the months-long process of counting, review, and reporting. As noted earlier, candidates and some observer groups have highlighted concerns over the fairness or accuracy of the results announced by the IEC, alleging manipulation to favor certain candidates, contributing to the removal of the IEC and ECC in mid-February before the final certification of all results. 

The author *cannot adjudicate or verify these charges* and is presenting this dataset ***solely*** for the purposes of contributing to public understanding of the elections and to allow for the analysis of available IEC reporting, *not* to validate or invalidate the available data or to make claims as to how it may correspond to voter actions in practice.

### Polling centers that did not report results
The file **[prelim_pcs_planned_not_reporting.csv](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/pc_plan/prelim_pcs_planned_not_reporting.csv)** lists polling centers (467, or 9.14% of 5106 planned) that were to have opened according to the IEC's September pre-election polling center plan but which did not report any results in the preliminary data, whether due to closure on election day, data entry gaps, or other reasons.

In districts where some polling centers reported results and others did not, the IEC initially (as of mid-December) generated blank results subpages for the polling centers that did not report results. As of the final data scrape (late February 2019), however, those blank polling center pages appear to have been hidden on the IEC website and do not appear in the list of available polling centers under each parent district. 

### IEC data entry errors
As of initial publication, the IEC's reporting on results for the Kuchi electorate produced some apparent data entry errors. Kuchi results reporting for polling center 0903077 (Hazrat Ali Doshi High School in Dushi, Baghlan) included duplicate data from the votes received by general electorate candidates in the same polling center. (This also appears to have resulted in the erroneous inclusion of non-Kuchi candidates in the IEC's ["Results by Ballot Order" constituency-wide summary](http://www.iec.org.af/results/en/home/preliminaryresult_by_province/35/1) for the Kuchi constituency.) This duplicate non-Kuchi data has been removed from the final dataset.

Additionally, polling center 3301007 (Boys High School in Farah city, Farah) reported data for general electorate candidates in the Kuchi results, but did not otherwise report Kuchi candidate results for that polling center. The duplicate general electorate candidate data has been removed from the final dataset.

In [four cases](https://github.com/colincookman/afghanistan_election_results_2018/blob/master/data/prelim_iec_tabulation_check.csv), all for candidates in Farah province, the IEC's reported constituency-wide sums of votes did not match a calculation of the available polling station-level data, although this involved undercounts by the IEC of at maximum two votes, and was not determinative in altering candidate rank or winner status.

Caution is again advised that other less evident data entry errors may also be present in the dataset.

### Other missing data
Latitude / longitude location coordinates for polling centers (either open or closed) that would allow for precise GIS mapping and more granular analysis of voting trends are currently unavailable. If you have access to such information and would be willing to share, please get in touch.

Polling stations (within each polling center) should in theory be designated for either male, female, or Kuchi or Sikh / Hindu voters (or in some cases, mixed stations). The IEC has not publicly released a list categorizing polling stations as such, although the scanned polling station forms do indicate their respective voter categories and may potentially be processed for this purpose. If you have access to such information in a machine-readable format and would be willing to share, please get in touch.

### Final results
Beginning January 20 2019, the IEC began releasing final results in tranches for some provinces, but as noted earlier this process was frozen in mid-February following the removal of the IEC and ECC commissioners. This dataset will be updated to include final certified results, and compared against initial preliminary results, should the IEC ultimately release such information.

## Contact and acknowledgements
Feedback, corrections, or suggestions for further expansion or collaboration are greatly appreciated. For questions, suggestions, or to contribute further, please leave an issue request here on Github or contact [Colin Cookman](https://colincookman.wordpress.com/about/) by email or Twitter.

Although I am responsible for any errors in this project, I am grateful to Asma Ebadi and Lucy Stevenson-Yang for their research and coding assistance.
