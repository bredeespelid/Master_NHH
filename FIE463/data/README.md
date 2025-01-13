# Data 

This folder contains various data sets used during the lectures and workshops.

- `FRED/FRED_annual.csv`:
    Contains annual data from [FRED](https://fred.stlouisfed.org/),
    a standard data source for macroeconomic time series.

    Variables:

    1.  `GDP`: Real gross domestic product in billions of chained
        2017 US dollars ([GDPC1](https://fred.stlouisfed.org/series/GDPC1))
    2.  `CPI`: Consumer Price Index for All Urban Consumers: All Items in U.S. City Average
        ([CPIAUCSL](https://fred.stlouisfed.org/series/CPIAUCSL)).
        Price level is normalized so that the average in 1982-1984 is 100.
    3.  `UNRATE`: Unemployment rate in percent ([UNRATE](https://fred.stlouisfed.org/series/UNRATE))
    4.  `FEDFUNDS`: Effective Federal Funds Rate in percent ([FEDFUNDS](https://fred.stlouisfed.org/series/FEDFUNDS))

- `FRED/FRED_monthly.csv`: 
    Contains _monthly_ data from [FRED](https://fred.stlouisfed.org/),
    a standard data source for macroeconomic time series.

    Variables:

    1.  `CPI`: Consumer Price Index for All Urban Consumers: All Items in U.S. City Average
        ([CPIAUCSL](https://fred.stlouisfed.org/series/CPIAUCSL)).
        Price level is normalized so that the average in 1982-1984 is 100.
    2.  `INFLATION`: Annual inflation over the previous 12-month period, computed from `CPI`.
    3.  `UNRATE`: Unemployment rate in percent ([UNRATE](https://fred.stlouisfed.org/series/UNRATE))
    4.  `REALRATE`: 1-Year Real Interest Rate in percent ([REAINTRATREARAT1YE](https://fred.stlouisfed.org/series/REAINTRATREARAT1YE))    
    5.  `FEDFUNDS`: Effective Federal Funds Rate in percent ([FEDFUNDS](https://fred.stlouisfed.org/series/FEDFUNDS))
    6.  `LFPART`: Labor Force Participation Rate in percent ([CIVPART](https://fred.stlouisfed.org/series/CIVPART))

- `population_norway.csv`: Population by municipality (kommune) as of January 1, 2024.
    
    Source: SSB, [https://www.ssb.no/statbank/sq/10102933](https://www.ssb.no/statbank/sq/10102933)

