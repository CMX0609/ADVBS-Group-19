/* =====================================================================================
   STAGE 2 — Shared utilities, the nine derived views, and the four owned functions
   Source : "Database Design ver Final" (v5.0) — Overview (freeze points), 1.3, C4, B5,
            4a (fees), 4b (roster, base places), 4c (service days), 4d (availability), 4f, 4g
   Target : SQL Server 2019 or later; run after Stage 1, in SSMS as database owner
   Placement: functions in schema api (owner dbo); views in schema gshg (with the tables)
   Creation order (each object only uses objects created above it):
     1  api.fnHotelLocalDate        shared
     2  api.fnIsInvoiced            shared
     3  api.fnStayIsClosed          shared
     4  gshg.vwReservationStatus    level 1
     5  gshg.vwRoomLineNight        level 1
     6  gshg.vwMaintenanceWindow    level 1
     7  gshg.vwOccupantNight        level 2  (vwRoomLineNight)
     8  gshg.vwServiceCharge        level 2  (vwRoomLineNight)
     9  gshg.vwUnbilledStay         level 2  (vwReservationStatus)
    10  gshg.vwStrayAllocation      level 2  (vwRoomLineNight)
    11  gshg.vwFolioLine            level 3  (level 1 and 2 views)
    12  gshg.vwAccountLine          level 4  (vwFolioLine, vwServiceCharge)
    13  api.fnAllocationGaps        Member 1 (owned)
    14  api.fnRoomOverfull          Member 1 (owned)
    15  api.fnRosterViolations      Member 2 (owned)
    16  api.fnBeddingOverStock      Member 3 (owned)
   Each owned function takes one key and is an inline table-valued function, so a trigger
   can test every affected row with CROSS APPLY. An empty result means the rule holds.
   ===================================================================================== */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
USE GSHG;
GO

-- Re-runnable: drop in reverse dependency order (same names as Stage 1).
DROP FUNCTION IF EXISTS api.fnBeddingOverStock;
DROP FUNCTION IF EXISTS api.fnRosterViolations;
DROP FUNCTION IF EXISTS api.fnRoomOverfull;
DROP FUNCTION IF EXISTS api.fnAllocationGaps;
DROP VIEW IF EXISTS gshg.vwAccountLine;
DROP VIEW IF EXISTS gshg.vwFolioLine;
DROP VIEW IF EXISTS gshg.vwStrayAllocation;
DROP VIEW IF EXISTS gshg.vwUnbilledStay;
DROP VIEW IF EXISTS gshg.vwServiceCharge;
DROP VIEW IF EXISTS gshg.vwOccupantNight;
DROP VIEW IF EXISTS gshg.vwMaintenanceWindow;
DROP VIEW IF EXISTS gshg.vwRoomLineNight;
DROP VIEW IF EXISTS gshg.vwReservationStatus;
DROP FUNCTION IF EXISTS api.fnStayIsClosed;
DROP FUNCTION IF EXISTS api.fnIsInvoiced;
DROP FUNCTION IF EXISTS api.fnHotelLocalDate;
GO

/* =====================================================================================
   1. SHARED UTILITIES
   ===================================================================================== */

-- fnHotelLocalDate: the hotel-local calendar date of an instant (Hotel.TimeZoneId).
-- Every day, month or quarter filter uses this date. NULL in, NULL out.
-- The parameter is DATETIMEOFFSET(7) so SYSDATETIMEOFFSET() is never rounded across midnight.
CREATE FUNCTION api.fnHotelLocalDate (@HotelID INT, @At DATETIMEOFFSET(7))
RETURNS DATE
AS
BEGIN
    RETURN (SELECT CONVERT(DATE, @At AT TIME ZONE h.TimeZoneId)
            FROM   gshg.Hotel AS h
            WHERE  h.HotelID = @HotelID);
END;
GO

-- fnIsInvoiced: 1 when the reservation has a finalised INVOICE (the second freeze point).
CREATE FUNCTION api.fnIsInvoiced (@ReservationID BIGINT)
RETURNS BIT
AS
BEGIN
    RETURN CAST(CASE WHEN EXISTS (SELECT 1
                                  FROM   gshg.Invoice AS i
                                  WHERE  i.ReservationID = @ReservationID
                                    AND  i.InvoiceType   = 'INVOICE'
                                    AND  i.FinalisedAt IS NOT NULL)
                     THEN 1 ELSE 0 END AS BIT);
END;
GO

-- fnStayIsClosed: 1 when the reservation is cancelled, or it has at least one confirmed
-- room line and every confirmed line has CheckedOutAt or NoShowAt (the first freeze point).
CREATE FUNCTION api.fnStayIsClosed (@ReservationID BIGINT)
RETURNS BIT
AS
BEGIN
    RETURN (SELECT CAST(CASE
                          WHEN r.CancelledAt IS NOT NULL THEN 1
                          WHEN EXISTS (SELECT 1 FROM gshg.ReservationRoom AS rr
                                       WHERE rr.ReservationID = r.ReservationID AND rr.ConfirmedAt IS NOT NULL)
                           AND NOT EXISTS (SELECT 1 FROM gshg.ReservationRoom AS rr
                                           WHERE rr.ReservationID = r.ReservationID
                                             AND rr.ConfirmedAt  IS NOT NULL
                                             AND rr.CheckedOutAt IS NULL
                                             AND rr.NoShowAt     IS NULL)
                          THEN 1 ELSE 0 END AS BIT)
            FROM   gshg.Reservation AS r
            WHERE  r.ReservationID = @ReservationID);
END;
GO

/* =====================================================================================
   2. LEVEL 1 VIEWS
   ===================================================================================== */

-- vwReservationStatus (1.3, level 1). First rule that applies wins:
--   CancelledAt -> Cancelled; confirmed lines all NoShowAt -> No-Show;
--   confirmed lines all CheckedOutAt or NoShowAt -> Checked Out; any line checked in -> Checked In;
--   any confirmed line -> Confirmed; otherwise Pending.
-- IsConfirmedBooking: has a confirmed line, not cancelled, not every confirmed line a no-show.
-- Also exposes the stored-value 48-hour test (4a): CheckInMoment = CheckInDate + AgreedCheckInTime
-- in the hotel's time zone; a GUEST cancellation is late when CancelledAt > CheckInMoment - 48h
-- (exactly 48h before is not late).
CREATE VIEW gshg.vwReservationStatus
AS
SELECT  r.ReservationID,
        r.ReservationNumber,
        r.HotelID,
        r.BookingGuestID,
        r.RatePlanID,
        r.AgreedNoShowChargeBasis,
        r.AgreedCheckInTime,
        r.CheckInDate,
        r.CheckOutDate,
        r.BookedAt,
        r.CancelledAt,
        r.CancellationInitiator,
        mo.CheckInMoment,
        ln.Lines,
        ln.ConfirmedLines,
        ln.CheckedInLines,
        ln.CheckedOutLines,
        ln.NoShowLines,
        ln.ClosedLines,
        st.Status,
        CAST(CASE WHEN r.CancelledAt IS NULL
                   AND ln.ConfirmedLines > 0
                   AND ln.NoShowLines < ln.ConfirmedLines
                  THEN 1 ELSE 0 END AS BIT)                                    AS IsConfirmedBooking,
        CAST(CASE WHEN st.Status IN ('Cancelled','No-Show','Checked Out')
                  THEN 1 ELSE 0 END AS BIT)                                    AS IsStayClosed,
        CASE WHEN r.CancelledAt IS NOT NULL                 THEN r.CancelledAt
             WHEN st.Status IN ('No-Show','Checked Out')    THEN ln.LastCloseEventAt
        END                                                                    AS ClosedAt,
        CAST(CASE WHEN r.CancellationInitiator = 'GUEST'
                   AND r.CancelledAt > DATEADD(HOUR, -48, mo.CheckInMoment)
                  THEN 1 ELSE 0 END AS BIT)                                    AS IsLateGuestCancellation
