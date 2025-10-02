-- DataSet 1 (Vantage Alpha Daily)
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY AUTO_INCREMENT,
    FullDate DATE NOT NULL,
    Year SMALLINT NOT NULL,
    Month VARCHAR(10) NOT NULL,
    Day TINYINT NOT NULL,
    DayOfWeek VARCHAR(10) NOT NULL,
    Quarter TINYINT NOT NULL,

    CONSTRAINT CHK_DayOfWeek_Valid
            CHECK (DayOfWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    CONSTRAINT CHK_Month_Valid
            CHECK (Month IN ('January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December')),
    CONSTRAINT CHK_Day_Valid
            CHECK (Day BETWEEN 1 AND 31),
    CONSTRAINT CHK_Quarter_Valid
            CHECK (Quarter BETWEEN 1 AND 4)
    );

-- DataSet 5 (Wikipedia)
CREATE TABLE DimCurrency (
    CurrencyID INT PRIMARY KEY AUTO_INCREMENT,
    CurrencyCode VARCHAR(10) NOT NULL,           -- DataSet 2 (Vantage Alpha Overview)
    CurrencyName VARCHAR(100) NOT NULL,
    CurrencySymbol VARCHAR(10),
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,

    UNIQUE(CurrencyCode, CurrencyName),

    CONSTRAINT CHK_Currency_ValidDates
            CHECK (ValidTo >= ValidFrom)

    );

-- DataSet 2 (Vantage Alpha Overview)
CREATE TABLE DimCompany (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    Symbol VARCHAR(10) NOT NULL,
    CIK INT NOT NULL,
    CompName VARCHAR(100) NOT NULL,
    Founded DATE,                        -- DataSet 3 (Datahub)
    CompanyHeadquaters VARCHAR(100),
    OfficialSite VARCHAR(100),
    FiscalYearEnd VARCHAR(10),
    Sector VARCHAR(50),
    Industry VARCHAR(50),                -- DataSet 3
    SubIndustry VARCHAR(50),             -- DataSet 3
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,

    UNIQUE(CIK),

    CONSTRAINT CHK_FiscalYearEnd_Valid
            CHECK (FiscalYearEnd IN ('January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December')),

    CONSTRAINT CHK_Company_ValidDates
            CHECK (ValidTo >= ValidFrom)

    );

-- DataSet 4 (ISO20022)
CREATE TABLE DimExchange (
    ExchangeID INT PRIMARY KEY AUTO_INCREMENT,
    ExSymbol VARCHAR(100) NOT NULL,      -- DataSet 2
    MIC VARCHAR(10) NOT NULL,
    ExCity VARCHAR(20),
    ExOfficialSite VARCHAR(100),
    IsCurrent BOOLEAN NOT NULL,
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,

    UNIQUE(MIC),

    CONSTRAINT CHK_Exchange_ValidDates
        CHECK (ValidTo >= ValidFrom)

    );

CREATE TABLE FactStockPrice (
    SurrogateID BIGINT PRIMARY KEY AUTO_INCREMENT,

    -- Foreign Keys
    DateID INT NOT NULL,
    CompanyID INT NOT NULL,
    ExchangeID INT NOT NULL,
    CurrencyID INT NOT NULL,

    -- Values
    High DECIMAL(19, 4) NOT NULL,
    Low DECIMAL(19, 4) NOT NULL,
    Open DECIMAL(19, 4) NOT NULL,
    Close DECIMAL(19, 4) NOT NULL,
    Volume BIGINT NOT NULL,

    UNIQUE (DateID, CompanyID),

    CONSTRAINT FK_Fact_Date
            FOREIGN KEY (DateID)
            REFERENCES DimDate (DateID),

    CONSTRAINT FK_Fact_Company
            FOREIGN KEY (CompanyID)
            REFERENCES DimCompany (CompanyID),

    CONSTRAINT FK_Fact_Exchange
            FOREIGN KEY (ExchangeID)
            REFERENCES DimExchange (ExchangeID),

    CONSTRAINT FK_Fact_Currency
            FOREIGN KEY (CurrencyID)
            REFERENCES DimCurrency (CurrencyID),

    CONSTRAINT CHK_High_NonNegative
            CHECK (High >= 0),

    CONSTRAINT CHK_Low_NonNegative
            CHECK (Low >= 0),

    CONSTRAINT CHK_Open_NonNegative
            CHECK (Open >= 0),

    CONSTRAINT CHK_Close_NonNegative
            CHECK (Close >= 0),

    CONSTRAINT CHK_Volume_NonNegative
            CHECK (Volume >= 0),

    CONSTRAINT CHK_High_Low
            CHECK (High >= Low)
    );
