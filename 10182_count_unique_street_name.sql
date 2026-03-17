-- =========================================================
-- Title: Number of Streets Per Zip Code
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10182
-- =========================================================

-- Problem:
-- Count the number of unique street names for each postal code in the business dataset. 

-- Note:
-- Use only the first word of the street name, case insensitive (e.g., "FOLSOM" and "Folsom" are the same). 
-- If the structure is reversed (e.g., "Pier 39" and "39 Pier"), count them as the same street. 

-- Output: postal codes, ordered by the number of streets (descending) and postal code (ascending).

-- Tables:

-- sf_restaurant_health_violations
--  ______________________________________________
-- | business_address       |  text              |
-- | business_city          |  text              |
-- | business_id            |  bigint            |
-- | business_latitude      |  double precision  |
-- | business_location      |  text              |
-- | business_longitude     |  double precision  |
-- | business_name          |  text              |
-- | business_phone_number  |  double precision  |
-- | business_postal_code   |  double precision  |
-- | business_state         |  text              |
-- | inspection_date        |  date              |
-- | inspection_id          |  text              |
-- | inspection_score       |  double precision  |
-- | inspection_type        |  text              |
-- | risk_category          |  text              |
-- | violation_description  |  text              |
-- | violation_id           |  text              |

-- =====================================================================================
-- Approach

-- 1. Clean the address by removing leading numbers, then extract the first word of the street name.
-- 2. Standardize street names to lowercase to ensure case-insensitive matching.
-- 3. Count distinct street names for each postal code.
-- 4. Sort results by number of streets (descending) and postal code (ascending).
-- =====================================================================================

with street_name as (
    select
        business_postal_code
        , business_address
        , lower(split_part(regexp_replace(business_address, '^\d+\s+', ''), ' ',1)) as street_name
    from sf_restaurant_health_violations
    where business_postal_code is not null
)

select
    business_postal_code
    , count(distinct street_name) as n_street
from street_name
group by 1
order by 2 desc, 1 asc
