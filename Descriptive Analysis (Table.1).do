*****************************************
*Analyst name: Hoda Mohammed
*Epidata Project: Heavy metals and Cognition
* Descriptive Analysis (Table 1)
*******************************************

*-----------------------------------------------------*
*             Set Survey Weights                      *
*-----------------------------------------------------*
*Before you start, set survey weights 
*Set survey analysis specification code i.e. a.	Correcting for clustered stratified sampling and survey weights
svyset sdmvpsu [pw= wt4yr_analysis], strata (sdmvstra)


//Correcting for clustered/stratified sampling but remove survey weighting:
//svyset sdmvpsu, strata(sdmvstra)

//Stata will "remember" this survey analysis specification, even after closing and re-opening the data file.  
//To clear the specification, run the following code:
//svyset, clear

//To check which survey analysis specification has already been set, run the following code:
//svyset

*------------------------------------------------------*
*                      Table 1.                        *
*------------------------------------------------------*

*------------------------------------------------------*
*         1.	Examine exposure: blood metals         *
*------------------------------------------------------*
*Range, median of each cadmium quartile
bysort lbxbcd_Q4: tabstat lbxbcd [aweight=wt4yr_analysis],stat(n min max p50)
tabstat lbxbcd, stat(n mean min max) by(lbxbcd_Q4)
**To find the min/max and median of each quartile
su lbxbcd if subpop3==1 & lbxbcd_Q4==1
su lbxbcd if subpop3==1 & lbxbcd_Q4==2
su lbxbcd if subpop3==1 & lbxbcd_Q4==3
su lbxbcd if subpop3==1 & lbxbcd_Q4==4


*------------------------------------------------------------------------------------------------------------*
*         2. Examine Distribution of other independent variables according to categories of exposure status##        
*------------------------------------------------------------------------------------------------------------*
*--------------------------------------------------------
*Part I. Descriptive Assessments: Univariable Analyses  *
*-------------------------------------------------------*
*•	Calculate descriptive statistics for continuous and categorical (or binary) variables.
*•	Ascertain adequacy of cell size (counts) and variability needed to assess the association of interest/ for categorical.
*A minimum cell size (denominator of) of at least 20 or 30 participants (unweighted) is needed in order to produce statistically reliable estimates of proportions 

//I.Categorical independent variables: Count and Column %
* Calculate frequencies, check that cell counts seem sufficient for analysis(>20 or >30)
* Calculate the percent in each category of the categorical independent variables (eg. sex,educ,race..etc) among metal quartiles. Report percentages to the nearest tenths place (1 decimal).
*Cross-tabulate categorical independent variables with the exposure variable, blood metals. 
*Do these cross-tabulations raise any concerns for regression analysis? check cell count if less than 20 or 30. 

*a.	Sex: In each quartile, how many & what % was male/female?
ta riagendr lbxbcd_Q4 if subpop3==1 //not weighted(get counts)
svy, subpop(subpop3): ta riagendr lbxbcd_Q4,col percent  //weighted (get%)

*b. Race: Among different race/ethnicites, how many have high low blood metal /quartiles?  
ta  race_eth lbxbcd_Q4 if subpop3==1 //not weighted (get counts) //small cell for asian,other and mex american
ta  race_eth lbxbcd_Q4 if (subpop4) //not weighted (get counts) //small cell for asian,other and mex american
svy, subpop(subpop3): ta race_eth lbxbcd_Q4,col percent  //weighted (get%)

*c.	Education: Among different education levels, how many have high low blood metal /quartiles?  
ta  education lbxbcd_Q4 if subpop3==1 //no weighted(get counts)
svy, subpop(subpop3): ta education lbxbcd_Q4,col percent  //weighted (get%)

*d.	FPL: Among FPL levels, how many have high low blood metal /quartiles?  
ta  fpl_cat lbxbcd_Q4 if subpop3==1 //no weighted(get counts)
svy, subpop(subpop3): ta fpl_cat lbxbcd_Q4,col percent  //weighted (get%)

*e.	Smoking: Among smoking levels, how many have high low blood metal /quartiles?  
ta  smokeNFC lbxbcd_Q4 if subpop3==1 //no weights? (get counts)//small cell counts
ta  smokeNFC lbxbcd_Q4 if (subpop4) //no weights? (get counts)//small cell counts
. ta  smokeNFC lbxbcd_Q4 if subpop3==1 ,m
svy, subpop(subpop3): ta smokeNFC lbxbcd_Q4,col percent  //weighted (get%)

*f.	Alcohol: Among alcohol levels, how many have high low blood metal /quartiles?  
ta alq_3cat lbxbcd_Q4 if subpop3==1 ,m
svy, subpop(subpop3): ta alq_3cat lbxbcd_Q4,col percent  //weighted (get%)

*g.	Physical Activity: Among Physical activity levels, how many have high low blood metal /quartiles?  
ta paq_3cat lbxbcd_Q4 if subpop3==1 ,m//small cell counts
ta paq_3cat lbxbcd_Q4 if (subpop4)
svy, subpop(subpop3): ta paq_3cat lbxbcd_Q4,col percent  //weighted (get%)



//II. Continuous independent variables: mean and SE
//Calculate mean and standard error (SE) for age (ridageyr) among Q1/Q2/Q3/Q4 Use 2 decimal places for the mean and SE. then Report the P-value for the test of difference in mean age between the quartiles. Report P-values as follows: 
*For values 0.20 or larger, report to the nearest hundredth place
*for values from 0.001 to <0.20, report to the nearest thousandth place 
*for values <0.001 report as <0.001 

*it is ok for age to be not normally distributed since it is not the dependent variable

