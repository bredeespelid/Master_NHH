# Define item types and their costs
item_types <- c("small", "medium", "large", "extra-large", "luxury", "premium", "bulk")
costs <- c(1, 2, 5, 10, 20, 50, 100)

# Create a dataframe with item types and costs
item_costs_df <- data.frame(Item_Type = item_types, Cost = costs)

# Initialize a vector to store the number of ways to make each amount
# Index i represents amount (i-1), so we need 201 elements for 0 to 200
ways <- rep(0, 201)
ways[1] <- 1  # There's one way to make 0 (by selecting nothing)

# Use dynamic programming to calculate combinations
for (cost in costs) {
  for (amount in cost:200) {
    # Update the number of ways to make 'amount'
    # by adding the number of ways to make 'amount - cost'
    ways[amount + 1] <- ways[amount + 1] + ways[amount - cost + 1]
  }
}

# Print the result (ways[201] represents the number of ways to make 200)
print(paste("Number of possible purchase combinations:", ways[201]))
