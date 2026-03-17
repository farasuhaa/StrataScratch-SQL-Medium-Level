-- =========================================================
-- Title: No Order Customers
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10142
-- =========================================================

-- Problem:
-- Identify customers who did not place an order between 2019-02-01 and 2019-03-01.

-- Note:
-- Include:
-- Customers who placed orders only outside this date range.
-- Customers who never placed any orders.

-- Output: customers' first names.

-- Tables:

-- customers
--  ____________________________
-- |  address       |  text    |
-- |  city          |  text    |
-- |  first_name    |  text    |
-- |  id            |  bigint  |
-- |  last_name     |  text    |
-- |  phone_number  |  text    |

-- orders
--  ________________________________
-- |  cust_id           |  bigint  |
-- |  id                |  bigint  |
-- |  order_date        |  date    |
-- |  order_details     |  text    |
-- |  total_order_cost  |  bigint  |

-- =====================================================================================
-- Approach
--
-- 1. Identify customers who placed orders within the target date range and exclude them.
-- 2. Include customers who never placed any orders using a LEFT JOIN.
-- 3. Combine both sets to get all customers with no orders between 2019-02-01 and 2019-03-01.
-- =====================================================================================

select
    distinct first_name
from customers c
left join orders o  on c.id = o.cust_id
where first_name not in (select first_name
                        from customers c
                        left join orders o  on c.id = o.cust_id
                        where o.order_date between '2019-02-01' and '2019-03-01')

union

select
    first_name
from customers c
left join orders o on c.id = o.cust_id
where o.cust_id is null

