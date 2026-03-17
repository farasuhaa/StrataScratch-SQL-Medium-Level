-- =========================================================
-- Title: Apple Product Counts
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10141
-- =========================================================

-- Problem:
-- We’re analyzing user data to understand how popular Apple devices are among users who have performed 
-- at least one event on the platform. Specifically, we want to measure this popularity across different languages. 
-- Count the number of distinct users using Apple devices limited to "macbook pro", "iphone 5s", and "ipad air"
-- and compare it to the total number of users per language.

-- Output:
-- Present the results with the language, the number of Apple users, and the total number of users for each language. 
-- Finally, sort the results so that languages with the highest total user count appear first.

-- Tables:

-- playbook_events
--  ____________________________________________
-- |  device       |  text                     |
-- |  event_name   |  text                     |
-- |  event_type   |  text                     |
-- |  location     |  text                     |
-- |  occurred_at  |  timestamp w/o time zone  |
-- |  user_id      |  bigint                   |

-- playbook_users
--  _____________________________________________
-- |  activated_at  |  date                     |
-- |  company_id    |  bigint                   |
-- |  created_at    |  timestamp w/o time zone  |
-- |  language      |  text                     |
-- |  state         |  text                     |
-- |  user_id       |  bigint                   |

-- =====================================================================================
-- Approach
--
-- 1. Join users with events to consider only active users.
-- 2. Identify Apple device users by filtering for specific devices and count distinct users per language.
-- 3. Count total active users per language.
-- 4. Left join Apple users to total users and handle missing values with COALESCE.
-- 5. Sort results by total users in descending order.
-- =====================================================================================

with apple_user as (
    select
        language
        , count(distinct e.user_id) as n_apple_user
    from playbook_users e
    inner join playbook_events u  on e.user_id = u.user_id
    where device ilike '%macbook%pro%'
        or device ilike '%iphone%5s%'
        or device ilike '%ipad%air%'
    group by 1
    order by 2 desc
)

, total_user as (
    select
        language
        , count(distinct e.user_id) as n_total_user
    from playbook_users e
    inner join playbook_events u  on e.user_id = u.user_id
    group by 1
    order by 2 desc
)

select
    t.language
    , n_total_user
    , coalesce(a.n_apple_user, 0) as n_apple_user
from total_user t
left join apple_user a  on t.language = a.language
group by 1,2,3
order by 2 desc
