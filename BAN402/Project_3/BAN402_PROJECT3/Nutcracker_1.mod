# Set of days
set DAYS;

# Parameters
param D{DAYS};  # Intercept
param m{DAYS};  # Slope
param max_capacity;
param min_tickets;

# Variables
var p{DAYS} >= 0;  # Price per ticket for each day
var Q{DAYS};  # Demand quantity for each day

# Objective function: Maximize total revenue
maximize Total_Revenue: sum{i in DAYS} p[i] * Q[i];

# Constraints
subject to Demand_Function {i in DAYS}:
    Q[i] = D[i] + m[i] * p[i] + sum{j in DAYS: j != i} 2 * (p[j] - p[i]);

subject to Capacity_Constraint {i in DAYS}:
    Q[i] <= max_capacity;

subject to Minimum_Tickets {i in DAYS}:
    Q[i] >= min_tickets;

subject to Non_Negative_Demand {i in DAYS}:
    Q[i] >= 0;