FROM    gshg.Reservation AS r
JOIN    gshg.Hotel       AS h ON h.HotelID = r.HotelID
CROSS APPLY (SELECT CheckInMoment =
                    DATEADD(SECOND,
                            DATEDIFF(SECOND, CAST('00:00:00' AS TIME(0)), r.AgreedCheckInTime),
                            CAST(r.CheckInDate AS DATETIME2(0))) AT TIME ZONE h.TimeZoneId) AS mo
CROSS APPLY (SELECT Lines            = COUNT(rr.ReservationRoomID),
                    ConfirmedLines   = COUNT(CASE WHEN rr.ConfirmedAt  IS NOT NULL THEN 1 END),
                    CheckedInLines   = COUNT(CASE WHEN rr.CheckedInAt  IS NOT NULL THEN 1 END),
                    CheckedOutLines  = COUNT(CASE WHEN rr.CheckedOutAt IS NOT NULL THEN 1 END),
                    NoShowLines      = COUNT(CASE WHEN rr.ConfirmedAt IS NOT NULL AND rr.NoShowAt IS NOT NULL THEN 1 END),
                    ClosedLines      = COUNT(CASE WHEN rr.ConfirmedAt IS NOT NULL
                                                   AND (rr.CheckedOutAt IS NOT NULL OR rr.NoShowAt IS NOT NULL) THEN 1 END),
                    LastCloseEventAt = MAX(CASE WHEN rr.ConfirmedAt IS NOT NULL
                                                THEN COALESCE(rr.CheckedOutAt, rr.NoShowAt) END)
             FROM   gshg.ReservationRoom AS rr
             WHERE  rr.ReservationID = r.ReservationID) AS ln
CROSS APPLY (SELECT Status = CAST(CASE
                        WHEN r.CancelledAt IS NOT NULL                                      THEN 'Cancelled'
                        WHEN ln.ConfirmedLines > 0 AND ln.NoShowLines = ln.ConfirmedLines   THEN 'No-Show'
                        WHEN ln.ConfirmedLines > 0 AND ln.ClosedLines = ln.ConfirmedLines   THEN 'Checked Out'
                        WHEN ln.CheckedInLines > 0                                          THEN 'Checked In'
                        WHEN ln.ConfirmedLines > 0                                          THEN 'Confirmed'
                        ELSE 'Pending' END AS VARCHAR(11))) AS st;
GO

-- vwRoomLineNight (1.3, level 1; C4). Each night of each line's window with its state.
-- Only stored nights inside [CheckInDate, CheckOutDate) are listed. First rule that applies wins:
--   PENDING (line not confirmed) ; CANCELLED (reservation cancelled) ; NO_SHOW (NoShowAt set) ;
--   RELEASED (checked in and night < hotel-local arrival date, or checked out and night >=
--   hotel-local departure date) ; USED (checked in) ; HELD (otherwise).
-- HELD and USED are live. AllocatedRoomID is the room the ledger holds for the night, if any.
CREATE VIEW gshg.vwRoomLineNight
AS
SELECT  n.ReservationRoomID,
        rr.ReservationID,
        n.HotelID,
        n.RoomCategoryID,
        n.StayDate,
        n.AgreedRoomRate,
        r.CheckInDate,
        r.CheckOutDate,
        ev.ArrivalDate,
        ev.DepartureDate,
        s.NightState,
        CAST(CASE WHEN s.NightState IN ('HELD','USED') THEN 1 ELSE 0 END AS BIT) AS IsLive,
        a.RoomID AS AllocatedRoomID
FROM    gshg.ReservationRoomNight AS n
JOIN    gshg.ReservationRoom      AS rr ON rr.ReservationRoomID = n.ReservationRoomID
JOIN    gshg.Reservation          AS r  ON r.ReservationID      = rr.ReservationID
CROSS APPLY (SELECT ArrivalDate   = CASE WHEN rr.CheckedInAt  IS NOT NULL THEN api.fnHotelLocalDate(rr.HotelID, rr.CheckedInAt)  END,
                    DepartureDate = CASE WHEN rr.CheckedOutAt IS NOT NULL THEN api.fnHotelLocalDate(rr.HotelID, rr.CheckedOutAt) END) AS ev
CROSS APPLY (SELECT NightState = CAST(CASE
                        WHEN rr.ConfirmedAt IS NULL                                       THEN 'PENDING'
                        WHEN r.CancelledAt  IS NOT NULL                                   THEN 'CANCELLED'
                        WHEN rr.NoShowAt    IS NOT NULL                                   THEN 'NO_SHOW'
                        WHEN (rr.CheckedInAt  IS NOT NULL AND n.StayDate <  ev.ArrivalDate)
                          OR (rr.CheckedOutAt IS NOT NULL AND n.StayDate >= ev.DepartureDate) THEN 'RELEASED'
                        WHEN rr.CheckedInAt IS NOT NULL                                   THEN 'USED'
                        ELSE 'HELD' END AS VARCHAR(9))) AS s
LEFT JOIN gshg.RoomNightAllocation AS a
       ON a.ReservationRoomID = n.ReservationRoomID
      AND a.StayDate          = n.StayDate
WHERE   n.StayDate >= r.CheckInDate
  AND   n.StayDate <  r.CheckOutDate;
GO

