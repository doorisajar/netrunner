#' Rate the players in a set of OCTGN data using Glicko.  
#'
#' This function downloads the latest Android: Netrunner OCTGN .csv data file from http://octgn.gamersjudgment.net/
#' 
#' @param octgn.df A data frame produced by read.octgn(). 
#' @param period A duration, such as \code{"week"} or \code{"month"}. Ratings are computed over each period. For ANR OCTGN data, \code{"week"} is generally best and is the defaut. 
#' @param history If \code{TRUE}, save and return rating history in \code{player.ratings}.
#' @param init Initialization parameters for the Glicko algorithm. By default, a 1500 initial rating and 350 deviation. 
#' @return player.ratings A data frame of computed ratings, optionally with rating history.  
#' @import lubridate PlayerRatings dplyr
#' 
#' @export

rate.players <- function( octgn.df, period = "week", history = FALSE, init = c(1500, 350) ) {
  
  # Take the date floor of each period to divide the games up for Glicko.   
  octgn.df$Period <- floor_date(octgn.df$GameStart, period)
  
  #-----------------------------------------------------------------------------
  # COMPUTING PLAYER RATINGS
  #-----------------------------------------------------------------------------
  
  # Use PlayerRatings package to compute Glicko rating for each player. Glicko requires the data to have:
  # 1. Time block as numeric.
  # 2. Numeric or character identifier for player one. 
  # 3. Numeric or character identifier for player two.
  # 4. The result of the game expressed as numeric -- 1 for P1 win, 0 for P2 win, 0.5 for draw.   
  ratings <- select(octgn.df, Period, Corp_Player, Runner_Player, Win)
  
  # Convert Win/Loss factor to 1/0. 
  ratings$Win <- as.numeric(ratings$Win)
  
  # Convert the Period "dates" to a factor and then to a numeric in order to pass them to glicko(). 
  ratings$Period <- cut(ratings$Period, breaks = period.select)
  ratings$Period <- as.numeric(ratings$Period)
  
  # Note that per its creator, Glicko works best when each player is playing 5-10 games per rating period. 
  ratings <- glicko(ratings, history = history, sort = TRUE, init = init)
  
  # Now I have ratings for each player in each period. 
  player.ratings <- tbl_df(ratings$ratings)
  
  return( player.ratings )
  
}