/* =====================================================================================
   STAGE 1 — Database, schemas, clean drop, and all 34 tables
   Source : "Database Design ver Final" (v5.0, frozen) — Sections 1.2, 3 (D1), 4e
   Target : SQL Server 2019 or later, run in SSMS as database owner
   Order  : database -> principal and schemas -> drops (children first) -> tables (parents first)
   Naming : PK_<Table>, UQ_<Table>_<Cols>, FK_<Child>_<Parent>, CK_<Table>_<Rule>,
            DF_<Table>_<Col>, UX_<Table>_<Rule> (filtered unique indexes)
   ===================================================================================== */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

/* -------------------------------------------------------------------------------------
   0. Database
   ------------------------------------------------------------------------------------- */
IF DB_ID(N'GSHG') IS NULL
    CREATE DATABASE GSHG;
GO
USE GSHG;
GO

/* -------------------------------------------------------------------------------------
   0.1 Principal and schemas
   Tables live in gshg, owned by a dedicated principal; procedures and functions live in
   api, owned by dbo (Overview: "Why permissions count as a tier").
   ------------------------------------------------------------------------------------- */
IF DATABASE_PRINCIPAL_ID(N'gshg_owner') IS NULL
    CREATE USER gshg_owner WITHOUT LOGIN;
GO
IF SCHEMA_ID(N'gshg') IS NULL
    EXEC (N'CREATE SCHEMA gshg AUTHORIZATION gshg_owner;');
IF SCHEMA_ID(N'api') IS NULL
    EXEC (N'CREATE SCHEMA api AUTHORIZATION dbo;');
GO

/* -------------------------------------------------------------------------------------
   1. Drops — procedures, triggers, functions, views, then tables (children before parents)
   The trigger, function, view and procedure names below are the ones Stages 2 and 3 create.
   ------------------------------------------------------------------------------------- */

-- 1a. Procedures (P1–P5 and the three helpers)
DROP PROCEDURE IF EXISTS api.usp_IssueInvoice;           -- P5
DROP PROCEDURE IF EXISTS api.usp_ChangeOrCloseStay;      -- P4
DROP PROCEDURE IF EXISTS api.usp_AddReservationService;  -- P3
DROP PROCEDURE IF EXISTS api.usp_CheckIn;                -- P2
DROP PROCEDURE IF EXISTS api.usp_CreateReservation;      -- P1
DROP PROCEDURE IF EXISTS api.usp_RecordPayment;          -- helper (M5)
DROP PROCEDURE IF EXISTS api.usp_ScheduleMaintenance;    -- helper (M5)
DROP PROCEDURE IF EXISTS api.usp_MergeGuest;             -- helper (M2)
GO

-- 1b. Triggers T1–T15 (also dropped with their tables; listed so a partial build is cleaned)
DROP TRIGGER IF EXISTS gshg.trg_T15_Payment;
DROP TRIGGER IF EXISTS gshg.trg_T14_InvoiceLine;
DROP TRIGGER IF EXISTS gshg.trg_T13_Invoice;
DROP TRIGGER IF EXISTS gshg.trg_T12_AdditionalCharge;
DROP TRIGGER IF EXISTS gshg.trg_T11_ReservationRoom_Close;
DROP TRIGGER IF EXISTS gshg.trg_T10_Reservation;
DROP TRIGGER IF EXISTS gshg.trg_T09_ReservationDiscount;
DROP TRIGGER IF EXISTS gshg.trg_T08_HotelService_Stock;
DROP TRIGGER IF EXISTS gshg.trg_T07_ReservationService;
DROP TRIGGER IF EXISTS gshg.trg_T06_ReservationRoomNight;
DROP TRIGGER IF EXISTS gshg.trg_T05_ReservationRoom_CheckIn;
DROP TRIGGER IF EXISTS gshg.trg_T04_RoomOccupant;
DROP TRIGGER IF EXISTS gshg.trg_T03_Room_RetireCapacity;
DROP TRIGGER IF EXISTS gshg.trg_T02_RoomNightAllocation;
DROP TRIGGER IF EXISTS gshg.trg_T01_ReservationRoom_Confirm;
GO

-- 1c. Functions (owned and shared)
DROP FUNCTION IF EXISTS api.fnBeddingOverStock;
DROP FUNCTION IF EXISTS api.fnRosterViolations;
DROP FUNCTION IF EXISTS api.fnRoomOverfull;
DROP FUNCTION IF EXISTS api.fnAllocationGaps;
DROP FUNCTION IF EXISTS api.fnIsInvoiced;
DROP FUNCTION IF EXISTS api.fnStayIsClosed;
DROP FUNCTION IF EXISTS api.fnHotelLocalDate;
GO

-- 1d. Views, highest level first (Section 1.3)
DROP VIEW IF EXISTS gshg.vwAccountLine;          -- level 4
DROP VIEW IF EXISTS gshg.vwFolioLine;            -- level 3
DROP VIEW IF EXISTS gshg.vwStrayAllocation;      -- level 2
DROP VIEW IF EXISTS gshg.vwUnbilledStay;         -- level 2
DROP VIEW IF EXISTS gshg.vwServiceCharge;        -- level 2
DROP VIEW IF EXISTS gshg.vwOccupantNight;        -- level 2
DROP VIEW IF EXISTS gshg.vwMaintenanceWindow;    -- level 1
DROP VIEW IF EXISTS gshg.vwRoomLineNight;        -- level 1
DROP VIEW IF EXISTS gshg.vwReservationStatus;    -- level 1
GO