-- vwMaintenanceWindow (1.3, level 1; B5). Per job, with today = the hotel-local date now:
--   Start        = earliest night.
--   FreeAgainOn  = for a job not yet finished (today < latest night + 1): the first date on or
--                  after the later of today and Start with no night of this job; otherwise
--                  latest night + 1. A paused job never shows the room busy on a free day.
--   Status, first rule that applies: Cancelled; Awaiting schedule (no nights); Scheduled
--                  (Start after today); In progress (today before latest night + 1); Completed.
CREATE VIEW gshg.vwMaintenanceWindow
AS
SELECT  m.MaintenanceID,
        m.RoomID,
        rm.HotelID,
        rm.RoomNumber,
        m.MaintenanceReason,
        m.OriginalPlannedEndDate,
        m.ReportedAt,
        m.CancelledAt,
        w.StartDate,
        w.LatestNight,
        w.NightCount,
        t.LocalToday,
        CASE WHEN w.StartDate IS NULL                                  THEN NULL
             WHEN t.LocalToday < DATEADD(DAY, 1, w.LatestNight)        THEN g.FirstFreeDate
             ELSE DATEADD(DAY, 1, w.LatestNight)
        END AS FreeAgainOn,
        CAST(CASE WHEN m.CancelledAt IS NOT NULL                       THEN 'Cancelled'
                  WHEN w.StartDate IS NULL                             THEN 'Awaiting schedule'
                  WHEN w.StartDate > t.LocalToday                      THEN 'Scheduled'
                  WHEN t.LocalToday < DATEADD(DAY, 1, w.LatestNight)   THEN 'In progress'
                  ELSE 'Completed' END AS VARCHAR(17)) AS Status
FROM    gshg.RoomMaintenance AS m
JOIN    gshg.Room            AS rm ON rm.RoomID = m.RoomID
CROSS APPLY (SELECT LocalToday = api.fnHotelLocalDate(rm.HotelID, SYSDATETIMEOFFSET())) AS t
CROSS APPLY (SELECT StartDate   = MIN(a.StayDate),
                    LatestNight = MAX(a.StayDate),
                    NightCount  = COUNT(a.StayDate)
             FROM   gshg.RoomNightAllocation AS a
             WHERE  a.MaintenanceID = m.MaintenanceID) AS w
CROSS APPLY (SELECT Anchor = CASE WHEN t.LocalToday > w.StartDate THEN t.LocalToday ELSE w.StartDate END) AS k
OUTER APPLY (SELECT FirstFreeDate = MIN(c.Candidate)
             FROM  (SELECT Candidate = k.Anchor
                    UNION ALL
                    SELECT DATEADD(DAY, 1, a2.StayDate)
                    FROM   gshg.RoomNightAllocation AS a2
                    WHERE  a2.MaintenanceID = m.MaintenanceID
                      AND  a2.StayDate >= k.Anchor) AS c
             WHERE NOT EXISTS (SELECT 1
                               FROM   gshg.RoomNightAllocation AS a3
                               WHERE  a3.MaintenanceID = m.MaintenanceID
                                 AND  a3.StayDate      = c.Candidate)) AS g;
GO

/* =====================================================================================
   3. LEVEL 2 VIEWS
   ===================================================================================== */

-- vwOccupantNight (1.3, level 2; 4b). Each occupant on each live night of their line, with
-- age at CheckInDate, AgeBand, RateClass and HeadcountCategory. BaseRank orders the line's
-- occupants FULL before REDUCED (NONE last), then oldest, then lowest GuestID.
-- The line's AgreedBaseOccupancy places go to the first ranks; infants (NONE) never take one.
-- SupplementRate is what that person pays for the night beyond the base places.
CREATE VIEW gshg.vwOccupantNight
AS
SELECT  x.ReservationRoomID,
        x.ReservationID,
        x.HotelID,
        x.RoomCategoryID,
        x.StayDate,
        x.NightState,
        x.AllocatedRoomID,
        x.CheckInDate,
        x.RoomOccupantID,
        x.GuestID,
        x.FirstName,
        x.LastName,
        x.DateOfBirth,
        x.AgeYears,
        x.BandMinAgeYears,
        x.BandName,
        x.RateClass,
        x.HeadcountCategoryCode,
        x.IsResponsibleAdult,
        x.IdDocumentType,
        x.IdDocumentNumber,
        x.IdIssuingCountryCode,
        x.AgreedBaseOccupancy,
        x.BaseRank,
        CAST(CASE WHEN x.RateClass IN ('FULL','REDUCED') AND x.BaseRank <= x.AgreedBaseOccupancy
                  THEN 1 ELSE 0 END AS BIT)                                       AS IsBasePlace,
        CAST(CASE WHEN x.BaseRank <= x.AgreedBaseOccupancy THEN 0
                  WHEN x.RateClass = 'FULL'                THEN x.AgreedExtraPersonRate
                  WHEN x.RateClass = 'REDUCED'             THEN x.AgreedReducedChildRate
                  ELSE 0 END AS DECIMAL(10,2))                                    AS SupplementRate
FROM   (SELECT  ln.ReservationRoomID,
                ln.ReservationID,
                ln.HotelID,
                ln.RoomCategoryID,
                ln.StayDate,
                ln.NightState,
                ln.AllocatedRoomID,
                ln.CheckInDate,
                o.RoomOccupantID,
                o.GuestID,
                g.FirstName,
                g.LastName,
                g.DateOfBirth,
                ag.AgeYears,
                b.MinAgeYears              AS BandMinAgeYears,
                b.BandName,
                b.RateClass,
                b.HeadcountCategoryCode,
                hc.IsResponsibleAdult,
                o.IdDocumentType,
                o.IdDocumentNumber,
                o.IdIssuingCountryCode,
                rr.AgreedBaseOccupancy,
                rr.AgreedExtraPersonRate,
                rr.AgreedReducedChildRate,
                ROW_NUMBER() OVER (PARTITION BY ln.ReservationRoomID, ln.StayDate
                                   ORDER BY CASE b.RateClass WHEN 'FULL' THEN 1 WHEN 'REDUCED' THEN 2 ELSE 3 END,
                                            g.DateOfBirth,
                                            o.GuestID) AS BaseRank
         FROM   gshg.vwRoomLineNight AS ln
         JOIN   gshg.ReservationRoom AS rr ON rr.ReservationRoomID = ln.ReservationRoomID
         JOIN   gshg.RoomOccupant    AS o  ON o.ReservationRoomID  = ln.ReservationRoomID
         JOIN   gshg.Guest           AS g  ON g.GuestID            = o.GuestID
         CROSS APPLY (SELECT AgeYears = DATEDIFF(YEAR, g.DateOfBirth, ln.CheckInDate)
                                      - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, g.DateOfBirth, ln.CheckInDate), g.DateOfBirth)
                                                  > ln.CheckInDate THEN 1 ELSE 0 END) AS ag
         OUTER APPLY (SELECT TOP (1) ab.MinAgeYears, ab.BandName, ab.RateClass, ab.HeadcountCategoryCode
                      FROM   gshg.AgeBand AS ab
                      WHERE  ab.MinAgeYears <= ag.AgeYears
                      ORDER BY ab.MinAgeYears DESC) AS b
         LEFT JOIN gshg.HeadcountCategory AS hc ON hc.HeadcountCategoryCode = b.HeadcountCategoryCode
         WHERE  ln.IsLive = 1) AS x;
