# Sets for organizing refineries, crude oils, components, final products, depots, markets, and time periods.
set Refineries;                    # Set of refinery locations
set CrudeOils;                     # Set of crude oil types
set Components;                    # Set of intermediate components in production
set FinalProducts;                 # Set of final products for distribution

set Depots;                        # Set of depots for storing and shipping products
set Markets;                       # Set of all markets where products are sold
set ExtremeMarkets within Markets; # Subset of markets with high demand variability
set NorthExtremeMarket within ExtremeMarkets; # Markets in northern high-demand zones
set SouthExtremeMarket within ExtremeMarkets; # Markets in southern high-demand zones
set TimePeriods;                   # Time periods over which production planning occurs

# Parameters defining costs, capacities, demands, and inventory requirements.
param Ccru {CrudeOils, TimePeriods};            # Cost of crude oil per time period
param a {Refineries, CrudeOils, Components};    # Conversion rate from crude oil to components per refinery
param Q {Components, FinalProducts};            # Conversion rate of components into final products
param S {FinalProducts};                        # Selling price per unit of final product
param Cdis {Refineries, CrudeOils};             # Distribution cost of crude oil to refineries
param Cpro {FinalProducts};                     # Production cost per unit of final product
param Ctra1;                                    # Transfer cost of components between refineries and hubs
param Ctra2 {Depots};                           # Transfer cost of final products from hubs to depots
param Ctra3 {Depots, Markets};                  # Delivery cost of final products from depots to markets
param CExtreme {Depots};                        # Additional costs for extreme market distribution from depots
param Cinvi;                                    # Inventory cost for crude oil stocks
param Cinvb;                                    # Inventory cost for component stocks
param Cinvp {Depots};                           # Inventory cost for final product stocks at depots
param delta {FinalProducts, Markets, TimePeriods}; # Demand for final products in each market and period

param IfinalCo {Components};                    # Final inventory requirements for components
param Izero {FinalProducts, Depots};            # Initial inventory levels of final products at depots
param Ifinal {FinalProducts, Depots};           # Target inventory levels of final products at depots
param MaxCap{Refineries};                       # Maximum production capacity per refinery

# Decision variables representing purchase, inventory, production, and transportation quantities.
var Purchase{CrudeOils, TimePeriods} >= 0;      # Quantity of each crude oil purchased per time period
var Allocate{CrudeOils, Refineries, TimePeriods} >= 0; # Allocation of crude oil to each refinery
var Transfer{Components, TimePeriods} >= 0;     # Quantity of components transferred to the hub
var Produce{FinalProducts, TimePeriods} >= 0;   # Quantity of final products produced per period
var Ship{FinalProducts, Depots, TimePeriods} >= 0; # Quantity shipped to depots
var Deliver{FinalProducts, Depots, Markets, TimePeriods} >= 0; # Quantity delivered to markets
var RawStock {CrudeOils, Refineries, TimePeriods} >= 0; # Inventory level of crude oil at refineries
var IntStock {Components, TimePeriods} >= 0;    # Inventory level of components at the hub
var EndStock {FinalProducts, Depots, TimePeriods} >= 0; # Inventory level of final products at depots
var NorthFlag{TimePeriods} binary;              # Binary flag for deliveries to NorthExtremeMarket
var SouthFlag{TimePeriods} binary;              # Binary flag for deliveries to SouthExtremeMarket

# Objective function: maximize profit from sales, minimize various costs.
maximize Profit:
     sum {p in FinalProducts, w in Depots, k in Markets diff ExtremeMarkets, y in TimePeriods: y > 0 and y <= card(TimePeriods)-2} (S[p] * Deliver[p,w,k,y])
    + sum {p in FinalProducts, w in Depots, k in ExtremeMarkets, y in TimePeriods: y > 0 and y <= card(TimePeriods)-3} (S[p] * Deliver[p,w,k,y])
    - sum{c in CrudeOils, y in TimePeriods: y > 0} (Ccru[c, y] * Purchase[c,y])
    - sum{f in Refineries, c in CrudeOils, y in TimePeriods: y > 0} (Cdis[f, c] * Allocate[c, f, y])
    - sum{p in FinalProducts, y in TimePeriods: y > 0} (Cpro[p] * Produce[p, y])
    - sum{m in Components, y in TimePeriods: y > 0} (Ctra1 * Transfer[m, y])
    - sum{p in FinalProducts, w in Depots, y in TimePeriods: y > 0} (Ctra2[w] * Ship[p,w,y])
    - sum{p in FinalProducts, w in Depots, k in Markets, y in TimePeriods: y > 0} (Ctra3[w, k] * Deliver[p, w, k, y])
    - sum{c in CrudeOils, f in Refineries, y in TimePeriods: y > 0} (Cinvi * RawStock[c,f,y])
    - sum{m in Components, y in TimePeriods: y > 0} (Cinvb * IntStock[m, y])
    - sum{p in FinalProducts, w in Depots, y in TimePeriods: y > 0} (Cinvp[w] * EndStock[p, w, y])
    - sum{w in Depots, y in TimePeriods: y > 0} (CExtreme[w] * (NorthFlag[y] + SouthFlag[y]));
    
