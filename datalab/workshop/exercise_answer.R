# ============================================================
# EXERCISE ANSWERS - FOR FACILITATORS
# ============================================================

library(datalab)
data(heart_data)
data <- heart_data

# ============================================================
# SECTION 1 ANSWER
# ============================================================
piechart(sex)


# ============================================================
# SECTION 2 ANSWER
# ============================================================
boxplot(age, group = sex)


# ============================================================
# SECTION 3 ANSWER
# ============================================================
boxplot(resting_bp)


# ============================================================
# SECTION 4 ANSWER
# ============================================================
data(agriculture_data)
data <- agriculture_data
linechart(nitrogen_content, crop_yield, smooth = TRUE)


# ============================================================
# SECTION 5 ANSWER
# ============================================================
data(heart_data)
data <- heart_data
descriptives(cholesterol)


# ============================================================
# SECTION 6 ANSWER
# ============================================================
frequencies(sex)


# ============================================================
# EXERCISE 1 ANSWER
# ============================================================

# Step 1: Create a boxplot comparing cholesterol by sex
boxplot(cholesterol, group = sex)

# Step 2: Get descriptive statistics for cholesterol
descriptives(cholesterol)

# Step 3: Possible answer
# "The boxplot shows that males tend to have slightly higher cholesterol levels
# than females, with males having a median around 245 mg/dl and females around
# 235 mg/dl. Both groups show similar variation. The difference appears small
# but consistent."


# ============================================================
# EXERCISE 2 EXAMPLE
# ============================================================

# Example: Exploring relationship between age and resting blood pressure
linechart(age, resting_bp, smooth = TRUE)
descriptives(age, resting_bp)

# Example: Distribution of cholesterol by chest pain type
boxplot(cholesterol, group = chest_pain_type)


# ============================================================
# COMMON TEACHING POINTS
# ============================================================

# 1. Emphasize that there's no single "right" chart - it depends on what 
#    question you're asking

# 2. Remind participants to look at BOTH visualizations AND statistics

# 3. Encourage them to write their interpretations in plain language

# 4. For pie charts with filters: point out how colors differ between charts
#    to make comparison easier

# 5. If participants get "variable not found" errors, check:
#    - Spelling of variable name
#    - Whether they loaded the data
#    - Whether they're using the right dataset