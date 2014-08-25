#' Read in an Android: Netrunner OCTGN data file.
#' 
#' This function reads a .csv file of Android: Netrunner OCTGN data downloaded
#' from http://octgn.gamersjudgement.com/wordpress/anr/statistics/. It returns a
#' data frame. To the existing columns, it adds a Win column where a Corporation
#' win is TRUE and a Runner win is FALSE. This is used by the player rating
#' function.
#' 
#' @param octgn.path A file path to a .csv file of OCTGN data.
#' @param pack.rm Whether to remove games without data pack information.
#'   Defaults to TRUE.
#' @param id.rm A character vector of IDs to remove. Defaults to 'Shaper: The Collective'. 
#' @return A data frame wrapped in dplyr::tbl_df for concise display.
#' @import dplyr
#' @importFrom lubridate parse_date_time
#'   
#' @export

read.octgn <- function( octgn.path, pack.rm = TRUE, id.rm = c('Shaper | The Collective') ) {
  
  octgn.df <- read.csv(octgn.path, as.is = TRUE)
  octgn.df <- tbl_df(octgn.df)

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
  
  data.packs <- get.data.packs()
  
  # Need to match the versions in this df to the versions in octgn.df. 
  # Follow this form:
  #
  # substr(octgn.df$Version[1], 1, 3)
  # 
  # For each 1:3 chars in octgn.df$Version, I want to match with data.packs$Version and populate a new
  # column in octgn.df with the associated data pack. 
  #
  # Write a simple match function to take a character string of the form "x.x" and return the most recent
  # data pack. 
  CheckPack <- function(x, data.packs) {
    return( data.packs$Pack[match( substr(x, 1, 3), data.packs$Version )] )
  }
  
  octgn.df <- octgn.df %>% 
                mutate(Pack = CheckPack(octgn.df$Version, data.packs)) %>%
                filter(!(Runner %in% id.rm | Corporation %in% id.rm))
  
  if (pack.rm == TRUE) {
    octgn.df <- filter(octgn.df, Pack %in% levels(data.packs$Pack))
  }

  
  
  return( octgn.df )
  
}