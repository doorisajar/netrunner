#' Get a list of data packs. 
#'
#' Create a data frame with the data pack as an ordered factor and the version number associated with it. Needs to be updated with each OCTGN version; would be very nice if it scraped db0's GitHub NEWS page and updated itself accordingly. 
#' 
#' @return A data frame listing each data pack with its version number as an ordered factor. 
#' @import dplyr stringr

get.data.packs <- function() {
  
  #-----------------------------------------------------------------------------
  # DATA PACKS
  #-----------------------------------------------------------------------------
  
  # Use version number to determine which data packs were included. 
  
  # List of plugin versions associated with data packs, for reference. 
  # "3.11.0","Upstalk"
  # "3.10.0","Honor and Profit"
  # "3.9.0","Double Time"
  # "3.8.0","Fear and Loathing"
  # "3.7.0","True Colors"
  # "3.6.0","Mala Tempora"
  # "3.5.0","Second Thoughts"
  # "3.3.0","Opening Moves"
  # "3.2.0","Creation and Control"
  # "3.1.0","Future Proof"
  # "3.0.0","Humanity's Shadow"
  # "2.3.0","A Study in Static"
  # "2.2.0","Cyber Exodus"
  # "2.1.0","Trace Amount"
  # "2.0.0","What Lies Ahead"
  
  # Consolidate all packs into a df. 
  data.packs <- data.frame(rep( (20:39) / 10 ), 
                           c("What Lies Ahead",
                             "Trace Amount",
                             "Cyber Exodus",
                             "A Study in Static",
                             "A Study in Static",
                             "A Study in Static",
                             "A Study in Static",
                             "A Study in Static",
                             "A Study in Static",
                             "A Study in Static",
                             "Humanity's Shadow",
                             "Future Proof",
                             "Creation and Control",
                             "Opening Moves",
                             "Opening Moves",
                             "Second Thoughts",
                             "Mala Tempora",
                             "True Colors",
                             "Fear and Loathing",
                             "Double Time"))
  
  names(data.packs) <- c("Version", "Pack")
  
  data.packs$Pack <- ordered(data.packs$Pack, c("What Lies Ahead",
                                                "Trace Amount",
                                                "Cyber Exodus",
                                                "A Study in Static",
                                                "Humanity's Shadow",
                                                "Future Proof",
                                                "Creation and Control",
                                                "Opening Moves",
                                                "Second Thoughts",
                                                "Mala Tempora",
                                                "True Colors",
                                                "Fear and Loathing",
                                                "Double Time",
                                                "Honor and Profit",
                                                "Upstalk",
                                                "The Spaces Between",
                                                "First Contact",
                                                "Up and Over",
                                                "All that Remains",
                                                "The Source",
                                                "Order and Chaos"
  )
  )
  
  data.packs <- select(data.packs, Version:Pack)
  data.packs$Version <- as.character(data.packs$Version)
  data.packs$Version[1] <- "2.0"
  data.packs$Version[11] <- "3.0"
  
  
  data.packs <- rbind(data.packs, 
                      c("3.10", "Honor and Profit"), 
                      c("3.11", "Upstalk"),
                      c("3.12", "The Spaces Between"),
                      c("3.13", "First Contact"),
                      c("3.14", "Up and Over"),
                      c("3.15", "All that Remains"),
                      c("3.16", "The Source"),
                      c("3.17", "Order and Chaos"))
  
  data.packs$Version <- str_pad(string = data.packs$Version, width = 4, side = "right", pad = ".")
  
  return( data.packs )
  
}