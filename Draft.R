

# 1. Install and load package
if (!requireNamespace("pdftools", quietly = TRUE)) {
  install.packages("pdftools")
}
library(pdftools)

# 2. Load all PDFs from Documents folder
files <- list.files("Documents", pattern = "\\.pdf$",
                    full.names = TRUE, ignore.case = TRUE)

if (length(files) == 0) stop("No PDFs found in Documents folder.")

pages <- data.frame()

for (file in files) {
  pdf <- pdf_text(file)
  
  for (i in seq_along(pdf)) {
    pages <- rbind(pages, data.frame(
      document = basename(file),
      page = i,
      text = pdf[i]
    ))
  }
}

cat("Loaded", length(files), "documents!\n")

# 3. AI search function
ask_ai <- function(question) {
  
  # Break the question into keywords
  words <- tolower(unlist(strsplit(
    gsub("[^a-zA-Z0-9 ]", " ", question), " +"
  )))
  
  words <- unique(words[nchar(words) > 3])
  
  if (length(words) == 0) {
    cat("Please ask a more specific question.\n")
    return(invisible(NULL))
  }
  
  # Split pages into smaller passages
  passages <- data.frame()
  
  for (i in seq_len(nrow(pages))) {
    text <- gsub("\\s+", " ", pages$text[i])
    starts <- seq(1, nchar(text), by = 1000)
    
    for (s in starts) {
      passages <- rbind(passages, data.frame(
        document = pages$document[i],
        page = pages$page[i],
        text = substr(text, s, s + 999)
      ))
    }
  }
  
  # Score each passage based on matching keywords
  scores <- sapply(passages$text, function(text) {
    sum(vapply(words, function(w) {
      grepl(paste0("\\b", w, "\\b"),
            tolower(text), perl = TRUE)
    }, logical(1)))
  })
  
  best <- which.max(scores)
  
  if (length(best) == 0 || scores[best] == 0) {
    cat("No matching information found.\n")
    return(invisible(NULL))
  }
  
  # Display answer and source
  cat("\nQUESTION:", question, "\n\n")
  cat("MOST RELEVANT ANSWER:\n")
  cat(passages$text[best], "\n\n")
  cat("SOURCE:", passages$document[best], "\n")
  cat("PAGE:", passages$page[best], "\n")
}

# 4. Ask your question here!
ask_ai("What are the responsibilities of cadets?")

