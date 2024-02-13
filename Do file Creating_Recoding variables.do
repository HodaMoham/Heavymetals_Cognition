*********************************************************
*Analyst: Hoda Mohammed
*Epidata project: Heavy metals and cognition
*Topic: Creating/recoding variables
*Last updated: Oct 26 2022
*********************************************************

*Recode race/ethnicity: 
ta ridreth3,m
//no missing data on race.
recode ridreth3 1=3 2=4 3=1 4=2 6=5 7=6, gen(race_eth)
. browse ridreth3 race_eth
label define race_eth 1"White-NH" 2 "Black-NH" 3 "Mex Am" 4 "Other-Hisp" 5 "Asian-NH" 6 "Other/Multi"
label values race_eth race_eth
ta race_eth
ta ridreth3 race_eth
*collapsing race bins due to small cell count ( bivariate analysis with exposures and with outcome)
//gen race_4cat=.
//replace race_4cat=1 if ridreth3==3 // White
//replace race_4cat=2 if ridreth3==4 //Black
//replace race_4cat=3 if ridreth3==1 | ridreth3==2 //mex american or other hispanic
//replace race_4cat=4 if ridreth3==6 | ridreth3==7 //Asian or Other race
//label define race_4cat 1" White-NH" 2 "Black-NH" 3 "Mex Am or Other-Hisp" 4 "Asian/Other/Multi"
//label values race_4cat race_4cat
//ta ridreth3 race_4cat

gen race_4cat=.
replace race_4cat=1 if ridreth3==3 // White
replace race_4cat=2 if ridreth3==4 //Black
replace race_4cat=3 if ridreth3==1 //mex american
replace race_4cat=4 if ridreth3==2 |ridreth3==6 | ridreth3==7  //Asian or Other race
label define race_4cat 1" White-NH" 2 "Black-NH" 3 "Mex Am"  4"Other Asian/OtherHisp/Other/Multi"
label values race_4cat race_4cat
ta ridreth3 race_4cat

*Recode Education level: 
ta dmdeduc2,m
//some missing data & refused & don't know--> recode all as missing
recode dmdeduc2 7=. 9=. , gen(education)
ta education
ta dmdeduc2 education,m

*Recode federal poverty level: 
//recode indfmpir min/1=1 1.01/max=0 .=., gen(fpl_2cat)//old variable don't use
//bysort fpl_2cat: su indfmpir
//ta fpl_2cat,m


gen fpl_cat=.
    replace fpl_cat=1 if indfmpir>=2.0 & indfmpir!=.
    replace fpl_cat=2 if indfmpir<2.0 & indfmpir>=1.0
    replace fpl_cat=3 if indfmpir<1.0
label define fpl_cat 1 "Over 200% of the FPL" 2 "100% - 200% of the FPL" 3 "Less than 100% of the FPL"
label values fpl_cat fpl_cat
//bysort fpl_cat: su indfmpir
ta fpl_cat, m

*Recode smoking: 
gen smokeNFC=.
replace smokeNFC=0 if smq020==2
replace smokeNFC=1 if smq020==1 & smq040==3
replace smokeNFC=2 if smq020==1 & smq040==1
replace smokeNFC=2 if smq020==1 & smq040==2
. ta smokeNFC
. ta smokeNFC,m
//cross tabulate is not possible between 3 variables, smq020, smq040, and smokeNFC...so I checked tabulating smokeNFC with missing.
label define smokeNFC 0 "Never" 1 "Former" 2 "Current"
label values smokeNFC smokeNFC
ta smokeNFC,m
*collapsing smoking bins due to small cell count ( bivariate analysis with exposures and with outcome)
gen smokeEver=.
replace smokeEver=0 if smq020==2
replace smokeEver=1 if smq020==1
label define smokeEver 0"Never" 1 "Ever"
label values smokeEver smokeEver
ta smokeEver,m

*Recode alcohol: 
//calling 0 if past  //1 if never // 2 if current
gen alq_3cat=.
replace alq_3cat= 0 if (alq101==1 | alq110==1) & alq120q==0
replace alq_3cat= 1 if alq101==2 & alq110==2
replace alq_3cat= 2 if (alq101==1 | alq110==1) & alq120q>0 & alq120q!=777 & alq120q!=999
ta alq_3cat,m
ta alq_3cat subpop3,m
label define alq_3cat 0 "Past" 1 "Never" 2 "Current" 
label values alq_3cat alq_3cat
ta alq_3cat,m


