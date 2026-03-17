-- =========================================================
-- Title: Finding User Purchases
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10322
-- =========================================================

-- Problem:
-- Identify returning active users by finding users who made a second purchase 
-- within 1 to 7 days after their first purchase. 
-- Ignore same-day purchases. 

-- Output: list of user_id.

-- Tables:

-- amazon_transactions
--  ____________________________
-- | created_at  | date        |
-- | id          | bigint      |
-- | item        | text        |
-- | revenue     | bigint      |
-- | uder_id     | bigint      |

-- =====================================================================================
-- Approach

-- 1. Rank each user’s transactions by purchase date to identify first and second purchases.
-- 2. Extract the first and second purchase dates using conditional aggregation.
-- 3. Compute the difference in days between the two purchases.
-- 4. Filter users whose second purchase occurs within 1 to 7 days after the first (excluding same-day purchases).
-- =====================================================================================

with base as (
    select
        user_id
        , created_at
        , rank() over (partition by user_id order by created_at asc) as order_rank
    from amazon_transactions
    -- where user_id = 100
    order by 1
)

, purchases as (
    select
        user_id,
        max(case when order_rank = 2 then created_at end) -
        max(case when order_rank = 1 then created_at end) as day_diff
    from base
    group by 1
)

select
    user_id
from purchases
where day_diff between 1 and 7
