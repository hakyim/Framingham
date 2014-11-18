#Consent Group 2
data_age<-read.delim("phs000007.v24.pht003099.v3.p9.c2.vr_dates_2011_m_0689s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_orig<-read.delim("phs000007.v24.pht000040.v4.p9.c2.dbt0_27s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_offs<-read.delim("phs000007.v24.pht000041.v6.p9.c2.dbt1_7s.HMB-IRB-NPU-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
#Consent Group 1
data_age<-read.delim("phs000007.v23.pht003099.v2.p8.c1.vr_dates_2011_m_0689s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_orig<-read.delim("phs000007.v23.pht000040.v4.p8.c1.dbt0_27s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')
data_offs<-read.delim("phs000007.v23.pht000041.v5.p8.c1.dbt1_7s.HMB-IRB-MDS.txt.gz", header=T, as.is=T, skip=10, sep='\t')

data = merge(data_orig, data_offs, all=T)
data2 = merge(data, data_age, by="dbGaP_Subject_ID", all.x=T)  ## erases ages!!
n <- dim(data)[1]*(dim(data)[2]-3) - sum(is.na(data)) #3 columns are subject ID, etc.
data_result<-data.frame(Values = numeric(n), Variables = numeric(n), ID = numeric(n), Ages = numeric(n), Dates = numeric(n))

k<-1
for(i in 1:dim(data)[1]){
loglist<- !is.na(data[i,]) #how to exclude first two and last?
test<-t(data[i,loglist])
ID<-test[1,1]
variables <- colnames(data)[loglist]
test = cbind(test, variables, rep(ID,each=nrow(test)))
test = test[4:nrow(test)-1,]
s <- unlist(strsplit(variables,"[^[:digit:]]"))
print(i)
s_cleared <- as.numeric(s[s!=""])
s_cleared <- s_cleared[s_cleared<29]              #gets rid of problem with dm150, etc.
ages <- t(data2[i, 2*s_cleared+dim(data)[2]+1]) #+3 with consent group 2
dates <- t(data2[i, s_cleared+dim(data)[2]+56]) #Date: missing date1, +57 with consent group 2
if(dim(ages)[1]==1) {				     #Solves problem with binding rownum=1
	test = c(test,ages,dates)
	rownum <- 1
} else {
test = cbind(test,ages,dates)                 #note: cbind coerces values to character
rownum <- nrow(test)
}
data_result[k:(k+rownum-1),] = test
k=k+rownum
}

#convert back to numeric
data_result$Values <- as.numeric(data_result$Values)
data_result$ID <- as.numeric(data_result$ID)
data_result$Ages <- as.numeric(data_result$Ages)
data_result$Dates <- as.numeric(data_result$Dates)

#separate data
##original
data_bls <- data_result[grep("BLS",data_result$Variables),]
data_dm <- data_result[grep("dm150_curr", data_result$Variables),]
##offspring
data_fgluc <- data_result[grep("F_GLUC", data_result$Variables),]
data_dmrx <- data_result[grep("DMRX", data_result$Variables),]
data_diab <- data_result[grep("DIAB", data_result$Variables),]

#counting
dim(unique(subset(data_diab, Values==1)[,c(1,3)]))
dim(subset(data_diab[grep("DIAB1", data_diab$Variables),],Values==1))

#calculating change in fasting glucose when become diabetic (x is diff)
df<-data.frame(Ages=c(),Diff=c())
data_temp<-merge(data_diab,data_fgluc2) #data_fluc2 is data_gluc with renamed columns
for(i in 1:dim(data_temp)[1]){
if(data_temp[i, 4]==1 && data_temp[i-1,4]==0 && data_temp[i,1]==data_temp[i-1,1]){
x<-data_temp[i,6] - data_temp[i-1,6]
age <- data_temp[i, 2]
df<-rbind(df,cbind(age,x))
}
}