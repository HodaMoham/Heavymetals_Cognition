*******************************************
* Analyst name: Hoda Mohammed
* Epidata Project Heavy metals and Cognition
* Figure 2
* Last updated: Nov 8 2022
*******************************************
*generate memory test with no missing:
//gen cognomiss=0
//replace cognomiss=1 if cfcerad_DR_4Q!=. & cfAF_4Q!=. & cfDSST_4Q!=. & cfcerad_DR_4Q!=.
//ta cognomiss // n=2,937

gen cognomiss=0
replace cognomiss=1 if subpop4==1 & cfcerad_DR_4Q!=. & cfAF_4Q!=. & cfDSST_4Q!=. & cfcerad_DR_4Q!=.
ta cognomiss

*Count of participants in quartile 1 of any cognitive function measure:
*For 0:
gen countif0=0
replace countif0=1 if subpop4==1 & cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.
ta countif0 // n=556 

*For 1:
gen countif1=0
replace countif1=1 if subpop4==1 &(cfcerad_WL_4Q==1 & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) | (cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q==1 & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) | (cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q==1 & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) | (cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q==1)
ta countif1 // n=378 


*For 2:
gen countif2=0
replace countif2=1 if subpop4==1 &(cfcerad_WL_4Q==1 & cfAF_4Q==1 & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) | (cfcerad_WL_4Q==1 & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q==1 & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) | (cfcerad_WL_4Q==1 & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q==1) | (cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q==1 & cfDSST_4Q==1 & cfcerad_DR_4Q!=1 & cfcerad_DR_4Q!=.) |(cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q==1 & cfDSST_4Q!=1 & cfDSST_4Q!=. & cfcerad_DR_4Q==1) | (cfcerad_WL_4Q!=1 & cfcerad_WL_4Q!=. & cfAF_4Q!=1 & cfAF_4Q!=. & cfDSST_4Q==1 & cfcerad_DR_4Q==1)
ta countif2 //n=331


*For 4:
gen countif4=0
replace countif4=1 if subpop4==1 &cfcerad_WL_4Q==1 & cfAF_4Q==1 & cfDSST_4==1 & cfcerad_DR_4Q==1
ta countif4 //n=201

*For 3:
gen countif3=0
replace countif3=1 if countif0==0 & countif1==0 & countif2==0 & countif4==0 //n=249
ta countif3
//Note: we know the number of countif3 by cross tabulation with cognomiss since it otherwise shows an exagerated number, including all missing values for cog tests.

ta cognomiss
ta cognomiss countif0
ta cognomiss countif1
ta cognomiss countif2
ta cognomiss countif3
ta cognomiss countif4


svyset sdmvpsu [pw= wt4yr_analysis], strata (sdmvstra)
svy, subpop(subpop4): ta countif0,col percent
svy, subpop(subpop4): ta countif1,col percent
svy, subpop(subpop4): ta countif2,col percent
svy, subpop(subpop4): ta countif3,col percent
svy, subpop(subpop4): ta countif4,col percent

ta subpop4 countif0
ta subpop4 countif1
ta subpop4 countif2
ta subpop4 countif3
ta subpop4 countif4


* 0= 556 1=378 2=331 3=249 4=201 -->all add up to subpop4= 1,715

*Pie chart:
. graph pie counts, over(counts)

*Bar chart
graph bar (asis) counts, over(freqinQ1)

*******************************************


