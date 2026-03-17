-- =========================================================
-- Title: Users By Average Session Time
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10352
-- =========================================================

-- Problem:
-- Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit. 
-- Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the 
-- latest page_load and the earliest page_exit. Only consider sessions where the page_load occurs before the page_exit on the same day. 

-- Output: user_id and their average session time.

-- Table:

-- facebook_web_log
--  _______________________________________
-- | action     | text                     |
-- | timestamp  | timestamp w/o time zone  |
-- | user_id    | bigint                   |

-- =====================================================================================
-- Approach

-- 1. Find the latest page_load and the earliest page_exit by date.
-- 2. Aggregate the data to calculate the average session time per user.
-- =====================================================================================

with base as (
    select
        user_id
        , date(timestamp) as session_date
        , max(case when action in ('page_load') then timestamp end) as last_load
        , min(case when action in ('page_exit') then timestamp end) as first_exit
    from facebook_web_log
    group by 1,2
    order by 1
)

select
    user_id
    , avg(first_exit - last_load) as avg_session
from base
where last_load is not null
    and first_exit is not null
    and first_exit > last_load
group by 1
