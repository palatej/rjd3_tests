source("./R files/rjava_init.R")
source("./R files/rproto_init.R")

ymd<-function(y, m, d=1){
  return (as.Date(sprintf("%04i-%02i-%02i", y, m, d)))
}

yearOf<-function(s){
  return ( as.integer(substr(s, 1, 4)))
}

monthOf<-function(s){
  return ( as.integer(substr(s, 6, 7)))
}

dayOf<-function(s){
  return ( as.integer(substr(s, 9, 10)))
}

dateOf<-function(year, month, day){
  d<-jd3.Date$new()
  d$year<-year
  d$month<-month
  d$day<-day
  return (d)
}

parseDate<-function(s){
  d<-jd3.Date$new()
  d$year<-yearOf(s)
  d$month<-monthOf(s)
  d$day<-dayOf(s)
  return (d)
}

DATE_MIN<-dateOf(1,1,1)
DATE_MAX<-dateOf(9999, 12, 31)


# Raw interface
newCalendar<-function(){
  return (jd3.Calendar$new())
}

validityPeriod<-function(start, end){
  vp<-jd3.ValidityPeriod$new()
  if (is.null(start)) {
    pstart=DATE_MIN
  }else{
    pstart=parseDate(start)
  }
  if (is.null(end)){
    pend=DATE_MAX
  }else{
    pend=parseDate(end)
  }
  vp$start<-pstart
  vp$end<-pend
  return (vp)
}

addFixedDayToCalendar<-function(calendar, month, day, weight=1, start=NULL, end=NULL){
  fd<-jd3.FixedDay$new()
  fd$month<-month
  fd$day<-day
  fd$weight<-weight
  fd$validity<-validityPeriod(start, end)
  n<-1+length(calendar$fixed_days)
  calendar$fixed_days[[n]]<-fd
}

addEasterRelatedDayToCalendar<-function(calendar, offset, julian=F, weight=1, start=NULL, end=NULL){
  ed<-jd3.EasterRelatedDay$new()
  ed$offset<-offset
  ed$julian<-julian
  ed$weight<-weight
  ed$validity<-validityPeriod(start, end)
  n<-1+length(calendar$easter_related_days)
  calendar$easter_related_days[[n]]<-ed
}

addPrespecifiedHolidayToCalendar<-function(calendar, event, offset=0, weight=1, start=NULL, end=NULL){
  pd<-jd3.PrespecifiedHoliday$new()
  pd$event<-enum_of(jd3.CalendarEvent, event, "HOLIDAY")
  pd$offset<-offset
  pd$weight<-weight
  pd$validity<-validityPeriod(start, end)
  n<-1+length(calendar$prespecified_holidays)
  calendar$prespecified_holidays[[n]]<-pd
}

p2jd_calendar<-function(pcalendar){
  bytes<-pcalendar$serialize(NULL)
  jcal<-.jcall("demetra/calendar/r/Calendars", "Ldemetra/timeseries/calendars/Calendar;",
             "calendarOf", bytes)
  return (jcal)
}

#' Usual trading days variables
#'
#' @param frequency Annual frequency. Should be a divisor of 12
#' @param start Array with the first year and the first period (for instance c(1980, 1) )
#' @param length Length of the variables
#' @param groups Groups of days. The length of the array must be 7. It indicates to what group each week day 
#' belongs. The first item corresponds to Mondays and the last one to Sundays. The group used for contrasts (usually Sundays) is identified by 0.
#' The other groups are identified by 1, 2, ... n (<= 6). For instance, usual trading days are defined by c(1,2,3,4,5,6,0),
#' week days by c(1,1,1,1,1,0,0), week days, Saturdays, Sundays by c(1,1,1,1,1,2,0) etc...
#' @param contrasts If true, the variables are defined by contrasts with the 0-group. Otherwise, raw number of days are provided
#'
#' @return
#' @return The variables corresponding to each group, starting with the 0-group (contrasts=F)
#' or the 1-group (contrasts=T)
#' @examples
td<-function(frequency, start, length, groups=c(1,2,3,4,5,6,0), contrasts=T){
  jdom<-tsdomain_r2jd(frequency, start[1], start[2], length)
  igroups<-as.integer(groups)
  jm<-.jcall("demetra/calendar/r/Calendars", "Ldemetra/math/matrices/MatrixType;",
             "td", jdom, igroups, contrasts)
  return (matrix_jd2r(jm))
}

#' Trading days variables corresponding to a specific calendar
#'
#' @param calendar The calendar
#' @param frequency Annual frequency. Should be a divisor of 12
#' @param start Array with the first year and the first period (for instance c(1980, 1) )
#' @param length Length of the variables
#' @param groups Groups of days. The length of the array must be 7. It indicates to what group each week day 
#' belongs. The first item corresponds to Mondays and the last one to Sundays. The group used for contrasts (usually Sundays) is identified by 0.
#' The other groups are identified by 1, 2, ... n (<= 6). For instance, usual trading days are defined by c(1,2,3,4,5,6,0),
#' week days by c(1,1,1,1,1,0,0), week days, Saturdays, Sundays by c(1,1,1,1,1,2,0) etc...
#' @param contrasts If true, the variables are defined by contrasts with the 0-group. Otherwise, raw number of days are provided
#'
#' @return The variables corresponding to each group, starting with the 0-group (contrasts=F)
#' or the 1-group (contrasts=T)
#' @export
#'
#' @examples
htd<-function(calendar,frequency, start, length, groups=c(1,2,3,4,5,6,0), contrasts=T){
  jdom<-tsdomain_r2jd(frequency, start[1], start[2], length)
  jcal<-p2jd_calendar(calendar)
  jm<-.jcall("demetra/calendar/r/Calendars", "Ldemetra/math/matrices/MatrixType;",
             "htd", jcal, jdom, as.integer(groups), contrasts)
  return (matrix_jd2r(jm))
}

#' Title
#'
#' @param calendar 
#' @param frequency 
#' @param groups 
#'
#' @return The long term means corresponding to each group/period, starting with the 0-group
#' @export
#'
#' @examples
longTermMean<-function(calendar,frequency,groups=c(1,2,3,4,5,6,0)){
  jcal<-p2jd_calendar(calendar)
  jm<-.jcall("demetra/calendar/r/Calendars", "Ldemetra/math/matrices/MatrixType;",
             "longTermMean", jcal, as.integer(frequency), as.integer(groups))
  return (matrix_jd2r(jm))
}

# Examples

belgiumCalendar<-newCalendar()
addFixedDayToCalendar(belgiumCalendar, 7, 21)
addPrespecifiedHolidayToCalendar(belgiumCalendar, "NEWYEAR")
addEasterRelatedDayToCalendar(belgiumCalendar, 1)

M<-td(12, c(1980,1), 120, c(1,1,1,1,1,2,0), contrasts = F)
H<-htd(belgiumCalendar, 12, c(1980,1), 120, c(1,1,1,1,1,2,0), contrasts =F)

MC<-td(4, c(1980,1), 120, c(1,1,1,1,1,2,0), contrasts = T)
HC<-htd(belgiumCalendar, 4, c(1980,1), 120, c(1,1,1,1,1,2,0), contrasts = T)

C12<-longTermMean(belgiumCalendar, 12)
C4<-longTermMean(belgiumCalendar, 4)

C12bis<-longTermMean(belgiumCalendar, 12, c(1,1,1,1,1,2,0))
C4bis<-longTermMean(belgiumCalendar, 4, c(1,1,1,1,1,2,0))

print(C12)
print( C12bis)