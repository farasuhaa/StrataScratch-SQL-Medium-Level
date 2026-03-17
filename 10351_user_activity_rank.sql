-- =========================================================
-- Title: Activity Rank
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10351
-- =========================================================

-- Problem:
-- Find the email activity rank for each user. 
-- Email activity rank is defined by the total number of emails sent. 
-- The user with the highest number of emails sent will have a rank of 1, and so on. 

-- Output: user, total emails, and their activity rank.

-- Note:
-- Order records first by the total emails in descending order.
-- Then, sort users with the same number of emails in alphabetical order by their username.
-- In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.

-- Tables:

-- google_gmail_emails
--  ___________________________
-- | day          | bigint    |
-- | from_user    | text      |
-- | id           | bigint    |
-- | to_user      | text      |

-- =====================================================================================
-- Approach

-- 1. Aggregate total emails sent by each user using COUNT(*).
-- 2. Apply ROW_NUMBER() to assign a unique rank based on total emails (descending) and username (alphabetical) for tie-breaking.
-- 3. Order the final output by total emails descending and username.
-- =====================================================================================

with sent as (
    select
        from_user
        , count(*) as n_emails
    from google_gmail_emails
    group by 1
)

select
    from_user
    , n_emails
    , row_number() over (order by n_emails desc, from_user) as e_rank
from sent
order by 2 desc, 1