*Recode physical activity: 
. ta paq650 paq665,m
gen paq_3cat=.
browse paq650 paq665 paq_3cat
replace paq_3cat=2 if paq650==1 
replace paq_3cat=0 if paq650==2 & paq665==2 
replace paq_3cat=1 if paq650~=1 & paq665==1 
//ta paq_3cat,m
label define paq_3cat 0 "None/Low" 1 "Moderate" 2 "Vigorous" 
label values paq_3cat paq_3cat
ta paq_3cat,m
*collapsing physical activity bins due to small cell count ( bivariate analysis with exposures and with outcome)
gen paq_2cat=.
replace paq_2cat=0 if paq650==2 & paq665==2
replace paq_2cat=1 if paq650==1 | paq665==1 
ta paq_2cat,m
label define paq_2cat 0 "None/Low" 1 "Moderate or Vigorous" 
label values paq_2cat paq_2cat
ta paq_2cat,m

*Generate quartiles of blood metals for our subpop3
**1. Cadmium
xtile lbxbcd_Q4 = lbxbcd [aweight=wt4yr_analysis] if subpop3==1, nq(4)
ta lbxbcd_Q4


**2.Lead
xtile lbxbpb_Q4 = lbxbpb [aweight=wt4yr_analysis] if subpop3==1, nq(4)
ta lbxbpb_Q4
ta lbxbpb_Q4 subpop3

**3.Mercury
xtile lbxthg_Q4 = lbxthg [aweight=wt4yr_analysis] if subpop3==1, nq(4)
ta lbxthg_Q4


pctile AF_25lowest= cfdast [aweight=wt4yr_analysis], nq(4) genp(percent)

**# Bookmark #1
*Generate Low cognitive function bin for all ppl 60 and above, do not apply study limitations:
*First take average of all immediate cerad, create 1 var.
gen cfcerad_WL=(cfdcst1+cfdcst2+cfdcst3)/3
browse cfdcst1 cfdcst2 cfdcst3 cfcerad_WL

*Second: create quartiles for 4 cog tests: Cerad immediate, AF, DSST, and Cerad delayed (in 60+ age of all population, no exclusions)

// generate new weight for the 2 cycles, not taking into account heavy metal subsample
gen wtmecnew= wtmec2yr*1/2

*Quartiles for average immediate cerad
xtile cfcerad_WL_4Q= cfcerad_WL [aweight= wtmecnew] if age_instudy==1, nq(4)
browse ridageyr cfcerad_WL cfcerad_WL_4Q
ta cfcerad_WL_4Q,m 
ta cfcerad_WL_4Q

*Quartiles for AF
xtile cfAF_4Q= cfdast [aweight=wtmecnew] if age_instudy==1, nq(4)
ta cfAF_4Q

*Quartile for DSST
xtile cfDSST_4Q= cfdds [aweight=wtmecnew] if age_instudy==1, nq(4)

*Quartiles for delayed cerad
xtile cfcerad_DR_4Q= cfdcsr [aweight=wtmecnew] if age_instudy==1, nq(4)
browse ridageyr cfcerad_WL cfdast cfdds cfdcsr cfcerad_WL_4Q cfcerad_DR_4Q cfAF_4Q cfDSST_4Q

*Third: create a bin for those we scored in the lowest quartiles of all 4 tests (from everyone 60+)
gen low_cog=0
replace low_cog=1 if cfcerad_WL_4Q==1 & cfAF_4Q==1 & cfDSST_4Q==1 & cfcerad_DR_4Q==1

ta low_cog
browse ridageyr cfcerad_WL_4Q cfcerad_DR_4Q cfAF_4Q cfDSST_4Q low_cog

**Generate subpop4 excludes all missing values from independent variables (confounders)
gen miss_cf=0
replace miss_cf=1 if (education==. | fpl_cat==.| smokeNFC==. |  alq_3cat==.)
//miss_cf=211 (n=213 from table 1)


gen subpop4=0
replace subpop4=1 if subpop3==1 & miss_cf==0
browse subpop3 miss_cf subpop4
ta subpop4


































