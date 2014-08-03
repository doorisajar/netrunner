#' Read in an Android: Netrunner OCTGN data file.
#' 
#' This function downloads the latest Android: Netrunner OCTGN .csv data file
#' from http://octgn.gamersjudgment.net/... or it will when it works.
#' 
#' @param write If TRUE, write the downloaded file out as a .csv.
#' @return If \code{write = FALSE}, return the downloaded data as a
#'   data frame. Otherwise, write a CSV file. 
#' @import httr stringr dplyr


download.octgn <- function( write = FALSE ) {
  
#   https://doc-00-4o-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/tr9ue5nv8i4a377l8ngq6lc5h7fkvkeh/1404496800000/07708637904532248706/*/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download
  
  octgn.df <- content( GET( url = "https://doc-00-4o-docs.googleusercontent.com/",
                         path = "docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/v8rqrt2sp9hcbc2fqhjrstutsusqv19g/1402804800000/07708637904532248706/*/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download"
                        ), 
                    type = "text/csv"
                  ) 

  if ( write == TRUE ) {
    
    write.csv(file = "octgn.csv", col.names = FALSE)
    invisible()
  
  } else {
    
    return( octgn.df )
  
  }
  
  
  
# What follows is a bunch of messing about trying to automatically extract the file ID from db0's site
# (which works) so that I can always download the latest file from Google Drive (which does not work).
#
# Unclear why OAuth is needed to download a public file. 
  
#   page <- content( GET( url = "http://octgn.gamersjudgement.com/", path = "wordpress/anr/statistics/" ), 
#                    as = "parsed",
#                    type = "text/html" )
#   
#   page <- getHTMLLinks( page )
#   
#   page <- page[which( str_detect( page, "drive.google.com" ) )]
#   
# #  path <- substr( page, start = 25, stop = nchar( page ) )  
#   path <- unlist( strsplit( page, "file" ) )[2]
#   path <- unlist( strsplit( path, "edit" ) )[1]
#   
# #   Can't use web OAuth tokens, need to actually obtain a login token. 
# #   Also, even for this public doc, the webContentLink download method doesn't work. 
# 
#   path <- substr( path, start = 4, stop = nchar( path ) - 1 ) 
#   fields <- "downloadUrl"
#   key <- "ya29.LgCCf6D6_mLm_SAAAAAamjyWJHRU698eTbHWEmEy8FpOzZIVoCUfDq47J7yE6Q"
# 
#   octgn <- GET( url = "https://www.googleapis.com/drive/v2/files/", 
#                 path = path,
#                 add_headers( fields = "webContentLink" ) )  
 


#   octgn <- content( GET( url = "https://docs.google.com/", path = paste0( "file", path, "edit" ) ),
#                     as = "text" )

# Example downloadUrl: 
#
#   "downloadUrl":"https://docs.google.com/uc?id\u003d0B-gMiPlH3rBANWVVZXR5OTBENlU\
#   u0026export\u003ddownload\u0026revid\u003d0B-gMiPlH3rBAaGYyRmpKMm5uYmJrdVRaZHZBTTRlTDlVSExJPQ"
#
#   octgn <- str_extract( octgn, pattern = "(downloadUrl\":\")(.*?)\"" )
# 
#   octgn <- substr( octgn, start = 39, stop = nchar( octgn ) - 1 )
# 
#   test <- content( GET( url = "https://docs.google.com/", path = octgn ),
#                    type = "text/csv" )


# "https://doc-14-bo-docs.googleusercontent.com/docs/securesc/o7l0aeqi0drljltr83c3565k9441n6of/fj2cr1s72ajlfidfqo88uc7lmvmimvvt/1402804800000/07708637904532248706/13058876669334088843/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download&gd=true"
#  https://doc-00-4o-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/v8rqrt2sp9hcbc2fqhjrstutsusqv19g/1402804800000/07708637904532248706/*/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download


}