-- 1e. Tables, children before parents (exact reverse of the create order below)
DROP TABLE IF EXISTS gshg.InvoiceLine;           -- D6
DROP TABLE IF EXISTS gshg.Invoice;               -- D5
DROP TABLE IF EXISTS gshg.Refund;                -- D4
DROP TABLE IF EXISTS gshg.Payment;               -- D3
DROP TABLE IF EXISTS gshg.ReservationDiscount;   -- D2
DROP TABLE IF EXISTS gshg.AdditionalCharge;      -- D1
DROP TABLE IF EXISTS gshg.RoomCategoryChange;    -- C10
DROP TABLE IF EXISTS gshg.ReservationDateChange; -- C9
DROP TABLE IF EXISTS gshg.ReservationService;    -- C8
DROP TABLE IF EXISTS gshg.RoomOccupant;          -- C7
DROP TABLE IF EXISTS gshg.RoomNightAllocation;   -- C6
DROP TABLE IF EXISTS gshg.ReservationRoomNight;  -- C5
DROP TABLE IF EXISTS gshg.ReservationRoom;       -- C4
DROP TABLE IF EXISTS gshg.Reservation;           -- C3
DROP TABLE IF EXISTS gshg.GuestDocument;         -- C2
DROP TABLE IF EXISTS gshg.Guest;                 -- C1
DROP TABLE IF EXISTS gshg.PromotionHotel;        -- B8
DROP TABLE IF EXISTS gshg.Promotion;             -- B7
DROP TABLE IF EXISTS gshg.HotelService;          -- B6
DROP TABLE IF EXISTS gshg.RoomMaintenance;       -- B5
DROP TABLE IF EXISTS gshg.RoomRate;              -- B4
DROP TABLE IF EXISTS gshg.Room;                  -- B3
DROP TABLE IF EXISTS gshg.HotelRoomCategory;     -- B2
DROP TABLE IF EXISTS gshg.Hotel;                 -- B1
DROP TABLE IF EXISTS gshg.PaymentMethod;         -- A10
DROP TABLE IF EXISTS gshg.ServiceType;           -- A9
DROP TABLE IF EXISTS gshg.RatePlan;              -- A8
DROP TABLE IF EXISTS gshg.AgeBand;               -- A7
DROP TABLE IF EXISTS gshg.HeadcountCategory;     -- A6
DROP TABLE IF EXISTS gshg.RoomCategoryUpgrade;   -- A5
DROP TABLE IF EXISTS gshg.RoomCategory;          -- A4
DROP TABLE IF EXISTS gshg.Country;               -- A3
DROP TABLE IF EXISTS gshg.ExchangeRate;          -- A2
DROP TABLE IF EXISTS gshg.Currency;              -- A1
GO

/* =====================================================================================
   2. GROUP A — Reference tables (10)
   ===================================================================================== */

-- A1. Currency
CREATE TABLE gshg.Currency
(
    CurrencyCode  CHAR(3)       NOT NULL,
    CurrencyName  NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_Currency              PRIMARY KEY (CurrencyCode),
    CONSTRAINT UQ_Currency_CurrencyName UNIQUE (CurrencyName)
);
GO

-- A2. ExchangeRate (ordinary table; rows can be corrected). Rate for date d = latest RateDate <= d.
CREATE TABLE gshg.ExchangeRate
(
    CurrencyCode  CHAR(3)        NOT NULL,
    RateDate      DATE           NOT NULL,
    MyrPerUnit    DECIMAL(18,8)  NOT NULL,
    CONSTRAINT PK_ExchangeRate            PRIMARY KEY (CurrencyCode, RateDate),
    CONSTRAINT FK_ExchangeRate_Currency   FOREIGN KEY (CurrencyCode) REFERENCES gshg.Currency (CurrencyCode),
    CONSTRAINT CK_ExchangeRate_Positive   CHECK (MyrPerUnit > 0),
    CONSTRAINT CK_ExchangeRate_MyrIsOne   CHECK (CurrencyCode <> 'MYR' OR MyrPerUnit = 1)
);
GO

-- A3. Country
CREATE TABLE gshg.Country
(
    CountryCode   CHAR(2)        NOT NULL,
    CountryName   NVARCHAR(100)  NOT NULL,
    CurrencyCode  CHAR(3)        NOT NULL,
    CONSTRAINT PK_Country             PRIMARY KEY (CountryCode),
    CONSTRAINT UQ_Country_CountryName UNIQUE (CountryName),
    CONSTRAINT FK_Country_Currency    FOREIGN KEY (CurrencyCode) REFERENCES gshg.Currency (CurrencyCode)
);
GO

-- A4. RoomCategory
CREATE TABLE gshg.RoomCategory
(
    RoomCategoryID  SMALLINT IDENTITY(1,1) NOT NULL,
    CategoryCode    VARCHAR(10)   NOT NULL,
    CategoryName    NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_RoomCategory              PRIMARY KEY (RoomCategoryID),
    CONSTRAINT UQ_RoomCategory_CategoryCode UNIQUE (CategoryCode),
    CONSTRAINT UQ_RoomCategory_CategoryName UNIQUE (CategoryName)
);
GO

-- A5. RoomCategoryUpgrade (allowed from -> to pairs; M:N self-junction)
CREATE TABLE gshg.RoomCategoryUpgrade
(
    FromRoomCategoryID  SMALLINT  NOT NULL,
    ToRoomCategoryID    SMALLINT  NOT NULL,
    CONSTRAINT PK_RoomCategoryUpgrade       PRIMARY KEY (FromRoomCategoryID, ToRoomCategoryID),
    CONSTRAINT FK_RoomCategoryUpgrade_From  FOREIGN KEY (FromRoomCategoryID) REFERENCES gshg.RoomCategory (RoomCategoryID),
    CONSTRAINT FK_RoomCategoryUpgrade_To    FOREIGN KEY (ToRoomCategoryID)   REFERENCES gshg.RoomCategory (RoomCategoryID),
    CONSTRAINT CK_RoomCategoryUpgrade_FromNotTo CHECK (FromRoomCategoryID <> ToRoomCategoryID)
);
GO

-- A6. HeadcountCategory (codes ADULT, CHILD, INFANT; read-only to the application role)
CREATE TABLE gshg.HeadcountCategory
(
    HeadcountCategoryCode  VARCHAR(6)    NOT NULL,
    CategoryName           NVARCHAR(30)  NOT NULL,
    IsResponsibleAdult     BIT           NOT NULL,
    CONSTRAINT PK_HeadcountCategory              PRIMARY KEY (HeadcountCategoryCode),
    CONSTRAINT UQ_HeadcountCategory_CategoryName UNIQUE (CategoryName)
);
GO

