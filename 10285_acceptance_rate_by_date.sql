-- =========================================================
-- Title: Acceptance Rate By Date
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10285
-- =========================================================

-- Problem:
-- Calculate the friend acceptance rate for each date when friend requests were sent. 
-- A request is sent if action = 'sent' and accepted if action = 'accepted'. 
-- If a request is not accepted, there is no record of it being accepted in the table.

-- Output: only include dates where requests were sent and at least one of them was accepted 
--         (acceptance can occur on any date after the request is sent).

-- Tables:

-- fb_friend_requests
--  ____________________________
-- | action            | text  |
-- | date              | date  | 
-- | user_id_receiver  | text  |  
-- | user_id_sender    | text  |

-- =====================================================================================
-- Approach

-- 1. Split the data into two CTEs: one for sent requests and one for accepted requests.
-- 2. Left join accepted to sent using sender and receiver to identify which requests were 
--    successfully accepted (even if accepted later).
-- 3. Aggregate by sent date to get total sent and total accepted requests.
-- 4. Compute acceptance rate as accepted / sent, using float division for accuracy.
-- =====================================================================================

with sent as (
    select
        date
        , user_id_receiver
        , user_id_sender
        , 1 as n_sent
    from fb_friend_requests
    where action in ('sent')
)

, accepted as (
    select
        date
        , user_id_receiver
        , user_id_sender
        , 1 as n_accepted
    from fb_friend_requests
    where action in ('accepted')
)

, combined as (
    select
        s.date
        , s.user_id_receiver
        , s.user_id_sender
        , s.n_sent
        , a.n_accepted
    from sent s
    left join accepted a    on s.user_id_sender = a.user_id_sender
                            and s.user_id_receiver = a.user_id_receiver
    order by 1
)

select
    date
    , (sum(n_accepted)::float / sum(n_sent)::float) as acceptance_rate
from combined
group by 1
