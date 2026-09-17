
USE game_analytics;

SHOW TABLES;
SELECT COUNT(*) AS total_rows
FROM train;
SELECT *
FROM train
LIMIT 5;
DESCRIBE train;
SELECT COUNT(*) AS total_rows
FROM train;
SELECT COUNT(*) AS total_rows
FROM mobile_game_ltv;
SELECT
    COUNT(*) AS total_rows,
    SUM(user_id IS NULL) AS missing_user_id,
    SUM(platform IS NULL) AS missing_platform,
    SUM(revenue_usd IS NULL) AS missing_revenue,
    SUM(ltv_d8_d180 IS NULL) AS missing_ltv
FROM train;
SELECT
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) AS total_records
FROM train;
SELECT
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(AVG(revenue_usd), 2) AS avg_revenue_per_record,
    ROUND(MAX(revenue_usd), 2) AS max_single_revenue
FROM train;
SELECT
    platform,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(AVG(revenue_usd), 2) AS avg_revenue_per_record
FROM train
GROUP BY platform
ORDER BY total_revenue DESC;
SELECT
    country_tier,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(AVG(revenue_usd), 2) AS avg_revenue_per_record
FROM train
GROUP BY country_tier
ORDER BY total_revenue DESC;
SELECT
    country_tier,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(SUM(revenue_usd) / COUNT(DISTINCT user_id), 2) AS revenue_per_user
FROM train
GROUP BY country_tier
ORDER BY revenue_per_user DESC;
SELECT
    channel_tier,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(SUM(revenue_usd) / COUNT(DISTINCT user_id), 2) AS revenue_per_user
FROM train
GROUP BY channel_tier
ORDER BY total_revenue DESC;
SELECT
    event_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train
GROUP BY event_type
ORDER BY total_revenue DESC;
SELECT
    product_id,
    COUNT(*) AS purchases,
    COUNT(DISTINCT user_id) AS unique_buyers,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(AVG(revenue_usd), 2) AS avg_purchase_value
FROM train
WHERE event_type = 'iap'
GROUP BY product_id
ORDER BY total_revenue DESC;
SELECT
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(AVG(ltv_d8_d180), 2) AS avg_ltv,
    ROUND(MIN(ltv_d8_d180), 2) AS min_ltv,
    ROUND(MAX(ltv_d8_d180), 2) AS max_ltv,
    ROUND(SUM(ltv_d8_d180), 2) AS total_ltv
FROM train;
SELECT
    user_id,
    MAX(ltv_d8_d180) AS user_ltv
FROM train
GROUP BY user_id
ORDER BY user_ltv DESC
LIMIT 10;
SELECT
    CASE
        WHEN user_ltv = 0 THEN 'Zero LTV'
        WHEN user_ltv < 10 THEN 'Low LTV'
        WHEN user_ltv < 50 THEN 'Medium LTV'
        WHEN user_ltv < 100 THEN 'High LTV'
        ELSE 'Very High LTV'
    END AS ltv_segment,
    COUNT(*) AS users,
    ROUND(SUM(user_ltv), 2) AS total_ltv,
    ROUND(AVG(user_ltv), 2) AS avg_ltv
FROM (
    SELECT
        user_id,
        MAX(ltv_d8_d180) AS user_ltv
    FROM train
    GROUP BY user_id
) AS user_ltv_data
GROUP BY ltv_segment
ORDER BY total_ltv DESC;
SELECT
    ltv_segment,
    users,
    total_ltv,
    ROUND((total_ltv / SUM(total_ltv) OVER()) * 100, 2) AS ltv_share_pct
FROM (
    SELECT
        CASE
            WHEN user_ltv = 0 THEN 'Zero LTV'
            WHEN user_ltv < 10 THEN 'Low LTV'
            WHEN user_ltv < 50 THEN 'Medium LTV'
            WHEN user_ltv < 100 THEN 'High LTV'
            ELSE 'Very High LTV'
        END AS ltv_segment,
        COUNT(*) AS users,
        ROUND(SUM(user_ltv), 2) AS total_ltv
    FROM (
        SELECT
            user_id,
            MAX(ltv_d8_d180) AS user_ltv
        FROM train
        GROUP BY user_id
    ) AS user_ltv_data
    GROUP BY ltv_segment
) AS segment_data
ORDER BY ltv_share_pct DESC;
SELECT
    platform,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) AS total_events,
    ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) AS events_per_user
FROM train
GROUP BY platform
ORDER BY events_per_user DESC;
SELECT
    event_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) AS events_per_user
FROM train
GROUP BY event_type
ORDER BY total_events DESC;
SELECT
    CASE
        WHEN iap_events > 0 THEN 'Paying User'
        ELSE 'Non-Paying User'
    END AS user_type,
    COUNT(*) AS users
