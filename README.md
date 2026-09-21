# Lifescience Product Submission & Lifecycle Management Analytics

## Project Overview

This project analyzes product submissions, regulatory review performance, lifecycle stages, risk, delays, approval outcomes, regional differences, and data quality.

The project simulates a product and regulatory operations environment where organizations need to understand how submissions move through the lifecycle and where delays or operational bottlenecks occur.

The analysis combines BigQuery, Python, and Power BI to create an end-to-end analytics workflow.

## Business Objective

The objective of this project is to answer key business questions such as:

- How many product submissions are being processed?
- What is the overall approval rate?
- What is the average regulatory review time?
- How frequently are submissions delayed?
- Which regulatory areas have higher delay rates?
- Which submission types require longer review periods?
- How does risk level relate to review duration and delays?
- Which regions and submission types form operational hotspots?
- How long does each lifecycle stage take?
- Are there data-quality issues that could affect reporting?
- Are performance patterns consistent across product categories and business units?

## Dataset

The project uses six related datasets.

| Dataset                | Description                           | Records |

| products.csv           | Product master data                   | 15,000 |
| submissions.csv        | Product submission records            | 30,000 |
| lifecycle_events.csv   | Lifecycle stage events                | 180,000 |
| regions.csv            | Region and regulatory area mapping    | 8 |
| product_categories.csv | Product category reference data       | 6 |
| submission_targets.csv | Target review time by submission type | 4 |

The datasets were loaded into Google BigQuery for validation and SQL analysis.

## Technology Stack

- Google BigQuery
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Power BI
- GitHub

## Project Workflow


Raw Dataset
    ↓
BigQuery Data Validation
    ↓
SQL Analysis
    ↓
Python Exploratory Data Analysis
    ↓
Data Enrichment
    ↓
Power BI Dashboard
    ↓
Business Insights


## Data Model

The main relationships are:

Products
    | Product_ID
Submissions
    | Submission_ID
Lifecycle Events

Submissions
    | Region_ID
Regions

Products
    | Product_Category_ID
Product Categories

Submission Type
    ↓
Submission Targets

## Data Validation

The BigQuery validation confirmed:

* 30,000 submission records
* 15,000 product records
* 180,000 lifecycle event records
* No orphaned Product_ID values in submissions
* No orphaned Region_ID values in submissions
* No orphaned Submission_ID values in lifecycle events

The Python analysis also identified data-quality issues in categorical fields.

### Missing and Invalid Values

There were:

* 80 submissions with an Unknown submission type
* 70 submissions with the invalid risk category value Unknow
* 7,918 missing approval dates
* 1,173 submissions with missing approval dates even though their status was not Under Review

For business analysis, the 150 records containing invalid submission-type or risk-category values were excluded from category-specific analysis while the original records were retained.

## Key Performance Metrics

Overall submission performance:

**Metric                                     -     Result**
| Total submissions                          -     30,000 
| Average review time                        - 74.61 days 
| Average target review time                 - 86.38 days 
| Approval rate                              -     53.63% 
| Delay rate                                 -     25.56% 
| Average risk score                         -      42.78 
| Unique products represented in submissions -     12,996 

Approval and delay rates are not complements because the dataset includes statuses such as Under Review and Withdrawn.

## Key Analytical Findings:-

### Regulatory Area Performance

Delay rates varied across regulatory areas.

| Regulatory Area | Average Review Days | Delay Rate | Approval Rate |

| TGA             |               79.91 |     35.18% |        47.06% |
| EU              |               76.05 |     27.82% |        51.59% |
| Health Canada   |               75.82 |     27.78% |        52.50% |
| HSA             |               75.26 |     26.64% |        52.64% |
| MHRA            |               73.69 |     23.29% |        55.20% |
| FDA             |               70.16 |     18.36% |        59.22% |

These are observed differences in the dataset and should not be interpreted as evidence that a specific regulatory authority causes delays.

### Submission Type Performance

Submission type showed a substantial difference in review duration and delay rates.

| Submission Type    | Average Review Days | Target Days | Approval Rate | Delay Rate |

| New Product        |               96.66 |         120 |        67.81% |      5.74% |
| Product Extension  |               76.98 |          90 |        58.76% |     18.55% |
| Label Update       |               57.21 |          60 |        41.16% |     42.65% |
| Post-Market Update |               47.57 |          45 |        31.71% |     56.34% |

Post-Market Updates showed the highest delay rate and were the only valid submission type averaging above its target review time.

### Risk Analysis

Higher-risk submissions were associated with longer review times and higher delay rates.

| Risk Category | Average Risk Score | Average Review Days | Delay Rate |

| Low           |              24.09 |               70.34 |     18.40% |
| Medium        |              47.67 |               75.73 |     27.16% |
| High          |              74.87 |               81.90 |     38.72% |

The correlation between Risk Score and Review Days was 0.177, indicating a weak positive relationship.

This means higher risk is associated with somewhat longer review times, but risk score alone does not explain most of the variation in review duration.

### Regional Performance

Regional performance also varied.

Australia had:

* 79.91 average review days
* 35.18% delay rate
* 47.06% approval rate

The United States had:

* 70.16 average review days
* 18.36% delay rate
* 59.22% approval rate

Average risk scores were relatively similar across regions, so regional differences in this dataset are not simply explained by average risk score.

### Region and Submission Type Hotspots

