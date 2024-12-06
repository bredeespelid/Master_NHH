# Sets
set REGIONS;
set PORTS;
set MARKETS;

# Parameters
param supply{REGIONS} >= 0;
param demand{MARKETS} >= 0;
param cost_port_market{PORTS, MARKETS} >= 0;
param cost_region_port{REGIONS, PORTS} >= 0;
param loss_ratio;
param port_capacity{PORTS} >= 0; # New parameter for the capacity

# Decision Variables
var y{REGIONS, PORTS} >= 0;    # Shipment from region to port
var z{PORTS, MARKETS} >= 0;    # Shipment from port to market

# Objective Function
minimize Total_Cost:
    sum{r in REGIONS, p in PORTS} cost_region_port[r,p] * y[r,p] +
    sum{p in PORTS, m in MARKETS} cost_port_market[p,m] * z[p,m];

# Constraints
subject to Supply_Constraint {r in REGIONS}:
    sum{p in PORTS} y[r,p] <= supply[r];

subject to Demand_Constraint {m in MARKETS}:
    sum{p in PORTS} z[p,m] >= demand[m];

subject to Port_Balance {p in PORTS}:
    sum{r in REGIONS} y[r,p] * (1 - loss_ratio) = sum{m in MARKETS} z[p,m];

# New constraint for the capacity
subject to Port_Capacity {p in PORTS}:
    sum{r in REGIONS} y[r,p] <= port_capacity[p];