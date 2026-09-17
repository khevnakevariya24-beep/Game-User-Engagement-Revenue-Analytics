>> Game User Engagement & Revenue Analytics

>> Project Overview

This project analyzes mobile game user behavior, engagement, monetization, acquisition channels, and customer lifetime value (LTV).

The goal is to transform raw gaming event data into meaningful business insights that can help understand user value and revenue performance.

---

>> Objectives

- Analyze overall game revenue and user activity
- Compare revenue across platforms and countries
- Evaluate acquisition channel performance
- Analyze user engagement after installation
- Identify paying and non-paying users
- Calculate ARPPU and paying-user percentage
- Segment users based on Lifetime Value (LTV)
- Analyze IAP and advertisement monetization
- Build an interactive Power BI dashboard

---

>> Dataset

The project uses a Mobile Game LTV dataset containing:

- 4,421,752 event records
- 28,883 unique users
- 15 columns

>> Important Features

- `user_id`
- `platform`
- `country_tier`
- `channel_tier`
- `install_day`
- `day_since_install`
- `event_type`
- `event_name`
- `product_id`
- `network`
- `revenue_usd`
- `ltv_d8_d180`

---

>> Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- SQL / MySQL
- MySQL Workbench
- Microsoft Power BI
- GitHub

---

>> Key KPIs

| KPI | Value |
|---|---:|
| Total Users | 28,883 |
| Total Revenue | $116,235.74 |
| IAP Revenue | $97,891.77 |
| Ad Revenue | $18,343.97 |
| Paying Users | 966 |
| Paying User % | 3.34% |
| ARPPU | $101.34 |
| Total User-Level LTV | $395,791.79 |
| Very High LTV Users | 338 |
| Very High LTV LTV Share | 81.02% |

---

>> Analysis Performed

>> Revenue Analysis

Revenue was analyzed by:

- Platform
- Country
- Acquisition channel
- Day since installation
- IAP products
- Advertisement networks

>> User Analysis

The project evaluates:

- Total users
- Paying users
- Non-paying users
- Paying-user percentage
- Average Revenue Per Paying User (ARPPU)

>> LTV Analysis

Users were segmented into:

- Zero LTV
- Low LTV
- Medium LTV
- High LTV
- Very High LTV

User-level LTV was calculated using the maximum `ltv_d8_d180` value for each user to avoid counting repeated LTV values multiple times.

---

>> Business Insights

### 1. Platform Revenue

Android generated approximately 60.6% of total revenue, while iOS generated approximately 39.4%.

### 2. Country Performance

Revenue varied significantly across markets. Some countries generated high total revenue, while countries such as CZ and NL showed higher revenue per user.

### 3. Acquisition Channels

Channel `92247aa9` generated the highest overall revenue. Channel performance was evaluated using both total revenue and revenue per user.

### 4. User Engagement

Day 0 had the highest number of active users. However, events per active user increased on later days, reaching approximately 50–52 events per user.

### 5. Revenue Timing

Day 2 generated the highest revenue at approximately $24,408.67, while Day 4 recorded the highest events per user.

### 6. LTV Concentration

Only 338 Very High LTV users contributed approximately 81.02% of total user-level LTV, showing that customer value is concentrated among a relatively small group of users.

### 7. Monetization

In-app purchases were the major monetization source, contributing approximately $97,891.77 compared with $18,343.97 from advertisements.

Only 3.34% of users were paying users, with an ARPPU of approximately $101.34.

---

>> Power BI Dashboard

The interactive dashboard contains:

- KPI cards
- Revenue by Platform
- Revenue by Country
- Revenue by Acquisition Channel
- Revenue by Day Since Install
- Total LTV by Customer Segment
- Paying vs Non-Paying Users

![Power BI Dashboard](dashboard/game_analytics_dashboard.png)

---

>> Project Structure

```text
Game-User-Engagement-Revenue-Analytics/
│
├── README.md
│
├── notebooks/
│   └── game_user_analysis.ipynb
│
├── sql/
│   └── analysis_queries.sql
│
├── dashboard/
│   └── game_analytics_dashboard.png
│
└── images/