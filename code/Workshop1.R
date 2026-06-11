# MB5370: Introduction to Programming
#title: "Wrangling_Plotting_M2W1"
#author: "Ryan Waln"
#date: "2026-06-02"
#output: html_document

  # Introduction

# This file covers basic data wrangling techniques, including:
# - importing data 
# - formatting data for R 
# - Tidyverse tibbles vs base R data frames
# - piping 
# - mutating data 
# - basic NA value handling

  # R Setup & housekeeping
rm(list=ls())
objects()

  # Creating a Standalone Clone of a Repository
 
## Get git credentials
#credentials::git_credential_ask()  

## see Git status
#usethis::git_sitrep()

## severs connection to original repository to allow storage in own GitHub after cloning for when working alone
#gert::git_remote_remove("origin") 


  # Housekeeping
  
# Inventory every active object currently residing in session RAM
objects()
# Purge global environment
rm(list = ls())
# Confirm that global session memory now completely vacant
objects()

# In global options: Uncheck the box that says: Re-restore .RData into workspace at startup and set to Never

unlink("~/.RData") #Prevent old hanging code and values from screwing up current code



  # Packages
  
#install.packages("gert")
#install.packages("usethis")
#install.packages("here")
#install.packages("tidyverse")
#install.packages("readxl")


library("gert")
library("usethis")
library("here")
library("tidyverse")
library("readxl")



  # Importing Data
 
# Importing Different File types
 
# Practice Import A: Loading a standard comma-separated plain text file
benthic_cover <- read_csv(here::here("data/reef_cover_log.csv"))

# Practice Import B: Parsing a tab-separated telemetry instrument array string
acoustic_stream <- read_tsv(here::here("data/acoustic_telemetry_stream.txt"))

# Practice Import C: Targeting a specific sheet in a multi-tab Excel spreadsheet
fisheries_annual <- read_excel(here::here("data/fish_catch_data.xlsx"), sheet = "Commercial_2026")



  # Data not formatted for R:

# Read in mangrove_data
mangrove_data <- read_csv(file = here::here("data/mangrove_survey_raw.csv"))

# Format data

# Use args within read_csv to skip headers and declare missing flags
mangrove_data <- read_csv(
  here::here("data/mangrove_survey_raw.csv"),
  skip = 5,   # Skip the first 5 lines of field notes
  na = c(".", "NA", "9999", "ND", "blank"))  # Convert known text alts to true NA

# Note to omit all comments from excel files when formating for R


  # Tidyverse Tibble vs base R Datframes (tibble lets you spot errors)

# Force a modern tibble to degrade into a legacy base R data frame structure
benthic_cover_df <- as.data.frame(benthic_cover)
# Print the old-style dataframe structure to view
print(benthic_cover_df)
# And compare with tibble alternative
print(benthic_cover)

# Tibbles allow you to see what type of data each column is to prevent data modificaion errors

  # Wrangling out ecological signals using Palmer Penguins dataset
  
#install.packages("palmerpenguins")
library(palmerpenguins)
data("penguins")

# Examine the structure of the data set - always do this when loading a new dataset!
glimpse(penguins) # tidyverse version (from dplyr package)
str(penguins) # base R version

# Palmerpenguins measures morphological characteristics of individual penguins of 3 species on 3 different islands
# Can compare morphological varriation and trends across spatial scales


  # Types of variables
# <fct> (Factor): Categorical groupings with fixed levels (e.g., species containing Adelie, Chinstrap, and Gentoo).
# <dbl> (Double): Continuous numeric measurements containing decimals (e.g., bill_length_mm).
# <int> (Integer): Whole number variables, usually to track counts, (e.g., body_mass_g).

# Generate an exploratory summary matrix
summary(penguins)

# Vertically slice specific morphometric variables by explicit name
morphology_metrics <- select(penguins, species, bill_length_mm, bill_depth_mm, body_mass_g)
glimpse(morphology_metrics)

# Retain a continuous block of attributes using the colon operator
spatial_block <- select(penguins, species:island)

# Discard logistics tracking attributes while preserving everything else using the minus sign
clean_scientific_fields <- select(penguins, -year)



  # The Pipe |> or %>% (used to prevent clutter in Enviornment tab by linking functions together)
  
# Without a Pipe: You have to read the code "inside-out." You start in the middle, perform the mutate(), then wrap that in a filter(), and finally wrap that all in a select().
  
# With a Pipe: You read from left to right, or top to bottom. You take your data, then you filter it, then you mutate it to create a new column, then you select the columns you need.
  
# Example Syntax 
  
  # Typical 
 
penguins_subset <- mutate(penguins, bill_ratio = bill_length_mm / bill_depth_mm)
penguins_final <- filter(penguins_subset, species == "Adelie")

  # Pipe

penguins_final <- penguins |>
  mutate(bill_ratio = bill_length_mm / bill_depth_mm) |>
  filter(species == "Adelie")



  # Mutating Data
  
# Mutating is how we modify data
  
# Calculate a new morphological ratio in our environment
penguin_ratios <- penguins  |> 
  mutate(body_mass_kg = body_mass_g / 1000,   # Convert grams to kilograms
         bill_ratio = bill_length_mm / bill_depth_mm  # Bill ratio
  )

# View your newly engineered variables appended to the far-right columns
glimpse(penguin_ratios)



    # Missing Value Trap: NA values stop functions from working

# Grouping our active memory penguins by species
grouped_penguins <- group_by(penguins, species)

# Notice that the table looks identical, but metadata notes 'Groups: species [3]'
print(grouped_penguins)

# Collapsing the buckets into explicit summary metrics
species_mass_summary <- summarise(grouped_penguins,
                                  mean_mass_g = mean(body_mass_g)
)

print(species_mass_summary)


# Overcoming the missing value trap using na.rm = TRUE
biological_signal <- penguins %>%
  group_by(species, sex) %>%
  summarise(
    sample_size = n(),                                     # Count total individuals per category
    mean_mass_g = mean(body_mass_g, na.rm = TRUE),         # Calculate mean ignoring missing cells
    sd_mass_g   = sd(body_mass_g, na.rm = TRUE)            # Standard deviation calculation
  )

print(biological_signal) #penguins now grouped by species and sex for mean mass




  # Plotting
 
  # Grammer of Graphics
  
  ## The Data Layer: Declaring the source dataset table object.
  ## The Aesthetic Mapping (aes): Defining which variables are mapped to structural axes, colors, shapes, or sizes.
  ## The Geometric Layer (geom_...): Defining the visual shape that represents the numbers (e.g., points, bars, lines, or boxplots).
  
# After sorting data in basic R script, use a .qmd file to render work into a professional HTML document

