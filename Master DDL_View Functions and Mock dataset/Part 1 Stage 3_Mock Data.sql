--   STAGE 3 — Mock data, loaded with all 15 triggers ENABLED

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
USE GSHG;
GO

IF EXISTS (SELECT 1 FROM gshg.Currency) OR EXISTS (SELECT 1 FROM gshg.Reservation)
BEGIN
    RAISERROR(N'Stage 4 loads into empty tables. Run Stages 1, 2 and 3 first, then this script.', 16, 1);
    SET NOEXEC ON;
END;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT gshg.Currency (CurrencyCode, CurrencyName) VALUES
    ('MYR', N'Malaysian Ringgit'),
    ('SGD', N'Singapore Dollar'),
    ('THB', N'Thai Baht'),
    ('JPY', N'Japanese Yen'),
    ('GBP', N'Pound Sterling'),
    ('AUD', N'Australian Dollar'),
    ('USD', N'US Dollar');

    INSERT gshg.ExchangeRate (CurrencyCode, RateDate, MyrPerUnit) VALUES
    ('MYR', '2024-12-01', 1.00000000),
    ('MYR', '2025-01-01', 1.00000000),
    ('MYR', '2025-02-01', 1.00000000),
    ('MYR', '2025-03-01', 1.00000000),
    ('MYR', '2025-04-01', 1.00000000),
    ('MYR', '2025-05-01', 1.00000000),
    ('MYR', '2025-06-01', 1.00000000),
    ('MYR', '2025-07-01', 1.00000000),
    ('MYR', '2025-08-01', 1.00000000),
    ('MYR', '2025-09-01', 1.00000000),
    ('MYR', '2025-10-01', 1.00000000),
    ('MYR', '2025-11-01', 1.00000000),
    ('MYR', '2025-12-01', 1.00000000),
    ('MYR', '2026-01-01', 1.00000000),
    ('MYR', '2026-02-01', 1.00000000),
    ('MYR', '2026-03-01', 1.00000000),
    ('MYR', '2026-04-01', 1.00000000),
    ('MYR', '2026-05-01', 1.00000000),
    ('MYR', '2026-06-01', 1.00000000),
    ('MYR', '2026-07-01', 1.00000000),
    ('MYR', '2026-08-01', 1.00000000),
    ('MYR', '2026-09-01', 1.00000000),
    ('MYR', '2026-10-01', 1.00000000),
    ('MYR', '2026-11-01', 1.00000000),
    ('MYR', '2026-12-01', 1.00000000),
    ('MYR', '2027-01-01', 1.00000000),
    ('MYR', '2027-02-01', 1.00000000),
    ('MYR', '2027-03-01', 1.00000000),
    ('MYR', '2027-04-01', 1.00000000),
    ('MYR', '2027-05-01', 1.00000000),
    ('MYR', '2027-06-01', 1.00000000),
    ('MYR', '2027-07-01', 1.00000000),
    ('MYR', '2027-08-01', 1.00000000),
    ('MYR', '2027-09-01', 1.00000000),
    ('MYR', '2027-10-01', 1.00000000),
    ('MYR', '2027-11-01', 1.00000000),
    ('MYR', '2027-12-01', 1.00000000),
    ('SGD', '2024-12-01', 3.35000000),
    ('SGD', '2025-01-01', 3.41250000),
    ('SGD', '2025-02-01', 3.36250000),
    ('SGD', '2025-03-01', 3.42500000),
    ('SGD', '2025-04-01', 3.37500000),
    ('SGD', '2025-05-01', 3.43750000),
    ('SGD', '2025-06-01', 3.38750000),
    ('SGD', '2025-07-01', 3.45000000),
    ('SGD', '2025-08-01', 3.40000000),
    ('SGD', '2025-09-01', 3.35000000),
    ('SGD', '2025-10-01', 3.41250000),
    ('SGD', '2025-11-01', 3.36250000),
    ('SGD', '2025-12-01', 3.42500000),
    ('SGD', '2026-01-01', 3.37500000),
    ('SGD', '2026-02-01', 3.43750000),
    ('SGD', '2026-03-01', 3.38750000),
    ('SGD', '2026-04-01', 3.45000000),
    ('SGD', '2026-05-01', 3.40000000),
    ('SGD', '2026-06-01', 3.35000000),
    ('SGD', '2026-07-01', 3.41250000),
    ('SGD', '2026-08-01', 3.36250000),
    ('SGD', '2026-09-01', 3.42500000),
    ('SGD', '2026-10-01', 3.37500000),
    ('SGD', '2026-11-01', 3.43750000),
    ('SGD', '2026-12-01', 3.38750000),
    ('SGD', '2027-01-01', 3.45000000),
    ('SGD', '2027-02-01', 3.40000000),
    ('SGD', '2027-03-01', 3.35000000),
    ('SGD', '2027-04-01', 3.41250000),
    ('SGD', '2027-05-01', 3.36250000),
    ('SGD', '2027-06-01', 3.42500000),
    ('SGD', '2027-07-01', 3.37500000),
    ('SGD', '2027-08-01', 3.43750000),
    ('SGD', '2027-09-01', 3.38750000),
    ('SGD', '2027-10-01', 3.45000000),
    ('SGD', '2027-11-01', 3.40000000),
    ('SGD', '2027-12-01', 3.35000000),
    ('THB', '2024-12-01', 0.12500000),
    ('THB', '2025-01-01', 0.12800000),
    ('THB', '2025-02-01', 0.13100000),
    ('THB', '2025-03-01', 0.12700000),
    ('THB', '2025-04-01', 0.13000000),
    ('THB', '2025-05-01', 0.12600000),
    ('THB', '2025-06-01', 0.12900000),
    ('THB', '2025-07-01', 0.12500000),
    ('THB', '2025-08-01', 0.12800000),
    ('THB', '2025-09-01', 0.13100000),
    ('THB', '2025-10-01', 0.12700000),
    ('THB', '2025-11-01', 0.13000000),
    ('THB', '2025-12-01', 0.12600000),
    ('THB', '2026-01-01', 0.12900000),
    ('THB', '2026-02-01', 0.12500000),
    ('THB', '2026-03-01', 0.12800000),
    ('THB', '2026-04-01', 0.13100000),
    ('THB', '2026-05-01', 0.12700000),
    ('THB', '2026-06-01', 0.13000000),
    ('THB', '2026-07-01', 0.12600000),
    ('THB', '2026-08-01', 0.12900000),
    ('THB', '2026-09-01', 0.12500000),
    ('THB', '2026-10-01', 0.12800000),
    ('THB', '2026-11-01', 0.13100000),
    ('THB', '2026-12-01', 0.12700000),
    ('THB', '2027-01-01', 0.13000000),
    ('THB', '2027-02-01', 0.12600000),
    ('THB', '2027-03-01', 0.12900000),
    ('THB', '2027-04-01', 0.12500000),
    ('THB', '2027-05-01', 0.12800000),
    ('THB', '2027-06-01', 0.13100000),
    ('THB', '2027-07-01', 0.12700000),
    ('THB', '2027-08-01', 0.13000000),
    ('THB', '2027-09-01', 0.12600000),
    ('THB', '2027-10-01', 0.12900000),
    ('THB', '2027-11-01', 0.12500000),
    ('THB', '2027-12-01', 0.12800000),
    ('JPY', '2024-12-01', 0.02950000),
    ('JPY', '2025-01-01', 0.03050000),
    ('JPY', '2025-02-01', 0.03150000),
    ('JPY', '2025-03-01', 0.03025000),
    ('JPY', '2025-04-01', 0.03125000),
    ('JPY', '2025-05-01', 0.03000000),
    ('JPY', '2025-06-01', 0.03100000),
    ('JPY', '2025-07-01', 0.02975000),
    ('JPY', '2025-08-01', 0.03075000),
    ('JPY', '2025-09-01', 0.02950000),
    ('JPY', '2025-10-01', 0.03050000),
    ('JPY', '2025-11-01', 0.03150000),
    ('JPY', '2025-12-01', 0.03025000),
    ('JPY', '2026-01-01', 0.03125000),
    ('JPY', '2026-02-01', 0.03000000),
    ('JPY', '2026-03-01', 0.03100000),
    ('JPY', '2026-04-01', 0.02975000),
    ('JPY', '2026-05-01', 0.03075000),
    ('JPY', '2026-06-01', 0.02950000),
    ('JPY', '2026-07-01', 0.03050000),
    ('JPY', '2026-08-01', 0.03150000),
    ('JPY', '2026-09-01', 0.03025000),
    ('JPY', '2026-10-01', 0.03125000),
    ('JPY', '2026-11-01', 0.03000000),
    ('JPY', '2026-12-01', 0.03100000),
    ('JPY', '2027-01-01', 0.02975000),
    ('JPY', '2027-02-01', 0.03075000),
    ('JPY', '2027-03-01', 0.02950000),
    ('JPY', '2027-04-01', 0.03050000),
    ('JPY', '2027-05-01', 0.03150000),
    ('JPY', '2027-06-01', 0.03025000),
    ('JPY', '2027-07-01', 0.03125000),
    ('JPY', '2027-08-01', 0.03000000),
    ('JPY', '2027-09-01', 0.03100000),
    ('JPY', '2027-10-01', 0.02975000),
    ('JPY', '2027-11-01', 0.03075000),
    ('JPY', '2027-12-01', 0.02950000);

    INSERT gshg.Country (CountryCode, CountryName, CurrencyCode) VALUES
    ('MY', N'Malaysia', 'MYR'),
    ('SG', N'Singapore', 'SGD'),
    ('TH', N'Thailand', 'THB'),
    ('JP', N'Japan', 'JPY'),
    ('GB', N'United Kingdom', 'GBP'),
    ('AU', N'Australia', 'AUD'),
    ('US', N'United States', 'USD');

    SET IDENTITY_INSERT gshg.RoomCategory ON;
    INSERT gshg.RoomCategory (RoomCategoryID, CategoryCode, CategoryName) VALUES
    (1, 'STD', N'Standard'),
    (2, 'DLX', N'Deluxe'),
    (3, 'SUI', N'Suite'),
    (4, 'FAM', N'Family');
    SET IDENTITY_INSERT gshg.RoomCategory OFF;

    INSERT gshg.RoomCategoryUpgrade (FromRoomCategoryID, ToRoomCategoryID) VALUES
    (1, 2),  -- STD -> DLX
    (1, 3),  -- STD -> SUI
    (2, 3);  -- DLX -> SUI

    INSERT gshg.HeadcountCategory (HeadcountCategoryCode, CategoryName, IsResponsibleAdult) VALUES
    ('ADULT', N'Adult', 1),
    ('CHILD', N'Child', 0),
    ('INFANT', N'Infant', 0);

    INSERT gshg.AgeBand (MinAgeYears, BandName, HeadcountCategoryCode, RateClass) VALUES
    (0, N'Infant', 'INFANT', 'NONE'),
    (2, N'Reduced-rate child', 'CHILD', 'REDUCED'),
    (12, N'Full-rate minor', 'CHILD', 'FULL'),
    (18, N'Adult', 'ADULT', 'FULL');

    SET IDENTITY_INSERT gshg.RatePlan ON;
    INSERT gshg.RatePlan (RatePlanID, RatePlanCode, RatePlanName, RateAdjustmentPct, NoShowChargeBasis) VALUES
    (1, 'BAR', N'Best Available Rate', 0, 'FIRST_NIGHT'),
    (2, 'FLEX', N'Flexible Rate', 10, 'NONE'),
    (3, 'NRF', N'Non-Refundable Saver', -15, 'FULL_STAY'),
    (4, 'MEMBER', N'Member Rate', -10, 'FIRST_NIGHT');
    SET IDENTITY_INSERT gshg.RatePlan OFF;

    SET IDENTITY_INSERT gshg.ServiceType ON;
    INSERT gshg.ServiceType (ServiceTypeID, TypeName, ServiceClass, MaxOccupantAgeYears) VALUES
    (1, N'Breakfast', 'OPTIONAL', NULL),
    (2, N'Airport Transfer', 'OPTIONAL', NULL),
    (3, N'Spa Treatment', 'OPTIONAL', NULL),
    (4, N'Parking', 'OPTIONAL', NULL),
    (5, N'Laundry', 'OPTIONAL', NULL),
    (6, N'Baby Cot', 'BEDDING', 1),
    (7, N'Extra Bed', 'BEDDING', NULL);
    SET IDENTITY_INSERT gshg.ServiceType OFF;

    SET IDENTITY_INSERT gshg.PaymentMethod ON;
    INSERT gshg.PaymentMethod (PaymentMethodID, MethodName, RetiredOn) VALUES
    (1, N'Cash', NULL),
    (2, N'Credit Card', NULL),
    (3, N'Debit Card', NULL),
    (4, N'Bank Transfer', NULL),
    (5, N'E-Wallet', NULL),
    (6, N'Cheque', '2026-01-01');  -- retired 2026-01-01; used only in 2025
    SET IDENTITY_INSERT gshg.PaymentMethod OFF;


    SET IDENTITY_INSERT gshg.Hotel ON;
    INSERT gshg.Hotel (HotelID, HotelCode, HotelName, CountryCode, City, AddressLine, PostalCode, Phone, Email,
                       TimeZoneId, StandardCheckInTime, StandardCheckOutTime, NoShowCutoffTime, SalesEndOn) VALUES
    (1, 'GSH-KUL', N'Grand Stay Kuala Lumpur', 'MY', N'Kuala Lumpur', N'88 Jalan Sultan Ismail', '50250', '+60 3 2141 8800', 'kul@grandstay.example', 'Singapore Standard Time', '15:00', '12:00', '23:59', NULL),  -- MYR, UTC+8
    (2, 'GSH-PEN', N'Grand Stay Penang', 'MY', N'George Town', N'12 Lebuh Farquhar', '10200', '+60 4 261 2200', 'pen@grandstay.example', 'Singapore Standard Time', '15:00', '12:00', '23:59', NULL),  -- MYR, UTC+8
    (3, 'GSH-SIN', N'Grand Stay Singapore', 'SG', N'Singapore', N'30 Orchard Link', '238880', '+65 6733 8800', 'sin@grandstay.example', 'Singapore Standard Time', '15:00', '12:00', '23:59', NULL),  -- SGD, UTC+8
    (4, 'GSH-BKK', N'Grand Stay Bangkok', 'TH', N'Bangkok', N'199 Sukhumvit Soi 11', '10110', '+66 2 254 8800', 'bkk@grandstay.example', 'SE Asia Standard Time', '15:00', '12:00', '22:00', NULL),  -- THB, UTC+7
    (5, 'GSH-TYO', N'Grand Stay Tokyo', 'JP', N'Tokyo', N'2-1 Marunouchi, Chiyoda-ku', '100-0005', '+81 3 3211 8800', 'tyo@grandstay.example', 'Tokyo Standard Time', '14:00', '11:00', '23:59', NULL);  -- JPY, UTC+9
    SET IDENTITY_INSERT gshg.Hotel OFF;

    INSERT gshg.HotelRoomCategory (HotelID, RoomCategoryID, BaseOccupancy, StandardNightlyRate, ExtraPersonRate, ReducedChildRate, WithdrawnOn) VALUES
    (1, 1, 2, 280, 80, 40, NULL),
    (1, 2, 2, 420, 100, 50, NULL),
    (1, 3, 2, 900, 150, 75, NULL),
    (1, 4, 4, 600, 90, 45, NULL),
    (2, 1, 2, 230, 70, 35, NULL),
    (2, 2, 2, 350, 90, 45, NULL),
    (2, 3, 2, 760, 130, 65, NULL),
    (2, 4, 4, 520, 80, 40, NULL),
    (3, 1, 2, 260, 60, 30, NULL),
    (3, 2, 2, 390, 80, 40, NULL),
    (3, 3, 2, 820, 120, 60, NULL),
    (3, 4, 4, 560, 70, 35, NULL),
    (4, 1, 2, 2600, 700, 350, NULL),
    (4, 2, 2, 3900, 900, 450, NULL),
    (4, 3, 2, 8200, 1300, 650, NULL),
    (4, 4, 4, 5600, 800, 400, NULL),
    (5, 1, 2, 22000, 6000, 3000, NULL),
    (5, 2, 2, 34000, 8000, 4000, NULL),
    (5, 3, 2, 72000, 12000, 6000, NULL),
    (5, 4, 4, 48000, 7000, 3500, NULL);

    SET IDENTITY_INSERT gshg.Room ON;
    INSERT gshg.Room (RoomID, HotelID, RoomCategoryID, RoomNumber, FloorNumber, MaxOccupancy, IsAccessible, RetiredOn) VALUES
    (1, 1, 1, '101', 1, 2, 1, NULL),  -- H1-101 STD accessible
    (2, 1, 1, '102', 1, 2, 0, NULL),  -- H1-102 STD
    (3, 1, 1, '103', 1, 3, 0, NULL),  -- H1-103 STD
    (4, 1, 2, '201', 2, 3, 1, NULL),  -- H1-201 DLX accessible
    (5, 1, 2, '202', 2, 3, 0, NULL),  -- H1-202 DLX
    (6, 1, 2, '203', 2, 3, 0, NULL),  -- H1-203 DLX
    (7, 1, 3, '301', 3, 4, 0, NULL),  -- H1-301 SUI
    (8, 1, 4, '302', 3, 5, 0, NULL),  -- H1-302 FAM
    (9, 2, 1, '101', 1, 2, 1, NULL),  -- H2-101 STD accessible
    (10, 2, 1, '102', 1, 2, 0, NULL),  -- H2-102 STD
    (11, 2, 1, '103', 1, 3, 0, NULL),  -- H2-103 STD
    (12, 2, 2, '201', 2, 3, 1, NULL),  -- H2-201 DLX accessible
    (13, 2, 2, '202', 2, 3, 0, NULL),  -- H2-202 DLX
    (14, 2, 2, '203', 2, 3, 0, NULL),  -- H2-203 DLX
    (15, 2, 3, '301', 3, 4, 0, NULL),  -- H2-301 SUI
    (16, 2, 4, '302', 3, 5, 0, NULL),  -- H2-302 FAM
    (17, 3, 1, '101', 1, 2, 1, NULL),  -- H3-101 STD accessible
    (18, 3, 1, '102', 1, 2, 0, NULL),  -- H3-102 STD
    (19, 3, 1, '103', 1, 3, 0, NULL),  -- H3-103 STD
    (20, 3, 2, '201', 2, 3, 1, NULL),  -- H3-201 DLX accessible
    (21, 3, 2, '202', 2, 3, 0, NULL),  -- H3-202 DLX
    (22, 3, 2, '203', 2, 3, 0, NULL),  -- H3-203 DLX
    (23, 3, 3, '301', 3, 4, 0, NULL),  -- H3-301 SUI
    (24, 3, 4, '302', 3, 5, 0, NULL),  -- H3-302 FAM
    (25, 4, 1, '101', 1, 2, 1, NULL),  -- H4-101 STD accessible
    (26, 4, 1, '102', 1, 2, 0, NULL),  -- H4-102 STD
    (27, 4, 1, '103', 1, 3, 0, NULL),  -- H4-103 STD
    (28, 4, 2, '201', 2, 3, 1, NULL),  -- H4-201 DLX accessible
    (29, 4, 2, '202', 2, 3, 0, NULL),  -- H4-202 DLX
    (30, 4, 2, '203', 2, 3, 0, NULL),  -- H4-203 DLX
    (31, 4, 3, '301', 3, 4, 0, NULL),  -- H4-301 SUI
    (32, 4, 4, '302', 3, 5, 0, NULL),  -- H4-302 FAM
    (33, 5, 1, '101', 1, 2, 1, NULL),  -- H5-101 STD accessible
    (34, 5, 1, '102', 1, 2, 0, NULL),  -- H5-102 STD
    (35, 5, 1, '103', 1, 3, 0, NULL),  -- H5-103 STD
    (36, 5, 2, '201', 2, 3, 1, NULL),  -- H5-201 DLX accessible
    (37, 5, 2, '202', 2, 3, 0, NULL),  -- H5-202 DLX
    (38, 5, 2, '203', 2, 3, 0, NULL),  -- H5-203 DLX
    (39, 5, 3, '301', 3, 4, 0, NULL),  -- H5-301 SUI
    (40, 5, 4, '302', 3, 5, 0, NULL);  -- H5-302 FAM
    SET IDENTITY_INSERT gshg.Room OFF;

    INSERT gshg.RoomRate (HotelID, RoomCategoryID, RateDate, NightlyRate) VALUES
    (1, 2, '2025-12-24', 520),
    (1, 2, '2025-12-25', 520),
    (1, 2, '2025-12-26', 520),
    (1, 2, '2025-12-27', 520),
    (1, 2, '2025-12-28', 520),
    (1, 2, '2025-12-29', 520),
    (1, 2, '2025-12-30', 520),
    (1, 2, '2025-12-31', 520),
    (3, 2, '2026-08-08', 455),
    (3, 2, '2026-08-09', 455),
    (5, 2, '2026-04-01', 41000),
    (5, 2, '2026-04-02', 41000),
    (5, 2, '2026-04-03', 41000),
    (5, 2, '2026-04-04', 41000),
    (5, 2, '2026-04-05', 41000);

    SET IDENTITY_INSERT gshg.HotelService ON;
    INSERT gshg.HotelService (HotelServiceID, HotelID, ServiceTypeID, ServiceClass, ServiceName, ChargingBasis, UnitPrice, StockUnits, WithdrawnOn)
    SELECT v.HotelServiceID, v.HotelID, st.ServiceTypeID, st.ServiceClass, st.TypeName, v.ChargingBasis, v.UnitPrice, v.StockUnits, NULL
    FROM (VALUES
        (1, 1, 1, 'PER_PERSON', 45, NULL),  -- H1 Breakfast
        (2, 1, 2, 'PER_RESERVATION', 120, NULL),  -- H1 Airport Transfer
        (3, 1, 3, 'PER_PERSON', 250, NULL),  -- H1 Spa Treatment
        (4, 1, 4, 'PER_ROOM', 30, NULL),  -- H1 Parking
        (5, 1, 6, 'PER_PERSON', 20, 2),  -- H1 Baby Cot
        (6, 1, 7, 'PER_PERSON', 90, 3),  -- H1 Extra Bed
        (7, 2, 1, 'PER_PERSON', 38, NULL),  -- H2 Breakfast
        (8, 2, 2, 'PER_RESERVATION', 90, NULL),  -- H2 Airport Transfer
        (9, 2, 3, 'PER_PERSON', 220, NULL),  -- H2 Spa Treatment - EDGE 5: OPTIONAL, never purchased (Spa sells at H1 and H3, never at H2)
        (10, 2, 5, 'PER_ROOM', 25, NULL),  -- H2 Laundry - EDGE 5: OPTIONAL, never purchased
        (11, 2, 6, 'PER_PERSON', 20, 2),  -- H2 Baby Cot
        (12, 2, 7, 'PER_PERSON', 80, 3),  -- H2 Extra Bed
        (13, 3, 1, 'PER_PERSON', 32, NULL),  -- H3 Breakfast
        (14, 3, 2, 'PER_RESERVATION', 85, NULL),  -- H3 Airport Transfer
        (15, 3, 3, 'PER_PERSON', 180, NULL),  -- H3 Spa Treatment
        (16, 3, 4, 'PER_ROOM', 40, NULL),  -- H3 Parking
        (17, 3, 6, 'PER_PERSON', 15, 2),  -- H3 Baby Cot
        (18, 3, 7, 'PER_PERSON', 70, 3),  -- H3 Extra Bed
        (19, 4, 1, 'PER_PERSON', 450, NULL),  -- H4 Breakfast
        (20, 4, 2, 'PER_RESERVATION', 1200, NULL),  -- H4 Airport Transfer
        (21, 4, 3, 'PER_PERSON', 2500, NULL),  -- H4 Spa Treatment - EDGE 5: OPTIONAL, never purchased
        (22, 4, 5, 'PER_ROOM', 300, NULL),  -- H4 Laundry
        (23, 4, 6, 'PER_PERSON', 200, 2),  -- H4 Baby Cot
        (24, 4, 7, 'PER_PERSON', 900, 3),  -- H4 Extra Bed
        (25, 5, 1, 'PER_PERSON', 3200, NULL),  -- H5 Breakfast
        (26, 5, 2, 'PER_RESERVATION', 9800, NULL),  -- H5 Airport Transfer
        (27, 5, 3, 'PER_PERSON', 15000, NULL),  -- H5 Spa Treatment
        (28, 5, 4, 'PER_ROOM', 2500, NULL),  -- H5 Parking - EDGE 5: OPTIONAL, never purchased
        (29, 5, 6, 'PER_PERSON', 1500, 2),  -- H5 Baby Cot
        (30, 5, 7, 'PER_PERSON', 7000, 3)  -- H5 Extra Bed
    ) AS v (HotelServiceID, HotelID, ServiceTypeID, ChargingBasis, UnitPrice, StockUnits)
    JOIN gshg.ServiceType AS st ON st.ServiceTypeID = v.ServiceTypeID;
    SET IDENTITY_INSERT gshg.HotelService OFF;

    SET IDENTITY_INSERT gshg.Promotion ON;
    INSERT gshg.Promotion (PromotionID, PromoCode, Description, DiscountType, DiscountValue, ValidFrom, ValidTo) VALUES
    (1, 'EARLY25', N'Early bird 2025: 10% off the room total', 'PERCENT', 10, '2025-01-01', '2025-12-31'),
    (2, 'SUMMER26', N'Summer 2026: fixed amount off', 'FIXED', 50, '2026-05-01', '2026-08-31'),
    (3, 'NEWYEAR27', N'New Year 2027: 15% off the room total', 'PERCENT', 15, '2026-12-01', '2027-02-28'),
    (4, 'LONGSTAY', N'Long-stay goodwill: fixed amount off', 'FIXED', 100, '2025-01-01', '2027-12-31');
    SET IDENTITY_INSERT gshg.Promotion OFF;

    INSERT gshg.PromotionHotel (PromotionID, HotelID) VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (3, 1),
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5);


    SET IDENTITY_INSERT gshg.RoomMaintenance ON;
    INSERT gshg.RoomMaintenance (MaintenanceID, RoomID, MaintenanceReason, OriginalPlannedEndDate, ReportedAt, CancelledAt) VALUES
    (1, 11, N'Bathroom re-tiling', '2025-08-09', '2025-07-28T09:00:00+08:00', NULL),  -- H2-103: EDGE 9: only maintenance and cancelled nights on room H2-103 in 2025-Q3
    (2, 34, N'Air-conditioning replacement', '2026-09-28', '2026-09-15T10:00:00+09:00', NULL),  -- H5-102: EDGE 2: first night 2026-09-24 = the night after R37 checks out; last night 2026-09-27 = the night before R38 checks in
    (3, 2, N'Carpet replacement', '2026-11-02', '2026-10-26T09:00:00+08:00', NULL),  -- H1-102: EDGE 2: in progress on @Today 2026-10-30 (nights 2026-10-27 to 2026-11-03)
    (4, 19, N'Plumbing leak; paused awaiting parts', '2026-10-29', '2026-10-24T18:00:00+08:00', NULL),  -- H3-103: EDGE 2: paused job with a gap (no nights 2026-10-29 to 2026-10-31); room free again on @Today
    (5, 29, N'Window seal repair', '2025-11-15', '2025-11-08T11:00:00+07:00', NULL),  -- H4-202: EDGE 2: cancelled job (two nights worked, then called off; contractor withdrew)
    (6, 15, N'Suite refurbishment', '2026-12-04', '2026-10-01T09:00:00+08:00', NULL);  -- H2-301: Scheduled job (starts after @Today)
    SET IDENTITY_INSERT gshg.RoomMaintenance OFF;

    -- The window is its night rows; each span is [FromDate, ToDate)
    ;WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
         Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c)
    INSERT gshg.RoomNightAllocation (RoomID, StayDate, HotelID, MaintenanceID)
    SELECT v.RoomID, DATEADD(DAY, t.n, v.FromDate), rm.HotelID, v.MaintenanceID
    FROM (VALUES
        (1, 11, '2025-08-05', '2025-08-09'),  -- job 1 H2-103
        (2, 34, '2026-09-24', '2026-09-28'),  -- job 2 H5-102
        (3, 2, '2026-10-27', '2026-11-04'),  -- job 3 H1-102
        (4, 19, '2026-10-25', '2026-10-29'),  -- job 4 H3-103
        (4, 19, '2026-11-01', '2026-11-05'),  -- job 4 H3-103
        (5, 29, '2025-11-10', '2025-11-12'),  -- job 5 H4-202
        (6, 15, '2026-12-01', '2026-12-04')  -- job 6 H2-301
    ) AS v (MaintenanceID, RoomID, FromDate, ToDate)
    JOIN gshg.Room AS rm ON rm.RoomID = v.RoomID
    JOIN Tally AS t ON t.n < DATEDIFF(DAY, v.FromDate, v.ToDate);

    -- EDGE 2: job 5 is called off after two nights; T2 now refuses any new night for it
    UPDATE gshg.RoomMaintenance SET CancelledAt = '2025-11-12T09:00:00+07:00' WHERE MaintenanceID = 5;


    SET IDENTITY_INSERT gshg.Guest ON;
    INSERT gshg.Guest (GuestID, FirstName, LastName, DateOfBirth, Email, Phone, NationalityCode) VALUES
    (1, N'Aisyah', N'Rahman', '1985-04-12', 'aisyah.rahman1@mail.example', '+61 1037 2053', 'MY'),
    (2, N'Daniel', N'Tan', '1979-09-03', 'daniel.tan2@mail.example', '+62 1074 2106', 'SG'),
    (3, N'Priya', N'Nair', '1990-01-25', 'priya.nair3@mail.example', '+63 1111 2159', 'MY'),
    (4, N'Somchai', N'Wongsakul', '1982-06-30', 'somchai.wongsakul4@mail.example', '+64 1148 2212', 'TH'),
    (5, N'Malee', N'Wongsakul', '1984-11-08', 'malee.wongsakul5@mail.example', '+65 1185 2265', 'TH'),
    (6, N'Hiroshi', N'Sato', '1975-02-14', 'hiroshi.sato6@mail.example', '+66 1222 2318', 'JP'),
    (7, N'Yuki', N'Sato', '1977-07-21', 'yuki.sato7@mail.example', NULL, 'JP'),
    (8, N'Emily', N'Clarke', '1988-03-17', 'emily.clarke8@mail.example', '+68 1296 2424', 'GB'),
    (9, N'Ahmad', N'Faizal', '1980-12-05', 'ahmad.faizal9@mail.example', '+69 1333 2477', 'MY'),
    (10, N'Grace', N'Lim', '1993-05-29', 'grace.lim10@mail.example', '+60 1370 2530', 'SG'),
    (11, N'Oliver', N'Brown', '1986-08-11', 'oliver.brown11@mail.example', '+61 1407 2583', 'AU'),
    (12, N'Siti', N'Nurhaliza', '1991-10-02', 'siti.nurhaliza12@mail.example', '+62 1444 2636', 'MY'),
    (13, N'James', N'Wilson', '1970-04-23', 'james.wilson13@mail.example', '+63 1481 2689', 'US'),
    (14, N'Nurul', N'Huda', '1987-01-30', 'nurul.huda14@mail.example', NULL, 'MY'),
    (15, N'Farid', N'Hassan', '1985-09-14', 'farid.hassan15@mail.example', '+65 1555 2795', 'MY'),
    (16, N'Kenji', N'Watanabe', '1983-06-06', 'kenji.watanabe16@mail.example', '+66 1592 2848', 'JP'),
    (17, N'Chloe', N'Ng', '1995-12-19', 'chloe.ng17@mail.example', '+67 1629 2901', 'SG'),
    (18, N'Arjun', N'Mehta', '1989-02-27', 'arjun.mehta18@mail.example', '+68 1666 2954', 'GB'),
    (19, N'Lucy', N'Tran', '1992-07-07', 'lucy.tran19@mail.example', '+69 1703 3007', 'AU'),
    (20, N'Wei Ming', N'Chong', '1978-11-11', 'weiming.chong20@mail.example', '+60 1740 3060', 'MY'),
    (21, N'Sarah', N'Johnson', '1990-03-03', 'sarah.johnson21@mail.example', NULL, 'US'),  -- EDGE 7: 4 guest-initiated cancellations
    (22, N'Thanawat', N'Chai', '1987-05-15', 'thanawat.chai22@mail.example', '+62 1814 3166', 'TH'),  -- EDGE 7: 3 guest-initiated cancellations
    (23, N'Robert', N'Miller', '1969-08-08', 'robert.miller23@mail.example', '+63 1851 3219', 'GB'),  -- EDGE 7: 2 hotel-initiated cancellations only
    (24, N'Mei Ling', N'Goh', '1980-06-20', 'meiling.goh24@mail.example', '+64 1888 3272', 'MY'),
    (25, N'Kavitha', N'Raj', '1994-04-04', 'kavitha.raj25@mail.example', '+65 1925 3325', 'MY'),
    (26, N'Takumi', N'Ito', '1984-10-10', 'takumi.ito26@mail.example', '+66 1962 3378', 'JP'),
    (27, N'Hana', N'Kobayashi', '1992-02-02', 'hana.kobayashi27@mail.example', '+67 1999 3431', 'JP'),
    (28, N'Benjamin', N'Lee', '1976-01-01', 'benjamin.lee28@mail.example', NULL, 'SG'),
    (29, N'Rachel', N'Cohen', '1983-09-09', 'rachel.cohen29@mail.example', '+69 2073 3537', 'US'),
    (30, N'Zainab', N'Ali', '1989-12-12', 'zainab.ali30@mail.example', '+60 2110 3590', 'MY'),
    (31, N'Ploy', N'Srisuk', '1996-03-21', 'ploy.srisuk31@mail.example', '+61 2147 3643', 'TH'),
    (32, N'Michael', N'O''Brien', '1972-05-05', 'michael.obrien32@mail.example', '+62 2184 3696', 'AU'),
    (33, N'Isabella', N'Rossi', '1985-08-18', 'isabella.rossi33@mail.example', '+63 2221 3749', 'GB'),
    (34, N'Marco', N'Rossi', '1983-04-28', 'marco.rossi34@mail.example', '+64 2258 3802', 'GB'),
    (35, N'Haruka', N'Yamamoto', '1991-11-30', 'haruka.yamamoto35@mail.example', NULL, 'JP'),
    (36, N'Nattapong', N'Kaew', '1988-07-17', 'nattapong.kaew36@mail.example', '+66 2332 3908', 'TH'),
    (37, N'Aaron', N'Tan', '1979-10-31', 'aaron.tan37@mail.example', '+67 2369 3961', 'SG'),
    (38, N'Lina', N'Wong', '1981-02-09', 'lina.wong38@mail.example', '+68 2406 4014', 'SG'),
    (39, N'Takeshi', N'Mori', '1974-03-14', 'takeshi.mori39@mail.example', '+69 2443 4067', 'JP'),
    (40, N'Emma', N'Davis', '1997-06-25', 'emma.davis40@mail.example', '+60 2480 4120', 'US'),
    (41, N'Arif', N'Raj', '2024-07-20', NULL, NULL, 'MY'),  -- EDGE 12: turns 2 on 2026-07-20 (R33 check-in)
    (42, N'Anya', N'Raj', '2024-07-21', NULL, NULL, 'MY'),  -- EDGE 12: turns 2 on 2026-07-21, so 1 at R33 check-in
    (43, N'Jun', N'Goh', '2014-06-15', NULL, NULL, 'MY'),  -- EDGE 12: turns 12 on 2026-06-15 (R32 check-in)
    (44, N'Kai', N'Goh', '2014-06-16', NULL, NULL, 'MY'),  -- EDGE 12: turns 12 on 2026-06-16, so 11 at R32 check-in
    (45, N'Lena', N'Goh', '2008-06-15', NULL, NULL, 'MY'),  -- EDGE 12: turns 18 on 2026-06-15 (R32 check-in)
    (46, N'Ryan', N'Goh', '2008-06-16', NULL, NULL, 'MY'),  -- EDGE 12: turns 18 on 2026-06-16, so 17 at R32 check-in
    (47, N'Ploy', N'Wongsakul', '2016-11-02', NULL, NULL, 'TH'),
    (48, N'Nok', N'Wongsakul', '2019-09-10', NULL, NULL, 'TH'),
    (49, N'Fah', N'Wongsakul', '2024-06-01', NULL, NULL, 'TH'),
    (50, N'Adam', N'Faizal', '2014-12-01', NULL, NULL, 'MY'),
    (51, N'Sofia', N'Huda', '2011-08-20', NULL, NULL, 'MY'),
    (52, N'Iman', N'Hassan', '2017-12-12', NULL, NULL, 'MY'),
    (53, N'Hana', N'Hassan', '2024-03-03', NULL, NULL, 'MY'),
    (54, N'Noah', N'Cohen', '2012-02-02', NULL, NULL, 'US'),
    (55, N'Sora', N'Sato', '2018-05-05', NULL, NULL, 'JP'),
    (56, N'Mio', N'Sato', '2020-10-10', NULL, NULL, 'JP'),
    (57, N'Aqil', N'Rahim', '2015-04-04', NULL, NULL, 'MY'),
    (58, N'Zara', N'Hassan', '2022-01-15', NULL, NULL, 'MY'),
    (59, N'Ren', N'Kobayashi', '2025-09-01', NULL, NULL, 'JP'),
    (60, N'Giulia', N'Rossi', '2013-03-30', NULL, NULL, 'GB');
    SET IDENTITY_INSERT gshg.Guest OFF;

    INSERT gshg.GuestDocument (DocumentType, DocumentNumber, IssuingCountryCode, GuestID) VALUES
    ('PASSPORT', 'MY7301913', 'MY', 1),
    ('NATIONAL_ID', '850412-14-5001', 'MY', 1),
    ('PASSPORT', 'SG7303826', 'SG', 2),
    ('NATIONAL_ID', 'S8000542C', 'SG', 2),
    ('PASSPORT', 'MY7305739', 'MY', 3),
    ('NATIONAL_ID', '900125-14-5003', 'MY', 3),
    ('PASSPORT', 'TH7307652', 'TH', 4),
    ('PASSPORT', 'TH7309565', 'TH', 5),
    ('PASSPORT', 'JP7311478', 'JP', 6),
    ('PASSPORT', 'JP7313391', 'JP', 7),
    ('PASSPORT', 'GB7315304', 'GB', 8),
    ('PASSPORT', 'MY7317217', 'MY', 9),
    ('NATIONAL_ID', '801205-14-5009', 'MY', 9),
    ('PASSPORT', 'SG7319130', 'SG', 10),
    ('NATIONAL_ID', 'S8002710K', 'SG', 10),
    ('PASSPORT', 'AU7321043', 'AU', 11),
    ('PASSPORT', 'MY7322956', 'MY', 12),
    ('NATIONAL_ID', '911002-14-5012', 'MY', 12),
    ('PASSPORT', 'US7324869', 'US', 13),
    ('PASSPORT', 'MY7326782', 'MY', 14),
    ('NATIONAL_ID', '870130-14-5014', 'MY', 14),
    ('PASSPORT', 'MY7328695', 'MY', 15),
    ('NATIONAL_ID', '850914-14-5015', 'MY', 15),
    ('PASSPORT', 'JP7330608', 'JP', 16),
    ('PASSPORT', 'SG7332521', 'SG', 17),
    ('NATIONAL_ID', 'S8004607R', 'SG', 17),
    ('PASSPORT', 'GB7334434', 'GB', 18),
    ('PASSPORT', 'AU7336347', 'AU', 19),
    ('PASSPORT', 'MY7338260', 'MY', 20),
    ('NATIONAL_ID', '781111-14-5020', 'MY', 20),
    ('PASSPORT', 'US7340173', 'US', 21),
    ('PASSPORT', 'TH7342086', 'TH', 22),
    ('PASSPORT', 'GB7343999', 'GB', 23),
    ('PASSPORT', 'MY7345912', 'MY', 24),
    ('NATIONAL_ID', '800620-14-5024', 'MY', 24),
    ('PASSPORT', 'MY7347825', 'MY', 25),
    ('NATIONAL_ID', '940404-14-5025', 'MY', 25),
    ('PASSPORT', 'JP7349738', 'JP', 26),
    ('PASSPORT', 'JP7351651', 'JP', 27),
    ('PASSPORT', 'SG7353564', 'SG', 28),
    ('NATIONAL_ID', 'S8007588C', 'SG', 28),
    ('PASSPORT', 'US7355477', 'US', 29),
    ('PASSPORT', 'MY7357390', 'MY', 30),
    ('NATIONAL_ID', '891212-14-5030', 'MY', 30),
    ('PASSPORT', 'TH7359303', 'TH', 31),
    ('PASSPORT', 'AU7361216', 'AU', 32),
    ('PASSPORT', 'GB7363129', 'GB', 33),
    ('PASSPORT', 'GB7365042', 'GB', 34),
    ('PASSPORT', 'JP7366955', 'JP', 35),
    ('PASSPORT', 'TH7368868', 'TH', 36),
    ('PASSPORT', 'SG7370781', 'SG', 37),
    ('NATIONAL_ID', 'S8010027L', 'SG', 37),
    ('PASSPORT', 'SG7372694', 'SG', 38),
    ('NATIONAL_ID', 'S8010298M', 'SG', 38),
    ('PASSPORT', 'JP7374607', 'JP', 39),
    ('PASSPORT', 'US7376520', 'US', 40),
    ('PASSPORT', 'MY7386085', 'MY', 45);


    SET IDENTITY_INSERT gshg.Reservation ON;
    INSERT gshg.Reservation (ReservationID, ReservationNumber, HotelID, BookingGuestID, RatePlanID,
                             AgreedNoShowChargeBasis, AgreedCheckInTime, CheckInDate, CheckOutDate, BookedAt)
    SELECT v.ReservationID, v.ReservationNumber, v.HotelID, v.BookingGuestID, v.RatePlanID,
           rp.NoShowChargeBasis, h.StandardCheckInTime, v.CheckInDate, v.CheckOutDate, v.BookedAt
    FROM (VALUES
        (1, 'R2501-001', 1, 1, 1, '2025-01-10', '2025-01-13', '2024-11-26T10:00:00+08:00'),  -- R1 out
        (2, 'R2501-002', 3, 3, 2, '2025-01-20', '2025-01-24', '2024-12-06T10:00:00+08:00'),  -- R2 out - EDGE 9: completed stay on room H3-202 in 2025-Q1
        (3, 'R2502-003', 4, 4, 1, '2025-02-05', '2025-02-08', '2024-12-22T10:00:00+07:00'),  -- R3 out - EDGE 3: 5 occupants incl. an infant = MaxOccupancy 5 of the Family room; EDGE 4: adults with children
        (4, 'R2502-004', 2, 6, 4, '2025-02-14', '2025-02-16', '2024-12-31T10:00:00+08:00'),  -- R4 out
        (5, 'R2503-005', 5, 8, 3, '2025-03-01', '2025-03-05', '2025-01-15T10:00:00+09:00'),  -- R5 out
        (6, 'R2503-006', 1, 9, 1, '2025-03-15', '2025-03-18', '2025-01-29T10:00:00+08:00'),  -- R6 out - EDGE 4: adult with a child; EDGE 8: checked out, partly paid (half the balance)
        (7, 'R2504-007', 3, 10, 1, '2025-04-02', '2025-04-05', '2025-02-16T10:00:00+08:00'),  -- R7 noshow - EDGE 11: no-show at Singapore (H3)
        (8, 'R2504-008', 4, 21, 2, '2025-04-10', '2025-04-14', '2025-02-24T10:00:00+07:00'),  -- R8 cancel - EDGE 7: guest G21 guest-initiated cancellation 1 of 4
        (9, 'R2505-009', 2, 13, 1, '2025-05-03', '2025-05-06', '2025-03-19T10:00:00+08:00'),  -- R9 out - EDGE 9: completed stay on room H2-103 in 2025-Q2; EDGE 11: debit note for a late charge
        (10, 'R2505-010', 1, 14, 1, '2025-05-20', '2025-05-23', '2025-04-05T10:00:00+08:00'),  -- R10 out - EDGE 3: 5 occupants incl. an infant = MaxOccupancy 5; EDGE 4: adults with children
        (11, 'R2506-011', 5, 16, 4, '2025-06-10', '2025-06-14', '2025-04-26T10:00:00+09:00'),  -- R11 out
        (12, 'R2507-012', 3, 22, 1, '2025-07-05', '2025-07-08', '2025-05-10T09:00:00+08:00'),  -- R12 cancel - EDGE 9: cancelled nights on room H3-202 in 2025-Q3; EDGE 7: guest G22 guest-initiated cancellation 1 of 3
        (13, 'R2508-013', 3, 18, 1, '2025-08-12', '2025-08-15', '2025-06-28T10:00:00+08:00'),  -- R13 noshow - EDGE 9: no-show nights on room H3-202 in 2025-Q3; EDGE 11: no-show at Singapore (H3)
        (14, 'R2507-014', 2, 23, 1, '2025-07-20', '2025-07-23', '2025-06-05T10:00:00+08:00'),  -- R14 cancel - EDGE 9: cancelled nights on room H2-103 in 2025-Q3; EDGE 7: guest G23 hotel-initiated cancellation 1 of 2
        (15, 'R2508-015', 1, 20, 4, '2025-08-08', '2025-08-11', '2025-06-24T10:00:00+08:00'),  -- R15 noshow - EDGE 11: no-show at Kuala Lumpur (H1)
        (16, 'R2509-016', 4, 26, 3, '2025-09-01', '2025-09-05', '2025-07-18T10:00:00+07:00'),  -- R16 out
        (17, 'R2510-017', 1, 28, 2, '2025-10-01', '2025-10-04', '2025-08-17T10:00:00+08:00'),  -- R17 out - EDGE 11: accessible room requested and assigned
        (18, 'R2510-018', 2, 21, 1, '2025-10-15', '2025-10-18', '2025-08-31T10:00:00+08:00'),  -- R18 cancel - EDGE 7: guest G21 guest-initiated cancellation 2 of 4
        (19, 'R2511-019', 2, 29, 1, '2025-11-05', '2025-11-08', '2025-09-21T10:00:00+08:00'),  -- R19 out - EDGE 4: adult with a child (13)
        (20, 'R2512-020', 1, 31, 1, '2025-12-24', '2025-12-27', '2025-11-09T10:00:00+08:00'),  -- R20 out - EDGE 11: Deluxe rate override 2025-12-24..31; EDGE 11: credit note (partial room credit) then refund
        (21, 'R2512-021', 3, 33, 4, '2025-12-28', '2026-01-02', '2025-11-13T10:00:00+08:00'),  -- R21 out
        (22, 'R2602-022', 5, 22, 1, '2026-02-10', '2026-02-13', '2025-12-27T10:00:00+09:00'),  -- R22 cancel - EDGE 1: Tokyo (H5) February 2026 - cancelled; EDGE 7: guest G22 guest-initiated cancellation 2 of 3
        (23, 'R2602-023', 5, 35, 1, '2026-02-20', '2026-02-23', '2026-01-06T10:00:00+09:00'),  -- R23 pending - EDGE 1: Tokyo (H5) February 2026 - pending, never confirmed
        (24, 'R2602-024', 5, 23, 1, '2026-02-05', '2026-02-07', '2025-12-22T10:00:00+09:00'),  -- R24 cancel - EDGE 1: Tokyo (H5) February 2026 - cancelled; EDGE 6: hotel-initiated late cancellation (18h before 14:00 check-in), no fee; EDGE 7: guest G23 hotel-initiated cancellation 2 of 2
        (25, 'R2603-025', 4, 21, 1, '2026-03-20', '2026-03-23', '2026-02-03T10:00:00+07:00'),  -- R25 cancel - EDGE 6: guest cancelled 47h59m before 2026-03-20 15:00 Bangkok time (stored as +08:00) - late, fee; EDGE 7: guest G21 guest-initiated cancellation 3 of 4
        (26, 'R2603-026', 4, 22, 1, '2026-03-25', '2026-03-27', '2026-02-08T10:00:00+07:00'),  -- R26 cancel - EDGE 6: guest cancelled exactly 48h before check-in - not late; EDGE 7: guest G22 guest-initiated cancellation 3 of 3
        (27, 'R2603-027', 4, 36, 2, '2026-03-28', '2026-03-30', '2026-02-11T10:00:00+07:00'),  -- R27 cancel - EDGE 6: guest cancelled 49h before check-in - not late
        (28, 'R2604-028', 1, 37, 1, '2026-04-02', '2026-04-05', '2026-02-16T10:00:00+08:00'),  -- R28 out - EDGE 8: checked out, paid in full, then 30% refunded - balance above zero
        (29, 'R2604-029', 5, 39, 4, '2026-04-01', '2026-04-05', '2026-02-15T10:00:00+09:00'),  -- R29 out - EDGE 11: Deluxe rate override 2026-04-01..05
        (30, 'R2605-030', 4, 2, 3, '2026-05-10', '2026-05-13', '2026-03-26T10:00:00+07:00'),  -- R30 noshow - EDGE 11: no-show at Bangkok (H4), full-stay charge
        (31, 'R2606-031', 3, 3, 1, '2026-06-05', '2026-06-08', '2026-04-21T10:00:00+08:00'),  -- R31 out - EDGE 11: debit note for a service sold after the invoice
        (32, 'R2606-032', 1, 24, 1, '2026-06-15', '2026-06-18', '2026-05-01T10:00:00+08:00'),  -- R32 out - EDGE 12: ages 18/17 and 12/11 on the check-in date; EDGE 3: 5 occupants = MaxOccupancy 5; EDGE 4: adults with children
        (33, 'R2607-033', 2, 25, 4, '2026-07-20', '2026-07-23', '2026-06-05T10:00:00+08:00'),  -- R33 out - EDGE 12: ages 2/1 on the check-in date; EDGE 3: 3 occupants incl. an infant = MaxOccupancy 3 of room H2-103; EDGE 4: adult with children; EDGE 11: infant (age 1) with a baby cot
        (34, 'R2608-034', 3, 4, 1, '2026-08-07', '2026-08-10', '2026-06-23T10:00:00+08:00'),  -- R34 out - EDGE 11: Deluxe rate override 2026-08-08..09
        (35, 'R2608-035', 4, 6, 1, '2026-08-15', '2026-08-19', '2026-07-01T10:00:00+07:00'),  -- R35 out - EDGE 3: 4 occupants = MaxOccupancy 4 of the Suite; EDGE 4: adults with children
        (36, 'R2609-036', 1, 8, 2, '2026-09-10', '2026-09-14', '2026-07-27T10:00:00+08:00'),  -- R36 out - EDGE 11: accessible room requested and assigned; Early departure (2 of 4 nights used)
        (37, 'R2609-037', 5, 9, 4, '2026-09-20', '2026-09-24', '2026-08-06T10:00:00+09:00'),  -- R37 out - EDGE 2: last booked night 2026-09-23 is the night before maintenance job 2 starts on H5-102
        (38, 'R2609-038', 5, 10, 1, '2026-09-28', '2026-10-01', '2026-08-14T10:00:00+09:00'),  -- R38 out - EDGE 2: checks in 2026-09-28, the night after maintenance job 2 ends on H5-102; EDGE 8: checked out, no invoice yet (deposit only) - balance above zero
        (39, 'R2610-039', 3, 11, 1, '2026-10-28', '2026-11-02', '2026-09-13T10:00:00+08:00'),  -- R39 inhouse
        (40, 'R2610-040', 1, 12, 4, '2026-10-27', '2026-10-31', '2026-09-12T10:00:00+08:00'),  -- R40 inhouse - EDGE 4: adult with a child
        (41, 'R2611-041', 1, 13, 1, '2026-11-15', '2026-11-18', '2026-10-01T10:00:00+08:00'),  -- R41 confirmed - EDGE 11: accessible room requested and assigned
        (42, 'R2612-042', 2, 14, 2, '2026-12-20', '2026-12-24', '2026-10-05T10:42:00+08:00'),  -- R42 confirmed - EDGE 4: adults with children
        (43, 'R2701-043', 5, 16, 4, '2027-01-05', '2027-01-08', '2026-10-06T10:43:00+09:00'),  -- R43 out
        (44, 'R2701-044', 1, 17, 1, '2027-01-20', '2027-01-23', '2026-10-07T10:44:00+08:00'),  -- R44 out - EDGE 11: debit note for a late damage charge
        (45, 'R2702-045', 3, 18, 1, '2027-02-10', '2027-02-14', '2026-10-08T10:45:00+08:00'),  -- R45 out - EDGE 11: credit note fully reversing a service line, then refund
        (46, 'R2703-046', 4, 19, 1, '2027-03-05', '2027-03-08', '2026-10-09T10:46:00+07:00'),  -- R46 out
        (47, 'R2703-047', 2, 20, 2, '2027-03-15', '2027-03-18', '2026-08-01T10:00:00+08:00'),  -- R47 confirmed - EDGE 11: date change in September 2026
        (48, 'R2704-048', 1, 26, 1, '2027-04-10', '2027-04-12', '2026-08-03T11:00:00+08:00'),  -- R48 confirmed - EDGE 11: date change in September 2026
        (49, 'R2705-049', 3, 27, 4, '2027-05-01', '2027-05-04', '2026-08-05T09:00:00+08:00'),  -- R49 confirmed - EDGE 11: room category change in September 2026
        (50, 'R2705-050', 4, 28, 1, '2027-05-20', '2027-05-23', '2026-08-07T09:00:00+07:00'),  -- R50 confirmed - EDGE 11: room category change in September 2026
        (51, 'R2702-051', 1, 21, 1, '2027-02-14', '2027-02-16', '2026-10-14T10:51:00+08:00'),  -- R51 cancel - EDGE 7: guest G21 guest-initiated cancellation 4 of 4
        (52, 'R2706-052', 5, 29, 3, '2027-06-01', '2027-06-04', '2026-10-15T10:52:00+09:00'),  -- R52 confirmed
        (53, 'R2706-053', 2, 30, 1, '2027-06-10', '2027-06-12', '2026-10-16T10:53:00+08:00'),  -- R53 pending
        (54, 'R2707-054', 3, 31, 1, '2027-07-01', '2027-07-05', '2026-10-17T10:54:00+08:00'),  -- R54 pending
        (55, 'R2701-055', 4, 32, 1, '2027-01-15', '2027-01-18', '2026-10-18T10:55:00+07:00'),  -- R55 cancel
        (56, 'R2612-056', 1, 33, 2, '2026-12-30', '2027-01-02', '2026-10-19T10:56:00+08:00'),  -- R56 confirmed
        (57, 'R2506-057', 2, 30, 1, '2025-06-14', '2025-06-16', '2025-04-30T10:00:00+08:00'),  -- R57 out
        (58, 'R2507-058', 4, 31, 4, '2025-07-08', '2025-07-11', '2025-05-24T10:00:00+07:00'),  -- R58 out
        (59, 'R2509-059', 1, 32, 3, '2025-09-18', '2025-09-20', '2025-08-04T10:00:00+08:00'),  -- R59 out
        (60, 'R2511-060', 5, 33, 1, '2025-11-20', '2025-11-23', '2025-10-06T10:00:00+09:00'),  -- R60 out
        (61, 'R2602-061', 3, 35, 2, '2026-02-12', '2026-02-15', '2025-12-29T10:00:00+08:00'),  -- R61 out
        (62, 'R2602-062', 2, 36, 1, '2026-02-05', '2026-02-08', '2025-12-22T10:00:00+08:00'),  -- R62 out
        (63, 'R2602-063', 1, 37, 4, '2026-02-20', '2026-02-23', '2026-01-06T10:00:00+08:00'),  -- R63 out
        (64, 'R2606-064', 5, 38, 1, '2026-06-20', '2026-06-24', '2026-05-06T10:00:00+09:00'),  -- R64 out
        (65, 'R2602-065', 4, 39, 3, '2026-02-08', '2026-02-11', '2025-12-25T10:00:00+07:00'),  -- R65 out
        (66, 'R2610-066', 3, 40, 1, '2026-10-02', '2026-10-05', '2026-08-18T10:00:00+08:00'),  -- R66 out
        (67, 'R2702-067', 2, 1, 1, '2027-02-03', '2027-02-06', '2026-10-11T11:07:00+08:00'),  -- R67 out
        (68, 'R2704-068', 4, 2, 4, '2027-04-08', '2027-04-11', '2026-10-12T11:08:00+07:00'),  -- R68 out
        (69, 'R2705-069', 5, 5, 2, '2027-05-10', '2027-05-13', '2026-10-13T11:09:00+09:00'),  -- R69 out
        (70, 'R2706-070', 1, 6, 1, '2027-06-15', '2027-06-18', '2026-10-14T11:10:00+08:00')  -- R70 confirmed
    ) AS v (ReservationID, ReservationNumber, HotelID, BookingGuestID, RatePlanID, CheckInDate, CheckOutDate, BookedAt)
    JOIN gshg.RatePlan AS rp ON rp.RatePlanID = v.RatePlanID
    JOIN gshg.Hotel    AS h  ON h.HotelID     = v.HotelID;
    SET IDENTITY_INSERT gshg.Reservation OFF;


    SET IDENTITY_INSERT gshg.ReservationRoom ON;
    INSERT gshg.ReservationRoom (ReservationRoomID, ReservationID, HotelID, RoomCategoryID, AgreedBaseOccupancy,
                                 AgreedExtraPersonRate, AgreedReducedChildRate, AccessibleRoomRequested, SpecialRequests)
    SELECT v.ReservationRoomID, v.ReservationID, v.HotelID, v.RoomCategoryID, hrc.BaseOccupancy,
           hrc.ExtraPersonRate, hrc.ReducedChildRate, v.AccessibleRoomRequested, v.SpecialRequests
    FROM (VALUES
        (1, 1, 1, 1, 0, NULL),  -- R1 line 1 STD
        (2, 2, 3, 2, 0, NULL),  -- R2 line 1 DLX
        (3, 3, 4, 4, 0, NULL),  -- R3 line 1 FAM
        (4, 4, 2, 3, 0, NULL),  -- R4 line 1 SUI
        (5, 5, 5, 1, 0, NULL),  -- R5 line 1 STD
        (6, 6, 1, 2, 0, NULL),  -- R6 line 1 DLX
        (7, 7, 3, 1, 0, NULL),  -- R7 line 1 STD
        (8, 8, 4, 2, 0, NULL),  -- R8 line 1 DLX
        (9, 9, 2, 1, 0, NULL),  -- R9 line 1 STD
        (10, 10, 1, 4, 0, NULL),  -- R10 line 1 FAM
        (11, 11, 5, 2, 0, NULL),  -- R11 line 1 DLX
        (12, 12, 3, 2, 0, NULL),  -- R12 line 1 DLX
        (13, 13, 3, 2, 0, NULL),  -- R13 line 1 DLX
        (14, 14, 2, 1, 0, NULL),  -- R14 line 1 STD
        (15, 15, 1, 1, 0, NULL),  -- R15 line 1 STD
        (16, 16, 4, 2, 0, NULL),  -- R16 line 1 DLX
        (17, 16, 4, 1, 0, NULL),  -- R16 line 2 STD
        (18, 17, 1, 2, 1, N'Wheelchair access needed'),  -- R17 line 1 DLX - EDGE 11: accessible room requested
        (19, 18, 2, 1, 0, NULL),  -- R18 line 1 STD
        (20, 19, 2, 3, 0, NULL),  -- R19 line 1 SUI
        (21, 19, 2, 1, 0, NULL),  -- R19 line 2 STD
        (22, 20, 1, 2, 0, NULL),  -- R20 line 1 DLX
        (23, 21, 3, 3, 0, NULL),  -- R21 line 1 SUI
        (24, 22, 5, 1, 0, NULL),  -- R22 line 1 STD
        (25, 23, 5, 2, 0, NULL),  -- R23 line 1 DLX
        (26, 24, 5, 2, 0, NULL),  -- R24 line 1 DLX
        (27, 25, 4, 2, 0, NULL),  -- R25 line 1 DLX
        (28, 26, 4, 1, 0, NULL),  -- R26 line 1 STD
        (29, 27, 4, 1, 0, NULL),  -- R27 line 1 STD
        (30, 28, 1, 1, 0, NULL),  -- R28 line 1 STD
        (31, 29, 5, 2, 0, NULL),  -- R29 line 1 DLX
        (32, 30, 4, 1, 0, NULL),  -- R30 line 1 STD
        (33, 31, 3, 2, 0, NULL),  -- R31 line 1 DLX
        (34, 32, 1, 4, 0, NULL),  -- R32 line 1 FAM
        (35, 33, 2, 1, 0, NULL),  -- R33 line 1 STD
        (36, 34, 3, 2, 0, NULL),  -- R34 line 1 DLX
        (37, 35, 4, 3, 0, NULL),  -- R35 line 1 SUI
        (38, 36, 1, 2, 1, N'Ground-floor or lift access'),  -- R36 line 1 DLX - EDGE 11: accessible room requested
        (39, 37, 5, 1, 0, NULL),  -- R37 line 1 STD
        (40, 38, 5, 1, 0, NULL),  -- R38 line 1 STD
        (41, 39, 3, 2, 0, NULL),  -- R39 line 1 DLX
        (42, 40, 1, 3, 0, NULL),  -- R40 line 1 SUI
        (43, 41, 1, 1, 1, N'Step-free shower'),  -- R41 line 1 STD - EDGE 11: accessible room requested
        (44, 42, 2, 4, 0, NULL),  -- R42 line 1 FAM
        (45, 43, 5, 2, 0, NULL),  -- R43 line 1 DLX
        (46, 44, 1, 2, 0, NULL),  -- R44 line 1 DLX
        (47, 45, 3, 1, 0, NULL),  -- R45 line 1 STD
        (48, 46, 4, 2, 0, NULL),  -- R46 line 1 DLX
        (49, 47, 2, 1, 0, NULL),  -- R47 line 1 STD
        (50, 48, 1, 2, 0, NULL),  -- R48 line 1 DLX
        (51, 49, 3, 1, 0, NULL),  -- R49 line 1 STD
        (52, 50, 4, 2, 0, NULL),  -- R50 line 1 DLX
        (53, 51, 1, 1, 0, NULL),  -- R51 line 1 STD
        (54, 52, 5, 1, 0, NULL),  -- R52 line 1 STD
        (55, 53, 2, 2, 0, NULL),  -- R53 line 1 DLX
        (56, 54, 3, 3, 0, NULL),  -- R54 line 1 SUI
        (57, 55, 4, 1, 0, NULL),  -- R55 line 1 STD
        (58, 56, 1, 3, 0, NULL),  -- R56 line 1 SUI
        (59, 56, 1, 2, 0, NULL),  -- R56 line 2 DLX
        (60, 57, 2, 1, 0, NULL),  -- R57 line 1 STD
        (61, 58, 4, 3, 0, NULL),  -- R58 line 1 SUI
        (62, 59, 1, 1, 0, NULL),  -- R59 line 1 STD
        (63, 60, 5, 4, 0, NULL),  -- R60 line 1 FAM
        (64, 61, 3, 2, 0, NULL),  -- R61 line 1 DLX
        (65, 62, 2, 2, 0, NULL),  -- R62 line 1 DLX
        (66, 63, 1, 3, 0, NULL),  -- R63 line 1 SUI
        (67, 64, 5, 1, 0, NULL),  -- R64 line 1 STD
        (68, 65, 4, 1, 0, NULL),  -- R65 line 1 STD
        (69, 66, 3, 1, 0, NULL),  -- R66 line 1 STD
        (70, 67, 2, 2, 0, NULL),  -- R67 line 1 DLX
        (71, 68, 4, 4, 0, NULL),  -- R68 line 1 FAM
        (72, 69, 5, 3, 0, NULL),  -- R69 line 1 SUI
        (73, 70, 1, 1, 0, NULL)  -- R70 line 1 STD
    ) AS v (ReservationRoomID, ReservationID, HotelID, RoomCategoryID, AccessibleRoomRequested, SpecialRequests)
    JOIN gshg.HotelRoomCategory AS hrc ON hrc.HotelID = v.HotelID AND hrc.RoomCategoryID = v.RoomCategoryID;
    SET IDENTITY_INSERT gshg.ReservationRoom OFF;


    ;WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
         Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c)
    INSERT gshg.ReservationRoomNight (ReservationRoomID, StayDate, HotelID, RoomCategoryID, AgreedRoomRate)
    SELECT rr.ReservationRoomID, DATEADD(DAY, t.n, r.CheckInDate), rr.HotelID, rr.RoomCategoryID,
           CAST(ROUND(COALESCE(rt.NightlyRate, hrc.StandardNightlyRate) * (1 + rp.RateAdjustmentPct / 100.0), 2) AS DECIMAL(10,2))
    FROM   gshg.ReservationRoom   AS rr
    JOIN   gshg.Reservation       AS r   ON r.ReservationID = rr.ReservationID
    JOIN   Tally                  AS t   ON t.n < DATEDIFF(DAY, r.CheckInDate, r.CheckOutDate)
    JOIN   gshg.HotelRoomCategory AS hrc ON hrc.HotelID = rr.HotelID AND hrc.RoomCategoryID = rr.RoomCategoryID
    JOIN   gshg.RatePlan          AS rp  ON rp.RatePlanID = r.RatePlanID
    LEFT JOIN gshg.RoomRate       AS rt  ON rt.HotelID = rr.HotelID AND rt.RoomCategoryID = rr.RoomCategoryID
                                         AND rt.RateDate = DATEADD(DAY, t.n, r.CheckInDate);


    SET IDENTITY_INSERT gshg.RoomOccupant ON;
    INSERT gshg.RoomOccupant (RoomOccupantID, ReservationRoomID, GuestID) VALUES
    (1, 1, 1),  -- R1 G1 age 39 ADULT/FULL
    (2, 1, 2),  -- R1 G2 age 45 ADULT/FULL
    (3, 2, 3),  -- R2 G3 age 34 ADULT/FULL
    (4, 3, 4),  -- R3 G4 age 42 ADULT/FULL
    (5, 3, 5),  -- R3 G5 age 40 ADULT/FULL
    (6, 3, 47),  -- R3 G47 age 8 CHILD/REDUCED
    (7, 3, 48),  -- R3 G48 age 5 CHILD/REDUCED
    (8, 3, 49),  -- R3 G49 age 0 INFANT/NONE
    (9, 4, 6),  -- R4 G6 age 50 ADULT/FULL
    (10, 4, 7),  -- R4 G7 age 47 ADULT/FULL
    (11, 5, 8),  -- R5 G8 age 36 ADULT/FULL
    (12, 6, 9),  -- R6 G9 age 44 ADULT/FULL
    (13, 6, 50),  -- R6 G50 age 10 CHILD/REDUCED
    (14, 7, 10),  -- R7 G10 age 31 ADULT/FULL
    (15, 8, 21),  -- R8 G21 age 35 ADULT/FULL
    (16, 8, 12),  -- R8 G12 age 33 ADULT/FULL
    (17, 9, 13),  -- R9 G13 age 55 ADULT/FULL
    (18, 10, 14),  -- R10 G14 age 38 ADULT/FULL
    (19, 10, 15),  -- R10 G15 age 39 ADULT/FULL
    (20, 10, 51),  -- R10 G51 age 13 CHILD/FULL
    (21, 10, 52),  -- R10 G52 age 7 CHILD/REDUCED
    (22, 10, 53),  -- R10 G53 age 1 INFANT/NONE
    (23, 11, 16),  -- R11 G16 age 42 ADULT/FULL
    (24, 12, 22),  -- R12 G22 age 38 ADULT/FULL
    (25, 13, 18),  -- R13 G18 age 36 ADULT/FULL
    (26, 14, 23),  -- R14 G23 age 55 ADULT/FULL
    (27, 15, 20),  -- R15 G20 age 46 ADULT/FULL
    (28, 16, 26),  -- R16 G26 age 40 ADULT/FULL
    (29, 17, 27),  -- R16 G27 age 33 ADULT/FULL
    (30, 18, 28),  -- R17 G28 age 49 ADULT/FULL
    (31, 19, 21),  -- R18 G21 age 35 ADULT/FULL
    (32, 20, 29),  -- R19 G29 age 42 ADULT/FULL
    (33, 20, 54),  -- R19 G54 age 13 CHILD/FULL
    (34, 21, 30),  -- R19 G30 age 35 ADULT/FULL
    (35, 22, 31),  -- R20 G31 age 29 ADULT/FULL
    (36, 22, 32),  -- R20 G32 age 53 ADULT/FULL
    (37, 23, 33),  -- R21 G33 age 40 ADULT/FULL
    (38, 23, 34),  -- R21 G34 age 42 ADULT/FULL
    (39, 24, 22),  -- R22 G22 age 38 ADULT/FULL
    (40, 25, 35),  -- R23 G35 age 34 ADULT/FULL
    (41, 26, 23),  -- R24 G23 age 56 ADULT/FULL
    (42, 27, 21),  -- R25 G21 age 36 ADULT/FULL
    (43, 28, 22),  -- R26 G22 age 38 ADULT/FULL
    (44, 29, 36),  -- R27 G36 age 37 ADULT/FULL
    (45, 30, 37),  -- R28 G37 age 46 ADULT/FULL
    (46, 30, 38),  -- R28 G38 age 45 ADULT/FULL
    (47, 31, 39),  -- R29 G39 age 52 ADULT/FULL
    (48, 31, 40),  -- R29 G40 age 28 ADULT/FULL
    (49, 32, 2),  -- R30 G2 age 46 ADULT/FULL
    (50, 33, 3),  -- R31 G3 age 36 ADULT/FULL
    (51, 34, 24),  -- R32 G24 age 45 ADULT/FULL
    (52, 34, 45),  -- R32 G45 age 18 ADULT/FULL - EDGE 12
    (53, 34, 46),  -- R32 G46 age 17 CHILD/FULL - EDGE 12
    (54, 34, 43),  -- R32 G43 age 12 CHILD/FULL - EDGE 12
    (55, 34, 44),  -- R32 G44 age 11 CHILD/REDUCED - EDGE 12
    (56, 35, 25),  -- R33 G25 age 32 ADULT/FULL
    (57, 35, 41),  -- R33 G41 age 2 CHILD/REDUCED - EDGE 12
    (58, 35, 42),  -- R33 G42 age 1 INFANT/NONE - EDGE 12
    (59, 36, 4),  -- R34 G4 age 44 ADULT/FULL
    (60, 36, 5),  -- R34 G5 age 41 ADULT/FULL
    (61, 37, 6),  -- R35 G6 age 51 ADULT/FULL
    (62, 37, 7),  -- R35 G7 age 49 ADULT/FULL
    (63, 37, 55),  -- R35 G55 age 8 CHILD/REDUCED
    (64, 37, 56),  -- R35 G56 age 5 CHILD/REDUCED
    (65, 38, 8),  -- R36 G8 age 38 ADULT/FULL
    (66, 39, 9),  -- R37 G9 age 45 ADULT/FULL
    (67, 40, 10),  -- R38 G10 age 33 ADULT/FULL
    (68, 41, 11),  -- R39 G11 age 40 ADULT/FULL
    (69, 42, 12),  -- R40 G12 age 35 ADULT/FULL
    (70, 42, 57),  -- R40 G57 age 11 CHILD/REDUCED
    (71, 43, 13),  -- R41 G13 age 56 ADULT/FULL
    (72, 44, 14),  -- R42 G14 age 39 ADULT/FULL
    (73, 44, 15),  -- R42 G15 age 41 ADULT/FULL
    (74, 44, 52),  -- R42 G52 age 9 CHILD/REDUCED
    (75, 44, 58),  -- R42 G58 age 4 CHILD/REDUCED
    (76, 45, 16),  -- R43 G16 age 43 ADULT/FULL
    (77, 46, 17),  -- R44 G17 age 31 ADULT/FULL
    (78, 47, 18),  -- R45 G18 age 37 ADULT/FULL
    (79, 48, 19),  -- R46 G19 age 34 ADULT/FULL
    (80, 49, 20),  -- R47 G20 age 48 ADULT/FULL
    (81, 50, 26),  -- R48 G26 age 42 ADULT/FULL
    (82, 51, 27),  -- R49 G27 age 35 ADULT/FULL
    (83, 51, 59),  -- R49 G59 age 1 INFANT/NONE
    (84, 52, 28),  -- R50 G28 age 51 ADULT/FULL
    (85, 53, 21),  -- R51 G21 age 36 ADULT/FULL
    (86, 54, 29),  -- R52 G29 age 43 ADULT/FULL
    (87, 55, 30),  -- R53 G30 age 37 ADULT/FULL
    (88, 56, 31),  -- R54 G31 age 31 ADULT/FULL
    (89, 57, 32),  -- R55 G32 age 54 ADULT/FULL
    (90, 58, 33),  -- R56 G33 age 41 ADULT/FULL
    (91, 58, 34),  -- R56 G34 age 43 ADULT/FULL
    (92, 59, 35),  -- R56 G35 age 35 ADULT/FULL
    (93, 60, 30),  -- R57 G30 age 35 ADULT/FULL
    (94, 61, 31),  -- R58 G31 age 29 ADULT/FULL
    (95, 62, 32),  -- R59 G32 age 53 ADULT/FULL
    (96, 63, 33),  -- R60 G33 age 40 ADULT/FULL
    (97, 63, 34),  -- R60 G34 age 42 ADULT/FULL
    (98, 63, 60),  -- R60 G60 age 12 CHILD/FULL
    (99, 64, 35),  -- R61 G35 age 34 ADULT/FULL
    (100, 65, 36),  -- R62 G36 age 37 ADULT/FULL
    (101, 66, 37),  -- R63 G37 age 46 ADULT/FULL
    (102, 67, 38),  -- R64 G38 age 45 ADULT/FULL
    (103, 68, 39),  -- R65 G39 age 51 ADULT/FULL
    (104, 69, 40),  -- R66 G40 age 29 ADULT/FULL
    (105, 70, 1),  -- R67 G1 age 41 ADULT/FULL
    (106, 71, 2),  -- R68 G2 age 47 ADULT/FULL
    (107, 71, 3),  -- R68 G3 age 37 ADULT/FULL
    (108, 72, 5),  -- R69 G5 age 42 ADULT/FULL
    (109, 73, 6);  -- R70 G6 age 52 ADULT/FULL
    SET IDENTITY_INSERT gshg.RoomOccupant OFF;


    INSERT gshg.RoomNightAllocation (RoomID, StayDate, HotelID, ReservationRoomID)
    SELECT v.RoomID, n.StayDate, n.HotelID, n.ReservationRoomID
    FROM (VALUES
        (1, 1),  -- R1 -> H1-101 (max 2, 2 occupants) - EDGE 3: at MaxOccupancy
        (2, 21),  -- R2 -> H3-202 (max 3, 1 occupant)
        (3, 32),  -- R3 -> H4-302 (max 5, 5 occupants) - EDGE 3: at MaxOccupancy
        (4, 15),  -- R4 -> H2-301 (max 4, 2 occupants)
        (5, 33),  -- R5 -> H5-101 (max 2, 1 occupant)
        (6, 4),  -- R6 -> H1-201 (max 3, 2 occupants)
        (7, 17),  -- R7 -> H3-101 (max 2, 1 occupant)
        (8, 28),  -- R8 -> H4-201 (max 3, 2 occupants)
        (9, 11),  -- R9 -> H2-103 (max 3, 1 occupant)
        (10, 8),  -- R10 -> H1-302 (max 5, 5 occupants) - EDGE 3: at MaxOccupancy
        (11, 36),  -- R11 -> H5-201 (max 3, 1 occupant)
        (12, 21),  -- R12 -> H3-202 (max 3, 1 occupant)
        (13, 21),  -- R13 -> H3-202 (max 3, 1 occupant)
        (14, 11),  -- R14 -> H2-103 (max 3, 1 occupant)
        (15, 1),  -- R15 -> H1-101 (max 2, 1 occupant)
        (16, 28),  -- R16 -> H4-201 (max 3, 1 occupant)
        (17, 25),  -- R16 -> H4-101 (max 2, 1 occupant)
        (18, 4),  -- R17 -> H1-201 (max 3, 1 occupant) - EDGE 11: accessible room assigned
        (19, 9),  -- R18 -> H2-101 (max 2, 1 occupant)
        (20, 15),  -- R19 -> H2-301 (max 4, 2 occupants)
        (21, 9),  -- R19 -> H2-101 (max 2, 1 occupant)
        (22, 4),  -- R20 -> H1-201 (max 3, 2 occupants)
        (23, 23),  -- R21 -> H3-301 (max 4, 2 occupants)
        (24, 33),  -- R22 -> H5-101 (max 2, 1 occupant)
        (26, 36),  -- R24 -> H5-201 (max 3, 1 occupant)
        (27, 28),  -- R25 -> H4-201 (max 3, 1 occupant)
        (28, 25),  -- R26 -> H4-101 (max 2, 1 occupant)
        (29, 25),  -- R27 -> H4-101 (max 2, 1 occupant)
        (30, 1),  -- R28 -> H1-101 (max 2, 2 occupants) - EDGE 3: at MaxOccupancy
        (31, 36),  -- R29 -> H5-201 (max 3, 2 occupants)
        (32, 25),  -- R30 -> H4-101 (max 2, 1 occupant)
        (33, 20),  -- R31 -> H3-201 (max 3, 1 occupant)
        (34, 8),  -- R32 -> H1-302 (max 5, 5 occupants) - EDGE 3: at MaxOccupancy
        (35, 11),  -- R33 -> H2-103 (max 3, 3 occupants) - EDGE 3: at MaxOccupancy
        (36, 20),  -- R34 -> H3-201 (max 3, 2 occupants)
        (37, 31),  -- R35 -> H4-301 (max 4, 4 occupants) - EDGE 3: at MaxOccupancy
        (38, 4),  -- R36 -> H1-201 (max 3, 1 occupant) - EDGE 11: accessible room assigned
        (39, 34),  -- R37 -> H5-102 (max 2, 1 occupant)
        (40, 34),  -- R38 -> H5-102 (max 2, 1 occupant)
        (41, 20),  -- R39 -> H3-201 (max 3, 1 occupant)
        (42, 7),  -- R40 -> H1-301 (max 4, 2 occupants)
        (43, 1),  -- R41 -> H1-101 (max 2, 1 occupant) - EDGE 11: accessible room assigned
        (44, 16),  -- R42 -> H2-302 (max 5, 4 occupants)
        (45, 36),  -- R43 -> H5-201 (max 3, 1 occupant)
        (46, 4),  -- R44 -> H1-201 (max 3, 1 occupant)
        (47, 17),  -- R45 -> H3-101 (max 2, 1 occupant)
        (48, 28),  -- R46 -> H4-201 (max 3, 1 occupant)
        (49, 9),  -- R47 -> H2-101 (max 2, 1 occupant)
        (50, 4),  -- R48 -> H1-201 (max 3, 1 occupant)
        (51, 17),  -- R49 -> H3-101 (max 2, 2 occupants) - EDGE 3: at MaxOccupancy
        (52, 28),  -- R50 -> H4-201 (max 3, 1 occupant)
        (53, 1),  -- R51 -> H1-101 (max 2, 1 occupant)
        (54, 33),  -- R52 -> H5-101 (max 2, 1 occupant)
        (57, 25),  -- R55 -> H4-101 (max 2, 1 occupant)
        (58, 7),  -- R56 -> H1-301 (max 4, 2 occupants)
        (59, 4),  -- R56 -> H1-201 (max 3, 1 occupant)
        (60, 9),  -- R57 -> H2-101 (max 2, 1 occupant)
        (61, 31),  -- R58 -> H4-301 (max 4, 1 occupant)
        (62, 1),  -- R59 -> H1-101 (max 2, 1 occupant)
        (63, 40),  -- R60 -> H5-302 (max 5, 3 occupants)
        (64, 20),  -- R61 -> H3-201 (max 3, 1 occupant)
        (65, 12),  -- R62 -> H2-201 (max 3, 1 occupant)
        (66, 7),  -- R63 -> H1-301 (max 4, 1 occupant)
        (67, 33),  -- R64 -> H5-101 (max 2, 1 occupant)
        (68, 25),  -- R65 -> H4-101 (max 2, 1 occupant)
        (69, 17),  -- R66 -> H3-101 (max 2, 1 occupant)
        (70, 12),  -- R67 -> H2-201 (max 3, 1 occupant)
        (71, 32),  -- R68 -> H4-302 (max 5, 2 occupants)
        (72, 39),  -- R69 -> H5-301 (max 4, 1 occupant)
        (73, 1)  -- R70 -> H1-101 (max 2, 1 occupant)
    ) AS v (ReservationRoomID, RoomID)
    JOIN gshg.ReservationRoomNight AS n ON n.ReservationRoomID = v.ReservationRoomID;


    UPDATE rr
    SET    ConfirmedAt = r.BookedAt
    FROM   gshg.ReservationRoom AS rr
    JOIN   gshg.Reservation     AS r ON r.ReservationID = rr.ReservationID
    WHERE  r.ReservationID NOT IN (23, 53, 54);   -- R23, R53, R54 stay Pending (EDGE 1: R23)


    UPDATE ro
    SET    IdDocumentType = v.DocumentType, IdDocumentNumber = v.DocumentNumber, IdIssuingCountryCode = v.IssuingCountryCode
    FROM   gshg.RoomOccupant AS ro
    JOIN  (VALUES
        (1, 'NATIONAL_ID', '850412-14-5001', 'MY'),  -- R1 G1
        (2, 'NATIONAL_ID', 'S8000542C', 'SG'),  -- R1 G2
        (3, 'NATIONAL_ID', '900125-14-5003', 'MY'),  -- R2 G3
        (4, 'PASSPORT', 'TH7307652', 'TH'),  -- R3 G4
        (5, 'PASSPORT', 'TH7309565', 'TH'),  -- R3 G5
        (9, 'PASSPORT', 'JP7311478', 'JP'),  -- R4 G6
        (10, 'PASSPORT', 'JP7313391', 'JP'),  -- R4 G7
        (11, 'PASSPORT', 'GB7315304', 'GB'),  -- R5 G8
        (12, 'NATIONAL_ID', '801205-14-5009', 'MY'),  -- R6 G9
        (17, 'PASSPORT', 'US7324869', 'US'),  -- R9 G13
        (18, 'NATIONAL_ID', '870130-14-5014', 'MY'),  -- R10 G14
        (19, 'NATIONAL_ID', '850914-14-5015', 'MY'),  -- R10 G15
        (23, 'PASSPORT', 'JP7330608', 'JP'),  -- R11 G16
        (28, 'PASSPORT', 'JP7349738', 'JP'),  -- R16 G26
        (29, 'PASSPORT', 'JP7351651', 'JP'),  -- R16 G27
        (30, 'NATIONAL_ID', 'S8007588C', 'SG'),  -- R17 G28
        (32, 'PASSPORT', 'US7355477', 'US'),  -- R19 G29
        (34, 'NATIONAL_ID', '891212-14-5030', 'MY'),  -- R19 G30
        (35, 'PASSPORT', 'TH7359303', 'TH'),  -- R20 G31
        (36, 'PASSPORT', 'AU7361216', 'AU'),  -- R20 G32
        (37, 'PASSPORT', 'GB7363129', 'GB'),  -- R21 G33
        (38, 'PASSPORT', 'GB7365042', 'GB'),  -- R21 G34
        (45, 'NATIONAL_ID', 'S8010027L', 'SG'),  -- R28 G37
        (46, 'NATIONAL_ID', 'S8010298M', 'SG'),  -- R28 G38
        (47, 'PASSPORT', 'JP7374607', 'JP'),  -- R29 G39
        (48, 'PASSPORT', 'US7376520', 'US'),  -- R29 G40
        (50, 'NATIONAL_ID', '900125-14-5003', 'MY'),  -- R31 G3
        (51, 'NATIONAL_ID', '800620-14-5024', 'MY'),  -- R32 G24
        (52, 'PASSPORT', 'MY7386085', 'MY'),  -- R32 G45 - EDGE 12: 18 today, so an adult who must show a document
        (56, 'NATIONAL_ID', '940404-14-5025', 'MY'),  -- R33 G25
        (59, 'PASSPORT', 'TH7307652', 'TH'),  -- R34 G4
        (60, 'PASSPORT', 'TH7309565', 'TH'),  -- R34 G5
        (61, 'PASSPORT', 'JP7311478', 'JP'),  -- R35 G6
        (62, 'PASSPORT', 'JP7313391', 'JP'),  -- R35 G7
        (65, 'PASSPORT', 'GB7315304', 'GB'),  -- R36 G8
        (66, 'NATIONAL_ID', '801205-14-5009', 'MY'),  -- R37 G9
        (67, 'NATIONAL_ID', 'S8002710K', 'SG'),  -- R38 G10
        (68, 'PASSPORT', 'AU7321043', 'AU'),  -- R39 G11
        (69, 'NATIONAL_ID', '911002-14-5012', 'MY'),  -- R40 G12
        (76, 'PASSPORT', 'JP7330608', 'JP'),  -- R43 G16
        (77, 'NATIONAL_ID', 'S8004607R', 'SG'),  -- R44 G17
        (78, 'PASSPORT', 'GB7334434', 'GB'),  -- R45 G18
        (79, 'PASSPORT', 'AU7336347', 'AU'),  -- R46 G19
        (93, 'NATIONAL_ID', '891212-14-5030', 'MY'),  -- R57 G30
        (94, 'PASSPORT', 'TH7359303', 'TH'),  -- R58 G31
        (95, 'PASSPORT', 'AU7361216', 'AU'),  -- R59 G32
        (96, 'PASSPORT', 'GB7363129', 'GB'),  -- R60 G33
        (97, 'PASSPORT', 'GB7365042', 'GB'),  -- R60 G34
        (99, 'PASSPORT', 'JP7366955', 'JP'),  -- R61 G35
        (100, 'PASSPORT', 'TH7368868', 'TH'),  -- R62 G36
        (101, 'NATIONAL_ID', 'S8010027L', 'SG'),  -- R63 G37
        (102, 'NATIONAL_ID', 'S8010298M', 'SG'),  -- R64 G38
        (103, 'PASSPORT', 'JP7374607', 'JP'),  -- R65 G39
        (104, 'PASSPORT', 'US7376520', 'US'),  -- R66 G40
        (105, 'NATIONAL_ID', '850412-14-5001', 'MY'),  -- R67 G1
        (106, 'NATIONAL_ID', 'S8000542C', 'SG'),  -- R68 G2
        (107, 'NATIONAL_ID', '900125-14-5003', 'MY'),  -- R68 G3
        (108, 'PASSPORT', 'TH7309565', 'TH')  -- R69 G5
    ) AS v (RoomOccupantID, DocumentType, DocumentNumber, IssuingCountryCode) ON v.RoomOccupantID = ro.RoomOccupantID;

    UPDATE rr SET CheckedInAt = v.EventAt
    FROM gshg.ReservationRoom AS rr
    JOIN (VALUES
        (1, '2025-01-10T15:30:00+08:00'),  -- R1
        (2, '2025-01-20T15:30:00+08:00'),  -- R2
        (3, '2025-02-05T15:30:00+07:00'),  -- R3
        (4, '2025-02-14T15:30:00+08:00'),  -- R4
        (5, '2025-03-01T14:30:00+09:00'),  -- R5
        (6, '2025-03-15T15:30:00+08:00'),  -- R6
        (9, '2025-05-03T15:30:00+08:00'),  -- R9
        (10, '2025-05-20T15:30:00+08:00'),  -- R10
        (11, '2025-06-10T14:30:00+09:00'),  -- R11
        (16, '2025-09-01T15:30:00+07:00'),  -- R16
        (17, '2025-09-01T15:30:00+07:00'),  -- R16
        (18, '2025-10-01T15:30:00+08:00'),  -- R17
        (20, '2025-11-05T15:30:00+08:00'),  -- R19
        (21, '2025-11-05T15:30:00+08:00'),  -- R19
        (22, '2025-12-24T15:30:00+08:00'),  -- R20
        (23, '2025-12-28T15:30:00+08:00'),  -- R21
        (30, '2026-04-02T15:30:00+08:00'),  -- R28
        (31, '2026-04-01T14:30:00+09:00'),  -- R29
        (33, '2026-06-05T15:30:00+08:00'),  -- R31
        (34, '2026-06-15T15:30:00+08:00'),  -- R32
        (35, '2026-07-20T15:30:00+08:00'),  -- R33
        (36, '2026-08-07T15:30:00+08:00'),  -- R34
        (37, '2026-08-15T15:30:00+07:00'),  -- R35
        (38, '2026-09-10T15:30:00+08:00'),  -- R36
        (39, '2026-09-20T14:30:00+09:00'),  -- R37
        (40, '2026-09-28T14:30:00+09:00'),  -- R38
        (41, '2026-10-28T15:30:00+08:00'),  -- R39 (in house on @Today)
        (42, '2026-10-27T15:30:00+08:00'),  -- R40 (in house on @Today)
        (45, '2027-01-05T14:30:00+09:00'),  -- R43
        (46, '2027-01-20T15:30:00+08:00'),  -- R44
        (47, '2027-02-10T15:30:00+08:00'),  -- R45
        (48, '2027-03-05T15:30:00+07:00'),  -- R46
        (60, '2025-06-14T15:30:00+08:00'),  -- R57
        (61, '2025-07-08T15:30:00+07:00'),  -- R58
        (62, '2025-09-18T15:30:00+08:00'),  -- R59
        (63, '2025-11-20T14:30:00+09:00'),  -- R60
        (64, '2026-02-12T15:30:00+08:00'),  -- R61
        (65, '2026-02-05T15:30:00+08:00'),  -- R62
        (66, '2026-02-20T15:30:00+08:00'),  -- R63
        (67, '2026-06-20T14:30:00+09:00'),  -- R64
        (68, '2026-02-08T15:30:00+07:00'),  -- R65
        (69, '2026-10-02T15:30:00+08:00'),  -- R66
        (70, '2027-02-03T15:30:00+08:00'),  -- R67
        (71, '2027-04-08T15:30:00+07:00'),  -- R68
        (72, '2027-05-10T14:30:00+09:00')  -- R69
    ) AS v (ReservationRoomID, EventAt) ON v.ReservationRoomID = rr.ReservationRoomID;

    UPDATE rr SET CheckedOutAt = v.EventAt
    FROM gshg.ReservationRoom AS rr
    JOIN (VALUES
        (1, '2025-01-13T11:00:00+08:00'),  -- R1
        (2, '2025-01-24T11:00:00+08:00'),  -- R2
        (3, '2025-02-08T11:00:00+07:00'),  -- R3
        (4, '2025-02-16T11:00:00+08:00'),  -- R4
        (5, '2025-03-05T10:30:00+09:00'),  -- R5
        (6, '2025-03-18T11:00:00+08:00'),  -- R6
        (9, '2025-05-06T11:00:00+08:00'),  -- R9
        (10, '2025-05-23T11:00:00+08:00'),  -- R10
        (11, '2025-06-14T10:30:00+09:00'),  -- R11
        (16, '2025-09-05T11:00:00+07:00'),  -- R16
        (17, '2025-09-05T11:00:00+07:00'),  -- R16
        (18, '2025-10-04T11:00:00+08:00'),  -- R17
        (20, '2025-11-08T11:00:00+08:00'),  -- R19
        (21, '2025-11-08T11:00:00+08:00'),  -- R19
        (22, '2025-12-27T11:00:00+08:00'),  -- R20
        (23, '2026-01-02T11:00:00+08:00'),  -- R21
        (30, '2026-04-05T11:00:00+08:00'),  -- R28
        (31, '2026-04-05T10:30:00+09:00'),  -- R29
        (33, '2026-06-08T11:00:00+08:00'),  -- R31
        (34, '2026-06-18T11:00:00+08:00'),  -- R32
        (35, '2026-07-23T11:00:00+08:00'),  -- R33
        (36, '2026-08-10T11:00:00+08:00'),  -- R34
        (37, '2026-08-19T11:00:00+07:00'),  -- R35
        (38, '2026-09-12T10:00:00+08:00'),  -- R36 - early departure
        (39, '2026-09-24T10:30:00+09:00'),  -- R37
        (40, '2026-10-01T10:30:00+09:00'),  -- R38
        (45, '2027-01-08T10:30:00+09:00'),  -- R43
        (46, '2027-01-23T11:00:00+08:00'),  -- R44
        (47, '2027-02-14T11:00:00+08:00'),  -- R45
        (48, '2027-03-08T11:00:00+07:00'),  -- R46
        (60, '2025-06-16T11:00:00+08:00'),  -- R57
        (61, '2025-07-11T11:00:00+07:00'),  -- R58
        (62, '2025-09-20T11:00:00+08:00'),  -- R59
        (63, '2025-11-23T10:30:00+09:00'),  -- R60
        (64, '2026-02-15T11:00:00+08:00'),  -- R61
        (65, '2026-02-08T11:00:00+08:00'),  -- R62
        (66, '2026-02-23T11:00:00+08:00'),  -- R63
        (67, '2026-06-24T10:30:00+09:00'),  -- R64
        (68, '2026-02-11T11:00:00+07:00'),  -- R65
        (69, '2026-10-05T11:00:00+08:00'),  -- R66
        (70, '2027-02-06T11:00:00+08:00'),  -- R67
        (71, '2027-04-11T11:00:00+07:00'),  -- R68
        (72, '2027-05-13T10:30:00+09:00')  -- R69
    ) AS v (ReservationRoomID, EventAt) ON v.ReservationRoomID = rr.ReservationRoomID;

    UPDATE rr SET NoShowAt = v.EventAt
    FROM gshg.ReservationRoom AS rr
    JOIN (VALUES
        (7, '2025-04-03T01:00:00+08:00'),  -- R7 H3 basis FIRST_NIGHT
        (13, '2025-08-13T01:00:00+08:00'),  -- R13 H3 basis FIRST_NIGHT
        (15, '2025-08-09T01:00:00+08:00'),  -- R15 H1 basis FIRST_NIGHT
        (32, '2026-05-11T01:00:00+07:00')  -- R30 H4 basis FULL_STAY
    ) AS v (ReservationRoomID, EventAt) ON v.ReservationRoomID = rr.ReservationRoomID;

    UPDATE r SET CancelledAt = v.EventAt, CancellationInitiator = v.Initiator, CancellationReason = v.Reason
    FROM gshg.Reservation AS r
    JOIN (VALUES
        (8, '2025-03-20T10:00:00+07:00', 'GUEST', N'Change of travel plans'),  -- R8 - EDGE 7: guest G21 guest-initiated cancellation 1 of 4
        (12, '2025-06-01T09:00:00+08:00', 'GUEST', N'Trip postponed'),  -- R12 - EDGE 9: cancelled nights on room H3-202 in 2025-Q3; EDGE 7: guest G22 guest-initiated cancellation 1 of 3
        (14, '2025-07-10T14:00:00+08:00', 'HOTEL', N'Room taken out of service for urgent repairs'),  -- R14 - EDGE 9: cancelled nights on room H2-103 in 2025-Q3; EDGE 7: guest G23 hotel-initiated cancellation 1 of 2
        (18, '2025-10-10T09:00:00+08:00', 'GUEST', N'Conference cancelled'),  -- R18 - EDGE 7: guest G21 guest-initiated cancellation 2 of 4
        (22, '2026-01-20T09:00:00+09:00', 'GUEST', N'Visa delayed'),  -- R22 - EDGE 1: Tokyo (H5) February 2026 - cancelled; EDGE 7: guest G22 guest-initiated cancellation 2 of 3
        (24, '2026-02-04T20:00:00+09:00', 'HOTEL', N'Overbooking after a system outage'),  -- R24 - EDGE 1: Tokyo (H5) February 2026 - cancelled; EDGE 6: hotel-initiated late cancellation (18h before 14:00 check-in), no fee; EDGE 7: guest G23 hotel-initiated cancellation 2 of 2
        (25, '2026-03-18T16:01:00+08:00', 'GUEST', N'Family emergency'),  -- R25 - EDGE 6: guest cancelled 47h59m before 2026-03-20 15:00 Bangkok time (stored as +08:00) - late, fee; EDGE 7: guest G21 guest-initiated cancellation 3 of 4
        (26, '2026-03-23T15:00:00+07:00', 'GUEST', N'Meeting moved online'),  -- R26 - EDGE 6: guest cancelled exactly 48h before check-in - not late; EDGE 7: guest G22 guest-initiated cancellation 3 of 3
        (27, '2026-03-26T14:00:00+07:00', 'GUEST', N'Booked another hotel'),  -- R27 - EDGE 6: guest cancelled 49h before check-in - not late
        (51, '2027-01-10T09:00:00+08:00', 'GUEST', N'Plans changed again'),  -- R51 - EDGE 7: guest G21 guest-initiated cancellation 4 of 4
        (55, '2026-12-20T10:00:00+07:00', 'HOTEL', N'Hotel closed for a private event')  -- R55
    ) AS v (ReservationID, EventAt, Initiator, Reason) ON v.ReservationID = r.ReservationID;


    DELETE a
    FROM   gshg.RoomNightAllocation AS a
    WHERE  EXISTS (SELECT 1 FROM gshg.vwStrayAllocation AS s WHERE s.RoomID = a.RoomID AND s.StayDate = a.StayDate);


    SET IDENTITY_INSERT gshg.ReservationDateChange ON;
    INSERT gshg.ReservationDateChange (DateChangeID, ReservationID, ChangedAt, OldCheckInDate, OldCheckOutDate,
                                       NewCheckInDate, NewCheckOutDate, OldRoomTotal, NewRoomTotal, Reason)
    VALUES (1, 47, '2026-09-15T10:00:00+08:00', '2027-03-15', '2027-03-18', '2027-03-20', '2027-03-24', 759.00, 1012.00, N'Guest moved the trip by five days');   -- 1. log row
    SET IDENTITY_INSERT gshg.ReservationDateChange OFF;
    ;WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
         Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c)
    INSERT gshg.ReservationRoomNight (ReservationRoomID, StayDate, HotelID, RoomCategoryID, AgreedRoomRate)   -- 2. new nights
    SELECT rr.ReservationRoomID, DATEADD(DAY, t.n, v.NewIn), rr.HotelID, rr.RoomCategoryID,
           CAST(ROUND(COALESCE(rt.NightlyRate, hrc.StandardNightlyRate) * (1 + rp.RateAdjustmentPct / 100.0), 2) AS DECIMAL(10,2))
    FROM  (VALUES (47, CAST('2027-03-20' AS DATE), CAST('2027-03-24' AS DATE))) AS v (ReservationID, NewIn, NewOut)
    JOIN   gshg.Reservation       AS r   ON r.ReservationID = v.ReservationID
    JOIN   gshg.ReservationRoom   AS rr  ON rr.ReservationID = r.ReservationID
    JOIN   Tally                  AS t   ON t.n < DATEDIFF(DAY, v.NewIn, v.NewOut)
    JOIN   gshg.HotelRoomCategory AS hrc ON hrc.HotelID = rr.HotelID AND hrc.RoomCategoryID = rr.RoomCategoryID
    JOIN   gshg.RatePlan          AS rp  ON rp.RatePlanID = r.RatePlanID
    LEFT JOIN gshg.RoomRate       AS rt  ON rt.HotelID = rr.HotelID AND rt.RoomCategoryID = rr.RoomCategoryID
                                         AND rt.RateDate = DATEADD(DAY, t.n, v.NewIn)
    WHERE  NOT EXISTS (SELECT 1 FROM gshg.ReservationRoomNight AS x
                       WHERE x.ReservationRoomID = rr.ReservationRoomID AND x.StayDate = DATEADD(DAY, t.n, v.NewIn));
    INSERT gshg.RoomNightAllocation (RoomID, StayDate, HotelID, ReservationRoomID)                         -- 2. rooms for them
    SELECT 9, n.StayDate, n.HotelID, n.ReservationRoomID
    FROM   gshg.ReservationRoomNight AS n
    WHERE  n.ReservationRoomID = 49 AND n.StayDate >= '2027-03-20' AND n.StayDate < '2027-03-24'
      AND  NOT EXISTS (SELECT 1 FROM gshg.RoomNightAllocation AS a WHERE a.ReservationRoomID = n.ReservationRoomID AND a.StayDate = n.StayDate);
    UPDATE gshg.Reservation SET CheckInDate = '2027-03-20', CheckOutDate = '2027-03-24' WHERE ReservationID = 47;   -- 3. move the dates (T10)
    DELETE gshg.RoomNightAllocation  WHERE ReservationRoomID = 49 AND (StayDate < '2027-03-20' OR StayDate >= '2027-03-24');   -- 4. allocations outside
    DELETE gshg.ReservationRoomNight WHERE ReservationRoomID = 49 AND (StayDate < '2027-03-20' OR StayDate >= '2027-03-24');   -- 4. then nights outside

    -- R48: 2027-04-10 -> 2027-04-12 becomes 2027-04-10 -> 2027-04-14 (Extended by two nights)
    SET IDENTITY_INSERT gshg.ReservationDateChange ON;
    INSERT gshg.ReservationDateChange (DateChangeID, ReservationID, ChangedAt, OldCheckInDate, OldCheckOutDate,
                                       NewCheckInDate, NewCheckOutDate, OldRoomTotal, NewRoomTotal, Reason)
    VALUES (2, 48, '2026-09-22T15:00:00+08:00', '2027-04-10', '2027-04-12', '2027-04-10', '2027-04-14', 840.00, 1680.00, N'Extended by two nights');   -- 1. log row
    SET IDENTITY_INSERT gshg.ReservationDateChange OFF;
    ;WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
         Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c)
    INSERT gshg.ReservationRoomNight (ReservationRoomID, StayDate, HotelID, RoomCategoryID, AgreedRoomRate)   -- 2. new nights
    SELECT rr.ReservationRoomID, DATEADD(DAY, t.n, v.NewIn), rr.HotelID, rr.RoomCategoryID,
           CAST(ROUND(COALESCE(rt.NightlyRate, hrc.StandardNightlyRate) * (1 + rp.RateAdjustmentPct / 100.0), 2) AS DECIMAL(10,2))
    FROM  (VALUES (48, CAST('2027-04-10' AS DATE), CAST('2027-04-14' AS DATE))) AS v (ReservationID, NewIn, NewOut)
    JOIN   gshg.Reservation       AS r   ON r.ReservationID = v.ReservationID
    JOIN   gshg.ReservationRoom   AS rr  ON rr.ReservationID = r.ReservationID
    JOIN   Tally                  AS t   ON t.n < DATEDIFF(DAY, v.NewIn, v.NewOut)
    JOIN   gshg.HotelRoomCategory AS hrc ON hrc.HotelID = rr.HotelID AND hrc.RoomCategoryID = rr.RoomCategoryID
    JOIN   gshg.RatePlan          AS rp  ON rp.RatePlanID = r.RatePlanID
    LEFT JOIN gshg.RoomRate       AS rt  ON rt.HotelID = rr.HotelID AND rt.RoomCategoryID = rr.RoomCategoryID
                                         AND rt.RateDate = DATEADD(DAY, t.n, v.NewIn)
    WHERE  NOT EXISTS (SELECT 1 FROM gshg.ReservationRoomNight AS x
                       WHERE x.ReservationRoomID = rr.ReservationRoomID AND x.StayDate = DATEADD(DAY, t.n, v.NewIn));
    INSERT gshg.RoomNightAllocation (RoomID, StayDate, HotelID, ReservationRoomID)                         -- 2. rooms for them
    SELECT 4, n.StayDate, n.HotelID, n.ReservationRoomID
    FROM   gshg.ReservationRoomNight AS n
    WHERE  n.ReservationRoomID = 50 AND n.StayDate >= '2027-04-10' AND n.StayDate < '2027-04-14'
      AND  NOT EXISTS (SELECT 1 FROM gshg.RoomNightAllocation AS a WHERE a.ReservationRoomID = n.ReservationRoomID AND a.StayDate = n.StayDate);
    UPDATE gshg.Reservation SET CheckInDate = '2027-04-10', CheckOutDate = '2027-04-14' WHERE ReservationID = 48;   -- 3. move the dates (T10)
    DELETE gshg.RoomNightAllocation  WHERE ReservationRoomID = 50 AND (StayDate < '2027-04-10' OR StayDate >= '2027-04-14');   -- 4. allocations outside
    DELETE gshg.ReservationRoomNight WHERE ReservationRoomID = 50 AND (StayDate < '2027-04-10' OR StayDate >= '2027-04-14');   -- 4. then nights outside

    -- R49 line 51: STD -> DLX (Upgrade requested: more space for an infant)
    SET IDENTITY_INSERT gshg.RoomCategoryChange ON;
    INSERT gshg.RoomCategoryChange (CategoryChangeID, ReservationRoomID, ChangedAt, OldRoomCategoryID, NewRoomCategoryID,
                                    OldRoomTotal, NewRoomTotal, Reason)
    VALUES (1, 51, '2026-09-05T11:00:00+08:00', 1, 2, 702.00, 1053.00, N'Upgrade requested: more space for an infant');   -- 1. log row
    SET IDENTITY_INSERT gshg.RoomCategoryChange OFF;
    UPDATE rr   -- 2. category and agreed terms; cascades to the nights (T11, T1, T6)
    SET    RoomCategoryID = hrc.RoomCategoryID, AgreedBaseOccupancy = hrc.BaseOccupancy,
           AgreedExtraPersonRate = hrc.ExtraPersonRate, AgreedReducedChildRate = hrc.ReducedChildRate
    FROM   gshg.ReservationRoom   AS rr
    JOIN   gshg.HotelRoomCategory AS hrc ON hrc.HotelID = rr.HotelID AND hrc.RoomCategoryID = 2
    WHERE  rr.ReservationRoomID = 51;
    UPDATE n    -- 3. reprice the nights at the new category
    SET    AgreedRoomRate = CAST(ROUND(COALESCE(rt.NightlyRate, hrc.StandardNightlyRate) * (1 + rp.RateAdjustmentPct / 100.0), 2) AS DECIMAL(10,2))
    FROM   gshg.ReservationRoomNight AS n
    JOIN   gshg.ReservationRoom      AS rr  ON rr.ReservationRoomID = n.ReservationRoomID
    JOIN   gshg.Reservation          AS r   ON r.ReservationID = rr.ReservationID
    JOIN   gshg.HotelRoomCategory    AS hrc ON hrc.HotelID = n.HotelID AND hrc.RoomCategoryID = n.RoomCategoryID
    JOIN   gshg.RatePlan             AS rp  ON rp.RatePlanID = r.RatePlanID
    LEFT JOIN gshg.RoomRate          AS rt  ON rt.HotelID = n.HotelID AND rt.RoomCategoryID = n.RoomCategoryID AND rt.RateDate = n.StayDate
    WHERE  n.ReservationRoomID = 51;
    UPDATE gshg.RoomNightAllocation SET RoomID = 20 WHERE ReservationRoomID = 51;   -- 4. move every night to H3-201 (DLX) (T2)

    -- R50 line 52: DLX -> SUI (Upsell to suite at booking review)
    SET IDENTITY_INSERT gshg.RoomCategoryChange ON;
    INSERT gshg.RoomCategoryChange (CategoryChangeID, ReservationRoomID, ChangedAt, OldRoomCategoryID, NewRoomCategoryID,
                                    OldRoomTotal, NewRoomTotal, Reason)
    VALUES (2, 52, '2026-09-28T16:00:00+07:00', 2, 3, 11700.00, 24600.00, N'Upsell to suite at booking review');   -- 1. log row
    SET IDENTITY_INSERT gshg.RoomCategoryChange OFF;
    UPDATE rr   -- 2. category and agreed terms; cascades to the nights (T11, T1, T6)
    SET    RoomCategoryID = hrc.RoomCategoryID, AgreedBaseOccupancy = hrc.BaseOccupancy,
           AgreedExtraPersonRate = hrc.ExtraPersonRate, AgreedReducedChildRate = hrc.ReducedChildRate
    FROM   gshg.ReservationRoom   AS rr
    JOIN   gshg.HotelRoomCategory AS hrc ON hrc.HotelID = rr.HotelID AND hrc.RoomCategoryID = 3
    WHERE  rr.ReservationRoomID = 52;
    UPDATE n    -- 3. reprice the nights at the new category
    SET    AgreedRoomRate = CAST(ROUND(COALESCE(rt.NightlyRate, hrc.StandardNightlyRate) * (1 + rp.RateAdjustmentPct / 100.0), 2) AS DECIMAL(10,2))
    FROM   gshg.ReservationRoomNight AS n
    JOIN   gshg.ReservationRoom      AS rr  ON rr.ReservationRoomID = n.ReservationRoomID
    JOIN   gshg.Reservation          AS r   ON r.ReservationID = rr.ReservationID
    JOIN   gshg.HotelRoomCategory    AS hrc ON hrc.HotelID = n.HotelID AND hrc.RoomCategoryID = n.RoomCategoryID
    JOIN   gshg.RatePlan             AS rp  ON rp.RatePlanID = r.RatePlanID
    LEFT JOIN gshg.RoomRate          AS rt  ON rt.HotelID = n.HotelID AND rt.RoomCategoryID = n.RoomCategoryID AND rt.RateDate = n.StayDate
    WHERE  n.ReservationRoomID = 52;
    UPDATE gshg.RoomNightAllocation SET RoomID = 31 WHERE ReservationRoomID = 52;   -- 4. move every night to H4-301 (SUI) (T2)



    SET IDENTITY_INSERT gshg.ReservationService ON;
    INSERT gshg.ReservationService (ReservationServiceID, ReservationID, HotelID, HotelServiceID, ChargingBasis, ReservationRoomID,
                                    RoomOccupantID, StartDate, Days, Quantity, AgreedUnitPrice, BookedAt)
    SELECT v.ReservationServiceID, r.ReservationID, r.HotelID, hs.HotelServiceID, hs.ChargingBasis, v.ReservationRoomID,
           v.RoomOccupantID, v.StartDate, v.Days, v.Quantity, hs.UnitPrice, v.BookedAt
    FROM (VALUES
        (1, 1, 1, 1, 1, '2025-01-11', 3, 1, '2025-01-10T16:30:00+08:00'),  -- R1 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-01
        (2, 1, 1, 1, 2, '2025-01-11', 3, 1, '2025-01-10T16:30:00+08:00'),  -- R1 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-01
        (3, 2, 14, NULL, NULL, '2025-01-20', 1, 1, '2025-01-20T16:30:00+08:00'),  -- R2 Airport Transfer PER_RESERVATION -> 1 billable day(s), charge 85.00
        (4, 3, 19, 3, 4, '2025-02-06', 3, 1, '2025-02-05T16:30:00+07:00'),  -- R3 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2025-02
        (5, 3, 19, 3, 5, '2025-02-06', 3, 1, '2025-02-05T16:30:00+07:00'),  -- R3 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2025-02
        (6, 3, 19, 3, 6, '2025-02-06', 3, 1, '2025-02-05T16:30:00+07:00'),  -- R3 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2025-02
        (7, 3, 19, 3, 7, '2025-02-06', 3, 1, '2025-02-05T16:30:00+07:00'),  -- R3 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2025-02
        (8, 3, 23, 3, 8, '2025-02-05', 3, 1, '2025-02-05T16:30:00+07:00'),  -- R3 Baby Cot PER_PERSON -> 3 billable day(s), charge 600.00 - EDGE 11: infant G49 with a cot
        (9, 5, 25, 5, 11, '2025-03-02', 4, 1, '2025-03-01T15:30:00+09:00'),  -- R5 Breakfast PER_PERSON -> 4 billable day(s), charge 12800.00 - EDGE 11: breakfast sale 2025-03
        (10, 6, 3, 6, 12, '2025-03-16', 1, 1, '2025-03-15T16:30:00+08:00'),  -- R6 Spa Treatment PER_PERSON -> 1 billable day(s), charge 250.00
        (11, 10, 1, 10, 18, '2025-05-21', 3, 1, '2025-05-20T16:30:00+08:00'),  -- R10 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-05
        (12, 10, 1, 10, 19, '2025-05-21', 3, 1, '2025-05-20T16:30:00+08:00'),  -- R10 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-05
        (13, 10, 1, 10, 20, '2025-05-21', 3, 1, '2025-05-20T16:30:00+08:00'),  -- R10 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-05
        (14, 10, 1, 10, 21, '2025-05-21', 3, 1, '2025-05-20T16:30:00+08:00'),  -- R10 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-05
        (15, 10, 5, 10, 22, '2025-05-20', 3, 1, '2025-05-20T16:30:00+08:00'),  -- R10 Baby Cot PER_PERSON -> 3 billable day(s), charge 60.00 - EDGE 11: infant G53 with a cot
        (16, 11, 25, 11, 23, '2025-06-11', 4, 1, '2025-06-10T15:30:00+09:00'),  -- R11 Breakfast PER_PERSON -> 4 billable day(s), charge 12800.00 - EDGE 11: breakfast sale 2025-06
        (17, 11, 26, NULL, NULL, '2025-06-10', 1, 1, '2025-06-10T15:30:00+09:00'),  -- R11 Airport Transfer PER_RESERVATION -> 1 billable day(s), charge 9800.00
        (18, 16, 22, 16, NULL, '2025-09-02', 2, 1, '2025-09-01T16:30:00+07:00'),  -- R16 Laundry PER_ROOM -> 2 billable day(s), charge 600.00
        (19, 17, 4, 18, NULL, '2025-10-01', 3, 1, '2025-10-01T16:30:00+08:00'),  -- R17 Parking PER_ROOM -> 3 billable day(s), charge 90.00
        (20, 19, 12, 20, 33, '2025-11-05', 3, 1, '2025-11-05T16:30:00+08:00'),  -- R19 Extra Bed PER_PERSON -> 3 billable day(s), charge 240.00
        (21, 19, 7, 20, 32, '2025-11-06', 3, 1, '2025-11-05T16:30:00+08:00'),  -- R19 Breakfast PER_PERSON -> 3 billable day(s), charge 114.00 - EDGE 11: breakfast sale 2025-11
        (22, 19, 7, 21, 34, '2025-11-06', 3, 1, '2025-11-05T16:30:00+08:00'),  -- R19 Breakfast PER_PERSON -> 3 billable day(s), charge 114.00 - EDGE 11: breakfast sale 2025-11
        (23, 20, 1, 22, 35, '2025-12-25', 3, 1, '2025-12-24T16:30:00+08:00'),  -- R20 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-12
        (24, 20, 1, 22, 36, '2025-12-25', 3, 1, '2025-12-24T16:30:00+08:00'),  -- R20 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2025-12
        (25, 20, 4, 22, NULL, '2025-12-24', 3, 1, '2025-12-24T16:30:00+08:00'),  -- R20 Parking PER_ROOM -> 3 billable day(s), charge 90.00
        (26, 21, 13, 23, 37, '2025-12-29', 4, 1, '2025-12-28T16:30:00+08:00'),  -- R21 Breakfast PER_PERSON -> 4 billable day(s), charge 128.00 - EDGE 11: breakfast sale 2025-12
        (27, 21, 13, 23, 38, '2025-12-29', 4, 1, '2025-12-28T16:30:00+08:00'),  -- R21 Breakfast PER_PERSON -> 4 billable day(s), charge 128.00 - EDGE 11: breakfast sale 2025-12
        (28, 28, 1, 30, 45, '2026-04-03', 3, 1, '2026-04-02T16:30:00+08:00'),  -- R28 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2026-04
        (29, 28, 1, 30, 46, '2026-04-03', 3, 1, '2026-04-02T16:30:00+08:00'),  -- R28 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2026-04
        (30, 28, 4, 30, NULL, '2026-04-02', 1, 1, '2026-04-02T16:30:00+08:00'),  -- R28 Parking PER_ROOM -> 1 billable day(s), charge 30.00
        (31, 29, 25, 31, 47, '2026-04-02', 4, 1, '2026-04-01T15:30:00+09:00'),  -- R29 Breakfast PER_PERSON -> 4 billable day(s), charge 12800.00 - EDGE 11: breakfast sale 2026-04
        (32, 29, 25, 31, 48, '2026-04-02', 4, 1, '2026-04-01T15:30:00+09:00'),  -- R29 Breakfast PER_PERSON -> 4 billable day(s), charge 12800.00 - EDGE 11: breakfast sale 2026-04
        (33, 31, 13, 33, 50, '2026-06-06', 3, 1, '2026-06-05T16:30:00+08:00'),  -- R31 Breakfast PER_PERSON -> 3 billable day(s), charge 96.00 - EDGE 11: breakfast sale 2026-06
        (35, 32, 1, 34, 51, '2026-06-16', 3, 1, '2026-06-15T16:30:00+08:00'),  -- R32 Breakfast PER_PERSON -> 3 billable day(s), charge 135.00 - EDGE 11: breakfast sale 2026-06
        (36, 32, 1, 34, 52, '2026-06-16', 2, 1, '2026-06-15T16:30:00+08:00'),  -- R32 Breakfast PER_PERSON -> 2 billable day(s), charge 90.00 - EDGE 11: breakfast sale 2026-06
        (37, 33, 7, 35, 56, '2026-07-21', 3, 1, '2026-07-20T16:30:00+08:00'),  -- R33 Breakfast PER_PERSON -> 3 billable day(s), charge 114.00 - EDGE 11: breakfast sale 2026-07
        (38, 33, 11, 35, 58, '2026-07-20', 3, 1, '2026-07-20T16:30:00+08:00'),  -- R33 Baby Cot PER_PERSON -> 3 billable day(s), charge 60.00 - EDGE 11: infant G42 with a cot
        (39, 34, 15, 36, 59, '2026-08-08', 1, 1, '2026-08-07T16:30:00+08:00'),  -- R34 Spa Treatment PER_PERSON -> 1 billable day(s), charge 180.00
        (40, 34, 13, 36, 59, '2026-08-08', 3, 1, '2026-08-07T16:30:00+08:00'),  -- R34 Breakfast PER_PERSON -> 3 billable day(s), charge 96.00 - EDGE 11: breakfast sale 2026-08
        (41, 34, 13, 36, 60, '2026-08-08', 3, 1, '2026-08-07T16:30:00+08:00'),  -- R34 Breakfast PER_PERSON -> 3 billable day(s), charge 96.00 - EDGE 11: breakfast sale 2026-08
        (42, 35, 19, 37, 61, '2026-08-16', 4, 1, '2026-08-15T16:30:00+07:00'),  -- R35 Breakfast PER_PERSON -> 4 billable day(s), charge 1800.00 - EDGE 11: breakfast sale 2026-08
        (43, 35, 19, 37, 62, '2026-08-16', 4, 1, '2026-08-15T16:30:00+07:00'),  -- R35 Breakfast PER_PERSON -> 4 billable day(s), charge 1800.00 - EDGE 11: breakfast sale 2026-08
        (44, 35, 22, 37, NULL, '2026-08-17', 1, 1, '2026-08-15T16:30:00+07:00'),  -- R35 Laundry PER_ROOM -> 1 billable day(s), charge 300.00
        (45, 39, 13, 41, 68, '2026-10-29', 2, 1, '2026-10-28T16:30:00+08:00'),  -- R39 Breakfast PER_PERSON -> 2 billable day(s), charge 64.00 - EDGE 11: breakfast sale 2026-10
        (46, 43, 25, 45, 76, '2027-01-06', 3, 1, '2027-01-05T15:30:00+09:00'),  -- R43 Breakfast PER_PERSON -> 3 billable day(s), charge 9600.00 - EDGE 11: breakfast sale 2027-01
        (47, 45, 13, 47, 78, '2027-02-11', 4, 1, '2027-02-10T16:30:00+08:00'),  -- R45 Breakfast PER_PERSON -> 4 billable day(s), charge 128.00 - EDGE 11: breakfast sale 2027-02
        (48, 57, 7, 60, 93, '2025-06-15', 2, 1, '2025-06-14T16:30:00+08:00'),  -- R57 Breakfast PER_PERSON -> 2 billable day(s), charge 76.00 - EDGE 11: breakfast sale 2025-06
        (49, 59, 4, 62, NULL, '2025-09-18', 2, 1, '2025-09-18T16:30:00+08:00'),  -- R59 Parking PER_ROOM -> 2 billable day(s), charge 60.00
        (50, 60, 25, 63, 96, '2025-11-21', 3, 1, '2025-11-20T15:30:00+09:00'),  -- R60 Breakfast PER_PERSON -> 3 billable day(s), charge 9600.00 - EDGE 11: breakfast sale 2025-11
        (51, 60, 25, 63, 97, '2025-11-21', 3, 1, '2025-11-20T15:30:00+09:00'),  -- R60 Breakfast PER_PERSON -> 3 billable day(s), charge 9600.00 - EDGE 11: breakfast sale 2025-11
        (52, 60, 25, 63, 98, '2025-11-21', 3, 1, '2025-11-20T15:30:00+09:00'),  -- R60 Breakfast PER_PERSON -> 3 billable day(s), charge 9600.00 - EDGE 11: breakfast sale 2025-11
        (53, 61, 13, 64, 99, '2026-02-13', 3, 1, '2026-02-12T16:30:00+08:00'),  -- R61 Breakfast PER_PERSON -> 3 billable day(s), charge 96.00 - EDGE 11: breakfast sale 2026-02
        (54, 63, 3, 66, 101, '2026-02-21', 1, 1, '2026-02-20T16:30:00+08:00'),  -- R63 Spa Treatment PER_PERSON -> 1 billable day(s), charge 250.00
        (55, 63, 1, 66, 101, '2026-02-22', 1, 1, '2026-02-20T16:30:00+08:00'),  -- R63 Breakfast PER_PERSON -> 1 billable day(s), charge 45.00 - EDGE 11: breakfast sale 2026-02
        (56, 64, 25, 67, 102, '2026-06-21', 2, 1, '2026-06-20T15:30:00+09:00'),  -- R64 Breakfast PER_PERSON -> 2 billable day(s), charge 6400.00 - EDGE 11: breakfast sale 2026-06
        (57, 66, 13, 69, 104, '2026-10-03', 3, 1, '2026-10-02T16:30:00+08:00'),  -- R66 Breakfast PER_PERSON -> 3 billable day(s), charge 96.00 - EDGE 11: breakfast sale 2026-10
        (58, 66, 16, 69, NULL, '2026-10-02', 3, 1, '2026-10-02T16:30:00+08:00'),  -- R66 Parking PER_ROOM -> 3 billable day(s), charge 120.00
        (59, 67, 7, 70, 105, '2027-02-04', 2, 1, '2027-02-03T16:30:00+08:00'),  -- R67 Breakfast PER_PERSON -> 2 billable day(s), charge 76.00 - EDGE 11: breakfast sale 2027-02
        (60, 67, 8, NULL, NULL, '2027-02-06', 1, 1, '2027-02-03T16:30:00+08:00'),  -- R67 Airport Transfer PER_RESERVATION -> 1 billable day(s), charge 90.00
        (61, 68, 19, 71, 106, '2027-04-09', 3, 1, '2027-04-08T16:30:00+07:00'),  -- R68 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2027-04
        (62, 68, 19, 71, 107, '2027-04-09', 3, 1, '2027-04-08T16:30:00+07:00'),  -- R68 Breakfast PER_PERSON -> 3 billable day(s), charge 1350.00 - EDGE 11: breakfast sale 2027-04
        (63, 69, 26, NULL, NULL, '2027-05-10', 1, 1, '2027-05-10T15:30:00+09:00')  -- R69 Airport Transfer PER_RESERVATION -> 1 billable day(s), charge 9800.00
    ) AS v (ReservationServiceID, ReservationID, HotelServiceID, ReservationRoomID, RoomOccupantID, StartDate, Days, Quantity, BookedAt)
    JOIN gshg.Reservation  AS r  ON r.ReservationID = v.ReservationID
    JOIN gshg.HotelService AS hs ON hs.HotelServiceID = v.HotelServiceID;
    SET IDENTITY_INSERT gshg.ReservationService OFF;

    SET IDENTITY_INSERT gshg.AdditionalCharge ON;
    INSERT gshg.AdditionalCharge (AdditionalChargeID, ReservationRoomID, ChargeType, ChargeDate, Description, Amount, PostedAt) VALUES
    (2, 11, 'MINIBAR', '2025-06-12', N'Minibar', 3800, '2025-06-12T21:00:00+09:00'),  -- R11
    (3, 30, 'LATE_CHECKOUT', '2026-04-05', N'Late check-out to 15:00', 60, '2026-04-05T21:00:00+08:00'),  -- R28
    (5, 63, 'OTHER', '2025-11-22', N'Replacement key card', 1500, '2025-11-22T21:00:00+09:00');  -- R60
    SET IDENTITY_INSERT gshg.AdditionalCharge OFF;

    SET IDENTITY_INSERT gshg.ReservationDiscount ON;
    INSERT gshg.ReservationDiscount (DiscountID, ReservationID, HotelID, PromotionID, Amount, Reason, PostedAt) VALUES
    (1, 4, 2, 1, 136.80, NULL, '2024-12-31T10:02:00+08:00'),  -- R4 EARLY25
    (2, 21, 3, 4, 100, N'Five-night stay', '2025-11-13T10:02:00+08:00'),  -- R21 LONGSTAY
    (3, 34, 3, 2, 50, NULL, '2026-06-23T10:02:00+08:00'),  -- R34 SUMMER26
    (4, 35, 4, 2, 50, NULL, '2026-07-01T10:02:00+07:00'),  -- R35 SUMMER26
    (5, 36, 1, NULL, 30, N'Compensation: pool closed', '2026-09-10T16:00:00+08:00'),  -- R36 goodwill (no promotion)
    (6, 43, 5, 3, 13770.00, NULL, '2026-10-06T10:45:00+09:00');  -- R43 NEWYEAR27
    SET IDENTITY_INSERT gshg.ReservationDiscount OFF;


    SET IDENTITY_INSERT gshg.Invoice ON;
    INSERT gshg.Invoice (InvoiceID, InvoiceNumber, ReservationID, InvoiceType, MyrPerUnit, IssuedAt, Reason)
    SELECT v.InvoiceID, v.InvoiceNumber, v.ReservationID, 'INVOICE',
           er.MyrPerUnit,
           v.IssuedAt, v.Reason
    FROM (VALUES
        (1, 'INV-2025-0001', 1, '2025-01-13T11:05:00+08:00', NULL),  -- R1 H1 total 1110.00 MYR
        (2, 'INV-2025-0002', 2, '2025-01-24T11:05:00+08:00', NULL),  -- R2 H3 total 1801.00 SGD
        (3, 'INV-2025-0003', 3, '2025-02-08T11:05:00+07:00', NULL),  -- R3 H4 total 22800.00 THB
        (4, 'INV-2025-0004', 4, '2025-02-16T11:05:00+08:00', NULL),  -- R4 H2 total 1231.20 MYR
        (5, 'INV-2025-0005', 5, '2025-03-05T10:35:00+09:00', NULL),  -- R5 H5 total 87600.00 JPY
        (6, 'INV-2025-0006', 6, '2025-03-18T11:05:00+08:00', NULL),  -- R6 H1 total 1510.00 MYR
        (7, 'INV-2025-0007', 7, '2025-04-03T01:05:00+08:00', NULL),  -- R7 H3 total 260.00 SGD (no-show fee)
        (8, 'INV-2025-0008', 9, '2025-05-06T11:05:00+08:00', NULL),  -- R9 H2 total 690.00 MYR
        (9, 'INV-2025-0009', 10, '2025-05-23T11:05:00+08:00', NULL),  -- R10 H1 total 2400.00 MYR
        (10, 'INV-2025-0010', 11, '2025-06-14T10:35:00+09:00', NULL),  -- R11 H5 total 148800.00 JPY
        (11, 'INV-2025-0011', 13, '2025-08-13T01:05:00+08:00', NULL),  -- R13 H3 total 390.00 SGD (no-show fee)
        (12, 'INV-2025-0012', 15, '2025-08-09T01:05:00+08:00', NULL),  -- R15 H1 total 252.00 MYR (no-show fee)
        (13, 'INV-2025-0013', 16, '2025-09-05T11:05:00+07:00', NULL),  -- R16 H4 total 22700.00 THB
        (14, 'INV-2025-0014', 17, '2025-10-04T11:05:00+08:00', NULL),  -- R17 H1 total 1476.00 MYR
        (15, 'INV-2025-0015', 19, '2025-11-08T11:05:00+08:00', NULL),  -- R19 H2 total 3438.00 MYR
        (16, 'INV-2025-0016', 20, '2025-12-27T11:05:00+08:00', NULL),  -- R20 H1 total 1920.00 MYR
        (17, 'INV-2026-0017', 21, '2026-01-02T11:05:00+08:00', NULL),  -- R21 H3 total 3846.00 SGD
        (18, 'INV-2026-0018', 25, '2026-03-18T15:06:00+07:00', NULL),  -- R25 H4 total 3900.00 THB (late cancellation fee)
        (19, 'INV-2026-0019', 28, '2026-04-05T11:05:00+08:00', NULL),  -- R28 H1 total 1200.00 MYR
        (20, 'INV-2026-0020', 29, '2026-04-05T10:35:00+09:00', NULL),  -- R29 H5 total 173200.00 JPY
        (21, 'INV-2026-0021', 30, '2026-05-11T01:05:00+07:00', NULL),  -- R30 H4 total 6630.00 THB (no-show fee)
        (22, 'INV-2026-0022', 31, '2026-06-08T11:05:00+08:00', NULL),  -- R31 H3 total 1266.00 SGD
        (23, 'INV-2026-0023', 32, '2026-06-18T11:05:00+08:00', NULL),  -- R32 H1 total 2160.00 MYR
        (24, 'INV-2026-0024', 33, '2026-07-23T11:05:00+08:00', NULL),  -- R33 H2 total 795.00 MYR
        (25, 'INV-2026-0025', 34, '2026-08-10T11:05:00+08:00', NULL),  -- R34 H3 total 1622.00 SGD
        (26, 'INV-2026-0026', 35, '2026-08-19T11:05:00+07:00', NULL),  -- R35 H4 total 41850.00 THB
        (27, 'INV-2026-0027', 36, '2026-09-12T10:05:00+08:00', NULL),  -- R36 H1 total 894.00 MYR
        (28, 'INV-2026-0028', 37, '2026-09-24T10:35:00+09:00', NULL),  -- R37 H5 total 79200.00 JPY
        (29, 'INV-2027-0029', 43, '2027-01-08T10:35:00+09:00', NULL),  -- R43 H5 total 87630.00 JPY
        (30, 'INV-2027-0030', 44, '2027-01-23T11:05:00+08:00', NULL),  -- R44 H1 total 1260.00 MYR
        (31, 'INV-2027-0031', 45, '2027-02-14T11:05:00+08:00', NULL),  -- R45 H3 total 1168.00 SGD
        (32, 'INV-2027-0032', 46, '2027-03-08T11:05:00+07:00', NULL),  -- R46 H4 total 11700.00 THB
        (33, 'INV-2025-0033', 57, '2025-06-16T11:05:00+08:00', NULL),  -- R57 H2 total 536.00 MYR
        (34, 'INV-2025-0034', 58, '2025-07-11T11:05:00+07:00', NULL),  -- R58 H4 total 22140.00 THB
        (35, 'INV-2025-0035', 59, '2025-09-20T11:05:00+08:00', NULL),  -- R59 H1 total 536.00 MYR
        (36, 'INV-2025-0036', 60, '2025-11-23T10:35:00+09:00', NULL),  -- R60 H5 total 174300.00 JPY
        (37, 'INV-2026-0037', 61, '2026-02-15T11:05:00+08:00', NULL),  -- R61 H3 total 1383.00 SGD
        (38, 'INV-2026-0038', 62, '2026-02-08T11:05:00+08:00', NULL),  -- R62 H2 total 1050.00 MYR
        (39, 'INV-2026-0039', 63, '2026-02-23T11:05:00+08:00', NULL),  -- R63 H1 total 2725.00 MYR
        (40, 'INV-2026-0040', 64, '2026-06-24T10:35:00+09:00', NULL),  -- R64 H5 total 94400.00 JPY
        (41, 'INV-2026-0041', 65, '2026-02-11T11:05:00+07:00', NULL),  -- R65 H4 total 6630.00 THB
        (42, 'INV-2026-0042', 66, '2026-10-05T11:05:00+08:00', NULL),  -- R66 H3 total 996.00 SGD
        (43, 'INV-2027-0043', 67, '2027-02-06T11:05:00+08:00', NULL),  -- R67 H2 total 1216.00 MYR
        (44, 'INV-2027-0044', 68, '2027-04-11T11:05:00+07:00', NULL),  -- R68 H4 total 17820.00 THB
        (45, 'INV-2027-0045', 69, '2027-05-13T10:35:00+09:00', NULL)  -- R69 H5 total 247400.00 JPY
    ) AS v (InvoiceID, InvoiceNumber, ReservationID, IssuedAt, Reason)
    JOIN gshg.Reservation AS r ON r.ReservationID = v.ReservationID
    JOIN gshg.Hotel       AS h ON h.HotelID = r.HotelID
    JOIN gshg.Country     AS c ON c.CountryCode = h.CountryCode
    CROSS APPLY (SELECT TOP (1) e.MyrPerUnit FROM gshg.ExchangeRate AS e
                 WHERE e.CurrencyCode = c.CurrencyCode
                   AND e.RateDate <= api.fnHotelLocalDate(r.HotelID, CAST(v.IssuedAt AS DATETIMEOFFSET(0)))
                 ORDER BY e.RateDate DESC) AS er;
    SET IDENTITY_INSERT gshg.Invoice OFF;

    INSERT gshg.InvoiceLine (InvoiceID, LineNumber, InvoiceType, LineType, LineDate, ReservationServiceID, AdditionalChargeID, Description, Amount)
    SELECT i.InvoiceID, CAST(f.LineSeq AS SMALLINT), 'INVOICE', f.LineType, f.LineDate, f.ReservationServiceID, f.AdditionalChargeID, f.Description, f.Amount
    FROM   gshg.Invoice     AS i
    JOIN   gshg.vwFolioLine AS f ON f.ReservationID = i.ReservationID
    WHERE  i.InvoiceType = 'INVOICE' AND i.FinalisedAt IS NULL;
    UPDATE gshg.Invoice SET FinalisedAt = IssuedAt WHERE InvoiceType = 'INVOICE' AND FinalisedAt IS NULL;


    SET IDENTITY_INSERT gshg.Payment ON;
    INSERT gshg.Payment (PaymentID, ReservationID, PaymentMethodID, Amount, PaidAt, ExternalReference) VALUES
    (1, 8, 2, 1500, '2025-02-24T10:05:00+07:00', 'DEP-00001'),  -- R8 deposit, Credit Card
    (2, 24, 2, 20000, '2025-12-22T10:05:00+09:00', 'DEP-00002'),  -- R24 deposit, Credit Card
    (3, 38, 5, 10000, '2026-08-14T10:05:00+09:00', 'DEP-00003'),  -- R38 deposit, E-Wallet
    (4, 39, 2, 300, '2026-09-13T10:05:00+08:00', 'DEP-00004'),  -- R39 deposit, Credit Card
    (5, 40, 5, 500, '2026-09-12T10:05:00+08:00', 'DEP-00005'),  -- R40 deposit, E-Wallet
    (6, 41, 5, 280, '2026-10-01T10:05:00+08:00', 'DEP-00006'),  -- R41 deposit, E-Wallet
    (7, 42, 2, 500, '2026-10-05T10:47:00+08:00', 'DEP-00007'),  -- R42 deposit, Credit Card
    (8, 47, 2, 200, '2026-08-01T10:05:00+08:00', 'DEP-00008'),  -- R47 deposit, Credit Card
    (9, 51, 2, 280, '2026-10-14T10:56:00+08:00', 'DEP-00009'),  -- R51 deposit, Credit Card
    (10, 52, 2, 56100, '2026-10-15T10:57:00+09:00', 'DEP-00010'),  -- R52 deposit, Credit Card
    (11, 56, 4, 1500, '2026-10-19T11:01:00+08:00', 'DEP-00011'),  -- R56 deposit, Bank Transfer
    (12, 70, 2, 280, '2026-10-14T11:15:00+08:00', 'DEP-00012');  -- R70 deposit, Credit Card
    -- Settlements
    INSERT gshg.Payment (PaymentID, ReservationID, PaymentMethodID, Amount, PaidAt, ExternalReference)
    SELECT v.PaymentID, v.ReservationID, v.PaymentMethodID, CAST(ROUND(b.Balance * v.Fraction, 2) AS DECIMAL(12,2)), v.PaidAt, v.Ref
    FROM (VALUES
        (13, 1, 2, 1.00, '2025-01-13T11:15:00+08:00', 'PAY-00013'),  -- R1 Credit Card 100% -> 1110.00
        (14, 2, 5, 1.00, '2025-01-24T11:15:00+08:00', 'PAY-00014'),  -- R2 E-Wallet 100% -> 1801.00
        (15, 3, 1, 1.00, '2025-02-08T11:15:00+07:00', 'PAY-00015'),  -- R3 Cash 100% -> 22800.00
        (16, 4, 6, 1.00, '2025-02-16T11:15:00+08:00', 'PAY-00016'),  -- R4 Cheque 100% -> 1231.20
        (17, 5, 4, 1.00, '2025-03-05T10:45:00+09:00', 'PAY-00017'),  -- R5 Bank Transfer 100% -> 87600.00
        (18, 6, 2, 0.50, '2025-03-18T11:15:00+08:00', 'PAY-00018'),  -- R6 Credit Card 50% -> 755.00 - EDGE 8
        (19, 7, 2, 1.00, '2025-04-03T01:15:00+08:00', 'PAY-00019'),  -- R7 Credit Card 100% -> 260.00
        (20, 9, 2, 1.00, '2025-05-06T11:15:00+08:00', 'PAY-00020'),  -- R9 Credit Card 100% -> 690.00
        (21, 10, 3, 1.00, '2025-05-23T11:15:00+08:00', 'PAY-00021'),  -- R10 Debit Card 100% -> 2400.00
        (22, 11, 5, 1.00, '2025-06-14T10:45:00+09:00', 'PAY-00022'),  -- R11 E-Wallet 100% -> 148800.00
        (23, 13, 2, 1.00, '2025-08-13T01:15:00+08:00', 'PAY-00023'),  -- R13 Credit Card 100% -> 390.00
        (24, 15, 5, 1.00, '2025-08-09T01:15:00+08:00', 'PAY-00024'),  -- R15 E-Wallet 100% -> 252.00
        (25, 16, 3, 1.00, '2025-09-05T11:15:00+07:00', 'PAY-00025'),  -- R16 Debit Card 100% -> 22700.00
        (26, 17, 2, 1.00, '2025-10-04T11:15:00+08:00', 'PAY-00026'),  -- R17 Credit Card 100% -> 1476.00
        (27, 19, 4, 1.00, '2025-11-08T11:15:00+08:00', 'PAY-00027'),  -- R19 Bank Transfer 100% -> 3438.00
        (28, 20, 2, 1.00, '2025-12-27T11:15:00+08:00', 'PAY-00028'),  -- R20 Credit Card 100% -> 1920.00
        (29, 21, 4, 1.00, '2026-01-02T11:15:00+08:00', 'PAY-00029'),  -- R21 Bank Transfer 100% -> 3846.00
        (30, 25, 2, 1.00, '2026-03-18T15:16:00+07:00', 'PAY-00030'),  -- R25 Credit Card 100% -> 3900.00
        (31, 28, 5, 1.00, '2026-04-05T11:15:00+08:00', 'PAY-00031'),  -- R28 E-Wallet 100% -> 1200.00 - EDGE 8
        (32, 29, 2, 1.00, '2026-04-05T10:45:00+09:00', 'PAY-00032'),  -- R29 Credit Card 100% -> 173200.00
        (33, 30, 2, 1.00, '2026-05-11T01:15:00+07:00', 'PAY-00033'),  -- R30 Credit Card 100% -> 6630.00
        (34, 31, 2, 1.00, '2026-06-08T11:15:00+08:00', 'PAY-00034'),  -- R31 Credit Card 100% -> 1266.00
        (35, 32, 2, 1.00, '2026-06-18T11:15:00+08:00', 'PAY-00035'),  -- R32 Credit Card 100% -> 2160.00
        (36, 33, 3, 1.00, '2026-07-23T11:15:00+08:00', 'PAY-00036'),  -- R33 Debit Card 100% -> 795.00
        (37, 34, 2, 1.00, '2026-08-10T11:15:00+08:00', 'PAY-00037'),  -- R34 Credit Card 100% -> 1622.00
        (38, 35, 1, 1.00, '2026-08-19T11:15:00+07:00', 'PAY-00038'),  -- R35 Cash 100% -> 41850.00
        (39, 36, 2, 1.00, '2026-09-12T10:15:00+08:00', 'PAY-00039'),  -- R36 Credit Card 100% -> 894.00
        (40, 37, 2, 1.00, '2026-09-24T10:45:00+09:00', 'PAY-00040'),  -- R37 Credit Card 100% -> 79200.00
        (41, 43, 2, 1.00, '2027-01-08T10:45:00+09:00', 'PAY-00041'),  -- R43 Credit Card 100% -> 87630.00
        (42, 44, 5, 1.00, '2027-01-23T11:15:00+08:00', 'PAY-00042'),  -- R44 E-Wallet 100% -> 1260.00
        (43, 45, 2, 1.00, '2027-02-14T11:15:00+08:00', 'PAY-00043'),  -- R45 Credit Card 100% -> 1168.00
        (44, 46, 1, 1.00, '2027-03-08T11:15:00+07:00', 'PAY-00044'),  -- R46 Cash 100% -> 11700.00
        (45, 57, 1, 1.00, '2025-06-16T11:15:00+08:00', 'PAY-00045'),  -- R57 Cash 100% -> 536.00
        (46, 58, 2, 1.00, '2025-07-11T11:15:00+07:00', 'PAY-00046'),  -- R58 Credit Card 100% -> 22140.00
        (47, 59, 6, 1.00, '2025-09-20T11:15:00+08:00', 'PAY-00047'),  -- R59 Cheque 100% -> 536.00
        (48, 60, 2, 1.00, '2025-11-23T10:45:00+09:00', 'PAY-00048'),  -- R60 Credit Card 100% -> 174300.00
        (49, 61, 5, 1.00, '2026-02-15T11:15:00+08:00', 'PAY-00049'),  -- R61 E-Wallet 100% -> 1383.00
        (50, 62, 3, 1.00, '2026-02-08T11:15:00+08:00', 'PAY-00050'),  -- R62 Debit Card 100% -> 1050.00
        (51, 63, 2, 1.00, '2026-02-23T11:15:00+08:00', 'PAY-00051'),  -- R63 Credit Card 100% -> 2725.00
        (52, 64, 4, 1.00, '2026-06-24T10:45:00+09:00', 'PAY-00052'),  -- R64 Bank Transfer 100% -> 94400.00
        (53, 65, 1, 1.00, '2026-02-11T11:15:00+07:00', 'PAY-00053'),  -- R65 Cash 100% -> 6630.00
        (54, 66, 2, 1.00, '2026-10-05T11:15:00+08:00', 'PAY-00054'),  -- R66 Credit Card 100% -> 996.00
        (55, 67, 5, 1.00, '2027-02-06T11:15:00+08:00', 'PAY-00055'),  -- R67 E-Wallet 100% -> 1216.00
        (56, 68, 2, 1.00, '2027-04-11T11:15:00+07:00', 'PAY-00056'),  -- R68 Credit Card 100% -> 17820.00
        (57, 69, 2, 1.00, '2027-05-13T10:45:00+09:00', 'PAY-00057')  -- R69 Credit Card 100% -> 247400.00
    ) AS v (PaymentID, ReservationID, PaymentMethodID, Fraction, PaidAt, Ref)
    CROSS APPLY (SELECT Balance = SUM(a.Amount) FROM gshg.vwAccountLine AS a WHERE a.ReservationID = v.ReservationID) AS b;
    SET IDENTITY_INSERT gshg.Payment OFF;


    SET IDENTITY_INSERT gshg.ReservationService ON;
    INSERT gshg.ReservationService (ReservationServiceID, ReservationID, HotelID, HotelServiceID, ChargingBasis, ReservationRoomID,
                                    RoomOccupantID, StartDate, Days, Quantity, AgreedUnitPrice, BookedAt)
    SELECT v.ReservationServiceID, r.ReservationID, r.HotelID, hs.HotelServiceID, hs.ChargingBasis, v.ReservationRoomID,
           v.RoomOccupantID, v.StartDate, v.Days, v.Quantity, hs.UnitPrice, v.BookedAt
    FROM (VALUES
        (34, 31, 14, NULL, NULL, '2026-06-08', 1, 1, '2026-06-10T10:00:00+08:00')  -- R31 Airport Transfer PER_RESERVATION -> 1 billable day(s), charge 85.00 - sold after the INVOICE
    ) AS v (ReservationServiceID, ReservationID, HotelServiceID, ReservationRoomID, RoomOccupantID, StartDate, Days, Quantity, BookedAt)
    JOIN gshg.Reservation  AS r  ON r.ReservationID = v.ReservationID
    JOIN gshg.HotelService AS hs ON hs.HotelServiceID = v.HotelServiceID;
    SET IDENTITY_INSERT gshg.ReservationService OFF;

    SET IDENTITY_INSERT gshg.AdditionalCharge ON;
    INSERT gshg.AdditionalCharge (AdditionalChargeID, ReservationRoomID, ChargeType, ChargeDate, Description, Amount, PostedAt) VALUES
    (1, 9, 'MINIBAR', '2025-05-05', N'Minibar found at room inspection', 46.50, '2025-05-08T10:00:00+08:00'),  -- R9 - posted after the INVOICE
    (4, 46, 'DAMAGE', '2027-01-22', N'Damage: broken bedside lamp', 85.00, '2027-01-26T10:00:00+08:00');  -- R44 - posted after the INVOICE
    SET IDENTITY_INSERT gshg.AdditionalCharge OFF;

    -- EDGE 11: debit notes
    SET IDENTITY_INSERT gshg.Invoice ON;
    INSERT gshg.Invoice (InvoiceID, InvoiceNumber, ReservationID, InvoiceType, MyrPerUnit, IssuedAt, Reason)
    SELECT v.InvoiceID, v.InvoiceNumber, v.ReservationID, 'DEBIT_NOTE',
           er.MyrPerUnit,
           v.IssuedAt, v.Reason
    FROM (VALUES
        (46, 'DN-2025-0046', 9, '2025-05-08T10:30:00+08:00', N'Minibar consumption found after check-out'),  -- R9 H2 total 46.50 MYR
        (47, 'DN-2026-0047', 31, '2026-06-10T10:30:00+08:00', N'Airport transfer booked after check-out'),  -- R31 H3 total 85.00 SGD
        (48, 'DN-2027-0048', 44, '2027-01-26T10:30:00+08:00', N'Damage found after check-out')  -- R44 H1 total 85.00 MYR
    ) AS v (InvoiceID, InvoiceNumber, ReservationID, IssuedAt, Reason)
    JOIN gshg.Reservation AS r ON r.ReservationID = v.ReservationID
    JOIN gshg.Hotel       AS h ON h.HotelID = r.HotelID
    JOIN gshg.Country     AS c ON c.CountryCode = h.CountryCode
    CROSS APPLY (SELECT TOP (1) e.MyrPerUnit FROM gshg.ExchangeRate AS e
                 WHERE e.CurrencyCode = c.CurrencyCode
                   AND e.RateDate <= api.fnHotelLocalDate(r.HotelID, CAST(v.IssuedAt AS DATETIMEOFFSET(0)))
                 ORDER BY e.RateDate DESC) AS er;
    SET IDENTITY_INSERT gshg.Invoice OFF;
    INSERT gshg.InvoiceLine (InvoiceID, LineNumber, InvoiceType, LineType, LineDate, ReservationServiceID, AdditionalChargeID, Description, Amount)
    SELECT dn.InvoiceID, CAST(ROW_NUMBER() OVER (PARTITION BY dn.InvoiceID ORDER BY u.SortType, u.LineDate, u.ItemID) AS SMALLINT),
           'DEBIT_NOTE', u.LineType, u.LineDate, u.ReservationServiceID, u.AdditionalChargeID, u.Description, u.Amount
    FROM   gshg.Invoice AS dn
    JOIN  (SELECT sc.ReservationID, SortType = 1, LineType = 'SERVICE', LineDate = sc.StartDate, ItemID = sc.ReservationServiceID,
                  ReservationServiceID = sc.ReservationServiceID, AdditionalChargeID = CAST(NULL AS BIGINT),
                  Description = CAST(CONCAT(sc.ServiceName, N' x', sc.Quantity, N', ', sc.BillableDays, N' day(s)') AS NVARCHAR(255)),
                  Amount = sc.Charge
           FROM   gshg.vwServiceCharge AS sc
           WHERE  NOT EXISTS (SELECT 1 FROM gshg.InvoiceLine AS il WHERE il.ReservationServiceID = sc.ReservationServiceID)
           UNION ALL
           SELECT rr.ReservationID, 2, 'ADDITIONAL', ac.ChargeDate, ac.AdditionalChargeID, NULL, ac.AdditionalChargeID, ac.Description, ac.Amount
           FROM   gshg.AdditionalCharge AS ac
           JOIN   gshg.ReservationRoom  AS rr ON rr.ReservationRoomID = ac.ReservationRoomID
           WHERE  NOT EXISTS (SELECT 1 FROM gshg.InvoiceLine AS il WHERE il.AdditionalChargeID = ac.AdditionalChargeID)) AS u
      ON   u.ReservationID = dn.ReservationID
    WHERE  dn.InvoiceType = 'DEBIT_NOTE' AND dn.FinalisedAt IS NULL;
    UPDATE gshg.Invoice SET FinalisedAt = IssuedAt WHERE InvoiceType = 'DEBIT_NOTE' AND FinalisedAt IS NULL;

    SET IDENTITY_INSERT gshg.Payment ON;
    -- Payment of each DEBIT_NOTE (the remaining balance)
    INSERT gshg.Payment (PaymentID, ReservationID, PaymentMethodID, Amount, PaidAt, ExternalReference)
    SELECT v.PaymentID, v.ReservationID, v.PaymentMethodID, CAST(ROUND(b.Balance * v.Fraction, 2) AS DECIMAL(12,2)), v.PaidAt, v.Ref
    FROM (VALUES
        (58, 9, 5, 1.00, '2025-05-08T12:00:00+08:00', 'LATE-00058'),  -- R9 E-Wallet 100% -> 46.50
        (59, 31, 2, 1.00, '2026-06-10T11:00:00+08:00', 'LATE-00059'),  -- R31 Credit Card 100% -> 85.00
        (60, 44, 3, 1.00, '2027-01-27T09:00:00+08:00', 'LATE-00060')  -- R44 Debit Card 100% -> 85.00
    ) AS v (PaymentID, ReservationID, PaymentMethodID, Fraction, PaidAt, Ref)
    CROSS APPLY (SELECT Balance = SUM(a.Amount) FROM gshg.vwAccountLine AS a WHERE a.ReservationID = v.ReservationID) AS b;
    SET IDENTITY_INSERT gshg.Payment OFF;


    SET IDENTITY_INSERT gshg.Invoice ON;
    INSERT gshg.Invoice (InvoiceID, InvoiceNumber, ReservationID, InvoiceType, MyrPerUnit, IssuedAt, Reason)
    SELECT v.InvoiceID, v.InvoiceNumber, v.ReservationID, 'CREDIT_NOTE',
           NULL,
           v.IssuedAt, v.Reason
    FROM (VALUES
        (49, 'CN-2026-0049', 20, '2026-01-05T10:00:00+08:00', N'Goodwill: noisy room on the first night'),  -- R20 H1 total -50 MYR
        (50, 'CN-2027-0050', 45, '2027-02-20T10:00:00+08:00', N'Breakfast not served: kitchen closed')  -- R45 H3 total -128.00 SGD
    ) AS v (InvoiceID, InvoiceNumber, ReservationID, IssuedAt, Reason)
    ;
    SET IDENTITY_INSERT gshg.Invoice OFF;
    INSERT gshg.InvoiceLine (InvoiceID, LineNumber, InvoiceType, LineType, LineDate, ReversesInvoiceID, ReversesLineNumber, Description, Amount)
    SELECT cn.InvoiceID, 1, 'CREDIT_NOTE', o.LineType, o.LineDate, o.InvoiceID, o.LineNumber,
           CAST(LEFT(CONCAT(N'Credit: ', o.Description), 255) AS NVARCHAR(255)), -COALESCE(v.Amount, o.Amount)
    FROM (VALUES
        (49, 'ROOM', 50),  -- R20: partial reversal of the first ROOM line
        (50, 'SERVICE', NULL)  -- R45: full reversal of the first SERVICE line
    ) AS v (InvoiceID, LineType, Amount)
    JOIN gshg.Invoice AS cn ON cn.InvoiceID = v.InvoiceID
    CROSS APPLY (SELECT TOP (1) il.InvoiceID, il.LineNumber, il.LineType, il.LineDate, il.Description, il.Amount
                 FROM   gshg.InvoiceLine AS il
                 JOIN   gshg.Invoice     AS i ON i.InvoiceID = il.InvoiceID
                 WHERE  i.ReservationID = cn.ReservationID AND i.InvoiceType = 'INVOICE' AND il.LineType = v.LineType
                 ORDER BY il.LineNumber) AS o;
    UPDATE gshg.Invoice SET FinalisedAt = IssuedAt WHERE InvoiceType = 'CREDIT_NOTE' AND FinalisedAt IS NULL;

    -- Refunds: of a deposit (full), of a credit note (its amount), or a partial goodwill refund (a share of the payment)
    SET IDENTITY_INSERT gshg.Refund ON;
    INSERT gshg.Refund (RefundID, PaymentID, PaymentAmount, PaymentPaidAt, Amount, RefundedAt, ExternalReference, Reason)
    SELECT v.RefundID, p.PaymentID, p.Amount, p.PaidAt,
           CASE v.Kind WHEN 'DEPOSIT' THEN p.Amount
                       WHEN 'CREDIT'  THEN -cr.Credited
                       ELSE CAST(ROUND(p.Amount * v.Share, 2) AS DECIMAL(12,2)) END,
           v.RefundedAt, v.Ref, v.Reason
    FROM (VALUES
        (1, 1, 'DEPOSIT', NULL, '2025-03-21T10:00:00+07:00', 'RFD-00001', N'Deposit returned after cancellation'),  -- R8 deposit -> 1500
        (2, 28, 'CREDIT', NULL, '2026-01-06T10:00:00+08:00', 'RFD-00002', N'Refund of goodwill credit'),  -- R20 credit -> 50
        (3, 2, 'DEPOSIT', NULL, '2026-02-05T09:00:00+09:00', 'RFD-00003', N'Deposit returned: hotel cancelled'),  -- R24 deposit -> 20000
        (4, 31, 'PARTIAL', 0.30, '2026-04-10T11:00:00+08:00', 'RFD-00004', N'Partial refund: air-conditioning fault'),  -- R28 partial -> 360.00 - EDGE 8: leaves a balance
        (5, 43, 'CREDIT', NULL, '2027-02-21T10:00:00+08:00', 'RFD-00005', N'Refund of breakfast credit'),  -- R45 credit -> 128.00
        (6, 9, 'DEPOSIT', NULL, '2027-01-11T09:00:00+08:00', 'RFD-00006', N'Deposit returned after cancellation')  -- R51 deposit -> 280
    ) AS v (RefundID, PaymentID, Kind, Share, RefundedAt, Ref, Reason)
    JOIN gshg.Payment AS p ON p.PaymentID = v.PaymentID
    CROSS APPLY (SELECT Credited = SUM(il.Amount)
                 FROM   gshg.InvoiceLine AS il
                 JOIN   gshg.Invoice     AS i ON i.InvoiceID = il.InvoiceID
                 WHERE  i.ReservationID = p.ReservationID AND i.InvoiceType = 'CREDIT_NOTE') AS cr;
    SET IDENTITY_INSERT gshg.Refund OFF;

    COMMIT TRANSACTION;
    SELECT N'Stage 4 loaded: every row passed all 53 trigger checks.' AS LoadResult;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    -- Name the check that rejected a row, then re-raise. Trigger errors are 51000 + 10 x trigger + check.
    SELECT ERROR_NUMBER() AS ErrorNumber,
           CASE WHEN ERROR_NUMBER() BETWEEN 51011 AND 51159
                THEN CONCAT(N'Rejected by trigger T', (ERROR_NUMBER() - 51000) / 10, N' check ', ERROR_NUMBER() % 10)
                ELSE N'Rejected by a constraint or other error' END AS RejectedBy,
           ERROR_MESSAGE() AS ErrorMessage;
    THROW;