GO

-- vwServiceCharge (1.3, level 2; 4c). Per service row: billable days and charge.
-- Requested days are StartDate .. StartDate + Days - 1. Day d is billable when the scope is live
-- on night d - 1 or night d: PER_PERSON and PER_ROOM -> the row's room line (an occupant is
-- present on every live night of their line); PER_RESERVATION -> any line of the reservation.
-- Charge = Quantity x billable days x AgreedUnitPrice.
CREATE VIEW gshg.vwServiceCharge
AS
WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
     Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d + 1000 * e.d
                   FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c CROSS JOIN Digit AS e)
SELECT  rs.ReservationServiceID,
        rs.ReservationID,
        rs.HotelID,
        rs.HotelServiceID,
        hs.ServiceTypeID,
        hs.ServiceClass,
        hs.ServiceName,
        rs.ChargingBasis,
        rs.ReservationRoomID,
        rs.RoomOccupantID,
        rs.StartDate,
        rs.Days,
        rs.Quantity,
        rs.AgreedUnitPrice,
        rs.BookedAt,
        bd.BillableDays,
        bd.FirstBillableDay,
        bd.LastBillableDay,
        CAST(rs.Quantity * bd.BillableDays * rs.AgreedUnitPrice AS DECIMAL(12,2)) AS Charge
FROM    gshg.ReservationService AS rs
JOIN    gshg.HotelService       AS hs ON hs.HotelServiceID = rs.HotelServiceID
CROSS APPLY (SELECT BillableDays     = COUNT(d.ServiceDay),
                    FirstBillableDay = MIN(d.ServiceDay),
                    LastBillableDay  = MAX(d.ServiceDay)
             FROM  (SELECT ServiceDay = DATEADD(DAY, t.n, rs.StartDate)
                    FROM   Tally AS t
                    WHERE  t.n < rs.Days) AS d
             WHERE EXISTS (SELECT 1
                           FROM   gshg.vwRoomLineNight AS ln
                           WHERE  ln.IsLive = 1
                             AND  ln.StayDate IN (DATEADD(DAY, -1, d.ServiceDay), d.ServiceDay)
                             AND ((rs.ChargingBasis IN ('PER_PERSON','PER_ROOM') AND ln.ReservationRoomID = rs.ReservationRoomID)
                               OR (rs.ChargingBasis = 'PER_RESERVATION'          AND ln.ReservationID     = rs.ReservationID)))) AS bd;
GO

-- vwUnbilledStay (1.3, level 2). Closed stays with no finalised INVOICE, oldest first
-- (order by OldestFirst). A closed stay is listed only when its draft bill can hold a line:
-- Checked Out; No-Show with a no-show charge basis other than NONE; or a late GUEST
-- cancellation of a reservation that had a confirmed line (it carries a CANCELLATION_FEE).
CREATE VIEW gshg.vwUnbilledStay
AS
SELECT  s.ReservationID,
        s.ReservationNumber,
        s.HotelID,
        s.Status,
        s.CheckInDate,
        s.CheckOutDate,
        s.ClosedAt,
        api.fnHotelLocalDate(s.HotelID, s.ClosedAt)                    AS ClosedOn,
        ROW_NUMBER() OVER (ORDER BY s.ClosedAt, s.ReservationID)       AS OldestFirst
FROM    gshg.vwReservationStatus AS s
WHERE   s.IsStayClosed = 1
  AND   api.fnIsInvoiced(s.ReservationID) = 0
  AND  (s.Status = 'Checked Out'
     OR (s.Status = 'No-Show'   AND s.AgreedNoShowChargeBasis <> 'NONE')
     OR (s.Status = 'Cancelled' AND s.IsLateGuestCancellation = 1 AND s.ConfirmedLines > 0));
GO

-- vwStrayAllocation (1.3, level 2; 4e). Booking allocations on a night that is RELEASED,
-- CANCELLED or NO_SHOW, or outside the reservation's window, dated from the hotel-local today
-- on (T2 keeps earlier rows as history), for P4 to remove. Pending lines are not stray.
CREATE VIEW gshg.vwStrayAllocation
AS
SELECT  a.RoomID,
        a.StayDate,
        a.HotelID,
        a.ReservationRoomID,
        rr.ReservationID,
        CAST(CASE WHEN ln.ReservationRoomID IS NULL THEN 'OUTSIDE_WINDOW' ELSE ln.NightState END AS VARCHAR(14)) AS StrayReason
FROM    gshg.RoomNightAllocation AS a
JOIN    gshg.ReservationRoom     AS rr ON rr.ReservationRoomID = a.ReservationRoomID
LEFT JOIN gshg.vwRoomLineNight   AS ln ON ln.ReservationRoomID = a.ReservationRoomID
                                      AND ln.StayDate          = a.StayDate
WHERE   a.ReservationRoomID IS NOT NULL
  AND  (ln.ReservationRoomID IS NULL OR ln.NightState IN ('RELEASED','CANCELLED','NO_SHOW'))
  AND   a.StayDate >= api.fnHotelLocalDate(a.HotelID, SYSDATETIMEOFFSET());
GO

/* =====================================================================================
   4. LEVEL 3 VIEW — the draft bill
   ===================================================================================== */

