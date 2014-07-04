#' Rate the players in a set of OCTGN data using Glicko.  
#'
#' This function downloads the latest Android: Netrunner OCTGN .csv data file from http://octgn.gamersjudgment.net/
#' 
#' @param player.ratings A data frame produced by rate.players(). 
#' @param min.rating The minimum Glicko rating a player must have to be included. 
#' @return player.ratings A data frame of computed ratings limited to players rated above \code{min.rating}.  
#' @import dplyr
#' 
#' @export

cut.players <- function( player.ratings, min.rating ) {}