END CATCH;
GO


BEGIN TRY
    BEGIN TRANSACTION;
    -- Attempt 1: maintenance job 2 (H5-102) tries to take 2026-09-28, the first night booked by R38
    INSERT gshg.RoomNightAllocation (RoomID, StayDate, HotelID, MaintenanceID)
    VALUES (34, '2026-09-28', 5, 2);
    COMMIT TRANSACTION;
    SELECT N'Attempt 1' AS Attempt, N'UNEXPECTED: accepted' AS Result;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT N'Attempt 1: maintenance onto a booked night' AS Attempt, N'Rejected' AS Result,
           ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
    BEGIN TRANSACTION;
    -- Attempt 2: move R40's night of 2026-10-30 into H1-102, which maintenance job 3 holds that night
    UPDATE gshg.RoomNightAllocation
    SET    RoomID = 2
    WHERE  ReservationRoomID = 42 AND StayDate = '2026-10-30';
    COMMIT TRANSACTION;
    SELECT N'Attempt 2' AS Attempt, N'UNEXPECTED: accepted' AS Result;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT N'Attempt 2: a booking onto a maintenance night' AS Attempt, N'Rejected' AS Result,
           ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

/* Row counts after the load */
SELECT t.name AS TableName, SUM(p.rows) AS RowsLoaded
FROM   sys.tables AS t
JOIN   sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
WHERE  t.schema_id = SCHEMA_ID(N'gshg')
GROUP BY t.name
ORDER BY t.name;
GO
SET NOEXEC OFF;
GO