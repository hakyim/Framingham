## Exploratory Analysis on Diabetes Phenotypes

##============================ Read In Files ==================================##
## Consent Group 1
data_age<-read.delim("phs000007.v23.pht003099.v2.p8.c1.vr_dates_2011_m_0689s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_orig<-read.delim("phs000007.v23.pht000040.v4.p8.c1.dbt0_27s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_offs<-read.delim("phs000007.v23.pht000041.v5.p8.c1.dbt1_7s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')

## Consent Group 2
data_age<-read.delim("phs000007.v24.pht003099.v3.p9.c2.vr_dates_2011_m_0689s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_orig<-read.delim("phs000007.v24.pht000040.v4.p9.c2.dbt0_27s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_offs<-read.delim("phs000007.v24.pht000041.v6.p9.c2.dbt1_7s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')

##============================ Organize Data ==================================##
## Merge Data
data = merge(data_orig, data_offs, all=T)                      ##Original Cohort and Offspring Cohort
data2 = merge(data, data_age, by="dbGaP_Subject_ID", all.x=T)  ##Original Cohort, Offspring Cohort, and their Ages/Dates

## Pre-allocate space for reorganized data (data_result)
n <- dim(data)[1]*(dim(data)[2]-3) - sum(is.na(data))          ##n = number of rows we will have in data_result
data_result<-data.frame(Values = numeric(n), Variables = numeric(n), ID = numeric(n), Ages = numeric(n), Dates = numeric(n))

k<-1
for(i in 1:dim(data)[1]){
  ## Get Non-Missing Values and Variable Names for Participant i
  loglist<- !is.na(data[i,])                                   ##loglist = list of column number with values (??how to exclude first two columns and last column)
  values<-t(data[i,loglist])                                   ##values = list of non-missing values for Participant i  
  ID<-values[1,1]                                              ##ID = Subject ID of Participant i
  variables <- colnames(data)[loglist]                         ##variables = variables names of the values
  values = cbind(values, variables, rep(ID,each=nrow(values))) 
  values = values[4:nrow(values)-1,]                           ##Exclude values for ID
  
  ## Get Ages and Dates for Participant i
  s <- unlist(strsplit(variables,"[^[:digit:]]"))              ##Extract numbers from variable names                                                  
  s_cleared <- as.numeric(s[s!=""])                            
  s_cleared <- s_cleared[s_cleared<29]                         ##Exams number are from 0-28, e.g. excludes 150 from dm150_curr4 
  ages <- t(data2[i, 2*s_cleared+dim(data)[2]+1])              ##If consent group 2, use +3 instead of +1
  dates <- t(data2[i, s_cleared+dim(data)[2]+56])              ##If consent group 2, use +57 (or 58?) instead of +56 
                                                               ##Bug: no column for date1, will return value for last age column, which should be NA
  ## Bind Values, Ages, and Dates
  if(dim(ages)[1]==1) {				                                 ##Fixes bug when there is only one row
	  values = c(values,ages,dates)
	  rownum <- 1
  } else {
    values = cbind(values,ages,dates)                          ##Note: cbind coerces values to character (??better way to do this)
    rownum <- nrow(values)
  }
  data_result[k:(k+rownum-1),] = values                        ##Replace the next empty rows in data_result with values
  k=k+rownum                                                   ##Jump to position of next empty row
  print(i) 
}

## Convert values back to numeric
data_result$Values <- as.numeric(data_result$Values)           
data_result$ID <- as.numeric(data_result$ID)
data_result$Ages <- as.numeric(data_result$Ages)
data_result$Dates <- as.numeric(data_result$Dates)

## Separate organized data into different subsets
## Original Cohort
data_bls <- data_result[grep("BLS",data_result$Variables),]           ##data_bls = Blood Glucose Level
data_dm <- data_result[grep("dm150_curr", data_result$Variables),]    ##data_dm = Diabetes Status (150 mg/dl)

## Offspring Cohort
data_fgluc <- data_result[grep("F_GLUC", data_result$Variables),]     ##data_fgluc = Fasting Glucose Level
data_dmrx <- data_result[grep("DMRX", data_result$Variables),]        ##data_dmrx = Treatment for Diabetes Status
data_diab <- data_result[grep("DIAB", data_result$Variables),]        ##data_diab = Diabetes Status


##=============================== Analysis of Data =================================##
## Count number of participants (Work in Progress)
dim(unique(subset(data_diab, Values==1)[,c(1,3)]))                    ##(?? Returns number of participants who are diabetic)
dim(subset(data_diab[grep("DIAB1", data_diab$Variables),],Values==1)) ##(?? Returns number of participants who are initially diabetic)

## Compute and plot changes in glucose when participant becomes diabetic                            
colnames(data_bls)<-c("BValues","BVariables","ID","Ages","Dates")
data_db_orig<-merge(data_dm,data_bls)                                 ##Original Cohort
colnames(data_fgluc)<-c("FValues","FVariables","ID","Ages","Dates")
data_db_offs<-merge(data_diab,data_fgluc)                             ##Offspring Cohort

## diffbls: data -> data_diff 
## Given data with diabetes status and blood glucose level,
## output data_diff with age turned diabetic "Ages" and change in blood glucose level from previous exam "Diff"
diffinbls = function(data){
  data_diff<-data.frame()                                                 ##(?? Pre-allocate with number of participants who become diabetic)
  for(i in 1:dim(data)[1]){
    currentID <- data[i,1]
    previousID <- data[i-1,1]
    currentstatus <- data[i,4]
    previousstatus <- data[i-1,4]
    if(currentID == previousID && currentstatus==1 && previousstatus==0){ ##if(participant became diabetic)
      diff<-data[i,6] - data[i-1,6]                                       ##diff = change in glucose level 
      age <- data[i, 2]                                                   ##age = age at which they test diabetic
      data_diff<-rbind(data_diff,c(age,diff))                             
    }
  }
  colnames(data_diff)<-c("Ages","Diff")
  return(data_diff)
}

data_diff_orig<-diffinbls(data_db_orig)
plot(data_diff_orig$Ages, data_diff_orig$Diff)
data_diff_offs<-diffinbls(data_db_offs)
plot(data_diff_offs$Ages, data_diff_offs$Diff)