-- vwFolioLine (1.3, level 3; 4a, 4b, 4c). The draft bill by line, in the hotel's currency:
--   ROOM              one per live (charged) night, at its AgreedRoomRate
--   SUPPLEMENT        one per line-night with extra persons beyond the base places
--   SERVICE           one per service row, at Quantity x billable days x AgreedUnitPrice
--   ADDITIONAL        one per additional charge
--   CANCELLATION_FEE  late GUEST cancellation: per confirmed line, its first-night AgreedRoomRate
--   NO_SHOW_FEE       per no-show line: FIRST_NIGHT -> first night; FULL_STAY -> every window night
--   DISCOUNT          one per discount, negative
-- LineSeq numbers the lines per reservation in a stable order (used by P5 for LineNumber).
CREATE VIEW gshg.vwFolioLine
AS
WITH Parts AS
(
    -- ROOM
    SELECT  ln.ReservationID,
            ln.HotelID,
            CAST('ROOM' AS VARCHAR(16))                                         AS LineType,
            1                                                                   AS TypeOrder,
            ln.StayDate                                                         AS LineDate,
            ln.ReservationRoomID                                                AS ReservationRoomID,
            CAST(NULL AS BIGINT)                                                AS ReservationServiceID,
            CAST(NULL AS BIGINT)                                                AS AdditionalChargeID,
            CAST(NULL AS BIGINT)                                                AS DiscountID,
            CAST(CONCAT(N'Room night, ', rc.CategoryName) AS NVARCHAR(255))     AS Description,
            CAST(ln.AgreedRoomRate AS DECIMAL(12,2))                            AS Amount
    FROM    gshg.vwRoomLineNight AS ln
    JOIN    gshg.RoomCategory    AS rc ON rc.RoomCategoryID = ln.RoomCategoryID
    WHERE   ln.IsLive = 1

    UNION ALL
    -- SUPPLEMENT
    SELECT  o.ReservationID,
            o.HotelID,
            'SUPPLEMENT',
            2,
            o.StayDate,
            o.ReservationRoomID,
            NULL, NULL, NULL,
            CAST(CONCAT(N'Extra person supplement, ',
                        COUNT(CASE WHEN o.SupplementRate > 0 THEN 1 END), N' person(s)') AS NVARCHAR(255)),
            CAST(SUM(o.SupplementRate) AS DECIMAL(12,2))
    FROM    gshg.vwOccupantNight AS o
    GROUP BY o.ReservationID, o.HotelID, o.StayDate, o.ReservationRoomID
    HAVING  SUM(o.SupplementRate) > 0

    UNION ALL
    -- SERVICE
    SELECT  sc.ReservationID,
            sc.HotelID,
            'SERVICE',
            3,
            sc.StartDate,
            sc.ReservationRoomID,
            sc.ReservationServiceID,
            NULL, NULL,
            CAST(CONCAT(sc.ServiceName, N' x', sc.Quantity, N', ', sc.BillableDays, N' day(s)') AS NVARCHAR(255)),
            sc.Charge
    FROM    gshg.vwServiceCharge AS sc

    UNION ALL
    -- ADDITIONAL
    SELECT  rr.ReservationID,
            rr.HotelID,
            'ADDITIONAL',
            4,
            ac.ChargeDate,
            ac.ReservationRoomID,
            NULL,
            ac.AdditionalChargeID,
            NULL,
            ac.Description,
            ac.Amount
    FROM    gshg.AdditionalCharge AS ac
    JOIN    gshg.ReservationRoom  AS rr ON rr.ReservationRoomID = ac.ReservationRoomID

    UNION ALL
    -- CANCELLATION_FEE
    SELECT  s.ReservationID,
            s.HotelID,
            'CANCELLATION_FEE',
            5,
            s.CheckInDate,
            rr.ReservationRoomID,
            NULL, NULL, NULL,
            CAST(N'Late cancellation fee (first night)' AS NVARCHAR(255)),
            CAST(n.AgreedRoomRate AS DECIMAL(12,2))
    FROM    gshg.vwReservationStatus  AS s
    JOIN    gshg.ReservationRoom      AS rr ON rr.ReservationID     = s.ReservationID
                                           AND rr.ConfirmedAt IS NOT NULL
    JOIN    gshg.ReservationRoomNight AS n  ON n.ReservationRoomID  = rr.ReservationRoomID
                                           AND n.StayDate           = s.CheckInDate
    WHERE   s.IsLateGuestCancellation = 1

    UNION ALL
    -- NO_SHOW_FEE
    SELECT  r.ReservationID,
            r.HotelID,
            'NO_SHOW_FEE',
            6,
            r.CheckInDate,
            rr.ReservationRoomID,
            NULL, NULL, NULL,
            CAST(CASE r.AgreedNoShowChargeBasis WHEN 'FIRST_NIGHT' THEN N'No-show fee (first night)'
                                                ELSE N'No-show fee (full stay)' END AS NVARCHAR(255)),
            CAST(fee.Amount AS DECIMAL(12,2))
    FROM    gshg.ReservationRoom AS rr
    JOIN    gshg.Reservation     AS r ON r.ReservationID = rr.ReservationID
    CROSS APPLY (SELECT Amount = SUM(n.AgreedRoomRate)
                 FROM   gshg.ReservationRoomNight AS n
                 WHERE  n.ReservationRoomID = rr.ReservationRoomID
                   AND  n.StayDate >= r.CheckInDate
                   AND  n.StayDate <  CASE WHEN r.AgreedNoShowChargeBasis = 'FIRST_NIGHT'
                                           THEN DATEADD(DAY, 1, r.CheckInDate)
                                           ELSE r.CheckOutDate END) AS fee
    WHERE   rr.NoShowAt IS NOT NULL
      AND   r.CancelledAt IS NULL
      AND   r.AgreedNoShowChargeBasis IN ('FIRST_NIGHT','FULL_STAY')
      AND   fee.Amount IS NOT NULL

    UNION ALL
    -- DISCOUNT
    SELECT  d.ReservationID,
            d.HotelID,
            'DISCOUNT',
            7,
            api.fnHotelLocalDate(d.HotelID, d.PostedAt),
            NULL, NULL, NULL,
            d.DiscountID,
            CAST(COALESCE(CASE WHEN p.PromoCode IS NOT NULL
                               THEN CONCAT(N'Promotion ', p.PromoCode, CASE WHEN d.Reason IS NOT NULL THEN N': ' + d.Reason END) END,
                          d.Reason) AS NVARCHAR(255)),
            CAST(-d.Amount AS DECIMAL(12,2))
    FROM    gshg.ReservationDiscount AS d
    LEFT JOIN gshg.Promotion         AS p ON p.PromotionID = d.PromotionID
)
SELECT  p.ReservationID,
        p.HotelID,
        p.LineType,
        p.TypeOrder,
        p.LineDate,
        p.ReservationRoomID,
        p.ReservationServiceID,
        p.AdditionalChargeID,
        p.DiscountID,
        p.Description,
        CAST(p.Amount AS DECIMAL(12,2)) AS Amount,
        ROW_NUMBER() OVER (PARTITION BY p.ReservationID
                           ORDER BY p.TypeOrder, p.LineDate, p.ReservationRoomID,
                                    p.ReservationServiceID, p.AdditionalChargeID, p.DiscountID) AS LineSeq
FROM    Parts AS p;
GO

/* =====================================================================================
   5. LEVEL 4 VIEW — every signed amount of a reservation
   ===================================================================================== */

