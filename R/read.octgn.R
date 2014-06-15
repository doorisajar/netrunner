#' Read in an Android: Netrunner OCTGN data file. 
#'
#' This function reads a .csv file of Android: Netrunner OCTGN data downloaded from http://octgn.gamersjudgement.com/wordpress/anr/statistics/. 
#' It returns a data frame. The .csv read call sets as.is = TRUE. 
#' 
#' @param octgn.path A file path to a .csv file of OCTGN data.
#' @return octgn.df A data frame wrapped in dplyr::tbl_df for concise display. 
#' @import dplyr
#' 
#' @export

read.octgn <- function( octgn.path ) {
  
  octgn.df <- read.csv(octgn.path, as.is = TRUE)
  octgn.df <- tbl_df(octgn.df)

  # Basic cleanup. This does eliminate 2012 games (about 12,000 of 156,000), because earlier versions
  # didn't include the agenda count or deck size. 
  # The POSIXct conversion is to make it play nice with dplyr.
  octgn.df$GameStart <- parse_date_time(octgn.df$GameStart, "%Y%m%d %H%M%S")
  octgn.df$GameStart <- as.POSIXct(octgn.df$GameStart)
  
  # Convert the player identifiers to numeric in order to play nice with PlayerRatings.  
  octgn.df$Corp_Player   <- as.numeric(octgn.df$Corp_Player)
  octgn.df$Runner_Player <- as.numeric(octgn.df$Runner_Player)
  
  # Coerce identities to factors. "Player_Faction" denotes Corp, "Opponent_Faction" denotes Runner.  
  octgn.df$Corporation <- as.factor(octgn.df$Corporation)
  octgn.df$Runner      <- as.factor(octgn.df$Runner)
  
  # There are six possible outcomes:
  # Corp Loss: Agenda Defeat, Deck Defeat, Conceded
  # Corp Win: Agenda Victory, Flatline Victory, ConcedeVictory
  octgn.df$Result <- as.factor(octgn.df$Result)
  
  # Set Corp win to TRUE, Runner win to FALSE. 
  octgn.df <- mutate(octgn.df, 
                     Win = (Result == "AgendaVictory"   | 
                            Result == "FlatlineVictory" | 
                            Result == "ConcedeVictory"  | 
                            Result == "Flatlined" ) )
  
  return( octgn.df )
  
}