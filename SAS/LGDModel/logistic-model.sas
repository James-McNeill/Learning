/* Logistic Regression run */
/* Multi-class dependent variable */

*CAT_VAR1: relates to a boolean value (Y/N)
CAT_VAR2: relates to a location variable
TARGET: dependent variable is a categorical grouping;

PROC LOGISTIC DATA= INPUT_DATA OUTEST=EXCEL_OUTPUT /*outmodel= MODEL_OUT*/;
CLASS /*CATEGORICAL VARIABLES*/ CAT_VAR1 (REF="Y") CAT_VAR2 (REF="WEST_REGION") / PARAM=REF; *REF: relates to the reference group. Each co-efficient will relate relative to this group;
MODEL /*RESPONSE VARIABLE*/ TARGET (REF='OTHER')= 

/*categorical variables*/  
CAT_VARIABLES
/*continuous variables*/
NUMERIC_VARIABLES

/ DETAILS LINK=GLOGIT LACKFIT RSQ; *Link function for the model;
;STORE MULTI_NOMIAL ; *Store the model output that can be used to score the input data for predictions;
RUN;

*Adds est. prob. by outcome for summary model estimates;
PROC PLM SOURCE= MULTI_NOMIAL;
SCORE DATA= INPUT_DATA 
OUT=INPUT_DATA_V1
PREDICTED=PREDICTED_PROB / ILINK; *Predicted variable being created;
RUN;

*Transpose the final output from the model outputs into the four multinomial class categories;
PROC TRANSPOSE DATA=INPUT_DATA_V1 OUT=OUT_DEV_SCORES (DROP=_NAME_ _LABEL_) PREFIX=PREDICTED_PROB_;
     VAR PREDICTED_PROB;
     BY ACCOUNT_NO OUTCOME_CURE OUTCOME_REPO OUTCOME_SUS OUTCOME_OTHER CURRENT_BALANCE TARGET;
     ID _LEVEL_;
RUN;
