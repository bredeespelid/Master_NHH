# Mock Exam: R Programming and Data Analysis

### Instructions
- The exam consists of multiple sections: Knowledge, Skills, and Applied Problems.
- Write your answers as R scripts or outputs.
- Use comments in your code to explain your reasoning.

---

## Part 1: Knowledge
### 1. Short Answer Questions
   - a. Explain why R is a useful tool for data analysis.  
   - b. What does "reproducibility" mean in the context of data analysis, and why is it important?  
   - c. Why is documentation critical when creating scripts in R?  

---

## Part 2: Skills
### 2. Basic Data Structures
Create the following data structures in R and perform operations on them:
```R
# A vector of numeric data: calculate the mean and median.

# A matrix: perform row and column sums.

# A data frame with at least three columns: subset rows based on a condition in one of the columns.
```

### 3. Data Manipulation
You are given the following two data frames:
```R
df1 <- data.frame(ID = c(1, 2, 3), Value = c(10, 20, 30))
df2 <- data.frame(ID = c(2, 3, 4), Category = c("A", "B", "C"))
```
- Merge `df1` and `df2` on the `ID` column.  
- Reshape the merged data frame to a wide format, with `Category` as columns.  

### 4. Debugging and Error Handling
The following code produces an error. Fix it and explain your changes:
```R
x <- c(1, 2, 3, NA, 5)
mean(x)
```

### 5. Control Structures
Write an R script that:
- Loops through numbers from 1 to 10.  
- Prints "Even" if the number is even and "Odd" if the number is odd.  

### 6. Vectorization and Parallelization
Compare the runtime of a loop-based summation versus a vectorized approach for summing the numbers from 1 to 1,000,000.

---

## Part 3: Applied Problems

### 7. Prediction and Machine Learning
1. Load the `flights` dataset from the `nycflights13` package.
2. Filter the dataset to include only flights with complete data for `arr_delay`, `dep_delay`, and `origin`.
3. Split the filtered data into training (80%) and test (20%) sets.
4. Train a decision tree model to predict the `origin` column (airport of origin) using the `rpart` package.
5. Evaluate the accuracy of the model on the test set.

---

### 8. Visualization
1. Load the `mtcars` dataset.
2. Create a scatter plot of `mpg` (miles per gallon) versus `hp` (horsepower).
3. Add a trend line to the scatter plot.

---

### 9. Business and Economics Application
1. Load the `ChickWeight` dataset.
2. Calculate the total weight gain per `Diet`.
3. Create a bar chart showing the average weight gain per diet.
4. Interpret the results in a biological or experimental context.
---

### Grading Criteria
- **Knowledge**: Clarity and depth of explanations (20%).  
- **Skills**: Correctness and efficiency of R code (40%).  
- **Applied Problems**: Relevance and accuracy of analyses and visualizations (30%).  
- **General Competence**: Documentation, reproducibility, and formatting (10%).

---

By completing this mock exam, you will demonstrate your understanding and competence in R programming, data analysis, and reproducible research practices.
