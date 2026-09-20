#Row count check
SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM `product-lifecycle-submission.product_lifecycle_analytics.products`

UNION ALL

SELECT 'submissions', COUNT(*)
FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

UNION ALL

SELECT 'lifecycle_events', COUNT(*)
FROM `product-lifecycle-submission.product_lifecycle_analytics.lifecycle_events`

UNION ALL

SELECT 'regions', COUNT(*)
FROM `product-lifecycle-submission.product_lifecycle_analytics.regions`

UNION ALL

SELECT 'product_categories', COUNT(*)
FROM `product-lifecycle-submission.product_lifecycle_analytics.product_categories`

UNION ALL

SELECT 'submission_targets', COUNT(*)
FROM `product-lifecycle-submission.product_lifecycle_analytics.submission_targets`;

#data quality analysis
SELECT
  COUNT(*) AS total_submissions,

  COUNTIF(Product_ID IS NULL) AS missing_product_id,

  COUNTIF(Region_ID IS NULL) AS missing_region_id,

  COUNTIF(Submission_Type IS NULL) AS missing_submission_type,

  COUNTIF(Submission_Date IS NULL) AS missing_submission_date,

  COUNTIF(Approval_Date IS NULL) AS missing_approval_date,

  COUNTIF(Submission_Status IS NULL) AS missing_status,

  COUNTIF(Priority IS NULL) AS missing_priority,

  COUNTIF(Risk_Score IS NULL) AS missing_risk_score

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`;

#validating missing approval date

SELECT
  Submission_Status,
  COUNT(*) AS total_submissions,
  COUNTIF(Approval_Date IS NULL) AS missing_approval_dates,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Approval_Date IS NULL),
      COUNT(*)
    ), 2
  ) AS missing_approval_pct

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Submission_Status

ORDER BY missing_approval_dates DESC;

#checking 'unknown' values
SELECT
  Submission_Type,
  COUNT(*) AS total_submissions

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Submission_Type

ORDER BY total_submissions DESC;

# checking risk category
SELECT
  Risk_Category,
  COUNT(*) AS total_submissions

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Risk_Category

ORDER BY total_submissions DESC;

#checking orphan submissions with no matching products
SELECT COUNT(*) AS orphan_submissions
FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions` s
LEFT JOIN `product-lifecycle-submission.product_lifecycle_analytics.products` p
  ON s.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

-- Check submissions with no matching region
SELECT COUNT(*) AS orphan_submissions_regions
FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions` s
LEFT JOIN `product-lifecycle-submission.product_lifecycle_analytics.regions` r
  ON s.Region_ID = r.Region_ID
WHERE r.Region_ID IS NULL;


-- Check lifecycle events with no matching submission
SELECT COUNT(*) AS orphan_lifecycle_events
FROM `product-lifecycle-submission.product_lifecycle_analytics.lifecycle_events` e
LEFT JOIN `product-lifecycle-submission.product_lifecycle_analytics.submissions` s
  ON e.Submission_ID = s.Submission_ID
WHERE s.Submission_ID IS NULL;

#Overall Submission performance
SELECT
  COUNT(*) AS total_submissions,
  ROUND(AVG(Review_Days), 2) AS avg_review_days,
  ROUND(AVG(Target_Review_Days), 2) AS avg_target_review_days,
  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,
  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Delayed = True),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct,
  ROUND(AVG(Risk_Score), 2) AS avg_risk_score
FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`;

##Submission performance by region

