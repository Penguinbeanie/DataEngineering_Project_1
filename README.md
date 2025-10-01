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

### Star Schema Summary

This document outlines the structure of the stock price data warehouse, which employs a star schema design. The schema consists of one central fact table, FactStockPrice, surrounded by four dimension tables: DimDate, DimCompany, DimExchange, and DimCurrency.

Fact Table:

The FactStockPrice table contains the measured daily stock metrics (High, Low, Open, Close, Volume) linked to the relevant dimensions via foreign keys. It is the central table used for analysis and reporting.

Dimension Tables:

Dimension tables provide the contextual information for analyzing the facts.

 - The DimDate table stores calendar-based attributes like year, month, day, and quarter for time-based analysis.

 - The DimCompany table stores descriptive information about the companies, including their symbol, CIK, and industry classification, managing changes over time using ValidFrom and ValidTo dates.

 - The DimExchange table stores details about the stock exchanges where trading occurs, identified by their Market Identifier Code (MIC).

 - The DimCurrency table stores the codes and names for the currencies in which the stock prices are denominated.
