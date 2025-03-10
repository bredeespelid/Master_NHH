library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

set.seed(123)



# SSB ---------------------------------------------------------------------


# API URL for SSB JSON-stat dataset
ssb_url <- "https://data.ssb.no/api/v0/dataset/45590.json?lang=no"

# Fetch data from API
response <- GET(ssb_url)

# Check if request was successful
if (status_code(response) == 200) {
  
  # Convert JSON response to R list
  ssb_data <- content(response, as = "text", encoding = "UTF-8")
  ssb_json <- fromJSON(ssb_data, simplifyDataFrame = FALSE)
  
  # Extract values, statuses, and dimensions
  values <- ssb_json$dataset$value
  statuses <- ssb_json$dataset$status  # Status values indicating missing data
  dimensions <- ssb_json$dataset$dimension  
  
  # Extract category labels and index mapping
  tidsperiode_labels <- dimensions$Tid$category$label
  indeks_labels <- dimensions$KonsumgrpJU$category$label
  
  tidsperiode_index <- dimensions$Tid$category$index
  indeks_index <- dimensions$KonsumgrpJU$category$index
  
  # Convert indices to a sorted order for correct mapping
  index_order <- expand.grid(
    Tid = names(tidsperiode_index),
    Indeks = names(indeks_index),
    stringsAsFactors = FALSE
  ) %>%
    arrange(Tid, Indeks)
  
  # Ensure data frame matches the order of values
  df <- index_order
  df$Verdi <- NA  # Initialize value column
  
  # Fill values while handling missing status (".")
  for (i in seq_along(values)) {
    if (!is.null(statuses[[as.character(i)]])) {
      df$Verdi[i] <- NA  # Mark missing values as NA
    } else {
      df$Verdi[i] <- values[i]
    }
  }
  
  # Replace indices with actual labels
  df$Tid <- tidsperiode_labels[df$Tid]
  df$Indeks <- indeks_labels[df$Indeks]
  
  # Convert Verdi column to numeric
  df$Verdi <- as.numeric(df$Verdi)
  
  # **Filtrer kun "KPI Totalindeks, sesongjustert"**
  df <- df %>% filter(Indeks == "KPI Totalindeks, sesongjustert")
  
  # Fjern NA-verdier
  df <- df %>% drop_na(Verdi)
  
  # Vis de første radene
  print(head(df))
  
} else {
  print(paste("Error fetching data. Status code:", status_code(response)))
}


head(df)


library(lubridate)

# Ekstraher år og måned og konverter til datoformat
df <- df %>%
  mutate(
    Year = as.numeric(substr(Tid, 1, 4)),
    Month = as.numeric(substr(Tid, 6, 7)),
    Date = make_date(Year, Month, 1)
  ) %>%
  select(-Year, -Month) %>% 
  filter(Date > "2014-12-01")

# Sjekk resultatet
head(df)


# LLAMA -------------------------------------------------------------------

# Define API URL
ollama.base.url <- "http://localhost:11434"
ollama.url <- paste0(ollama.base.url, "/api/generate")

# JSON Request Payload
generate.graph <- toJSON(list(
  model = "llama3.2",
  prompt = "Write an R script that generates a **simplistic scatter plot** using ggplot2. 
  The script should:
  
  1. Use the excisting dataframe df, which contains:
     - A column named 'Date' (formatted as a Date object) representing time.
     - A column named 'Verdi' representing numerical values.
     - Do not make a dataframe. 
  
  2. Generate a basic scatter plot with:
     - X-axis: 'Date'
     - Y-axis: 'Verdi'
     - Use `geom_point()` to plot individual data points.
     - If applicable, `geom_line()` can be added to connect points, but **avoid extra formatting**.
  
  3. Ensure simplicity by:
     - Removing any grid modifications.
     - Removing unnecessary themes and styling.
     - Avoiding custom color schemes or labels beyond axis titles.
     - Excluding `element_text()` modifications.
     - Ensuring that **only valid** ggplot2 arguments are used.
     - Avoiding `halign`, `linecolor`, and `size` in `geom_line()` (use `linewidth` instead).
  
  4. The script should assume all required packages (ggplot2) are **already installed**.
     - Do **not** include `install.packages()` or any update commands.
  
  5. The script should be self-contained and **runnable without errors**.",
  stream = FALSE
), auto_unbox = TRUE)

# Make API Call
response.graph <- POST(
  url = ollama.url,
  body = generate.graph,
  encode = "json",
  content_type_json()
)

# Parse Response
response.graph.text <- content(response.graph, as = "text", encoding = "UTF-8")
response.graph.json <- fromJSON(response.graph.text)

# Extract the generated R code
generated_code <- response.graph.json$response

# Use regex to extract R code block
code_block <- str_match(generated_code, "(?s)```r\\n(.*?)```")[,2]

# Print the extracted code for verification
cat("Extracted R Code:\n", code_block, "\n")

# Execute the extracted code if valid
if (!is.na(code_block) && nchar(code_block) > 0) {
  eval(parse(text = code_block))
} else {
  cat("No valid R code extracted.\n")
}