SELECT
  r.Region,

  COUNT(*) AS total_submissions,

  ROUND(AVG(s.Review_Days), 2) AS avg_review_days,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(s.Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(s.Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct,

  ROUND(AVG(s.Risk_Score), 2) AS avg_risk_score

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions` s

JOIN `product-lifecycle-submission.product_lifecycle_analytics.regions` r
  ON s.Region_ID = r.Region_ID

GROUP BY r.Region

ORDER BY delay_rate_pct DESC;


##Submission performance by submission type

SELECT
  Submission_Type,

  COUNT(*) AS total_submissions,

  ROUND(AVG(Review_Days), 2) AS avg_review_days,

  ROUND(AVG(Target_Review_Days), 2) AS avg_target_days,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct,

  ROUND(AVG(Risk_Score), 2) AS avg_risk_score

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Submission_Type

ORDER BY delay_rate_pct DESC;

#Which lifecycle stage consumes the most time?
SELECT
  Lifecycle_Stage,

  COUNT(*) AS total_events,

  ROUND(AVG(Stage_Duration_Days), 2) AS avg_stage_duration_days,

  ROUND(
    SUM(Stage_Duration_Days), 2
  ) AS total_stage_duration_days

FROM `product-lifecycle-submission.product_lifecycle_analytics.lifecycle_events`

GROUP BY Lifecycle_Stage, Stage_Order

ORDER BY Stage_Order;

#risk category performance
SELECT
  Risk_Category,

  COUNT(*) AS total_submissions,

  ROUND(AVG(Risk_Score), 2) AS avg_risk_score,

  ROUND(AVG(Review_Days), 2) AS avg_review_days,

  ROUND(AVG(Target_Review_Days), 2) AS avg_target_days,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Risk_Category

ORDER BY avg_risk_score DESC;

#priority performance

SELECT
  Priority,

  COUNT(*) AS total_submissions,

  ROUND(AVG(Review_Days), 2) AS avg_review_days,

  ROUND(AVG(Target_Review_Days), 2) AS avg_target_days,

  ROUND(AVG(Risk_Score), 2) AS avg_risk_score,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY Priority

ORDER BY
  CASE Priority
    WHEN 'Critical' THEN 1
    WHEN 'High' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'Low' THEN 4
    ELSE 5
  END;

#monthly submission trend

SELECT
  FORMAT_DATE('%Y-%m', Submission_Date) AS submission_month,

  COUNT(*) AS total_submissions,

  ROUND(AVG(Review_Days), 2) AS avg_review_days,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct,

  ROUND(AVG(Risk_Score), 2) AS avg_risk_score

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions`

GROUP BY submission_month

ORDER BY submission_month;


#Regional × Submission Type hotspot analysis - Which combinations of region and submission type have the highest delay rates?

SELECT
  r.Region,
  s.Submission_Type,

  COUNT(*) AS total_submissions,

  ROUND(AVG(s.Review_Days), 2) AS avg_review_days,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(s.Submission_Delayed = TRUE),
      COUNT(*)
    ), 2
  ) AS delay_rate_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(s.Submission_Status = 'Approved'),
      COUNT(*)
    ), 2
  ) AS approval_rate_pct,

  ROUND(AVG(s.Risk_Score), 2) AS avg_risk_score

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions` s

JOIN `product-lifecycle-submission.product_lifecycle_analytics.regions` r
  ON s.Region_ID = r.Region_ID

GROUP BY
  r.Region,
  s.Submission_Type

HAVING COUNT(*) >= 100

ORDER BY
  delay_rate_pct DESC;


#highest risk submission

SELECT
  s.Submission_ID,
  p.Product_Name,
  c.Product_Category,
  r.Region,
  s.Submission_Type,
  s.Priority,
  s.Risk_Score,
  s.Risk_Category,
  s.Review_Days,
  s.Target_Review_Days,
  s.Submission_Status,
  s.Submission_Delayed

FROM `product-lifecycle-submission.product_lifecycle_analytics.submissions` s

JOIN `product-lifecycle-submission.product_lifecycle_analytics.products` p
  ON s.Product_ID = p.Product_ID

JOIN `product-lifecycle-submission.product_lifecycle_analytics.product_categories` c
  ON p.Product_Category_ID = c.Product_Category_ID

JOIN `product-lifecycle-submission.product_lifecycle_analytics.regions` r
  ON s.Region_ID = r.Region_ID

WHERE s.Risk_Category = 'High'

ORDER BY
  s.Risk_Score DESC,
  s.Submission_Delayed DESC,
  s.Review_Days DESC

LIMIT 20;


