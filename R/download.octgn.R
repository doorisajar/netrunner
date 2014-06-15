#' Read in an Android: Netrunner OCTGN data file. 
#'
#' This function downloads the latest Android: Netrunner OCTGN data file from http://octgn.gamersjudgment.net/
#' 
#' @param quietly If TRUE, don't display any messages or a progress bar while downloading.  
#' @import httr stringr
#' 
#' @export

download.octgn <- function( quietly = TRUE ) {
  
  page <- content( GET( url = "http://octgn.gamersjudgement.com/", path = "wordpress/anr/statistics/" ), 
                   as = "parsed",
                   type = "text/html" )
  
  page <- getHTMLLinks( page )
  
  page <- page[which( str_detect( page, "drive.google.com" ) )]
  
#  path <- substr( page, start = 25, stop = nchar( page ) )  
  path <- unlist( strsplit( page, "file" ) )[2]
  path <- unlist( strsplit( path, "edit" ) )[1]
  
#   Got a token, but the official way still throws a 404. ??? 

  path <- substr( path, start = 4, stop = nchar( path ) - 1 ) 
  octgn <- GET( url = "https://www.googleapis.com/drive/v2/files/", 
                path = paste0(path,
                              "?fields=downloadUrl&?key=ya29.LgAHpoOw8iYIdSAAAAAOzgpFvdkOBWvhF_pytIT_H3nk4xiSwR_UAUkc2skzTA" ) )  




#   octgn <- content( GET( url = "https://docs.google.com/", path = paste0( "file", path, "edit" ) ),
#                     as = "text" )

# Example downloadUrl: 
#
#   "downloadUrl":"https://docs.google.com/uc?id\u003d0B-gMiPlH3rBANWVVZXR5OTBENlU\
#   u0026export\u003ddownload\u0026revid\u003d0B-gMiPlH3rBAaGYyRmpKMm5uYmJrdVRaZHZBTTRlTDlVSExJPQ"

  octgn <- str_extract( octgn, pattern = "(downloadUrl\":\")(.*?)\"" )

  octgn <- substr( octgn, start = 39, stop = nchar( octgn ) - 1 )

  test <- content( GET( url = "https://docs.google.com/", path = octgn ),
                   type = "text/csv" )


# "https://doc-14-bo-docs.googleusercontent.com/docs/securesc/o7l0aeqi0drljltr83c3565k9441n6of/fj2cr1s72ajlfidfqo88uc7lmvmimvvt/1402804800000/07708637904532248706/13058876669334088843/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download&gd=true"
#  https://doc-00-4o-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/v8rqrt2sp9hcbc2fqhjrstutsusqv19g/1402804800000/07708637904532248706/*/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download

  test <- content( GET( url = "https://doc-00-4o-docs.googleusercontent.com/",
                        path = "docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/v8rqrt2sp9hcbc2fqhjrstutsusqv19g/1402804800000/07708637904532248706/*/0B-gMiPlH3rBANWVVZXR5OTBENlU?h=16653014193614665626&e=download"
                        ), 
                   type = "text/csv"
                   ) 

}