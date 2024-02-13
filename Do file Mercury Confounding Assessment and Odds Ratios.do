*************************************************
**Analyst: Hoda Mohammed
*Epidata: Project heavy metals and cognition
* Confounding assessment using selection and deletion approaches
*Last updated: Oct 31 2022
**************************************************

*------------------------------------------------*
*         Mercury                                *
*------------------------------------------------*
*confounding assessment 
*"change in estimate" criterion
*10% change in the Odds Ratio is commonly used to define confounding 

*I. Selection approach of confounders. 
*Minimally adjusted (force age) OR and 95% CI
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr, or
*Add potential confounders, one at a time. 
*use the `i.' specification in front of categorical variables to fit indicator terms for each category (other than the referent)

//Selection cycle 1:
*Start with sex:
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4_Q4 ridageyr riagendr , or
*Next fit race/eth
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.race_4cat, or
*Next fit education
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.education , or
*Next fit FPL
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.fpl_cat, or
*Next fit smoking
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.smokeEver, or
*Next fit alcohol
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.alq_3cat , or
*Next fit physical activity
xi: svy,subpop(subpop4): logit low_cog i.lbxthg_Q4 ridageyr i.paq_2cat , or
*****Biggest change in slope was for education, so we include it in cycle 2

//Selection cycle 2:
*Start with cycle 2 base model
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education, or
*Start with sex:
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education riagendr , or
*Next fit race/eth
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education i.race_4cat, or
*Next fit FPL
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education i.fpl_cat, or
*Next fit smoking
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education i.smokeEver, or
*Next fit alcohol
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education i.alq_3cat , or
*Next fit physical activity
xi: svy,subpop(subpop4): logit low_cog i.lbxbcd_Q4 ridageyr i.education i.paq_2cat , or
*****there was no change in slope = or > 10. so we stop here.



*Descriptive columns in Table 2 Mercury
*For all
ta lbxthg_Q4 if (subpop4)
ta lbxthg_Q4 low_cog if (subpop4)
. svy, subpop(subpop4): ta lbxthg_Q4 low_cog,col percent

*For males:
. ta lbxthg_Q4 if (subpop4) & riagendr==1
. ta lbxthg_Q4 if (subpop4) & riagendr==1 & low_cog==1
. svy, subpop(subpop4 if riagendr==1): ta lbxthg_Q4 low_cog,col percent

*For females:
. ta lbxthg_Q4 if (subpop4) & riagendr==2
. ta lbxthg_Q4 if (subpop4) & riagendr==2 & low_cog==1
svy, subpop(subpop4 if riagendr==2): ta lbxthg_Q4 low_cog,col percent



********************************************************
*     Regression Model & OR for Mercury                *
********************************************************
*Minimally adjusted OR (adjusted for age)
xi: svy,subpop(subpop4): logit low_cog ridageyr i.lbxthg_Q4, or

*Fully adjusted OR for merury
xi: svy,subpop(subpop4): logit low_cog ridageyr i.lbxthg_Q4  i.education, or

********************************************************











