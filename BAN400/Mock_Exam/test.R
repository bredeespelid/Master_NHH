

## Part_1 ------------------------------------------------------------------

# #
# # 1. R is a usefull tool for data analysis because of its easy syntax,
# # fast operations, built for statistical analysis and good looking graphics.
# # It could be used for analysis to predict outcomes like why some
# # customers leaves or other stays as a customer.
# 
# # 2. Reproduceibility in the context of data analysis mean that
# # you are others can continue on a project that you have started on before,
# # for example you start on a big project and has to take a break for it
# # in a period in time. Instead of starting all over again, you could
# # start where you left your script, with tracklogs and well documented
# # comments.
# 
# 3. Documentation is crucial in R because it makes it easier for you
# and other people to understand and read what you have done in your code.



## Part_2 ------------------------------------------------------------------

# Question 2 --------------------------------------------------------------


#Making a standard vector
v<-c(1,2,3,4,5,6,7,8,9)

#Calculating the median and mean
median(v)
mean(v)

# Making a standard matrix with 2 rows and 3 columns
m<- matrix(c(1,2,3, 11,12,13),nrow = 2, ncol = 3, )

#Sum of each row
sum(m[1,]) #Row_1
sum(m[2,]) #Row_2

#Sum of each column
sum(m[,1]) #Column_1
sum(m[,2]) #Column_2
sum(m[,3]) #Column_3

#Making a basic df
df <- data.frame(Name = c("Alice", "Bob", "Charlie", "David"),
                 Age = c(25, 30, 35, 40),
                 City = c("New York", "Los Angeles", "Chicago", "Houston"))

#Making a subset based on that age is greater than 30
subset_df <- subset(df, Age > 30)
print(subset_df)

# Question 3 --------------------------------------------------------------
library(dplyr)
library(tidyr)

df1 <- data.frame(ID = c(1, 2, 3), Value = c(10, 20, 30))
df2 <- data.frame(ID = c(2, 3, 4), Category = c("A", "B", "C"))

#Joined by ID and without NA's
merg <- inner_join(df1,df2,by="ID" )

#Joined fully with Na's
full_join(df1,df2,by="ID" )

#Merge full and names based on Category
merg %>%   pivot_wider(
  names_from = Category,
  values_from = c(Value, ID)
)

# Question 4 --------------------------------------------------------------
#Original code
# x <- c(1, 2, 3, NA, 5)
# mean(x)

x <- c(1, 2, 3, NA, 5)

#The code can be fixed by simply ignoring the NA value
mean(x, na.rm = T)


# Question 5 --------------------------------------------------------------

#Random numbers from 1-10
numb <- 1:10

#Looping trough all of the numbers
for(i in numb){
  
  #Checks if the reminder if (i) divided by two is greater than 1
  if(i%%2==1){
    
    #Print if it is odd
    print(paste0(i, " is Odd"))
  }
  else{
    
    #Print if it is even
    print(paste0(i, " is Even"))
          }
}


# Question 6 --------------------------------------------------------------
 
library(tictoc)

#Making a function for the vectorized summing
Vector_sum <- function(Vectorr){
  
  #Declaring the sum of the vector
  summ <- sum(Vectorr)
  
  #Returning the value
  return(summ)
}



#Making a function for summing with loop function
Loop <- function(Vectorr)
{
  
  #Making an empty variabel to store the value
  summ<- 0
  
  #Loop through the vector one by one
  for(i in Vectorr){
    
    #Adding each element to the empty variable
    summ <- summ + i
  }
  
#Returns the sum
return(summ)
}

#Making the vector to use
Vector_1 <- 1:1000000

#Checking run time for loop 0.03 sec elapsed
tic()
Loop(Vectorr = Vector_1)
toc()

#Checking run time for vector 0 sec elapsed
tic()
Vector_sum(Vectorr = Vector_1)
toc()

##Conclusion for adding numbers the built in vetorized summing is faster


## Part_3 ------------------------------------------------------------------

# Question 7 --------------------------------------------------------------



# Question 9 --------------------------------------------------------------

library(ggplot2)
#Checking the structure
str(mtcars)

#Starting the pipline with the df
mtcars %>% 
  
  #Setting the values for x and y
  ggplot( aes(x = hp, y = mpg))+
  
  #Making the scatter
  geom_point()+
  
  #Adding the trendline
  geom_line(aes(
    lm(hp ~ mpg, data = mtcars) %>% 
      predict()
  ))

##It shows a negative trend, the more horespower the less fuel
##efficient