-- vwAccountLine (1.3, level 4; 4g). Before the INVOICE is finalised: the folio lines.
-- After: the lines of every finalised document (INVOICE, DEBIT_NOTE, CREDIT_NOTE), plus
-- services and charges not yet billed on a finalised document. Payments count negative and
-- refunds positive. Balance = SUM(Amount), in the hotel's currency.
-- MyrPerUnit: a charging document's stored rate; a credit line takes the rate of the document
-- holding the line it reverses (4g). NULL elsewhere: convert at the line date's rate.
CREATE VIEW gshg.vwAccountLine
AS
WITH Invoiced AS
(
    SELECT DISTINCT i.ReservationID
    FROM   gshg.Invoice AS i
    WHERE  i.InvoiceType = 'INVOICE' AND i.FinalisedAt IS NOT NULL
),
BilledService AS
(
    SELECT DISTINCT il.ReservationServiceID
    FROM   gshg.InvoiceLine AS il
    JOIN   gshg.Invoice     AS i ON i.InvoiceID = il.InvoiceID
    WHERE  il.ReservationServiceID IS NOT NULL AND i.FinalisedAt IS NOT NULL
),
BilledCharge AS
(
    SELECT DISTINCT il.AdditionalChargeID
    FROM   gshg.InvoiceLine AS il
    JOIN   gshg.Invoice     AS i ON i.InvoiceID = il.InvoiceID
    WHERE  il.AdditionalChargeID IS NOT NULL AND i.FinalisedAt IS NOT NULL
)
-- Before the INVOICE: the draft bill
SELECT  f.ReservationID,
        f.HotelID,
        CAST('FOLIO' AS VARCHAR(12))      AS Source,
        f.LineType,
        f.LineDate,
        CAST(NULL AS BIGINT)              AS InvoiceID,
        CAST(NULL AS VARCHAR(20))         AS InvoiceNumber,
        CAST(NULL AS SMALLINT)            AS LineNumber,
        CAST(NULL AS VARCHAR(11))         AS DocumentType,
        CAST(NULL AS DECIMAL(18,8))       AS MyrPerUnit,
        f.ReservationServiceID,
        f.AdditionalChargeID,
        CAST(NULL AS BIGINT)              AS PaymentID,
        CAST(NULL AS TINYINT)             AS PaymentMethodID,
        f.Description,
        f.Amount
FROM    gshg.vwFolioLine AS f
WHERE   NOT EXISTS (SELECT 1 FROM Invoiced AS v WHERE v.ReservationID = f.ReservationID)

UNION ALL
-- After the INVOICE: finalised document lines
SELECT  i.ReservationID,
        r.HotelID,
        'DOCUMENT',
        il.LineType,
        il.LineDate,
        il.InvoiceID,
        i.InvoiceNumber,
        il.LineNumber,
        i.InvoiceType,
        COALESCE(i.MyrPerUnit, ri.MyrPerUnit),
        il.ReservationServiceID,
        il.AdditionalChargeID,
        NULL,
        NULL,
        il.Description,
        il.Amount
FROM    gshg.InvoiceLine AS il
JOIN    gshg.Invoice     AS i  ON i.InvoiceID     = il.InvoiceID
JOIN    gshg.Reservation AS r  ON r.ReservationID = i.ReservationID
LEFT JOIN gshg.Invoice   AS ri ON ri.InvoiceID    = il.ReversesInvoiceID
WHERE   i.FinalisedAt IS NOT NULL
  AND   EXISTS (SELECT 1 FROM Invoiced AS v WHERE v.ReservationID = i.ReservationID)

UNION ALL
-- After the INVOICE: services sold later and not yet on a finalised DEBIT_NOTE
SELECT  sc.ReservationID,
        sc.HotelID,
        'LATE_SERVICE',
        'SERVICE',
        sc.StartDate,
        NULL, NULL, NULL, NULL, NULL,
        sc.ReservationServiceID,
        NULL,
        NULL,
        NULL,
        CAST(CONCAT(sc.ServiceName, N' x', sc.Quantity, N', ', sc.BillableDays, N' day(s) (not yet billed)') AS NVARCHAR(255)),
        sc.Charge
FROM    gshg.vwServiceCharge AS sc
WHERE   EXISTS     (SELECT 1 FROM Invoiced      AS v WHERE v.ReservationID        = sc.ReservationID)
  AND   NOT EXISTS (SELECT 1 FROM BilledService AS b WHERE b.ReservationServiceID = sc.ReservationServiceID)

UNION ALL
-- After the INVOICE: charges posted later and not yet on a finalised DEBIT_NOTE
SELECT  rr.ReservationID,
        rr.HotelID,
        'LATE_CHARGE',
        'ADDITIONAL',
        ac.ChargeDate,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        ac.AdditionalChargeID,
        NULL,
        NULL,
        CAST(CONCAT(ac.Description, N' (not yet billed)') AS NVARCHAR(255)),
        ac.Amount
FROM    gshg.AdditionalCharge AS ac
JOIN    gshg.ReservationRoom  AS rr ON rr.ReservationRoomID = ac.ReservationRoomID
WHERE   EXISTS     (SELECT 1 FROM Invoiced     AS v WHERE v.ReservationID      = rr.ReservationID)
  AND   NOT EXISTS (SELECT 1 FROM BilledCharge AS b WHERE b.AdditionalChargeID = ac.AdditionalChargeID)

UNION ALL
-- Payments (negative)
SELECT  p.ReservationID,
        r.HotelID,
        'PAYMENT',
        'PAYMENT',
        api.fnHotelLocalDate(r.HotelID, p.PaidAt),
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        NULL,
        p.PaymentID,
        p.PaymentMethodID,
        CAST(CONCAT(N'Payment, ', pm.MethodName) AS NVARCHAR(255)),
        CAST(-p.Amount AS DECIMAL(12,2))
FROM    gshg.Payment       AS p
JOIN    gshg.Reservation   AS r  ON r.ReservationID    = p.ReservationID
JOIN    gshg.PaymentMethod AS pm ON pm.PaymentMethodID = p.PaymentMethodID

UNION ALL
-- Refunds (positive)
SELECT  p.ReservationID,
        r.HotelID,
        'REFUND',
        'REFUND',
        api.fnHotelLocalDate(r.HotelID, rf.RefundedAt),
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        NULL,
        p.PaymentID,
        p.PaymentMethodID,
        CAST(CONCAT(N'Refund, ', pm.MethodName, N': ', rf.Reason) AS NVARCHAR(255)),
        rf.Amount
FROM    gshg.Refund        AS rf
JOIN    gshg.Payment       AS p  ON p.PaymentID        = rf.PaymentID
JOIN    gshg.Reservation   AS r  ON r.ReservationID    = p.ReservationID
JOIN    gshg.PaymentMethod AS pm ON pm.PaymentMethodID = p.PaymentMethodID;
GO

/* =====================================================================================
   6. OWNED FUNCTIONS (inline table-valued; an empty result means the rule holds)
   ===================================================================================== */

