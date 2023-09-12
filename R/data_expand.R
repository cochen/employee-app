#'
#' @title Experience Study Data Processing 
#' @name studydata
#' @author Conrad Chen
#'
#' @param data data.table structure
#' @param study.end study end date
#' @param policy.start policy start date
#' @param death.date death date
#' @param sex gender
#' @param issue.age age at policy issue
#' @param keyp unique ID
#' @return data expanded by duration w/exposures & expecteds using VBT 2015 and 15% smoker assumption
#' @examples 
#' dt <- studydata(dt, "2019-12-17", "Start", "Death", "Gender", "Age", "Id")
#' @import data.table
#' @export

studydata <- function(data, study.end, policy.start, death.date, sex, issue.age, keyp ){
  
  DT <- (data) 
  
  col = c(policy.start, death.date, sex, issue.age, keyp)
  
  setnames(DT, old = col, new = c('policy.start', 'death.date', 'sex', 'issue.age', 'keyp'))

  is.date <- function(x) inherits(x, 'Date')

  
  if(!is.data.table(DT)) stop("'dataframe' must be data.table")
  if (is.na(as.Date(study.end,"%Y-%m-%d"))) stop ("input date as '%Y-%m-%d'")
  if(!is.date(DT$policy.start)) stop("'start.date' must be date '%Y-%m-%d'")
  if(!is.date(DT$death.date)) stop("'death.date' must be date '%Y-%m-%d'")
  if(!is.character(DT$sex)) stop("'gender' must be character")
  if(!is.numeric(DT$issue.age)) stop("'age' must be numeric")

  End.of.Study.Date = as.Date(study.end)
  
  
  #calculate number of exposures and extract year from date
  
  DT[, Exposures := ifelse(is.na((death.date)), (End.of.Study.Date-(policy.start))/365, ifelse((death.date)>End.of.Study.Date,
                                                                                                     (End.of.Study.Date-(policy.start))/365, ((death.date)-(policy.start))/365))][, Policy_yr:=as.numeric(format((policy.start), "%Y"))]
  
  #expand records (to number of exposures) and determine duration
  DT <- DT[rep(1:.N,ceiling(Exposures))][,Duration:=1:.N,by=(keyp)]

  #Cap duration <= 30
  DT <- DT[ Duration <= 30]

  #Assign exposures to duration and calculate policy year
  DT[, Exposures := ifelse((Exposures-Duration) >= 0, 1,(Exposures-Duration)+1)][, Policy_yr:=(Policy_yr+Duration-1)]


  #Remove move records past end of study period
  End.Study.Year<-min(as.numeric(format(End.of.Study.Date, "%Y")))
  DT <- DT[ Policy_yr <= End.Study.Year]

  #Calculate if death in study period and assign to last exposure
  DT[, Dead := ifelse((death.date) <= pmin(((policy.start)+365*Duration), End.of.Study.Date), 1, 0)][,Dead := ifelse(is.na(Dead),0,Dead)]


  #Import customized VBT tables
  Male_NS = readRDS("./data/vbt.2015.M.NS.ANB.rds")
  Male_S  = readRDS("./data/vbt.2015.M.S.ANB.rds")
  Female_NS = readRDS("./data/vbt.2015.F.NS.ANB.rds")
  Female_S = readRDS("./data/vbt.2015.F.S.ANB.rds")

  #Assign qx nonsmoker and smoker by age, gender, and duration (+1 is for age start 0, +1 first column is age)
  DT[(sex)=="M",qx_ns:= Male_NS[cbind(DT[(sex)=="M",(issue.age)]+1,DT[(sex)=="M",Duration]+1)]][(sex)=="M",qx_s:=
                                                                                                         Male_S[cbind(DT[(sex)=="M",(issue.age)]+1,DT[(sex)=="M",Duration]+1)]]

  DT[(sex)=="F",qx_ns:= Female_NS[cbind(DT[(sex)=="F",(issue.age)]+1,DT[(sex)=="F",Duration]+1)]][(sex)=="F",qx_s:=
                                                                                                           Female_S[cbind(DT[(sex)=="F",(issue.age)]+1,DT[(sex)=="F",Duration]+1)]]


  #Blend 85/15 NS/S rate (as no smoker indicator), and convert to probability i.e. *0.001
  DT[,qx_c:=0.001*(0.85*qx_ns+0.15*qx_s)]

  #remove columns after blending into qx_c
  DT[,c("qx_ns","qx_s"):=NULL]

  #calculate expecteds
  DT[, Expected := ifelse(Dead==0,Exposures*qx_c,1*qx_c)]
  
  return(DT)
  
}


