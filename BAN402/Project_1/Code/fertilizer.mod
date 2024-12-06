# Sets
set Locations;

# Parameters
param cost{Locations};
param reduction_P1{Locations};
param reduction_P2{Locations};
param target_P1;
param target_P2;

# Variables
var x{Locations} >= 0;

# Objective function
minimize Total_Cost: sum{i in Locations} cost[i] * x[i];

# Constraints
subject to P1_Reduction: sum{i in Locations} reduction_P1[i] * x[i] >= target_P1;
subject to P2_Reduction: sum{i in Locations} reduction_P2[i] * x[i] >= target_P2;