*Preliminary data analysis/standard function/values are not sensitive to survey design effects
*count, min/max 
su ridageyr if subpop3==1 //general mean and SE. Not per quartile.

*survey functions/ using design variables/mean and SE
*mean, SE requires svy function
svy, subpop(if subpop3==1):mean ridageyr,over(lbxbcd_Q4) 
*OR
svy, subpop(if subpop3==1):mean ridageyr,over(lbxbcd_Q4) coeflegend

test _b[c.ridageyr@0bn.food_any] =_b[c.ridageyr@1.food_any]

//a test that ignores survey sampling//wrong test
ttest ridageyr if subpop3==1,by(lbxbcd_Q4)

**50 percentile/median: can use aweight for weighted percentiles
*http://www.stata.com/support/faqs/statistics/percentiles-for-survey-data/
tabstat ridageyr [aweight= wt4yr_analysis] if (subpop3), stat(p50 p10 p90) col(stat)

*test skewness and kurtosis
sktest ridageyr [aweight= wt4yr_analysis] if (subpop3)

*these are not weighted
hist ridageyr if subpop3==1,norm

graph box ridageyr if subpop3==1

list bmiz bmxbmi ridageyr bmxwt bmxht if bmiz<-3 & bmiz~=. & subpop2==1 & male==1 & foodinsec==0

list bmiz bmxbmi ridageyr bmxwt bmxht if bmiz>3 & bmiz~=. & subpop2==1 & male==1 & foodinsec==0



*-----------------------------------------------------------------*
*         3.	Examine outcome: low cognitive functioning        *
*-----------------------------------------------------------------*
//Prevalence of low cognitive in metal quartiles.
svy,subpop(subpop4): ta low_cog lbxbcd_Q4, row percent
svy,subpop(subpop4): ta low_cog lbxbpb_Q4, row percent
svy,subpop(subpop4): ta low_cog lbxthg_Q4, row percent

//dependent variable cognitive must be normally distributed(?/E7)====> continuous outcome only??
//In your project analysis, histogram and box plot, other normality plots (e.g., Q-Q) as appropriate for your study.  Survey commands for these plots are not available, so they run as described in your Biostatistics courses. c.	
//Are there any extreme values?  If yes, do they appear to be of concern
//the distribution of outcome variable?  Does it seem appropriate to model the low cog function as is for logistic regression analysis or would it be advisable to perform some type of transformation? 

*these are not weighted
hist bmiz if subpop2==1 & male==1 & foodinsec==0,norm

graph box bmiz if subpop2==1 & male==1 & foodinsec==0

list bmiz bmxbmi ridageyr bmxwt bmxht if bmiz<-3 & bmiz~=. & subpop2==1 & male==1 & foodinsec==0

list bmiz bmxbmi ridageyr bmxwt bmxht if bmiz>3 & bmiz~=. & subpop2==1 & male==1 & foodinsec==0


*--------------------------------------------------------
*Part II. Descriptive Assessments: Bivariable Analyses  *
*-------------------------------------------------------*
*1.	Cross-tabulate categorical independent variables (exposure:blood metals, and potential confounding variables) with the dependent categorical variable, cognitive function (=outcome) counts unweighted.
//ta pb_quartile cognitive if subpop3==1
ta lbxbcd_Q4 low_cog if subpop4==1
ta lbxbpb_Q4 low_cog if subpop4==1
ta lbxthg_Q4 low_cog if subpop4==1

ta riagendr low_cog if subpop4==1
ta race_eth low_cog if subpop4==1//small count asian,other
ta education low_cog if subpop4==1 //small count (5+4?)
ta fpl_cat low_cog if subpop4==1
ta smokeNFC low_cog if subpop4==1
ta alq_3cat low_cog if subpop4==1
ta paq_3cat low_cog if subpop4==1 //small count (V+M?)


*Are the cell counts for this categorical outcome variable of sufficient size for analysis? Do these cross-tabulations raise any concerns for logistic regression analysis with regard to statistical precision of odds ratio estimates? 

*2.	Calculate 10th and 90th percentile values of continuous independent variable (age) within each category of the dependent variable (cognitive). 
. tabstat ridageyr [aweight= wt4yr_analysis] if (subpop4) ,stat (n p50 p10 p90) col(stat) by(low_cog) 
*Do the distributions of age in the two categories of cognitve raise any concerns for regression analysis? 



*4.	Calculate 10th and 90th percentile values of age as a continuous independent variable among each category of the exposure variable, blood metals.
. tabstat ridageyr if subpop4,stat (n p50 p10 p90) col(stat) by(lbxbcd_Q4)
. tabstat ridageyr if subpop4==1,stat (n p50 p10 p90) col(stat) by(lbxbpb_Q4)
. tabstat ridageyr if subpop4==1,stat (n p50 p10 p90) col(stat) by(lbxthg_Q4)
*Do the distributions of age in the two categories of exposure raise any concerns for regression analysis? age must have similar distribution among metal quartiles.

*Assessing linearity of age: lowess does not accomodate survey data analysis and does not accomodate adjusted models
. lowess low_cog ridageyr if subpop4==1,logit
*General approach:
xtile ridageyr_q5=ridageyr [aweight= wt4yr_analysis] if subpop4,nq(5)
bysort ridageyr_q5: tabstat ridageyr [aweight= wt4yr_analysis], stat(n min max p50)
xi: svy, subpop(subpop4): logit low_cog i.ridageyr_q5
xi: svy, subpop(subpop4): logit low_cog ridageyr

*prevalence of low cognitive 
. svy, subpop(subpop4): tab low_cog, col percent,ci
