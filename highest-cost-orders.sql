-- =========================================================
-- Title: Highest Cost Orders
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 9915
-- =========================================================

-- Problem:
-- Find the customers with the highest daily total order cost between 2019-02-01 and 2019-05-01.
-- If a customer placed multiple orders on the same day, sum their total_order_cost for that day.
-- For each date, return the customer(s) with the highest daily total cost.
--
-- Output: first_name | total_cost | order_date
--
-- Note:
-- If multiple customers tie for the highest total on the same date, return all of them.
-- Assume every first_name is unique.

-- Tables:
--
-- customers
--  ____________________________
-- | id            | bigint    |
-- | first_name    | text      |
-- | last_name     | text      |
-- | city          | text      |
-- | address       | text      |
-- | phone_number  | text      |
--
-- orders
-- _________________________________
-- | id                | bigint    |
-- | cust_id           | bigint    |
-- | order_date        | date      |
-- | order_details     | text      |
-- | total_order_cost  | bigint    |

-- =====================================================================================
-- Approach
--
-- 1. Create a base dataset by joining the customers and orders tables. Filter orders 
--    that occurred between 2019-02-01 and 2019-05-01 and keep relevant fields such as
--    customer name, order date, and order cost.
--
-- 2. Aggregate the data to calculate each customer's total order cost per day. This 
--    ensures that if a customer placed multiple orders on the same date, their costs
--    are summed into a single daily total.
--
-- 3. Rank customers within each order_date based on their daily total order cost using
--    DENSE_RANK(), ordering from highest to lowest.
--
-- 4. Filter the results to return only customers with rank = 1, which represents the 
--    highest daily total order cost. If multiple customers tie for the highest total on 
--    the same date, all of them are returned.
-- =====================================================================================

with base as (
    select
        c.first_name
        , o.id as order_id
        , o.order_date
        , o.total_order_cost
    from customers c
    left join orders o on c.id = o.cust_id
    where o.order_date between '2019-02-01' and '2019-05-01'
        -- and first_name in ('Mark')
)

, sum_order as (
    select
        first_name
        , order_date
        , sum(total_order_cost) as total_order
    from base
    group by 1,2
)

, cust_rank as (
    select
        first_name
        , order_date
        , total_order
        , dense_rank() over (partition by order_date order by total_order desc) as order_rank
    from sum_order
    order by 2,1
)

select
    first_name
    , order_date
    , total_order
from cust_rank
where order_rank = 1

