# ============================================================
# DATALAB WORKSHOP - PARTICIPANT TEMPLATE
# Making Sense of Data: A Beginner's Guide
# ============================================================

# STEP 1: SETUP
# Run this section first to load the package and data
library(datalab)

# Load the heart disease dataset
data(heart_data)
data <- heart_data

# Take a quick look at your data
head(data)


# ============================================================
# SECTION 1: YOUR FIRST VISUALIZATION
# ============================================================

# Create a pie chart to see types of chest pain
piechart(chest_pain_type)

# YOUR TURN: Create a pie chart for sex
# Type your code below:



# ============================================================
# SECTION 2: COMPARING GROUPS
# ============================================================

# Compare chest pain types between males and females
piechart(chest_pain_type, sex)

# YOUR TURN: Create a boxplot comparing age by sex
# Type your code below:



# ============================================================
# SECTION 3: UNDERSTANDING DISTRIBUTIONS
# ============================================================

# See the distribution of age
boxplot(age)

# See how age differs by sex
boxplot(age, group = sex)

# YOUR TURN: Create a boxplot for resting_bp (resting blood pressure)
# Type your code below:



# ============================================================
# SECTION 4: FINDING PATTERNS
# ============================================================

# Load the agriculture dataset
data(agriculture_data)
data <- agriculture_data

# See the relationship between nitrogen and crop yield
linechart(nitrogen_content, crop_yield)

# YOUR TURN: Add a smooth line to see the trend better
# Hint: Add smooth = TRUE to your linechart
# Type your code below:



# ============================================================
# SECTION 5: SUMMARY STATISTICS
# ============================================================

# Go back to heart data
data(heart_data)
data <- heart_data

# Get summary statistics for age
descriptives(age)

# Get summary statistics for multiple variables
descriptives(age, resting_bp, cholesterol)

# YOUR TURN: Get statistics for just cholesterol
# Type your code below:



# ============================================================
# SECTION 6: COUNTING CATEGORIES
# ============================================================

# Count how many of each chest pain type
frequencies(chest_pain_type)

# Count and sort by most common
frequencies(chest_pain_type, sort = "desc")

# YOUR TURN: Create a frequency table for sex
# Type your code below:



# ============================================================
# EXERCISE 1: TELL A STORY
# ============================================================

# Task: Answer this question using charts and statistics:
# "Is there a difference in cholesterol levels between males and females?"

# Step 1: Create a boxplot comparing cholesterol by sex




# Step 2: Get descriptive statistics for cholesterol




# Step 3: Write your answer in a comment below:
# My finding: 


# ============================================================
# EXERCISE 2: EXPLORE ON YOUR OWN
# ============================================================

# Choose any two variables and create visualizations to explore them
# Write your code below:






# ============================================================
# EXERCISE 3: YOUR OWN DATA (OPTIONAL)
# ============================================================

# If you have your own CSV file, load it here:
# data <- read.csv("your_file.csv")

# Then use any of the functions above to explore it!


# ============================================================
# QUICK REFERENCE
# ============================================================

# linechart(x, y)           - Line chart
# boxplot(var)              - Distribution of one variable
# boxplot(var, group = g)   - Compare distributions
# piechart(var)             - Pie chart
# piechart(var, filter)     - Multiple pie charts
# descriptives(var1, var2)  - Summary statistics
# frequencies(var)          - Count categories

# To get help: ?function_name
# Example: ?linechart