The strongest combined hotspot identified in the analysis was:

Australia + Post-Market Update

Results:

* 489 submissions
* 52.42 average review days
* 70.55% delay rate
* 22.29% approval rate

Other high-delay Post-Market Update combinations included Germany and France.

This demonstrates why analyzing region and submission type together can reveal patterns that are less visible when each dimension is analyzed separately.

### Lifecycle Analysis

Average lifecycle stage duration:

| Lifecycle Stage        - Average Duration Days |

| Development            -                120.03 |
| Post-Market Monitoring -                 90.05 |
| Regulatory Review      -                 74.61 |
| Submission Preparation -                 44.95 |
| Approval               -                 14.97 |
| Regulatory Submission  -                 12.03 |

Development was the longest overall lifecycle stage, while Regulatory Review was a major regulatory-process component of total duration.

### Product Category Analysis

Product categories showed relatively small performance differences.

Average delay rates ranged from approximately 24.51% to 27.03%, while average review times remained close to 75 days.

This suggests that product category was not a major differentiator of submission performance in this dataset.

### Business Unit Analysis

Business unit performance was also relatively consistent.

Delay rates ranged from:

25.04% to 26.38%

Average review times ranged from:

74.41 to 74.83 days

This indicates limited variation across business units compared with the larger differences observed across regulatory areas and region-submission-type combinations.

## Power BI Dashboard

The Power BI dashboard provides an interactive executive view of submission and lifecycle performance.

The dashboard includes:

* Total submissions
* Approval rate
* Average review time
* Delay rate
* Unique products
* Delay rate by regulatory area
* Average review time by submission type
* Submission status
* Monthly submission trends
* Submissions by product category
* Delay rate by business unit
* Region and submission type analysis
* Interactive slicers for filtering the analysis



## Skills Demonstrated

### SQL

* BigQuery data loading
* Data validation
* Multi-table joins
* Aggregation
* Conditional calculations
* Window and trend analysis
* Data-quality checks
* Regional and submission-type analysis

### Python

* Pandas data manipulation
* Data cleaning
* Data enrichment
* Exploratory data analysis
* Correlation analysis
* Grouped performance analysis
* Matplotlib visualization
* Seaborn visualization
* Exception analysis

### Power BI

* Data import
* DAX measures
* KPI cards
* Interactive slicers
* Conditional formatting
* Matrix heatmap analysis
* Trend analysis
* Dashboard design
* Business-focused data storytelling

## Business Value

The analysis provides a structured view of product submission operations and highlights where additional investigation may be useful.

The dashboard can support questions around:

* Regulatory review performance
* Submission delays
* Risk-related operational patterns
* Regional differences
* Submission-type bottlenecks
* Lifecycle duration
* Data-quality monitoring
* Operational prioritization

The findings describe patterns in the analytical dataset and do not establish causal relationships.

**##Key Insights**
Post-Market Updates show the highest delay rate at 56.34%, with an average review time of 47.57 days against a 45-day target.
Australia has the highest overall delay rate at 35.18% and the longest average review time at 79.91 days. Its approval rate is 47.06%.
The Australia + Post-Market Update combination is the strongest operational hotspot, with a 70.55% delay rate and 22.29% approval rate.
Higher-risk submissions are associated with longer reviews and higher delays. High-risk submissions average 81.88 review days and a 38.70% delay rate, compared with 70.33 days and 18.42% for low-risk submissions.
Risk score and review time have a positive but weak relationship, with a correlation of 0.177. This suggests risk is related to review duration, but does not explain most of the variation.
Regulatory Review is the main regulatory-process stage, averaging 74.61 days. Development is the longest lifecycle stage overall at approximately 120 days.
Submission performance varies substantially by region, while average risk scores remain relatively similar. This indicates that regional processes may be an important area for further investigation.
Data quality requires attention. There are 7,918 missing approval dates, including 1,173 records where the submission status is not Under Review.

**##Recommendations**
Review the Post-Market Update workflow to identify causes of delays, particularly in Australia, Germany, and France.
Investigate Australia-specific regulatory processes, documentation requirements, review queues, and resource allocation.
Introduce additional monitoring for high-risk submissions so that potential delays can be identified earlier.
Compare regulatory workflows across regions to identify process differences associated with review-time variation.
Establish data-quality rules for Approval_Date so that missing values are consistent with Submission_Status.
Monitor Region × Submission Type combinations rather than relying only on overall regional or submission-type metrics.
Track review performance against the target review time, rather than evaluating review duration alone. This gives better context for operational performance.
Create recurring KPI monitoring for delay rate, approval rate, review variance, and high-risk submissions to identify changes over time.

**##Business takeaway**

The analysis indicates that submission delays are concentrated around specific combinations of region and submission type, particularly Post-Market Updates in Australia. Risk level is also associated with review performance, while regional differences remain visible even with broadly similar risk profiles. These findings provide a basis for targeted process investigation, workload planning, and data-quality improvement.

## Conclusion

This project demonstrates an end-to-end analytics workflow starting from raw relational datasets and progressing through BigQuery validation, SQL analysis, Python exploratory analysis, data enrichment, and Power BI dashboard development.

The analysis identified meaningful variation in regulatory performance, submission types, risk categories, and region-submission-type combinations while also documenting data-quality limitations.

The final dashboard provides an interactive view of product submission and lifecycle performance for operational analysis and decision support.
