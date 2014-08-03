#' Remove players from a set of OCTGN data. 
#' 
#' This function reads a set of OCTGN data and a set of player IDs, then 
#' 
#' @param octgn A data frame of OCTGN data. 
#' @param players A data frame of player IDs. Defaults to NULL. 
#' @param keep Whether to keep the designated IDs (TRUE) or remove them (FALSE). Defaults to FALSE. 
#' @return A data frame of OCTGN data with the designated players removed.
#' @import dplyr
#'   
#' @export

prune.games <- function( octgn, players = NULL, keep = FALSE ) {
 
  if ( keep == FALSE ) {

    octgn <- filter(octgn, !(Corp_Player %in% players) & !(Runner_Player %in% players))
    
  } else if ( keep == TRUE ) {
    
    octgn <- filter(octgn, Corp_Player %in% players | Runner_Player %in% players)
  
  }
    
}