# Constraints to enforce system balances and requirements
# Crude Oil Balance at Refineries
CrudeOilBalance{c in CrudeOils, f in Refineries, y in TimePeriods: y > 0}:
    RawStock[c, f, y] = RawStock[c, f, y-1] + Purchase[c, y] - sum {m in Components} Allocate[c, f, y] * a[f,c,m];

# Component Balance at Hub
ComponentBalance {m in Components, y in TimePeriods: y > 0}:
    IntStock[m, y] = IntStock[m, y-1] + Transfer[m, y] - sum {p in FinalProducts} Produce[p, y] * Q[m,p];

# Refinery Processing Capacity
RefineryCapacity {f in Refineries, y in TimePeriods: y > 0}:    
    sum{c in CrudeOils} Allocate[c, f, y] <= MaxCap[f];
    
# Component Flow to Hub
RefineryToHubFlow {m in Components, y in TimePeriods: y > 0}:
    Transfer[m, y] = sum {f in Refineries, c in CrudeOils} Allocate[c, f, y] * a[f, c, m];

# Recipe Requirement Satisfaction
RecipeSufficiency {m in Components, y in TimePeriods: y > 0}: 
    Transfer[m,y-1] >= sum {p in FinalProducts} Q[m, p] * Produce[p, y];

# Product Flow from Hub to Depots
HubToDepotFlow {p in FinalProducts, y in TimePeriods: y > 0}: 
    Produce[p, y] = sum {w in Depots} Ship[p, w, y];

# Product Balance at Depots
DepotProductBalance {p in FinalProducts, w in Depots, y in TimePeriods: y > 0}: 
    EndStock[p, w, y] = EndStock[p, w, y-1] + Ship[p,w,y-1] - sum{k in Markets} Deliver[p, w, k, y];

# Demand Satisfaction in Regular Markets
RegularMarketDemand {p in FinalProducts, k in Markets diff ExtremeMarkets, y in TimePeriods: y > 0}:
    sum {w in Depots} Deliver[p, w, k, y-1] <= delta[p, k, y];

# Demand Satisfaction in Extreme Markets
ExtremeMarketDemand {p in FinalProducts, k in ExtremeMarkets, y in TimePeriods: y > 1}:
    sum {w in Depots} Deliver[p, w, k, y-2] <= delta[p, k, y];

# Shipment Requirements for Extreme Markets
ExtremeMarketShippingNorth {y in TimePeriods: y > 0}:
    sum{k in NorthExtremeMarket, p in FinalProducts, w in Depots} Deliver[p, w, k, y] <= 10000 * NorthFlag[y];

ExtremeMarketShippingSouth {y in TimePeriods: y > 0}:
    sum{k in SouthExtremeMarket, p in FinalProducts, w in Depots} Deliver[p, w, k, y] <= 10000 * SouthFlag[y];
    
# Mutually Exclusive Shipping for Extreme Markets
ExclusiveExtremeShipping {k in ExtremeMarkets, y in TimePeriods: y > 0}:
    NorthFlag[y] + SouthFlag[y] <= 1;

# Initial Inventory Values
InitialCrudeInventory {c in CrudeOils, f in Refineries}: RawStock[c, f, 0] = 0;
InitialComponentInventory {m in Components}: IntStock[m, 0] = 0;
InitialProductInventory {p in FinalProducts, w in Depots}: EndStock[p, w, 0] = Izero[p, w];

# Initial Flow Values
InitialComponentFlow {m in Components}: Transfer[m, 0] = 0;
InitialProductFlow {p in FinalProducts, w in Depots}: Ship[p, w, 0] = 0;
InitialMarketFlow {p in FinalProducts, w in Depots, k in Markets}: Deliver[p, w, k, 0] = 0;

# Final Inventory Requirements
FinalComponentInventory {m in Components}: IntStock[m, 10] >= IfinalCo[m];
FinalProductInventory {p in FinalProducts, w in Depots}: EndStock[p, w, 10] = Ifinal[p, w];