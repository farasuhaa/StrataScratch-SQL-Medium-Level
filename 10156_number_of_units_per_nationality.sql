-- =========================================================
-- Title: Number Of Units Per Nationality
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10156
-- =========================================================

-- Problem:
-- Write a query that figures out how many different apartments (use unit_id) are owned by 
-- people under 30, broken down by their nationality. 
-- We want to see which nationality owns the most apartments, so make sure to sort the results accordingly.

-- Output: nationality, apartment_count

-- Tables:

-- airbnb_hosts
--  ___________________________
-- |  age          |  bigint  |
-- |  gender       |  text    |
-- |  host_id      |  bigint  |
-- |  nationality  |  text    |

-- airbnb_units
--  __________________________
-- |  city        |  text    |
-- |  country     |  text    |
-- |  host_id     |  bigint  |
-- |  n_bedrooms  |  bigint  |
-- |  n_beds      |  bigint  |
-- |  unit_id     |  text    |
-- |  unit_type   |  text    |

-- =====================================================================================
-- Approach
--
-- 1. Join hosts with units to associate each apartment with its owner.
-- 2. Filter for hosts under 30 and units that are apartments.
-- 3. Count distinct unit_id per nationality to find the number of apartments owned.
-- 4. Sort results to identify nationalities with the most apartments.
-- =====================================================================================

with base as (
    select
        h.host_id
        , age
        , nationality
        , unit_id
    from airbnb_hosts h
    left join airbnb_units u    on h.host_id = u.host_id
    where h.age < 30
        and unit_type ilike '%apartment%'
)

select 
    count(distinct unit_id) as n_apartment
    , nationality
from base
group by 2
