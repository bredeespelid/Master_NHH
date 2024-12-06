#____________________________________________Sets
set TEAMS;  # Set of teams
set VENUES;  # Set of venues
set DATES ordered;  # Ordered set of dates
set GROUPS;  # Set of groups
set MATCHES;  # Set of matches


#_____________________________________________Parameters

param distance{VENUES, VENUES};  # Distance between venues
param group{TEAMS};  # Group assignment for each team
param match_date{MATCHES};  # Date for each match
param matches_per_venue{VENUES};  # Max number of matches per venue
param team1{MATCHES} symbolic;  # First team in each match
param team2{MATCHES} symbolic;  # Second team in each match
param venue_schedule{VENUES, DATES};
param germany_matches{MATCHES, VENUES};

# ____________________________________________Variables

var x{MATCHES, VENUES} binary;  # Indicates if a match is played at a venue
param date_index{DATES} integer;
var y{TEAMS, MATCHES, MATCHES, VENUES, VENUES} binary;  # Links two matches for travel calculation
var travel{TEAMS} >= 0;  # Total travel distance for each team
var z{GROUPS, VENUES} binary;  # Indicates group presence at a venue
var early_game{VENUES} binary;  # Indicates early games at a venue
var late_game{VENUES} binary;  # Indicates late games at a venue

#____________________________________________ Objective

minimize TotalDistance:
    sum {t in TEAMS} travel[t];  # Minimize total travel distance for all teams

#____________________________________________ Constraints

# Each match is assigned to exactly one venue
subject to MatchAssignment {m in MATCHES}:
    sum {v in VENUES} x[m,v] = 1;
    
subject to VenueSchedule {v in VENUES, d in DATES}:
    sum{m in MATCHES: match_date[m] = d} x[m,v] = venue_schedule[v,d];

# Ensure correct distribution of group games across venues
subject to GroupGamesDistribution1 {g in GROUPS, v in VENUES}:
    z[g,v] <= sum {m in MATCHES: group[team1[m]] = g or group[team2[m]] = g} x[m,v];

subject to GroupGamesDistribution2 {g in GROUPS, v in VENUES}:
    z[g,v] >= (sum {m in MATCHES: group[team1[m]] = g or group[team2[m]] = g} x[m,v]) / card(MATCHES);

subject to GroupGamesDistribution3 {g in GROUPS}:
    sum {v in VENUES} z[g,v] >= 4;

# Ensure early games at each venue are tracked correctly
subject to EarlyGameAllVenues1 {v in VENUES}:
    early_game[v] <= sum {m in MATCHES: match_date[m] <= 18} x[m,v];

subject to EarlyGameAllVenues2 {v in VENUES}:
    early_game[v] >= (sum {m in MATCHES: match_date[m] <= 18} x[m,v]) / card(MATCHES);

subject to EarlyGameAllVenues3:
    sum {v in VENUES} early_game[v] >= card(VENUES) - 2;

# Ensure late games at each venue are tracked correctly
subject to LateGameAllVenues1 {v in VENUES}:
    late_game[v] <= sum {m in MATCHES: match_date[m] >= 24} x[m,v];

subject to LateGameAllVenues2 {v in VENUES}:
    late_game[v] >= (sum {m in MATCHES: match_date[m] >= 24} x[m,v]) / card(MATCHES);

subject to LateGameAllVenues3:
    sum {v in VENUES} late_game[v] >= card(VENUES) - 2;

# All matches must be assigned across venues
subject to AllMatchesAssigned:
    sum {m in MATCHES, v in VENUES} x[m,v] = card(MATCHES);

# Limit number of matches per venue based on schedule constraints
subject to MatchesPerVenue {v in VENUES}:
    sum {m in MATCHES} x[m,v] <= matches_per_venue[v];

# Venue_restdays
	subject to VenueRest {v in VENUES, m1 in MATCHES, m2 in MATCHES: 
    m1 != m2 and abs(date_index[match_date[m1]] - date_index[match_date[m2]]) < 3}:
    x[m1, v] + x[m2, v] <= 1;

# No venue can host more than two matches for the same group
subject to MaxGroupGamesPerVenue {v in VENUES, g in GROUPS}:
    sum {m in MATCHES: group[team1[m]] = g or group[team2[m]] = g} x[m,v] <= 2;

subject to GermanyGames {m in MATCHES, v in VENUES: germany_matches[m,v] = 1}:
    x[m,v] = 1;

# Link travel between consecutive matches using binary variables (linearization)
subject to LinkY1 {t in TEAMS, m1 in MATCHES, m2 in MATCHES, v1 in VENUES, v2 in VENUES: 
    (team1[m1] = t or team2[m1] = t) and (team1[m2] = t or team2[m2] = t) and match_date[m1] < match_date[m2]}:
    y[t,m1,m2,v1,v2] <= x[m1,v1];

subject to LinkY2 {t in TEAMS, m1 in MATCHES, m2 in MATCHES, v1 in VENUES, v2 in VENUES: 
    (team1[m1] = t or team2[m1] = t) and (team1[m2] = t or team2[m2] = t) and match_date[m1] < match_date[m2]}:
    y[t,m1,m2,v1,v2] <= x[m2,v2];

subject to LinkY3 {t in TEAMS, m1 in MATCHES, m2 in MATCHES, v1 in VENUES, v2 in VENUES: 
    (team1[m1] = t or team2[m1] = t) and (team1[m2] = t or team2[m2] = t) and match_date[m1] < match_date[m2]}:
    y[t,m1,m2,v1,v2] >= x[m1,v1] + x[m2,v2] - 1;

# Calculate total travel distance for each team based on linked matches
subject to TravelDistance {t in TEAMS}:
    travel[t] = sum {m1 in MATCHES, m2 in MATCHES, v1 in VENUES, v2 in VENUES:
        (team1[m1] = t or team2[m1] = t) and 
        (team1[m2] = t or team2[m2] = t) and 
        match_date[m1] < match_date[m2] and 
        forall {m3 in MATCHES: match_date[m1] < match_date[m3] < match_date[m2]}
            ((team1[m3] != t) and (team2[m3] != t))}
    distance[v1,v2] * y[t,m1,m2,v1,v2];
