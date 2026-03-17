-- =========================================================
-- Title: Meta/Facebook Accounts
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10296
-- =========================================================

-- Problem:
-- Of all accounts with status records on January 10th, 2020, calculate the ratio of those with 'closed' status.

-- Output: the ratio

-- Tables:

-- fb_account_status
--  ____________________________________
-- | acc_id       | bigint             |
-- | status       | character varying  |
-- | status_date  | date               |

-- =====================================================================================
-- Approach
--
-- 1. Filter records for the target date (2020-01-10).
-- 2. Use conditional aggregation to count closed and open accounts.
-- 3. Compute the ratio as closed / (closed + open), using float division for accuracy.
-- =====================================================================================

with acc_ratio as (
    select
        sum(case when status in ('closed') then 1 else 0 end) as acc_closed
        , sum(case when status in ('open') then 1 else 0 end) as acc_open
    from fb_account_status
    where status_date = '2020-01-10'
)

select 
    acc_closed :: float / (acc_closed + acc_open) as closed_ratio
from acc_ratio
