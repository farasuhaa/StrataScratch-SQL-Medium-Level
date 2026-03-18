-- =========================================================
-- Title: Income By Title and Gender
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10077
-- =========================================================

-- Problem:
-- Find the average total compensation based on employee titles and gender. 
-- Total compensation is calculated by adding both the salary and bonus of each employee. 
-- However, not every employee receives a bonus so disregard employees without bonuses in your calculation. 
-- Employee can receive more than one bonus.

-- Output: employee title, gender (i.e., sex), along with the average total compensation.

-- Tables:

-- sf_employee
-- _______________________________
-- |  address         |  text    |
-- |  age             |  bigint  |
-- |  city            |  text    |
-- |  department      |  text    |
-- |  email           |  text    |
-- |  employee_title  |  text    |
-- |  first_name      |  text    |
-- |  id              |  bigint  |
-- |  last_name       |  text    |
-- |  manager_id      |  bigint  |
-- |  salary          |  bigint  |
-- |  sex             |  text    |
-- |  target          |  bigint  |

-- sf_bonus
-- ______________________________
-- |  bonus          |  bigint  |
-- |  worker_ref_id  |  bigint  |

-- =====================================================================================
-- Approach
--
-- 
-- =====================================================================================

with base as (
    select
        e.id as employee_id
        , employee_title
        , sex
        , salary
        , bonus
    from sf_employee e
    left join sf_bonus b    on e.id = b.worker_ref_id
    where bonus is not null
        -- and e.id between 1 and 20
        -- and employee_title in ('Senior Sales')
    order by 1 
)

, total_bonus as (
    select
        employee_id
        , employee_title
        , sex
        , salary
        , sum(bonus) as bonus
    from base
    group by 1,2,3,4
    order by 1
)

, total_compensation as (
    select
        employee_id
        , employee_title
        , sex
        , sum(salary) + sum(bonus) as compensation
    from total_bonus
    group by 1,2,3
)

select
    employee_title
    , sex as gender
    , avg(compensation) as avg_compensation
from total_compensation
group by 1,2
