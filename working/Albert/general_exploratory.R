## Data Files
# Read the files (Format: data.i is the ith data file)
datalist <- list.files(pattern="*.gz")
for (i in 1:length(datalist)){
  names <- paste("data", i, sep=".")
  assign(names, read.delim(datalist[i],header=T,as.is=T,skip=10,sep='\t'))
}

## Variable Report XML Files
# Read the files (Format = var_report.i is the ith variable report)
library(XML)
varlist = list.files(pattern="*var_report.xml")
for (i in 1:length(varlist)) {
  names <- paste("var_report",i, sep=".")
  xmlvarfile = varlist[i]
  xmlint = xmlTreeParse(xmlvarfile, useInternalNodes=T)
  listdesc = xpathApply(xmlint,"//description",xmlValue) #Variable Description
  assign(names, listdesc[c(FALSE,TRUE,FALSE)])
}

# Count number of variables
num_variables = list()
for(i in 1:length(varlist)) {
  name = paste("var_report", i, sep=".")
  num_variables[i] = length(get(name))
}
unlist(num_variables)                                    #Table of num of variables for each data file                  



## Data Dictionary XML Files
## Haky's Function 
## copy and paste the function below
## given xml file name returns list with code+label list
codefun =  function(filename)
{
  doc = xmlTreeParse(filename)
  root = xmlRoot(doc)
  lista = list()
  cont = 1
  for(ll in 1:length(root))
  {
    code = unlist(xmlSApply(root[[ll]],xmlAttrs))
    code = code[names(code)=="value.code"]
    label = unlist(xmlSApply(root[[ll]],xmlValue))
    label=label[names(label)=="value"]
    if(length(code)>0)
    {
      lista[[cont]] = cbind(code,label)
      rownames(lista[[cont]]) = NULL
      nombres = as.vector(xmlSApply(root[[ll]],xmlName))
      values = as.vector(xmlSApply(root[[ll]],xmlValue))
      names(lista)[cont] = values[which(nombres=="name")]
      names(lista)[cont] = tolower(names(lista)[cont])
      cont = cont+1
    }
  }
  return(lista)
}

## Example on single XML File
xmlfile = 'phs000007.v23.pht000298.v5.crp3_1s.data_dict.xml'
codelist = codefun(xmlfile)

## Multiple XML Files (doesn't work)
# 
# temp = list.files(pattern="*data_dict.xml")
# for (i in 1:length(temp)) {
#   names <-paste("data_dict",i, sep=".")
#   xmlfile = temp[i]
#   assign(names, codefun(xmlfile))
# }

