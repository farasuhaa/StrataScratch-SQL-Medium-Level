-- =========================================================
-- Title: Matching Similar Hosts and Guests
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10078
-- =========================================================

-- Problem:
-- Find matching hosts and guests pairs in a way that they are both of the same gender and nationality.

-- Output: the host id and the guest id of matched pair.

-- Tables:

-- airbnb_hosts
-- ____________________________
-- |  age          |  bigint  |
-- |  gender       |  text    |
-- |  host_id      |  bigint  |
-- |  nationality  |  text    |

-- airbnb_guests
-- ____________________________
-- |  age          |  bigint  |
-- |  gender       |  text    |
-- |  guest_id     |  bigint  |
-- |  nationality  |  text    |

-- =====================================================================================
-- Approach
--
-- 1. Join hosts and guests on matching gender and nationality.
-- 2. Select distinct pairs to remove any duplicates.
-- =====================================================================================

select distinct
    host_id
    , guest_id
from airbnb_hosts h
left join airbnb_guests g
    on h.gender = g.gender
    and h.nationality = g.nationality
