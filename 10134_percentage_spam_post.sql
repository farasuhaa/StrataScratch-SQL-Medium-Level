-- =========================================================
-- Title: Spam Posts
-- Language: PostgreSQL
-- Difficulty: Medium
-- Source: StrataScratch
-- ID: 10134
-- =========================================================

-- Problem:
-- Calculate the percentage of spam posts in all viewed posts by day.

-- Note:
-- A post is considered a spam if a string "spam" is inside keywords of the post. 
-- The facebook_posts table stores all posts posted by users. 
-- The facebook_post_views table is an action table denoting if a user has viewed a post.

-- Output: post_date, percentage of spam

-- Tables:

-- facebook_posts
--  _____________________________
-- |  post_date      |  date    |
-- |  post_id        |  bigint  |
-- |  post_keywords  |  text    |
-- |  post_text      |  text    |
-- |  poster         |  bigint  |

-- facebook_post_views
--  _________________________
-- |  post_id    |  bigint  |
-- |  viewer_id  |  bigint  |

-- =====================================================================================
-- Approach
--
-- 1. Join posts with views to consider only viewed posts.
-- 2. Count daily spam posts by filtering post_keywords for “spam”.
-- 3. Count total viewed posts per day.
-- 4. Calculate the spam percentage as (spam / total) * 100 by day.
-- =====================================================================================

with spam_post as (
    select 
        post_date
        , count(p.post_id) as n_spam_post
    from facebook_posts p
    inner join facebook_post_views v    on p.post_id = v.post_id
    where post_keywords ilike '%spam%'
    group by 1
)

, all_post as (
    select 
        post_date
        , count(p.post_id) as n_all_post
    from facebook_posts p
    inner join facebook_post_views v    on p.post_id = v.post_id
    group by 1
)

select
    a.post_date
    , (sum(n_spam_post) / sum(n_all_post))*100 as percentage
from all_post a
left join spam_post s   on a.post_date = s.post_date
group by 1
