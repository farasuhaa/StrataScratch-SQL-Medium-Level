-- =========================================================
-- Title: Finding Purchases
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10553
-- =========================================================

-- Problem:
-- Identify returning active users by finding users who made a repeat purchase 
-- within 7 days or less of their previous transaction, excluding same-day purchases. 

-- Output: list of these user_id.

-- Tables:

-- amazon_transactions
--  ____________________________
-- | created_at  | date        |
-- | id          | bigint      |
-- | item        | text        |
-- | revenue     | bigint      |
-- | user_id     | bigint      |

-- =====================================================================================
-- Approach
--
-- 1. Use LAG() to get each user’s previous purchase date ordered by transaction time.
-- 2. Calculate the difference in days between consecutive purchases.
-- 3. Filter transactions where the gap is between 1 and 7 days (excluding same-day purchases).
-- 4. Return distinct users who meet the condition.
-- =====================================================================================

with base as (
    select
        user_id
        , created_at
        , created_at - lag(created_at) over (partition by user_id order by created_at) as day_diff
    from amazon_transactions
    group by 1,2
    order by 1
)

select
    user_id
from base
where day_diff between 1 and 7
group by 1