-- fnAllocationGaps (Member 1; 4d). For one room line: every live night of its window that has
-- no night row, no allocated room, or a room that is neither the booked category nor a listed
-- upgrade from it. Live nights are computed from the window itself (not only from stored night
-- rows), so a missing night row is reported too. Only a confirmed line of an uncancelled
-- reservation with no NoShowAt has live nights; RELEASED nights are skipped.
CREATE FUNCTION api.fnAllocationGaps (@ReservationRoomID BIGINT)
RETURNS TABLE
AS
RETURN
WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
     Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d + 1000 * e.d
                   FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c CROSS JOIN Digit AS e),
     Line AS
     (
         SELECT rr.ReservationRoomID,
                rr.RoomCategoryID,
                rr.CheckedInAt,
                rr.CheckedOutAt,
                r.CheckInDate,
                r.CheckOutDate,
                ArrivalDate   = CASE WHEN rr.CheckedInAt  IS NOT NULL THEN api.fnHotelLocalDate(rr.HotelID, rr.CheckedInAt)  END,
                DepartureDate = CASE WHEN rr.CheckedOutAt IS NOT NULL THEN api.fnHotelLocalDate(rr.HotelID, rr.CheckedOutAt) END
         FROM   gshg.ReservationRoom AS rr
         JOIN   gshg.Reservation     AS r ON r.ReservationID = rr.ReservationID
         WHERE  rr.ReservationRoomID = @ReservationRoomID
           AND  rr.ConfirmedAt IS NOT NULL
           AND  rr.NoShowAt    IS NULL
           AND  r.CancelledAt  IS NULL
     ),
     LiveNight AS
     (
         SELECT l.ReservationRoomID,
                l.RoomCategoryID,
                StayDate = DATEADD(DAY, t.n, l.CheckInDate)
         FROM   Line  AS l
         JOIN   Tally AS t ON t.n < DATEDIFF(DAY, l.CheckInDate, l.CheckOutDate)
         WHERE  NOT ((l.CheckedInAt  IS NOT NULL AND DATEADD(DAY, t.n, l.CheckInDate) <  l.ArrivalDate)
                  OR (l.CheckedOutAt IS NOT NULL AND DATEADD(DAY, t.n, l.CheckInDate) >= l.DepartureDate))
     )
SELECT  lv.ReservationRoomID,
        lv.StayDate,
        a.RoomID AS AllocatedRoomID,
        CAST(CASE WHEN n.StayDate IS NULL THEN 'NO_NIGHT_ROW'
                  WHEN a.RoomID   IS NULL THEN 'NO_ROOM'
                  ELSE 'UNSUITABLE_CATEGORY' END AS VARCHAR(19)) AS Problem
FROM    LiveNight AS lv
LEFT JOIN gshg.ReservationRoomNight AS n  ON n.ReservationRoomID = lv.ReservationRoomID
                                        AND n.StayDate          = lv.StayDate
LEFT JOIN gshg.RoomNightAllocation  AS a  ON a.ReservationRoomID = lv.ReservationRoomID
                                        AND a.StayDate          = lv.StayDate
LEFT JOIN gshg.Room                 AS rm ON rm.RoomID          = a.RoomID
WHERE   n.StayDate IS NULL
   OR   a.RoomID   IS NULL
   OR  (rm.RoomCategoryID <> lv.RoomCategoryID
        AND NOT EXISTS (SELECT 1
                        FROM   gshg.RoomCategoryUpgrade AS u
                        WHERE  u.FromRoomCategoryID = lv.RoomCategoryID
                          AND  u.ToRoomCategoryID   = rm.RoomCategoryID));
GO

-- fnRoomOverfull (Member 1; 4b). For one room line: each room it holds from the hotel-local
-- today on, on a night that is PENDING, HELD or USED, whose MaxOccupancy is below the line's
-- occupant count (every person counts, infants included).
CREATE FUNCTION api.fnRoomOverfull (@ReservationRoomID BIGINT)
RETURNS TABLE
AS
RETURN
SELECT  a.ReservationRoomID,
        a.RoomID,
        a.StayDate,
        oc.Occupants,
        rm.MaxOccupancy
FROM    gshg.RoomNightAllocation AS a
JOIN    gshg.Room                AS rm ON rm.RoomID = a.RoomID
JOIN    gshg.vwRoomLineNight     AS ln ON ln.ReservationRoomID = a.ReservationRoomID
                                      AND ln.StayDate          = a.StayDate
CROSS APPLY (SELECT Occupants = COUNT(*)
             FROM   gshg.RoomOccupant AS o
             WHERE  o.ReservationRoomID = a.ReservationRoomID) AS oc
WHERE   a.ReservationRoomID = @ReservationRoomID
  AND   a.StayDate >= api.fnHotelLocalDate(a.HotelID, SYSDATETIMEOFFSET())
  AND   ln.NightState IN ('PENDING','HELD','USED')
  AND   oc.Occupants > rm.MaxOccupancy;
GO

-- fnRosterViolations (Member 2; 4b). For one room line, the five roster rules:
--   1 a line with occupants includes a responsible adult (18+, via AgeBand -> HeadcountCategory)
--   2 a confirmed line of an open stay has at least one occupant
--   3 DateOfBirth <= CheckInDate
--   4 no guest is on another confirmed line whose live nights overlap this line's nights
--     (this line's PENDING, HELD or USED nights against the other line's live nights)
--   5 every adult on an arrived line has the document they showed recorded
-- Ages are whole years at the reservation's CheckInDate.
CREATE FUNCTION api.fnRosterViolations (@ReservationRoomID BIGINT)
RETURNS TABLE
AS
RETURN
WITH Line AS
(
    SELECT rr.ReservationRoomID,
           rr.ConfirmedAt,
           rr.CheckedInAt,
           r.CheckInDate,
           StayIsClosed = api.fnStayIsClosed(rr.ReservationID)
    FROM   gshg.ReservationRoom AS rr
    JOIN   gshg.Reservation     AS r ON r.ReservationID = rr.ReservationID
    WHERE  rr.ReservationRoomID = @ReservationRoomID
),
Occ AS
(
    SELECT l.ReservationRoomID,
           l.CheckedInAt,
           l.CheckInDate,
           o.RoomOccupantID,
           o.GuestID,
           o.IdDocumentType,
           g.DateOfBirth,
           IsResponsibleAdult = ISNULL(hc.IsResponsibleAdult, CAST(0 AS BIT))
    FROM   Line              AS l
    JOIN   gshg.RoomOccupant AS o ON o.ReservationRoomID = l.ReservationRoomID
    JOIN   gshg.Guest        AS g ON g.GuestID           = o.GuestID
    CROSS APPLY (SELECT AgeYears = DATEDIFF(YEAR, g.DateOfBirth, l.CheckInDate)
                                 - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, g.DateOfBirth, l.CheckInDate), g.DateOfBirth)
                                             > l.CheckInDate THEN 1 ELSE 0 END) AS ag
    OUTER APPLY (SELECT TOP (1) ab.HeadcountCategoryCode
                 FROM   gshg.AgeBand AS ab
                 WHERE  ab.MinAgeYears <= ag.AgeYears
                 ORDER BY ab.MinAgeYears DESC) AS b
    LEFT JOIN gshg.HeadcountCategory AS hc ON hc.HeadcountCategoryCode = b.HeadcountCategoryCode
)
SELECT  l.ReservationRoomID, CAST(NULL AS BIGINT) AS GuestID, 1 AS RuleNo,
        CAST('NO_RESPONSIBLE_ADULT' AS VARCHAR(25)) AS Problem
