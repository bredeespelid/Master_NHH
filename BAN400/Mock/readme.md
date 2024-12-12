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
   - a. Load the `iris` dataset in R.  
   - b. Split the data into training (80%) and test (20%) sets.  
   - c. Train a decision tree model to predict the `Species` column using the `rpart` package.  
   - d. Evaluate the accuracy of the model on the test set.  

### 8. Reproducible Research
Write an R script that reads in a CSV file, performs exploratory data analysis (EDA), and outputs a formatted HTML report using the `rmarkdown` package.

### 9. Visualization
Using the `mtcars` dataset:
- Create a scatter plot of `mpg` (miles per gallon) versus `hp` (horsepower).  
- Add a trend line to the scatter plot.  
- Save the plot as a PNG file.  

### 10. Business and Economics Application
The file `sales.csv` contains columns `Region`, `Product`, and `Sales`. Write an R script to:
- Calculate the total sales per region and product.  
- Create a bar chart showing the total sales per region.  
- Interpret the results for a business context.  

---

## Part 4: General Competence
### 11. Standardized and Documented Code
Write an R script that calculates the factorial of a number using recursion. Ensure the script:
- Is well-documented with comments.  
- Follows best practices for formatting and readability.  

### 12. Reproducibility
Write an R script that:
- Generates a reproducible random sample of 100 numbers from a normal distribution with a mean of 50 and a standard deviation of 10.  
- Saves the generated data to a CSV file.  

---

### Grading Criteria
- **Knowledge**: Clarity and depth of explanations (20%).  
- **Skills**: Correctness and efficiency of R code (40%).  
- **Applied Problems**: Relevance and accuracy of analyses and visualizations (30%).  
- **General Competence**: Documentation, reproducibility, and formatting (10%).

---

By completing this mock exam, you will demonstrate your understanding and competence in R programming, data analysis, and reproducible research practices.
