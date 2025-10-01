# DataEngineering_Project_1
Conceptual pipeline for an analytical database, populated with information about individual stocks and their daily prices.

### Data used for the pipeline:

1. Daily stock activity for individual companies, requested throught the AlphaVantage API (DataSet1).

Source: https://www.alphavantage.co/documentation/ (TIME_SERIES_DAILY)

2. Company overviews for each individual copany, requested throught the AlphaVantage API (DataSet2).

Source: https://www.alphavantage.co/documentation/ (Company Overview)

3. Additional industry/subindustry data for the company overviews, scrapped from Wikipedia (DataSet3).

Source: https://en.wikipedia.org/wiki/List_of_S%26P_500_companies#S&P_500_component_stocks

4. Information about the individual exchanges, downloaded from the official ISO site (DataSet4).

Source: https://www.iso20022.org/market-identifier-codes

5. Information about the individual currencies used (DataSet5).

Source: https://en.wikipedia.org/wiki/List_of_circulating_currencies