FROM (
    SELECT
        user_id,
        SUM(event_type = 'iap') AS iap_events
    FROM train
    GROUP BY user_id
) AS user_summary
GROUP BY user_type
ORDER BY users DESC;
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'iap' THEN user_id END) AS paying_users,
    ROUND(SUM(CASE WHEN event_type = 'iap' THEN revenue_usd ELSE 0 END), 2) AS iap_revenue,
    ROUND(
        SUM(CASE WHEN event_type = 'iap' THEN revenue_usd ELSE 0 END)
        / COUNT(DISTINCT CASE WHEN event_type = 'iap' THEN user_id END),
        2
    ) AS arppu
FROM train;
SELECT
    network,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    ROUND(
        SUM(revenue_usd) / COUNT(DISTINCT user_id),
        2
    ) AS revenue_per_user
FROM train
GROUP BY network
ORDER BY total_revenue DESC;
SELECT
    COALESCE(network, 'Missing Network') AS network,
    event_type,
    COUNT(*) AS events,
    COUNT(DISTINCT user_id) AS users,
    ROUND(SUM(revenue_usd), 2) AS revenue
FROM train
GROUP BY COALESCE(network, 'Missing Network'), event_type
ORDER BY revenue DESC;
SELECT
    network,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) AS ad_impressions,
    ROUND(SUM(revenue_usd), 2) AS ad_revenue,
    ROUND(
        SUM(revenue_usd) / COUNT(DISTINCT user_id),
        2
    ) AS revenue_per_user
FROM train
WHERE event_type = 'ad_impression'
GROUP BY network
ORDER BY ad_revenue DESC;
SELECT
    network,
    COUNT(*) AS ad_impressions,
    ROUND(SUM(revenue_usd), 2) AS ad_revenue,
    ROUND(
        SUM(revenue_usd) / COUNT(*) * 1000,
        4
    ) AS revenue_per_1000_impressions
FROM train
WHERE event_type = 'ad_impression'
GROUP BY network
ORDER BY revenue_per_1000_impressions DESC;
SELECT
    user_id,
    platform,
    country_tier,
    COUNT(*) AS total_events,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    MAX(ltv_d8_d180) AS user_ltv
FROM train
GROUP BY user_id, platform, country_tier
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    user_id,
    COUNT(*) AS total_events,
    ROUND(SUM(revenue_usd), 2) AS total_revenue,
    MAX(ltv_d8_d180) AS user_ltv
FROM train
GROUP BY user_id
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    day_since_install,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(*) AS total_events,
    ROUND(
        COUNT(*) / COUNT(DISTINCT user_id),
        2
    ) AS events_per_user,
    ROUND(SUM(revenue_usd), 2) AS revenue
FROM train
GROUP BY day_since_install
ORDER BY day_since_install;

-- =====================================================
-- GAME USER ENGAGEMENT & REVENUE ANALYTICS
-- SQL Analysis Queries
-- =====================================================

-- 1. Total Users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM train;


-- 2. Total Revenue
SELECT ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train;


-- 3. Revenue by Platform
SELECT
    platform,
    ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train
GROUP BY platform
ORDER BY total_revenue DESC;


-- 4. Revenue by Country
SELECT
    country_tier,
    COUNT(DISTINCT user_id) AS users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train
GROUP BY country_tier
ORDER BY total_revenue DESC;


-- 5. Revenue by Acquisition Channel
SELECT
    channel_tier,
    COUNT(DISTINCT user_id) AS users,
    ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train
GROUP BY channel_tier
ORDER BY total_revenue DESC;


-- 6. IAP Revenue
SELECT
    ROUND(SUM(revenue_usd), 2) AS iap_revenue
FROM train
WHERE event_type = 'iap';


-- 7. Advertisement Revenue
SELECT
    ROUND(SUM(revenue_usd), 2) AS ad_revenue
FROM train
WHERE event_type = 'ad_impression';


-- 8. Paying Users
SELECT
    COUNT(DISTINCT user_id) AS paying_users
FROM train
WHERE event_type = 'iap';


-- 9. Paying User Percentage
SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN event_type = 'iap' THEN user_id
        END)
        / COUNT(DISTINCT user_id) * 100,
        2
    ) AS paying_user_percentage
FROM train;


-- 10. Revenue by Day Since Install
SELECT
    day_since_install,
    COUNT(DISTINCT user_id) AS active_users,
    ROUND(SUM(revenue_usd), 2) AS revenue
FROM train
WHERE day_since_install BETWEEN 0 AND 7
GROUP BY day_since_install
ORDER BY day_since_install;


-- 11. Top Products by IAP Revenue
SELECT
    product_id,
    COUNT(*) AS purchases,
    COUNT(DISTINCT user_id) AS buyers,
    ROUND(SUM(revenue_usd), 2) AS total_revenue
FROM train
WHERE event_type = 'iap'
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;


-- 12. Ad Network Performance
SELECT
    network,
    COUNT(DISTINCT user_id) AS users,
    COUNT(*) AS impressions,
    ROUND(SUM(revenue_usd), 2) AS ad_revenue,
    ROUND(
        SUM(revenue_usd) / COUNT(*) * 1000,
        2
    ) AS revenue_per_1000_impressions
FROM train
WHERE event_type = 'ad_impression'
GROUP BY network
ORDER BY ad_revenue DESC;