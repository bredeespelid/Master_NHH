# Sets
set PRODUCTS;
set RAW_MATERIALS;

# Parameters
param demand {PRODUCTS};
param min_demand {PRODUCTS};
param selling_price {PRODUCTS};
param min_protein {PRODUCTS};
param max_protein {PRODUCTS};
param min_carb {PRODUCTS};
param max_carb {PRODUCTS};
param min_vitamin {PRODUCTS};
param max_vitamin {PRODUCTS};

param cost {RAW_MATERIALS};
param supply {RAW_MATERIALS};
param protein {RAW_MATERIALS};
param carb {RAW_MATERIALS};
param vitamin {RAW_MATERIALS};

param max_production;
param production_cost;

# Variables
var blend {PRODUCTS, RAW_MATERIALS} >= 0;
var production {PRODUCTS} >= 0;

# Objective function
maximize profit: 
    sum {p in PRODUCTS} (selling_price[p] * production[p]) - 
    sum {p in PRODUCTS, r in RAW_MATERIALS} (cost[r] * blend[p,r]) -
    sum {p in PRODUCTS} (production_cost * production[p]);

# Constraints
subject to demand_constraint {p in PRODUCTS: demand[p] > 0}:
    production[p] = demand[p];

subject to min_demand_constraint {p in PRODUCTS: min_demand[p] > 0}:
    production[p] >= min_demand[p];

subject to production_balance {p in PRODUCTS}:
    production[p] = sum {r in RAW_MATERIALS} blend[p,r];

subject to max_production_constraint:
    sum {p in PRODUCTS} production[p] <= max_production;

subject to supply_constraint {r in RAW_MATERIALS}:
    sum {p in PRODUCTS} blend[p,r] <= supply[r];

subject to min_protein_constraint {p in PRODUCTS}:
    sum {r in RAW_MATERIALS} (protein[r] * blend[p,r]) >= min_protein[p] * production[p];

subject to max_protein_constraint {p in PRODUCTS: max_protein[p] < Infinity}:
    sum {r in RAW_MATERIALS} (protein[r] * blend[p,r]) <= max_protein[p] * production[p];

subject to min_carb_constraint {p in PRODUCTS}:
    sum {r in RAW_MATERIALS} (carb[r] * blend[p,r]) >= min_carb[p] * production[p];

subject to max_carb_constraint {p in PRODUCTS}:
    sum {r in RAW_MATERIALS} (carb[r] * blend[p,r]) <= max_carb[p] * production[p];

subject to min_vitamin_constraint {p in PRODUCTS}:
    sum {r in RAW_MATERIALS} (vitamin[r] * blend[p,r]) >= min_vitamin[p] * production[p];

subject to max_vitamin_constraint {p in PRODUCTS: max_vitamin[p] < Infinity}:
    sum {r in RAW_MATERIALS} (vitamin[r] * blend[p,r]) <= max_vitamin[p] * production[p];
