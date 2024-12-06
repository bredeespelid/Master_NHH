# Sets
set DAYS;
set WEEKDAYS within DAYS;
set WEEKEND within DAYS;

# Parameters
param D{DAYS};  # Intercept
param m{DAYS};  # Slope
param max_capacity;
param min_tickets;

# Decision variables
var weekday_price >= 0, <= 1000;  # Weekday price
var weekend_price >= 0, <= 1000;  # Weekend price
var friday_pricing >= 0, <= 1;
var Q{DAYS} >= 0;         # Demand quantity for each day

# Objective function
maximize Total_Revenue:
    sum{i in WEEKDAYS} weekday_price * Q[i] +
    (1 - friday_pricing) * weekday_price * Q['Fri'] +
    friday_pricing * weekend_price * Q['Fri'] +
    sum{j in WEEKEND} weekend_price * Q[j];

subject to Demand_Function {i in DAYS}:
    Q[i] <= D[i] + m[i] * (if i in WEEKDAYS then weekday_price else weekend_price) 
            + sum{j in DAYS} 2 * ((if j in WEEKDAYS then weekday_price else weekend_price) 
                                  - (if i in WEEKDAYS then weekday_price else weekend_price));
                                   
# Capacity constraint
subject to Capacity_Constraint {i in DAYS}:
    Q[i] <= max_capacity;

# Minimum tickets constraint
subject to Minimum_Tickets {i in DAYS}:
    Q[i] >= min_tickets;

# Weekend price higher constraint
subject to WeekendPriceHigher:
    weekend_price >= weekday_price;
