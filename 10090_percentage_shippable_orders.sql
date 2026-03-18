-- =========================================================
-- Title: Find the percentage of shipable orders
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10090
-- =========================================================

-- Problem:
-- Find the percentage of shipable orders.
-- Consider an order is shipable if the customer's address is known.

-- Output: the percentage of shippable orders

-- Tables:

-- orders
-- _________________________________
-- |  cust_id           |  bigint  |
-- |  id                |  bigint  |
-- |  order_date        |  date    |
-- |  order_details     |  text    |
-- |  total_order_cost  |  bigint  |

-- customers
-- _____________________________
-- |  address       |  text    |
-- |  city          |  text    |
-- |  first_name    |  text    |
-- |  id            |  bigint  |
-- |  last_name     |  text    |
-- |  phone_number  |  text    |

-- =====================================================================================
-- Approach

-- 1. Join orders with customers to retrieve address information.
-- 2. Flag each order as shippable if the address is not null.
-- 3. Count total orders and total shippable orders.
-- 4. Compute the percentage of shippable orders using aggregated counts.
-- =====================================================================================

with shippable as (
    select
        o.cust_id
        , o.id as order_id
        , case when address is not null then 1 else 0 end as shippable_orders
        , count(*) as all_orders
    from orders o
    left join customers c   on o.cust_id = c.id
    group by 1,2,3
)

select
    sum(shippable_orders)::float / (sum(all_orders)) * 100 as pct
from shippable
