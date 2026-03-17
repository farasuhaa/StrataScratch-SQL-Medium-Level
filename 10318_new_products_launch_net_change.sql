-- =========================================================
-- Title: New Products
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10318
-- =========================================================

-- Problem:
-- Calculate the net change in the number of products launched by companies in 2020 compared to 2019. 

-- Output: company_name | net_difference.

-- Note:
-- (Net difference = Number of products launched in 2020 - The number launched in 2019.)

-- Tables:

-- car_launches
-- __________________________
-- | company_name  | text    |
-- | product_name  | text    |
-- | year          | bigint  |

-- =====================================================================================
-- Approach

-- 1. Find the total number of products launched for each year.
-- 2. Calculate the net change of products launched.
-- =====================================================================================

with base as (
    select
        company_name
        , year
        , count(*) as n_products
    from car_launches
    group by 1,2
    order by 1,2
)

select
    company_name
    , sum(case when year = 2020 then n_products else 0 end) -
        sum(case when year = 2019 then n_products else 0 end) as net
from base
group by 1
order by 1