-- A7. AgeBand (a band runs to the next band's MinAgeYears - 1; read-only to the application role)
CREATE TABLE gshg.AgeBand
(
    MinAgeYears            TINYINT       NOT NULL,
    BandName               NVARCHAR(30)  NOT NULL,
    HeadcountCategoryCode  VARCHAR(6)    NOT NULL,
    RateClass              VARCHAR(7)    NOT NULL,
    CONSTRAINT PK_AgeBand                    PRIMARY KEY (MinAgeYears),
    CONSTRAINT UQ_AgeBand_BandName           UNIQUE (BandName),
    CONSTRAINT FK_AgeBand_HeadcountCategory  FOREIGN KEY (HeadcountCategoryCode) REFERENCES gshg.HeadcountCategory (HeadcountCategoryCode),
    CONSTRAINT CK_AgeBand_RateClass          CHECK (RateClass IN ('NONE','REDUCED','FULL'))
);
GO

-- A8. RatePlan
CREATE TABLE gshg.RatePlan
(
    RatePlanID         SMALLINT IDENTITY(1,1) NOT NULL,
    RatePlanCode       VARCHAR(15)    NOT NULL,
    RatePlanName       NVARCHAR(100)  NOT NULL,
    RateAdjustmentPct  DECIMAL(5,2)   NOT NULL CONSTRAINT DF_RatePlan_RateAdjustmentPct DEFAULT (0),
    NoShowChargeBasis  VARCHAR(11)    NOT NULL,
    CONSTRAINT PK_RatePlan                   PRIMARY KEY (RatePlanID),
    CONSTRAINT UQ_RatePlan_RatePlanCode      UNIQUE (RatePlanCode),
    CONSTRAINT CK_RatePlan_AdjustmentRange   CHECK (RateAdjustmentPct BETWEEN -50 AND 50),
    CONSTRAINT CK_RatePlan_NoShowChargeBasis CHECK (NoShowChargeBasis IN ('FIRST_NIGHT','FULL_STAY','NONE'))
);
GO

-- A9. ServiceType
CREATE TABLE gshg.ServiceType
(
    ServiceTypeID        SMALLINT IDENTITY(1,1) NOT NULL,
    TypeName             NVARCHAR(50)  NOT NULL,
    ServiceClass         VARCHAR(8)    NOT NULL,
    MaxOccupantAgeYears  TINYINT       NULL,
    CONSTRAINT PK_ServiceType                     PRIMARY KEY (ServiceTypeID),
    CONSTRAINT UQ_ServiceType_ID_Class            UNIQUE (ServiceTypeID, ServiceClass),   -- FK target for HotelService (D1)
    CONSTRAINT UQ_ServiceType_TypeName            UNIQUE (TypeName),
    CONSTRAINT CK_ServiceType_ServiceClass        CHECK (ServiceClass IN ('OPTIONAL','BEDDING')),
    CONSTRAINT CK_ServiceType_AgeOnlyForBedding   CHECK (MaxOccupantAgeYears IS NULL OR ServiceClass = 'BEDDING')
);
GO

-- A10. PaymentMethod (RetiredOn: no new payment on or after this date — T15)
CREATE TABLE gshg.PaymentMethod
(
    PaymentMethodID  TINYINT IDENTITY(1,1) NOT NULL,
    MethodName       NVARCHAR(30)  NOT NULL,
    RetiredOn        DATE          NULL,
    CONSTRAINT PK_PaymentMethod            PRIMARY KEY (PaymentMethodID),
    CONSTRAINT UQ_PaymentMethod_MethodName UNIQUE (MethodName)
);
GO

/* =====================================================================================
   3. GROUP B — Property, rates and services (8)
   ===================================================================================== */

-- B1. Hotel
CREATE TABLE gshg.Hotel
(
    HotelID               INT IDENTITY(1,1) NOT NULL,
    HotelCode             VARCHAR(10)    NOT NULL,
    HotelName             NVARCHAR(150)  NOT NULL,
    CountryCode           CHAR(2)        NOT NULL,
    City                  NVARCHAR(100)  NOT NULL,
    AddressLine           NVARCHAR(255)  NOT NULL,
    PostalCode            VARCHAR(20)    NULL,
    Phone                 VARCHAR(30)    NOT NULL,
    Email                 VARCHAR(255)   NOT NULL,
    TimeZoneId            VARCHAR(64)    NOT NULL,   -- a sys.time_zone_info name
    StandardCheckInTime   TIME(0)        NOT NULL CONSTRAINT DF_Hotel_StandardCheckInTime  DEFAULT ('15:00'),
    StandardCheckOutTime  TIME(0)        NOT NULL CONSTRAINT DF_Hotel_StandardCheckOutTime DEFAULT ('12:00'),
    NoShowCutoffTime      TIME(0)        NOT NULL CONSTRAINT DF_Hotel_NoShowCutoffTime     DEFAULT ('23:59'),
    SalesEndOn            DATE           NULL,
    CONSTRAINT PK_Hotel           PRIMARY KEY (HotelID),
    CONSTRAINT UQ_Hotel_HotelCode UNIQUE (HotelCode),
    CONSTRAINT FK_Hotel_Country   FOREIGN KEY (CountryCode) REFERENCES gshg.Country (CountryCode)
);
GO

-- B2. HotelRoomCategory (M:N junction Hotel x RoomCategory; base, extra and child rates)
CREATE TABLE gshg.HotelRoomCategory
(
    HotelID              INT            NOT NULL,
    RoomCategoryID       SMALLINT       NOT NULL,
    BaseOccupancy        TINYINT        NOT NULL,
    StandardNightlyRate  DECIMAL(10,2)  NOT NULL,
    ExtraPersonRate      DECIMAL(10,2)  NOT NULL,
    ReducedChildRate     DECIMAL(10,2)  NOT NULL,
    WithdrawnOn          DATE           NULL,
    CONSTRAINT PK_HotelRoomCategory                 PRIMARY KEY (HotelID, RoomCategoryID),
    CONSTRAINT FK_HotelRoomCategory_Hotel           FOREIGN KEY (HotelID)        REFERENCES gshg.Hotel (HotelID),
    CONSTRAINT FK_HotelRoomCategory_RoomCategory    FOREIGN KEY (RoomCategoryID) REFERENCES gshg.RoomCategory (RoomCategoryID),
    CONSTRAINT CK_HotelRoomCategory_BaseOccupancy   CHECK (BaseOccupancy >= 1),
    CONSTRAINT CK_HotelRoomCategory_StandardRate    CHECK (StandardNightlyRate > 0),
    CONSTRAINT CK_HotelRoomCategory_ExtraRate       CHECK (ExtraPersonRate >= 0),
    CONSTRAINT CK_HotelRoomCategory_ChildRate       CHECK (ReducedChildRate >= 0),
    CONSTRAINT CK_HotelRoomCategory_ChildLeExtra    CHECK (ReducedChildRate <= ExtraPersonRate)
);
GO

-- B3. Room
CREATE TABLE gshg.Room
(
    RoomID          INT IDENTITY(1,1) NOT NULL,
    HotelID         INT          NOT NULL,
    RoomCategoryID  SMALLINT     NOT NULL,
    RoomNumber      VARCHAR(10)  NOT NULL,
    FloorNumber     SMALLINT     NULL,
    MaxOccupancy    TINYINT      NOT NULL,
    IsAccessible    BIT          NOT NULL CONSTRAINT DF_Room_IsAccessible DEFAULT (0),
    RetiredOn       DATE         NULL,
    CONSTRAINT PK_Room                     PRIMARY KEY (RoomID),
    CONSTRAINT UQ_Room_RoomID_HotelID      UNIQUE (RoomID, HotelID),          -- FK target for RoomNightAllocation (D1)
    CONSTRAINT UQ_Room_HotelID_RoomNumber  UNIQUE (HotelID, RoomNumber),
    CONSTRAINT FK_Room_HotelRoomCategory   FOREIGN KEY (HotelID, RoomCategoryID)
                                           REFERENCES gshg.HotelRoomCategory (HotelID, RoomCategoryID),
    CONSTRAINT CK_Room_MaxOccupancy        CHECK (MaxOccupancy BETWEEN 1 AND 12)
);
GO

-- B4. RoomRate (date-specific nightly rate; StandardNightlyRate covers every other date)
CREATE TABLE gshg.RoomRate
(
    HotelID         INT            NOT NULL,
    RoomCategoryID  SMALLINT       NOT NULL,
    RateDate        DATE           NOT NULL,
    NightlyRate     DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_RoomRate                    PRIMARY KEY (HotelID, RoomCategoryID, RateDate),
    CONSTRAINT FK_RoomRate_HotelRoomCategory  FOREIGN KEY (HotelID, RoomCategoryID)
                                              REFERENCES gshg.HotelRoomCategory (HotelID, RoomCategoryID),
    CONSTRAINT CK_RoomRate_NightlyRate        CHECK (NightlyRate > 0)
);
GO

-- B5. RoomMaintenance (reason and cancellation; the window is its RoomNightAllocation rows)
CREATE TABLE gshg.RoomMaintenance
(
    MaintenanceID           INT IDENTITY(1,1) NOT NULL,
    RoomID                  INT                NOT NULL,
    MaintenanceReason       NVARCHAR(255)      NOT NULL,
    OriginalPlannedEndDate  DATE               NOT NULL,   -- first estimate, reference only
    ReportedAt              DATETIMEOFFSET(0)  NOT NULL,
    CancelledAt             DATETIMEOFFSET(0)  NULL,
    CONSTRAINT PK_RoomMaintenance                 PRIMARY KEY (MaintenanceID),
    CONSTRAINT UQ_RoomMaintenance_ID_RoomID       UNIQUE (MaintenanceID, RoomID),   -- FK target for RoomNightAllocation
    CONSTRAINT FK_RoomMaintenance_Room            FOREIGN KEY (RoomID) REFERENCES gshg.Room (RoomID)
);
GO

-- B6. HotelService (M:N junction Hotel x ServiceType)
CREATE TABLE gshg.HotelService
(
    HotelServiceID  INT IDENTITY(1,1) NOT NULL,
    HotelID         INT            NOT NULL,
    ServiceTypeID   SMALLINT       NOT NULL,
    ServiceClass    VARCHAR(8)     NOT NULL,   -- copied (D1)
    ServiceName     NVARCHAR(100)  NOT NULL,
    ChargingBasis   VARCHAR(15)    NOT NULL,
    UnitPrice       DECIMAL(10,2)  NOT NULL,
    StockUnits      SMALLINT       NULL,
    WithdrawnOn     DATE           NULL,
    CONSTRAINT PK_HotelService                    PRIMARY KEY (HotelServiceID),
    CONSTRAINT UQ_HotelService_ID_HotelID         UNIQUE (HotelServiceID, HotelID),   -- FK target for ReservationService (D1)
    CONSTRAINT UQ_HotelService_HotelID_Name       UNIQUE (HotelID, ServiceName),
    CONSTRAINT FK_HotelService_Hotel              FOREIGN KEY (HotelID) REFERENCES gshg.Hotel (HotelID),
    CONSTRAINT FK_HotelService_ServiceType        FOREIGN KEY (ServiceTypeID, ServiceClass)
                                                  REFERENCES gshg.ServiceType (ServiceTypeID, ServiceClass)
                                                  ON UPDATE CASCADE,
    CONSTRAINT CK_HotelService_ChargingBasis      CHECK (ChargingBasis IN ('PER_PERSON','PER_ROOM','PER_RESERVATION')),
    CONSTRAINT CK_HotelService_UnitPrice          CHECK (UnitPrice >= 0),
    CONSTRAINT CK_HotelService_StockUnits         CHECK (StockUnits >= 0),
    CONSTRAINT CK_HotelService_BeddingPerPerson   CHECK (ServiceClass = 'OPTIONAL' OR ChargingBasis = 'PER_PERSON'),
    CONSTRAINT CK_HotelService_StockOnlyBedding   CHECK (StockUnits IS NULL OR ServiceClass = 'BEDDING')
);
GO

-- B7. Promotion
CREATE TABLE gshg.Promotion
(
    PromotionID    INT IDENTITY(1,1) NOT NULL,
    PromoCode      VARCHAR(20)    NOT NULL,
    Description    NVARCHAR(255)  NOT NULL,
    DiscountType   VARCHAR(7)     NOT NULL,
    DiscountValue  DECIMAL(10,2)  NOT NULL,
    ValidFrom      DATE           NOT NULL,
    ValidTo        DATE           NOT NULL,
    CONSTRAINT PK_Promotion                 PRIMARY KEY (PromotionID),
    CONSTRAINT UQ_Promotion_PromoCode       UNIQUE (PromoCode),
    CONSTRAINT CK_Promotion_DiscountType    CHECK (DiscountType IN ('PERCENT','FIXED')),
    CONSTRAINT CK_Promotion_DiscountValue   CHECK (DiscountValue > 0 AND (DiscountType <> 'PERCENT' OR DiscountValue <= 100)),
    CONSTRAINT CK_Promotion_ValidRange      CHECK (ValidTo >= ValidFrom)
);
GO

-- B8. PromotionHotel (M:N junction)
CREATE TABLE gshg.PromotionHotel
(
    PromotionID  INT  NOT NULL,
    HotelID      INT  NOT NULL,
    CONSTRAINT PK_PromotionHotel            PRIMARY KEY (PromotionID, HotelID),
    CONSTRAINT FK_PromotionHotel_Promotion  FOREIGN KEY (PromotionID) REFERENCES gshg.Promotion (PromotionID),
    CONSTRAINT FK_PromotionHotel_Hotel      FOREIGN KEY (HotelID)     REFERENCES gshg.Hotel (HotelID)
);
GO

/* =====================================================================================
   4. GROUP C — Guests, reservations and occupancy (10)
   ===================================================================================== */

-- C1. Guest
CREATE TABLE gshg.Guest
(
    GuestID          BIGINT IDENTITY(1,1) NOT NULL,
    FirstName        NVARCHAR(100)  NOT NULL,
    LastName         NVARCHAR(100)  NOT NULL,
    DateOfBirth      DATE           NOT NULL,
    Email            VARCHAR(255)   NULL,
    Phone            VARCHAR(30)    NULL,
    NationalityCode  CHAR(2)        NULL,
    CONSTRAINT PK_Guest                 PRIMARY KEY (GuestID),
    CONSTRAINT FK_Guest_Nationality     FOREIGN KEY (NationalityCode) REFERENCES gshg.Country (CountryCode),
    CONSTRAINT CK_Guest_DobNotFuture    CHECK (DateOfBirth <= CONVERT(DATE, SYSDATETIME()))
);
GO

-- C2. GuestDocument (one guest may hold several documents)
CREATE TABLE gshg.GuestDocument
(
    DocumentType        VARCHAR(11)  NOT NULL,
    DocumentNumber      VARCHAR(50)  NOT NULL,
    IssuingCountryCode  CHAR(2)      NOT NULL,
    GuestID             BIGINT       NOT NULL,
    CONSTRAINT PK_GuestDocument               PRIMARY KEY (DocumentType, DocumentNumber, IssuingCountryCode),
    CONSTRAINT UQ_GuestDocument_WithGuest     UNIQUE (DocumentType, DocumentNumber, IssuingCountryCode, GuestID),  -- FK target for RoomOccupant
    CONSTRAINT FK_GuestDocument_Country       FOREIGN KEY (IssuingCountryCode) REFERENCES gshg.Country (CountryCode),
    CONSTRAINT FK_GuestDocument_Guest         FOREIGN KEY (GuestID) REFERENCES gshg.Guest (GuestID),
    CONSTRAINT CK_GuestDocument_DocumentType  CHECK (DocumentType IN ('PASSPORT','NATIONAL_ID'))
);
GO

-- C3. Reservation
CREATE TABLE gshg.Reservation
(
    ReservationID            BIGINT IDENTITY(1,1) NOT NULL,
    ReservationNumber        VARCHAR(20)        NOT NULL,
    HotelID                  INT                NOT NULL,
    BookingGuestID           BIGINT             NOT NULL,
    RatePlanID               SMALLINT           NOT NULL,
    AgreedNoShowChargeBasis  VARCHAR(11)        NOT NULL,
    AgreedCheckInTime        TIME(0)            NOT NULL,
    CheckInDate              DATE               NOT NULL,
    CheckOutDate             DATE               NOT NULL,
    BookedAt                 DATETIMEOFFSET(0)  NOT NULL,
    CancelledAt              DATETIMEOFFSET(0)  NULL,
    CancellationInitiator    VARCHAR(5)         NULL,
    CancellationReason       NVARCHAR(255)      NULL,
    RowVer                   ROWVERSION         NOT NULL,
    CONSTRAINT PK_Reservation                    PRIMARY KEY (ReservationID),
    CONSTRAINT UQ_Reservation_ID_HotelID         UNIQUE (ReservationID, HotelID),   -- FK target (D1)
    CONSTRAINT UQ_Reservation_ReservationNumber  UNIQUE (ReservationNumber),
    CONSTRAINT FK_Reservation_Hotel              FOREIGN KEY (HotelID)        REFERENCES gshg.Hotel (HotelID),
    CONSTRAINT FK_Reservation_BookingGuest       FOREIGN KEY (BookingGuestID) REFERENCES gshg.Guest (GuestID),
    CONSTRAINT FK_Reservation_RatePlan           FOREIGN KEY (RatePlanID)     REFERENCES gshg.RatePlan (RatePlanID),
    CONSTRAINT CK_Reservation_NoShowChargeBasis  CHECK (AgreedNoShowChargeBasis IN ('FIRST_NIGHT','FULL_STAY','NONE')),
    CONSTRAINT CK_Reservation_DateOrder          CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT CK_Reservation_CancelAfterBooking CHECK (CancelledAt IS NULL OR CancelledAt >= BookedAt),
    CONSTRAINT CK_Reservation_Initiator          CHECK (CancellationInitiator IN ('GUEST','HOTEL'))
);
GO

-- C4. ReservationRoom (one room line; confirmation and events per line)
CREATE TABLE gshg.ReservationRoom
(
    ReservationRoomID        BIGINT IDENTITY(1,1) NOT NULL,
    ReservationID            BIGINT             NOT NULL,
    HotelID                  INT                NOT NULL,
    RoomCategoryID           SMALLINT           NOT NULL,
    AgreedBaseOccupancy      TINYINT            NOT NULL,
    AgreedExtraPersonRate    DECIMAL(10,2)      NOT NULL,
    AgreedReducedChildRate   DECIMAL(10,2)      NOT NULL,
    AccessibleRoomRequested  BIT                NOT NULL CONSTRAINT DF_ReservationRoom_AccessibleRequested DEFAULT (0),
    SpecialRequests          NVARCHAR(500)      NULL,
    ConfirmedAt              DATETIMEOFFSET(0)  NULL,
    CheckedInAt              DATETIMEOFFSET(0)  NULL,
    CheckedOutAt             DATETIMEOFFSET(0)  NULL,
    NoShowAt                 DATETIMEOFFSET(0)  NULL,
    CONSTRAINT PK_ReservationRoom                       PRIMARY KEY (ReservationRoomID),
    CONSTRAINT UQ_ReservationRoom_ID_Hotel_Category     UNIQUE (ReservationRoomID, HotelID, RoomCategoryID),  -- FK target for nights
    CONSTRAINT UQ_ReservationRoom_ReservationID_ID      UNIQUE (ReservationID, ReservationRoomID),            -- FK target for services
    CONSTRAINT FK_ReservationRoom_Reservation           FOREIGN KEY (ReservationID, HotelID)
                                                        REFERENCES gshg.Reservation (ReservationID, HotelID),
    CONSTRAINT FK_ReservationRoom_HotelRoomCategory     FOREIGN KEY (HotelID, RoomCategoryID)
                                                        REFERENCES gshg.HotelRoomCategory (HotelID, RoomCategoryID),
    CONSTRAINT CK_ReservationRoom_BaseOccupancy         CHECK (AgreedBaseOccupancy >= 1),
    CONSTRAINT CK_ReservationRoom_ExtraRate             CHECK (AgreedExtraPersonRate >= 0),
    CONSTRAINT CK_ReservationRoom_ChildRate             CHECK (AgreedReducedChildRate >= 0 AND AgreedReducedChildRate <= AgreedExtraPersonRate)
);
GO

-- C5. ReservationRoomNight (agreed rate per night)
CREATE TABLE gshg.ReservationRoomNight
(
    ReservationRoomID  BIGINT         NOT NULL,
    StayDate           DATE           NOT NULL,
    HotelID            INT            NOT NULL,   -- copied (D1)
    RoomCategoryID     SMALLINT       NOT NULL,   -- copied (D1); cascades from the line
    AgreedRoomRate     DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_ReservationRoomNight                   PRIMARY KEY (ReservationRoomID, StayDate),
    CONSTRAINT UQ_ReservationRoomNight_ID_Date_Hotel     UNIQUE (ReservationRoomID, StayDate, HotelID),   -- FK target for allocations
    CONSTRAINT FK_ReservationRoomNight_ReservationRoom   FOREIGN KEY (ReservationRoomID, HotelID, RoomCategoryID)
                                                         REFERENCES gshg.ReservationRoom (ReservationRoomID, HotelID, RoomCategoryID)
                                                         ON UPDATE CASCADE,
    CONSTRAINT CK_ReservationRoomNight_Rate              CHECK (AgreedRoomRate >= 0)
);
GO

-- C6. RoomNightAllocation (the room ledger: bookings and maintenance windows)
CREATE TABLE gshg.RoomNightAllocation
(
    RoomID             INT     NOT NULL,
    StayDate           DATE    NOT NULL,
    HotelID            INT     NOT NULL,   -- copied (D1)
    ReservationRoomID  BIGINT  NULL,
    MaintenanceID      INT     NULL,
    -- K1 (Member 1 headline): one booking or one maintenance job per room per night
    CONSTRAINT PK_RoomNightAllocation                       PRIMARY KEY (RoomID, StayDate),
    CONSTRAINT FK_RoomNightAllocation_Room                  FOREIGN KEY (RoomID, HotelID)
                                                            REFERENCES gshg.Room (RoomID, HotelID),
    CONSTRAINT FK_RoomNightAllocation_ReservationRoomNight  FOREIGN KEY (ReservationRoomID, StayDate, HotelID)
                                                            REFERENCES gshg.ReservationRoomNight (ReservationRoomID, StayDate, HotelID),
    CONSTRAINT FK_RoomNightAllocation_RoomMaintenance       FOREIGN KEY (MaintenanceID, RoomID)
                                                            REFERENCES gshg.RoomMaintenance (MaintenanceID, RoomID),
    CONSTRAINT CK_RoomNightAllocation_ExactlyOneOwner       CHECK ((ReservationRoomID IS NOT NULL AND MaintenanceID IS NULL)
                                                                OR (ReservationRoomID IS NULL AND MaintenanceID IS NOT NULL))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_RoomNightAllocation_LineNight
    ON gshg.RoomNightAllocation (ReservationRoomID, StayDate)
    WHERE ReservationRoomID IS NOT NULL;
GO

-- C7. RoomOccupant (M:N junction ReservationRoom x Guest)
CREATE TABLE gshg.RoomOccupant
(
    RoomOccupantID        BIGINT IDENTITY(1,1) NOT NULL,
    ReservationRoomID     BIGINT       NOT NULL,
    GuestID               BIGINT       NOT NULL,
    IdDocumentType        VARCHAR(11)  NULL,
    IdDocumentNumber      VARCHAR(50)  NULL,
    IdIssuingCountryCode  CHAR(2)      NULL,
    CONSTRAINT PK_RoomOccupant                    PRIMARY KEY (RoomOccupantID),
    CONSTRAINT UQ_RoomOccupant_Line_ID            UNIQUE (ReservationRoomID, RoomOccupantID),   -- FK target for services
    CONSTRAINT UQ_RoomOccupant_Line_Guest         UNIQUE (ReservationRoomID, GuestID),
    CONSTRAINT FK_RoomOccupant_ReservationRoom    FOREIGN KEY (ReservationRoomID) REFERENCES gshg.ReservationRoom (ReservationRoomID),
    CONSTRAINT FK_RoomOccupant_Guest              FOREIGN KEY (GuestID) REFERENCES gshg.Guest (GuestID),
    CONSTRAINT FK_RoomOccupant_GuestDocument      FOREIGN KEY (IdDocumentType, IdDocumentNumber, IdIssuingCountryCode, GuestID)
                                                  REFERENCES gshg.GuestDocument (DocumentType, DocumentNumber, IssuingCountryCode, GuestID)
                                                  ON UPDATE CASCADE,
    CONSTRAINT CK_RoomOccupant_DocumentAllOrNone  CHECK ((IdDocumentType IS NULL AND IdDocumentNumber IS NULL AND IdIssuingCountryCode IS NULL)
                                                      OR (IdDocumentType IS NOT NULL AND IdDocumentNumber IS NOT NULL AND IdIssuingCountryCode IS NOT NULL))
);
GO

-- C8. ReservationService
CREATE TABLE gshg.ReservationService
(
    ReservationServiceID  BIGINT IDENTITY(1,1) NOT NULL,
    ReservationID         BIGINT             NOT NULL,
    HotelID               INT                NOT NULL,   -- copied (D1)
    HotelServiceID        INT                NOT NULL,
    ChargingBasis         VARCHAR(15)        NOT NULL,   -- copied at booking; must match HotelService (T7)
    ReservationRoomID     BIGINT             NULL,
    RoomOccupantID        BIGINT             NULL,
    StartDate             DATE               NOT NULL,
    Days                  SMALLINT           NOT NULL,
    Quantity              SMALLINT           NOT NULL,
    AgreedUnitPrice       DECIMAL(10,2)      NOT NULL,
    BookedAt              DATETIMEOFFSET(0)  NOT NULL,
    CONSTRAINT PK_ReservationService                  PRIMARY KEY (ReservationServiceID),
    CONSTRAINT FK_ReservationService_Reservation      FOREIGN KEY (ReservationID, HotelID)
                                                      REFERENCES gshg.Reservation (ReservationID, HotelID),
    CONSTRAINT FK_ReservationService_HotelService     FOREIGN KEY (HotelServiceID, HotelID)
                                                      REFERENCES gshg.HotelService (HotelServiceID, HotelID),
    CONSTRAINT FK_ReservationService_ReservationRoom  FOREIGN KEY (ReservationID, ReservationRoomID)
                                                      REFERENCES gshg.ReservationRoom (ReservationID, ReservationRoomID),
    CONSTRAINT FK_ReservationService_RoomOccupant     FOREIGN KEY (ReservationRoomID, RoomOccupantID)
                                                      REFERENCES gshg.RoomOccupant (ReservationRoomID, RoomOccupantID),
    CONSTRAINT CK_ReservationService_Days             CHECK (Days >= 1),
    CONSTRAINT CK_ReservationService_Quantity         CHECK (Quantity >= 1),
    CONSTRAINT CK_ReservationService_UnitPrice        CHECK (AgreedUnitPrice >= 0)
);
GO

-- C9. ReservationDateChange (append-only)
CREATE TABLE gshg.ReservationDateChange
(
    DateChangeID     BIGINT IDENTITY(1,1) NOT NULL,
    ReservationID    BIGINT             NOT NULL,
    ChangedAt        DATETIMEOFFSET(0)  NOT NULL,
    OldCheckInDate   DATE               NOT NULL,
    OldCheckOutDate  DATE               NOT NULL,
    NewCheckInDate   DATE               NOT NULL,
    NewCheckOutDate  DATE               NOT NULL,
    OldRoomTotal     DECIMAL(12,2)      NOT NULL,
    NewRoomTotal     DECIMAL(12,2)      NOT NULL,
    Reason           NVARCHAR(255)      NULL,
    CONSTRAINT PK_ReservationDateChange               PRIMARY KEY (DateChangeID),
    CONSTRAINT FK_ReservationDateChange_Reservation   FOREIGN KEY (ReservationID) REFERENCES gshg.Reservation (ReservationID),
    CONSTRAINT CK_ReservationDateChange_NewOrder      CHECK (NewCheckOutDate > NewCheckInDate),
    CONSTRAINT CK_ReservationDateChange_PairChanged   CHECK (NewCheckInDate <> OldCheckInDate OR NewCheckOutDate <> OldCheckOutDate)
);
GO

-- C10. RoomCategoryChange (append-only)
CREATE TABLE gshg.RoomCategoryChange
(
    CategoryChangeID   BIGINT IDENTITY(1,1) NOT NULL,
    ReservationRoomID  BIGINT             NOT NULL,
    ChangedAt          DATETIMEOFFSET(0)  NOT NULL,
    OldRoomCategoryID  SMALLINT           NOT NULL,
    NewRoomCategoryID  SMALLINT           NOT NULL,
    OldRoomTotal       DECIMAL(12,2)      NOT NULL,
    NewRoomTotal       DECIMAL(12,2)      NOT NULL,
    Reason             NVARCHAR(255)      NULL,
    CONSTRAINT PK_RoomCategoryChange                 PRIMARY KEY (CategoryChangeID),
    CONSTRAINT FK_RoomCategoryChange_ReservationRoom FOREIGN KEY (ReservationRoomID) REFERENCES gshg.ReservationRoom (ReservationRoomID),
    CONSTRAINT FK_RoomCategoryChange_OldCategory     FOREIGN KEY (OldRoomCategoryID) REFERENCES gshg.RoomCategory (RoomCategoryID),
    CONSTRAINT FK_RoomCategoryChange_NewCategory     FOREIGN KEY (NewRoomCategoryID) REFERENCES gshg.RoomCategory (RoomCategoryID),
    CONSTRAINT CK_RoomCategoryChange_NewNotOld       CHECK (NewRoomCategoryID <> OldRoomCategoryID)
);
GO

/* =====================================================================================
   5. GROUP D — Billing and payments (6)
   ===================================================================================== */

-- D1. AdditionalCharge (minibar, damage, late check-out, other)
CREATE TABLE gshg.AdditionalCharge
(
    AdditionalChargeID  BIGINT IDENTITY(1,1) NOT NULL,
    ReservationRoomID   BIGINT             NOT NULL,
    ChargeType          VARCHAR(13)        NOT NULL,
    ChargeDate          DATE               NOT NULL,   -- hotel-local date the charge arose
    Description         NVARCHAR(255)      NOT NULL,
    Amount              DECIMAL(12,2)      NOT NULL,
    PostedAt            DATETIMEOFFSET(0)  NOT NULL,
    CONSTRAINT PK_AdditionalCharge                  PRIMARY KEY (AdditionalChargeID),
    CONSTRAINT UQ_AdditionalCharge_ID_Amount        UNIQUE (AdditionalChargeID, Amount),   -- FK target for InvoiceLine
    CONSTRAINT FK_AdditionalCharge_ReservationRoom  FOREIGN KEY (ReservationRoomID) REFERENCES gshg.ReservationRoom (ReservationRoomID),
    CONSTRAINT CK_AdditionalCharge_ChargeType       CHECK (ChargeType IN ('MINIBAR','DAMAGE','LATE_CHECKOUT','OTHER')),
    CONSTRAINT CK_AdditionalCharge_Amount           CHECK (Amount > 0)
);
GO

-- D2. ReservationDiscount
CREATE TABLE gshg.ReservationDiscount
(
    DiscountID     BIGINT IDENTITY(1,1) NOT NULL,
    ReservationID  BIGINT             NOT NULL,
    HotelID        INT                NOT NULL,   -- copied (D1)
    PromotionID    INT                NULL,
    Amount         DECIMAL(12,2)      NOT NULL,
    Reason         NVARCHAR(255)      NULL,
    PostedAt       DATETIMEOFFSET(0)  NOT NULL,
    CONSTRAINT PK_ReservationDiscount                  PRIMARY KEY (DiscountID),
    CONSTRAINT FK_ReservationDiscount_Reservation      FOREIGN KEY (ReservationID, HotelID)
                                                       REFERENCES gshg.Reservation (ReservationID, HotelID),
    CONSTRAINT FK_ReservationDiscount_PromotionHotel   FOREIGN KEY (PromotionID, HotelID)
                                                       REFERENCES gshg.PromotionHotel (PromotionID, HotelID),
    CONSTRAINT CK_ReservationDiscount_Amount           CHECK (Amount > 0),
    CONSTRAINT CK_ReservationDiscount_PromoOrReason    CHECK (PromotionID IS NOT NULL OR Reason IS NOT NULL)
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_ReservationDiscount_PromotionOnce
    ON gshg.ReservationDiscount (ReservationID, PromotionID)
    WHERE PromotionID IS NOT NULL;
GO

-- D3. Payment (append-only)
CREATE TABLE gshg.Payment
(
    PaymentID          BIGINT IDENTITY(1,1) NOT NULL,
    ReservationID      BIGINT             NOT NULL,
    PaymentMethodID    TINYINT            NOT NULL,
    Amount             DECIMAL(12,2)      NOT NULL,
    PaidAt             DATETIMEOFFSET(0)  NOT NULL,
    ExternalReference  VARCHAR(100)       NULL,
    CONSTRAINT PK_Payment                  PRIMARY KEY (PaymentID),
    CONSTRAINT UQ_Payment_ID_Amount_PaidAt UNIQUE (PaymentID, Amount, PaidAt),   -- FK target for Refund
    CONSTRAINT FK_Payment_Reservation      FOREIGN KEY (ReservationID)   REFERENCES gshg.Reservation (ReservationID),
    CONSTRAINT FK_Payment_PaymentMethod    FOREIGN KEY (PaymentMethodID) REFERENCES gshg.PaymentMethod (PaymentMethodID),
    CONSTRAINT CK_Payment_Amount           CHECK (Amount > 0)
);
GO

-- D4. Refund (append-only; no trigger)
CREATE TABLE gshg.Refund
(
    RefundID           BIGINT IDENTITY(1,1) NOT NULL,
    PaymentID          BIGINT             NOT NULL,
    PaymentAmount      DECIMAL(12,2)      NOT NULL,   -- copied (D1)
    PaymentPaidAt      DATETIMEOFFSET(0)  NOT NULL,   -- copied (D1)
    Amount             DECIMAL(12,2)      NOT NULL,
    RefundedAt         DATETIMEOFFSET(0)  NOT NULL,
    ExternalReference  VARCHAR(100)       NULL,
    Reason             NVARCHAR(255)      NOT NULL,
    CONSTRAINT PK_Refund                 PRIMARY KEY (RefundID),
    CONSTRAINT UQ_Refund_PaymentID       UNIQUE (PaymentID),
    CONSTRAINT FK_Refund_Payment         FOREIGN KEY (PaymentID, PaymentAmount, PaymentPaidAt)
                                         REFERENCES gshg.Payment (PaymentID, Amount, PaidAt),
    CONSTRAINT CK_Refund_Amount          CHECK (Amount > 0 AND Amount <= PaymentAmount),
    CONSTRAINT CK_Refund_AfterPayment    CHECK (RefundedAt >= PaymentPaidAt)
);
GO

-- D5. Invoice (one INVOICE per reservation; any number of DEBIT_NOTEs and CREDIT_NOTEs)
CREATE TABLE gshg.Invoice
(
    InvoiceID      BIGINT IDENTITY(1,1) NOT NULL,
    InvoiceNumber  VARCHAR(20)        NOT NULL,
    ReservationID  BIGINT             NOT NULL,
    InvoiceType    VARCHAR(11)        NOT NULL,
    MyrPerUnit     DECIMAL(18,8)      NULL,
    IssuedAt       DATETIMEOFFSET(0)  NOT NULL,
    FinalisedAt    DATETIMEOFFSET(0)  NULL,
    Reason         NVARCHAR(255)      NULL,
    CONSTRAINT PK_Invoice                    PRIMARY KEY (InvoiceID),
    CONSTRAINT UQ_Invoice_ID_Type            UNIQUE (InvoiceID, InvoiceType),   -- FK target for InvoiceLine (D1)
    CONSTRAINT UQ_Invoice_InvoiceNumber      UNIQUE (InvoiceNumber),
    CONSTRAINT FK_Invoice_Reservation        FOREIGN KEY (ReservationID) REFERENCES gshg.Reservation (ReservationID),
    CONSTRAINT CK_Invoice_InvoiceType        CHECK (InvoiceType IN ('INVOICE','DEBIT_NOTE','CREDIT_NOTE')),
    CONSTRAINT CK_Invoice_RateWhenCharging   CHECK ((InvoiceType <> 'CREDIT_NOTE' AND MyrPerUnit IS NOT NULL)
                                                 OR (InvoiceType =  'CREDIT_NOTE' AND MyrPerUnit IS NULL)),
    CONSTRAINT CK_Invoice_NoteHasReason      CHECK (InvoiceType = 'INVOICE' OR Reason IS NOT NULL)
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_Invoice_OneInvoicePerReservation
    ON gshg.Invoice (ReservationID)
    WHERE InvoiceType = 'INVOICE';
GO

-- D6. InvoiceLine (append-only)
CREATE TABLE gshg.InvoiceLine
(
    InvoiceID             BIGINT         NOT NULL,
    LineNumber            SMALLINT       NOT NULL,
    InvoiceType           VARCHAR(11)    NOT NULL,   -- copied (D1)
    LineType              VARCHAR(16)    NOT NULL,
    LineDate              DATE           NOT NULL,   -- hotel-local service date
    ReservationServiceID  BIGINT         NULL,
    AdditionalChargeID    BIGINT         NULL,
    ReversesInvoiceID     BIGINT         NULL,
    ReversesLineNumber    SMALLINT       NULL,
    Description           NVARCHAR(255)  NOT NULL,
    Amount                DECIMAL(12,2)  NOT NULL,
    CONSTRAINT PK_InvoiceLine                       PRIMARY KEY (InvoiceID, LineNumber),
    CONSTRAINT UQ_InvoiceLine_ID_Line_Type          UNIQUE (InvoiceID, LineNumber, LineType),   -- FK target for credit lines
    CONSTRAINT FK_InvoiceLine_Invoice               FOREIGN KEY (InvoiceID, InvoiceType)
                                                    REFERENCES gshg.Invoice (InvoiceID, InvoiceType),
    CONSTRAINT FK_InvoiceLine_ReservationService    FOREIGN KEY (ReservationServiceID)
                                                    REFERENCES gshg.ReservationService (ReservationServiceID),
    CONSTRAINT FK_InvoiceLine_AdditionalCharge      FOREIGN KEY (AdditionalChargeID, Amount)
                                                    REFERENCES gshg.AdditionalCharge (AdditionalChargeID, Amount),
    CONSTRAINT FK_InvoiceLine_ReversedLine          FOREIGN KEY (ReversesInvoiceID, ReversesLineNumber, LineType)
                                                    REFERENCES gshg.InvoiceLine (InvoiceID, LineNumber, LineType),
    CONSTRAINT CK_InvoiceLine_LineType              CHECK (LineType IN ('ROOM','SUPPLEMENT','SERVICE','ADDITIONAL',
                                                                        'CANCELLATION_FEE','NO_SHOW_FEE','DISCOUNT'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_InvoiceLine_ServiceBilledOnce
    ON gshg.InvoiceLine (ReservationServiceID)
    WHERE ReservationServiceID IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_InvoiceLine_ChargeBilledOnce
    ON gshg.InvoiceLine (AdditionalChargeID)
    WHERE AdditionalChargeID IS NOT NULL;
GO

/* =====================================================================================
   6. Self-check: 34 tables and an inventory of declarative objects
   ===================================================================================== */
DECLARE @TableCount INT = (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'gshg'));
IF @TableCount <> 34
BEGIN
    DECLARE @Msg NVARCHAR(200) = CONCAT(N'Stage 1 expected 34 tables in gshg, found ', @TableCount, N'.');
    THROW 50001, @Msg, 1;
END;

SELECT  Item, ObjectCount
FROM   (VALUES
          (N'Tables',                    (SELECT COUNT(*) FROM sys.tables             WHERE schema_id = SCHEMA_ID(N'gshg'))),
          (N'Primary keys',              (SELECT COUNT(*) FROM sys.key_constraints    WHERE schema_id = SCHEMA_ID(N'gshg') AND type = 'PK')),
          (N'Unique constraints',        (SELECT COUNT(*) FROM sys.key_constraints    WHERE schema_id = SCHEMA_ID(N'gshg') AND type = 'UQ')),
          (N'Foreign keys',              (SELECT COUNT(*) FROM sys.foreign_keys       WHERE schema_id = SCHEMA_ID(N'gshg'))),
          (N'  of which ON UPDATE CASCADE', (SELECT COUNT(*) FROM sys.foreign_keys    WHERE schema_id = SCHEMA_ID(N'gshg') AND update_referential_action = 1)),
          (N'Check constraints',         (SELECT COUNT(*) FROM sys.check_constraints  WHERE schema_id = SCHEMA_ID(N'gshg'))),
          (N'Default constraints',       (SELECT COUNT(*) FROM sys.default_constraints WHERE schema_id = SCHEMA_ID(N'gshg'))),
          (N'Filtered unique indexes',   (SELECT COUNT(*) FROM sys.indexes i JOIN sys.tables t ON t.object_id = i.object_id
                                          WHERE t.schema_id = SCHEMA_ID(N'gshg') AND i.has_filter = 1 AND i.is_unique = 1))
       ) AS v (Item, ObjectCount);
GO