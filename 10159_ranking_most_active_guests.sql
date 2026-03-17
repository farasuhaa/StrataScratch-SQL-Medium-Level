-- =========================================================
-- Title: Ranking Most Active Guests
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10159
-- =========================================================

-- Problem:
-- Identify the most engaged guests by ranking them according to their overall messaging activity. 
-- The most active guest, meaning the one who has exchanged the most messages with hosts, should have the highest rank. 
-- If two or more guests have the same number of messages, they should have the same rank. 
-- Importantly, the ranking shouldn't skip any numbers, even if many guests share the same rank. 

-- Output: 
-- Present your results in a clear format, showing the rank, guest identifier, 
-- and total number of messages for each guest, ordered from the most to least active.

-- Tables:

-- airbnb_contacts
--  ___________________________________________________
-- |  ds_checkin      |  date                         |
-- |  ds_checkout     |  date                         |
-- |  id_guest        |  text                         |
-- |  id_host         |  text                         |
-- |  id_listing      |  text                         |
-- |  n_guests        |  bigint                       |
-- |  n_messages      |  bigint                       |
-- |  ts_accepted_at  |  timestamp without time zone  |
-- |  ts_booking_at   |  timestamp without time zone  |
-- |  ts_contact_at   |  timestamp without time zone  |
-- |  ts_reply_at     |  timestamp without time zone  |

-- =====================================================================================
-- Approach
--
-- 1. Aggregate total messages for each guest using SUM(n_messages).
-- 2. Apply DENSE_RANK() on total messages in descending order to assign ranks without skipping numbers for ties.
-- 3. Order the final output by total messages (descending) and rank.
-- =====================================================================================

with sum_msg as (
    select
        id_guest
        , sum(n_messages) as n_msg
    
    from airbnb_contacts
    group by 1
)

select 
    id_guest
    , n_msg
    , dense_rank() over (order by n_msg desc) as ranking
from sum_msg
order by 2 desc,3