FROM    Line AS l
WHERE   EXISTS     (SELECT 1 FROM Occ)
  AND   NOT EXISTS (SELECT 1 FROM Occ WHERE Occ.IsResponsibleAdult = 1)
UNION ALL
SELECT  l.ReservationRoomID, NULL, 2, 'NO_OCCUPANT'
FROM    Line AS l
WHERE   l.ConfirmedAt IS NOT NULL
  AND   l.StayIsClosed = 0
  AND   NOT EXISTS (SELECT 1 FROM Occ)
UNION ALL
SELECT  o.ReservationRoomID, o.GuestID, 3, 'BORN_AFTER_CHECK_IN'
FROM    Occ AS o
WHERE   o.DateOfBirth > o.CheckInDate
UNION ALL
SELECT  o.ReservationRoomID, o.GuestID, 4, 'ALREADY_STAYING_ELSEWHERE'
FROM    Occ AS o
WHERE   EXISTS (SELECT 1
                FROM   gshg.vwRoomLineNight AS me
                JOIN   gshg.RoomOccupant    AS o2    ON o2.GuestID            = o.GuestID
                                                    AND o2.ReservationRoomID <> me.ReservationRoomID
                JOIN   gshg.vwRoomLineNight AS other ON other.ReservationRoomID = o2.ReservationRoomID
                                                    AND other.StayDate          = me.StayDate
                                                    AND other.IsLive            = 1
                WHERE  me.ReservationRoomID = o.ReservationRoomID
                  AND  me.NightState IN ('PENDING','HELD','USED'))
UNION ALL
SELECT  o.ReservationRoomID, o.GuestID, 5, 'ADULT_WITHOUT_DOCUMENT'
FROM    Occ AS o
WHERE   o.CheckedInAt IS NOT NULL
  AND   o.IsResponsibleAdult = 1
  AND   o.IdDocumentType IS NULL;
GO

-- fnBeddingOverStock (Member 3; 4b). For one BEDDING HotelService with StockUnits set: each
-- hotel-local date from today on where the units booked exceed StockUnits. A row books
-- Quantity units on each requested day, unless the reservation is cancelled, the line is a
-- no-show, or the day falls after the line's hotel-local departure date.
CREATE FUNCTION api.fnBeddingOverStock (@HotelServiceID INT)
RETURNS TABLE
AS
RETURN
WITH Digit (d) AS (SELECT v.d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v (d)),
     Tally (n) AS (SELECT a.d + 10 * b.d + 100 * c.d + 1000 * e.d
                   FROM Digit AS a CROSS JOIN Digit AS b CROSS JOIN Digit AS c CROSS JOIN Digit AS e),
     Svc AS
     (
         SELECT hs.HotelServiceID,
                hs.StockUnits,
                LocalToday = api.fnHotelLocalDate(hs.HotelID, SYSDATETIMEOFFSET())
         FROM   gshg.HotelService AS hs
         WHERE  hs.HotelServiceID = @HotelServiceID
           AND  hs.ServiceClass   = 'BEDDING'
           AND  hs.StockUnits IS NOT NULL
     ),
     Booked AS
     (
         SELECT s.HotelServiceID,
                s.StockUnits,
                ServiceDay = DATEADD(DAY, t.n, rs.StartDate),
                rs.Quantity
         FROM   Svc                     AS s
         JOIN   gshg.ReservationService AS rs ON rs.HotelServiceID    = s.HotelServiceID
         JOIN   gshg.Reservation        AS r  ON r.ReservationID      = rs.ReservationID
         LEFT JOIN gshg.ReservationRoom AS rr ON rr.ReservationRoomID = rs.ReservationRoomID
         JOIN   Tally                   AS t  ON t.n < rs.Days
         WHERE  r.CancelledAt IS NULL
           AND  rr.NoShowAt IS NULL
           AND  DATEADD(DAY, t.n, rs.StartDate) >= s.LocalToday
           AND (rr.CheckedOutAt IS NULL
                OR DATEADD(DAY, t.n, rs.StartDate) <= api.fnHotelLocalDate(rr.HotelID, rr.CheckedOutAt))
     )
SELECT  b.HotelServiceID,
        b.ServiceDay,
        SUM(b.Quantity) AS UnitsBooked,
        b.StockUnits
FROM    Booked AS b
GROUP BY b.HotelServiceID, b.ServiceDay, b.StockUnits
HAVING  SUM(b.Quantity) > b.StockUnits;
GO

/* =====================================================================================
   7. SELF-CHECK — counts, and every object binds when queried
   ===================================================================================== */
DECLARE @Views INT = (SELECT COUNT(*) FROM sys.views   WHERE schema_id = SCHEMA_ID(N'gshg'));
DECLARE @Funcs INT = (SELECT COUNT(*) FROM sys.objects WHERE schema_id = SCHEMA_ID(N'api') AND type IN ('FN','IF','TF'));
IF @Views <> 9 OR @Funcs <> 7
BEGIN
    DECLARE @Msg NVARCHAR(200) = CONCAT(N'Stage 2 expected 9 views and 7 functions, found ', @Views, N' and ', @Funcs, N'.');
    THROW 50002, @Msg, 1;
END;

SELECT TOP (0) * FROM gshg.vwReservationStatus;
SELECT TOP (0) * FROM gshg.vwRoomLineNight;
SELECT TOP (0) * FROM gshg.vwMaintenanceWindow;
SELECT TOP (0) * FROM gshg.vwOccupantNight;
SELECT TOP (0) * FROM gshg.vwServiceCharge;
SELECT TOP (0) * FROM gshg.vwUnbilledStay;
SELECT TOP (0) * FROM gshg.vwStrayAllocation;
SELECT TOP (0) * FROM gshg.vwFolioLine;
SELECT TOP (0) * FROM gshg.vwAccountLine;
SELECT TOP (0) * FROM api.fnAllocationGaps(NULL);
SELECT TOP (0) * FROM api.fnRoomOverfull(NULL);
SELECT TOP (0) * FROM api.fnRosterViolations(NULL);
SELECT TOP (0) * FROM api.fnBeddingOverStock(NULL);
SELECT api.fnHotelLocalDate(NULL, NULL) AS LocalDate,
       api.fnIsInvoiced(NULL)           AS IsInvoiced,
       api.fnStayIsClosed(NULL)         AS StayIsClosed;

SELECT o.name AS ObjectName,
       s.name AS SchemaName,
       o.type_desc
FROM   sys.objects AS o
JOIN   sys.schemas AS s ON s.schema_id = o.schema_id
WHERE  (s.name = N'gshg' AND o.type = 'V')
   OR  (s.name = N'api'  AND o.type IN ('FN','IF','TF'))
ORDER BY s.name, o.type_desc, o.name;
GO