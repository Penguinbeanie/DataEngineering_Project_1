# DataEngineering_Project_1
Conceptual pipeline for an analytical database, populated with information about individual stocks and their daily prices.

## Data Used For The Pipeline

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

## Star Schema Summary

This document outlines the structure of the stock price data warehouse, which employs a star schema design. The schema consists of one central fact table, FactStockPrice, surrounded by four dimension tables: DimDate, DimCompany, DimExchange, and DimCurrency.

### Fact Table

The FactStockPrice table contains the measured daily stock metrics (High, Low, Open, Close, Volume) linked to the relevant dimensions via foreign keys. It is the central table used for analysis and reporting.

### Dimension Tables

Dimension tables provide the contextual information for analyzing the facts.

 - The DimDate table stores calendar-based attributes like year, month, day, and quarter for time-based analysis.

 - The DimCompany table stores descriptive information about the companies, including their symbol, CIK, and industry classification, managing changes over time using ValidFrom and ValidTo dates.

 - The DimExchange table stores details about the stock exchanges where trading occurs, identified by their Market Identifier Code (MIC).

 - The DimCurrency table stores the codes and names for the currencies in which the stock prices are denominated.

## Data Dictionary

### FactStockPrice

- SurrogateID: Unique identifier for each record in the fact table.
- DateID: Foreign key linking to the DimDate table. This is a surrogate key and does not map to a specific column in the source data.
- CompanyID: Foreign key linking to the DimCompany table. This is a surrogate key and does not map to a specific column in the source data.
- ExchangeID: Foreign key linking to the DimExchange table. This is a surrogate key and does not map to a specific column in the source data.
- CurrencyID: Foreign key linking to the DimCurrency table. This is a surrogate key and does not map to a specific column in the source data.
- High: The highest price of the stock for the day.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: High
  - Description: Highest price of the stock for the day.
- Low: The lowest price of the stock for the day.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Low
  - Description: Lowest price of the stock for the day.
- Open: The opening price of the stock for the day.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Open
  - Description: Opening price of the stock for the day.
- Close: The closing price of the stock for the day.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Close
  - Description: Closing price of the stock for the day.
- Volume: The volume of shares traded for the day.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Volume
  - Description: Number of shares traded during the day.

### DimDate

- DateID: Unique identifier for each date. This is a surrogate key and does not map to a specific column in the source data.
- FullDate: The full date.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date
  - Description: The full date.
- Year: The year of the date.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date (derived)
  - Description: The year component of the date.
- Month: The month of the date.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date (derived)
  - Description: The month component of the date.
- Day: The day of the month.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date (derived)
  - Description: The day component of the date.
- DayOfWeek: The day of the week.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date (derived)
  - Description: The day of the week.
- Quarter: The quarter of the year.
  - Dataset: DataSet1(AlphaVantage)_dailyData.csv
  - Column: Date (derived)
  - Description: The quarter of the year.

### DimCompany

- CompanyID: Unique identifier for each company. This is a surrogate key and does not map to a specific column in the source data.
- Symbol: The stock symbol of the company.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Symbol
  - Description: The stock ticker symbol.
- CIK: Central Index Key.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: CIK
  - Description: Central Index Key (CIK) is a unique identifier assigned by the SEC.
- CompName: The name of the company.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Name
  - Description: The legal name of the company.
- Founded: The date the company was founded.
  - Dataset: DataSet3(Wikipedia)_sp500_components.csv
  - Column: Founded
  - Description: The year the company was founded.
- CompanyHeadquaters: The location of the company's headquarters.
  - Dataset: DataSet3(Wikipedia)_sp500_components.csv
  - Column: Headquarters Location
  - Description: The city and state of the company's headquarters.
- OfficialSite: The official website of the company.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: OfficialSite
  - Description: The official website URL of the company.
- FiscalYearEnd: The end of the company's fiscal year.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: FiscalYearEnd
  - Description: The month in which the company's fiscal year ends.
- Sector: The sector the company belongs to.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Sector
  - Description: The economic sector the company operates in.
- Industry: The industry the company belongs to.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Industry
  - Description: The specific industry the company operates in.
- SubIndustry: The sub-industry the company belongs to.
  - Dataset: DataSet3(Wikipedia)_sp500_components.csv
  - Column: GICS Sub-Industry
  - Description: The specific sub-industry classification.
- ValidFrom: The start date of the validity of the record.
- ValidTo: The end date of the validity of the record.

### DimExchange

- ExchangeID: Unique identifier for each exchange. This is a surrogate key and does not map to a specific column in the source data.
- ExSymbol: The symbol of the exchange.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Exchange
  - Description: The symbol or name of the stock exchange.
- MIC: Market Identifier Code.
  - Dataset: DataSet4(ISO)_ISO10383_MIC.csv
  - Column: MIC
  - Description: Market Identifier Code (MIC) is a unique identification code for exchanges.
- ExCity: The city where the exchange is located.
  - Dataset: DataSet4(ISO)_ISO10383_MIC.csv
  - Column: CITY
  - Description: The city where the exchange is located.
- ExOfficialSite: The official website of the exchange.
  - Dataset: DataSet4(ISO)_ISO10383_MIC.csv
  - Column: WEBSITE
  - Description: The official website URL of the exchange.
- IsCurrent: A boolean indicating if the exchange is current.
- ValidFrom: The start date of the validity of the record.
- ValidTo: The end date of the validity of the record.

### DimCurrency

- CurrencyID: Unique identifier for each currency. This is a surrogate key and does not map to a specific column in the source data.
- CurrencyCode: The code of the currency.
  - Dataset: DataSet2(AlphaVantage)_company_overviews.csv
  - Column: Currency
  - Description: The ISO currency code. Relates to the currency the stock price is listed in.
- CurrencyName: The name of the currency.
  - Dataset: DataSet5(Wikipedia)_circulating_currencies.csv
  - Column: Currency
  - Description: The name of the currency.
- CurrencySymbol: The symbol of the currency.
  - Dataset: DataSet5(Wikipedia)_circulating_currencies.csv
  - Column: Symbol or abbrev.
  - Description: The symbol of the currency.
- ValidFrom: The start date of the validity of the record.
- ValidTo: The end date of the validity of the record.
