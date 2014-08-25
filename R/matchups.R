#' Compute matchup winrates by ID over a set of games. 
#'
#' This function takes a set of games provided in a data frame and computes the winrates for each ID against each ID on the other side. 
#'
#' @param octgn A data frame matching the structure produced by read.octgn(). 
#' @param period A period over which to compute winrates. By default, \code{pack}, which computes winrates for the periods between each data pack release. Can also be time durations such as \code{week} or \code{month}.
#' @return A data frame of IDs and matchup winrates by period. 
#' @import dplyr
#' @importFrom lubridate floor_date
#' 
#' @export

matchups <- function(octgn, period = "pack") {

  if ( period == "pack" ) {
    
    octgn$Period <- octgn$Pack
    
  } else if ( period == "week" | period == "month" | period == "year" ) {
    
    # Take the date floor of each period.   
    octgn$Period <- floor_date(octgn$GameStart, period)
    
  } else {
    
    message("Period argument not accepted, please use pack, week, month, or year.")
    
  }
  
  
  matchups.df <- octgn %>%
                    group_by(Corporation, Runner, Period) %>%
                    summarise(CorpWins = sum(Win) / length(Win),
                              RunWins = 1 - CorpWins,
                              Games = n())

  return(matchups.df)

}