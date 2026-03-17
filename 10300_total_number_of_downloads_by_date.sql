-- =========================================================
-- Title: Premium vs Freemium
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10300
-- =========================================================

-- Problem:
-- Find the total number of downloads for paying and non-paying users by date. 
-- Include only records where non-paying customers have more downloads than paying customers. 

-- Output: sort by earliest date first and contain 3 columns date, non-paying downloads, paying downloads. 

-- Tables:

-- ms_user_dimension
--  ______________________
-- | acc_id    | bigint  |
-- | user_id   | bigint  |

-- ms_acc_dimension
-- _______________________________
-- | acc_id            | bigint  |
-- | paying_customers  | text    |

-- ms_download_facts
-- _________________________
-- | date        | date    |
-- | downloads   | bigint  |
-- | user_id     | bigint  |

-- =====================================================================================
-- Approach
--
-- 1. Join user, account, and download tables to associate each download with paying status.
-- 2. Split data into two groups: paying and non-paying users, then aggregate total downloads by date for each group.
-- 3. Combine both results on date and handle missing values using COALESCE.
-- 4. Filter for dates where non-paying downloads exceed paying downloads and sort by date.
-- 
-- =====================================================================================

with pay_cust as (
    with pay_base as (
        select
            u.user_id
            , date
            , downloads
        from ms_user_dimension u
        left join ms_acc_dimension a    on u.acc_id = a.acc_id
        left join ms_download_facts d   on u.user_id = d.user_id
        where paying_customer in ('yes')
    )
    
    select
        date
        , sum(downloads) as pay_download
    from pay_base
    group by 1
    order by 1
)

, no_pay_cust as (
    with no_pay_base as (
        select
            u.user_id
            , date
            , downloads
        from ms_user_dimension u
        left join ms_acc_dimension a    on u.acc_id = a.acc_id
        left join ms_download_facts d   on u.user_id = d.user_id
        where paying_customer in ('no')
    )
    
    select
        date
        , sum(downloads) as no_pay_download
    from no_pay_base
    group by 1
    order by 1
)

select
    coalesce(p.date, np.date) as date
    , coalesce(np.no_pay_download , 0) as no_pay_download
    , coalesce(p.pay_download, 0) as pay_download
from pay_cust p
left join no_pay_cust np    on p.date = np.date
where no_pay_download > pay_download
order by 1
