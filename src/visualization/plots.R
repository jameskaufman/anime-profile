#install.packages("ggplot2", repos="http://cran.rstudio.com/")
#install.packages("waffle", repos="http://cran.rstudio.com/")
library(ggplot2)
library(waffle)

# Generates a scatterplot showing correlation between global anime 
# ratings and a user's anime ratings
#
# Parameters: Valid animelist dataframe
scores_scatterplot <- function(comp_data) {
	ggplot(comp_data, aes(x = local_score, y = global_score)) + 
		   geom_point(color = "mediumseagreen", size = 3) + 
		   geom_smooth(method = "lm", col = "black") +
    	   labs(title = "Correlation Scatterplot", subtitle = "Global Score vs. User Score",
   		 	 	x = "User Scores", y = "Global Scores")
}

# Generates a scatterplot showing correlation between global anime 
# popularity and a user's anime ratings
#
# Parameters: Valid animelist dataframe
popularity_scatterplot <- function(comp_data) {
	comp_data$members <- gsub(',', '', comp_data$members)
	options(scipen = 5)

	ggplot(comp_data, aes(x = local_score, y = as.integer(members))) + 
		   geom_point(color = "lightcoral", size = 3) + 
		   geom_smooth(method = "lm", col = "black") +
    	   labs(title = "Correlation Scatterplot", subtitle = "Popularity vs. User Score",
   		 	 	x = "User Scores", y = "Total Number of Members")
}

# Generates a diverging bars graph to show how much higher or lower
# a user's ratings are from the global average.
#
# Parameters: Valid animelist dataframe
scores_delta_plot <- function(comp_data) {
	# Generate new field for score deltas
	comp_data$'score_delta' <- (comp_data$local_score - comp_data$global_score)
	comp_data$'delta_color' <- ifelse(comp_data$score_delta < 0, "below", "above")
	comp_data <- comp_data[order(comp_data$score_delta), ] 

	# Ensure that the order of shows by delta value is preserved
	comp_data$title <- factor(comp_data$title, levels = comp_data$title)

	# Make the visualization
	ggplot(comp_data, aes(x = title, y = score_delta)) +
		   geom_bar(stat = "identity", aes(fill = delta_color), width = .5) +
		   scale_fill_manual(name = "", labels = c("User rated higher", "User rated lower"),
		   					 values = c("above" = "forestgreen", "below" = "firebrick")) +
		   coord_flip() +
		   labs(title = "Difference Between User \n Scores and Global Scores",
		   		x = "Title", y = "Rating Delta")
}

# Generates a histogram showing the frequency of a user's ratings and
# the distribution of those ratings.
#
# Parameters: Valid animelist dataframe
scores_distribution <- function(comp_data) {
	ggplot(comp_data, aes(x = local_score)) + 
		   geom_histogram(binwidth = 1, colour = "black", fill = c(rep("red2", 2), rep("green4", 5)), # fill = c(rep("red2", 6), rep("green4", 5)),
		   				  alpha =  c(.2, 0, .2, .4, .6, .8, 1.0)) + # c(1, .8, .6, .4, .2, 0, .2, .4, .6, .8, 1.0)) +
		   scale_x_continuous(breaks = 0:10) +
    	   labs(title = "Distribution of Scores", subtitle = "Frequency vs. User Score",
   		 		color = "Age Rating", x = "User Rating", y = "Frequency")

}

# Generates a waffle chart (square pie chart) showing the composition of
# the population by its age rating.
#
# Parameters: Valid animelist dataframe
age_waffle <- function(comp_data) {
	categ_table <- table(comp_data$age_rating)
	waffle(categ_table, rows = ceiling(sqrt(nrow(comp_data))), 
		   			    colors = c("#442B48", "#F85A3E", "#08A045", "#ED254E", "#3E8989")) +
    	   labs(title = "Categorical Composition by Age Rating",
   		   		caption = "Each box reqpresents 1 entry")
}

# Generates a waffle chart (square pie chart) showing the composition of
# the population by its source material.
#
# Parameters: Valid animelist dataframe
source_waffle <- function(comp_data) {
	categ_table <- table(comp_data$source)
	waffle(categ_table, rows = ceiling(sqrt(nrow(comp_data)))) +
    	   labs(title = "Categorical Composition by Source Material",
   		 		caption = "Each box reqpresents 1 entry") 
}

# Generates a histogram showing the frequency of anime studios on
# a user's list
#
# Parameters: Valid animelist dataframe
studio_frequency <- function(comp_data) {
	ggplot(comp_data, aes(x = reorder(studio, studio, function(x) - length(x)))) + 
		   geom_bar(fill = "mediumseagreen") +
    	   labs(title = "Frequency of Anime Studios", subtitle = "Count vs. Studio",
   		 		x = "Anime Studio", y = "Frequency") +
    	   coord_flip()
}

# Generates a histogram showing the frequency of the year that 
# shows aired.
#
# Parameters: Valid animelist dataframe
year_frequency <- function(comp_data) {
	comp_data <- comp_data[grep("n/a", comp_data$season, invert = TRUE), ]
	comp_data$season <- sub("^\\S+\\s+", '', comp_data$season)

	ggplot(comp_data, aes(x = reorder(season, season, function(x) - length(x)))) + 
		   geom_bar(fill = "tomato3") +
    	   labs(title = "Frequency of Anime Years", subtitle = "Count vs. Year",
   		 		x = "Airing Date", y = "Frequency") +
    	   coord_flip()
}

# Read data into dataframe
comp_data <- read.csv("completed.csv", stringsAsFactors = FALSE)
comp_data <- comp_data[grep("n/a", comp_data$global_rank, invert = TRUE), ]
comp_data$global_score <- as.numeric(comp_data$global_score)

# Plot all visualizations
scores_scatterplot(comp_data) 
popularity_scatterplot(comp_data)
scores_delta_plot(comp_data)
scores_distribution(comp_data)
age_waffle(comp_data)
source_waffle(comp_data)
studio_frequency(comp_data)
year_frequency(comp_data)