#' Compute winrates for Runner IDs in a set of games.
#'
#' This function takes a set of games provided in a data frame and computes the winrates for each Runner ID in the data during specified periods of time. 
#' 
#' @param octgn A data frame matching the structure produced by read.octgn(). 
#' @param period A period over which to compute winrates. By default, \code{pack}, which computes winrates for the periods between each data pack release. Can also be time durations such as \code{week} or \code{month}.
#' @return A data frame of Runner IDs and winrates by period. 
#' @import dplyr
#' @importFrom lubridate floor_date
#' 
#' @export

runner.winrates <- function( octgn, period = "pack" ) {
  
  if ( period == "pack" ) {
    
   octgn.df$Period <- octgn.df$Pack
    
  } else if ( period == "week" | period == "month" | period == "year" ) {
  
    # Take the date floor of each period.   
    octgn.df$Period <- floor_date(octgn.df$GameStart, period)

  } else {
    
    message("Period argument not accepted, please use pack, week, month, or year.")
    
  }
  
  
  runwins.df <- octgn.df %>% 
                 tbl_df() %>%
                 group_by(Runner, Period) %>%
                 summarise(Games = n(),
                           Winrate = 1 - sum(Win) / Games)
    
  return(runwins.df)
  
}