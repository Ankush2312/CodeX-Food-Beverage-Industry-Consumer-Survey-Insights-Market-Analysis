# Who prefers energy drink more? (male/female/non-binary?)
select 
	gender, 
    count(*) as response_cnt 
from dim_respondents
group by gender
order by response_cnt desc;

# Which age group prefers energy drinks more? 
select 
	age, 
    count(*) as response_cnt 
from dim_respondents
group by age
order by response_cnt desc;

# Which type of marketing reaches the most Youth (15-30)? 
with cte1 as (
	SELECT 
		Marketing_channels, 
		count(case when age = "15-18" then age end) as A, 
		count(case when age = "19-30" then age end) as B
	FROM fact_survey_responses s
	join dim_respondents r on s.Respondent_ID = r.Respondent_ID
	where age in ("15-18","19-30")
	group by Marketing_channels
)
select 
	Marketing_channels, 
    A + B as Total_Youth
from cte1
order by Total_Youth desc;

# What are the preferred ingredients of energy drinks among respondents? 
SELECT 
	ingredients_expected,  
    round(respondents_cnt/(select sum(respondents_cnt) from ingredients_expected)*100,1) as respondents_pct
FROM ingredients_expected
order by respondents_pct desc;

# What packaging preferences do respondents have for energy drinks? 
select 
	packaging_preference, 
    round(respondents_cnt/(select sum(respondents_cnt) from packaging_preference)*100,1) as respondents_pct
from packaging_preference
order by respondents_pct desc;

# Who are the current market leaders? 
select 
	Current_brands, 
    round(customers_cnt/(select sum(customers_cnt) from brands_market_share)*100,1) as Market_share
from brands_market_share
order by Market_share desc;

# What are the primary reasons consumers prefer those brands over ours? 
SELECT 
	Current_brands, 
	count(case 
		when Reasons_for_choosing_brands = "Availability" then Respondent_ID end) as Availability, 
	count(case 
		when Reasons_for_choosing_brands = "Brand Reputation" then Respondent_ID end) as Brand_Reputation, 
	count(case 
		when Reasons_for_choosing_brands = "Effectiveness" then Respondent_ID end) as Effectiveness, 
	count(case 
		when Reasons_for_choosing_brands = "Other" then Respondent_ID end) as Other, 
	count(case 
		when Reasons_for_choosing_brands = "Taste/Flavor preference" then Respondent_ID end) as Taste_Flavor_preference
FROM fact_survey_responses
where Current_brands is not null
group by current_brands;

# Which marketing channel can be used to reach more customers? 
select 
	Marketing_channels,  
	count(Respondent_ID) as respondents_cnt
from fact_survey_responses 
group by Marketing_channels 
order by respondents_cnt desc;

# How effective are different marketing strategies and channels in reaching our customers? 
select 
	Marketing_channels,  
	count(Respondent_ID) as CodeX_consumers
from fact_survey_responses 
where current_brands = "CodeX" 
group by Marketing_channels 
order by CodeX_consumers desc;

# What do people think about our brand? (overall rating) 
Select 
	Brand_perception, 
    round(respondents_cnt/(select sum(respondents_cnt) from brand_perception)*100,1) as respondents_pct
from brand_perception
order by respondents_pct desc;

# Which cities do we need to focus more on? 
SELECT 
	City, 
    round((Positive+Neutral)/(Positive+neutral+negative)*100,1) as positive_neutral_pct
FROM city_wise_brand_perception 
order by positive_neutral_pct desc;

# Where do respondents prefer to purchase energy drinks? 
select 
	Purchase_location, 
	round(respondent_cnt/(select sum(respondent_cnt) from purchase_location)*100,1) as respondents_pct
from purchase_location
order by respondents_pct desc;

# What are the typical consumption situations for energy drinks among respondents? 
select 
	Typical_consumption_situations as Consumption_situations, 
	count(Respondent_ID) as respondents_cnt
from fact_survey_responses 
group by Consumption_situations 
order by respondents_cnt desc;

# How price range influences respondent’s purchase decisions? 
select 
	Price_range, 
    round(respondent_cnt/(select sum(respondent_cnt) from price_range)*100,1) as respondents_pct 
from price_range
order by respondents_pct desc;

# Which area of business should we focus more on our product development? 
select 
	City,
    count(case 
		when Reasons_for_choosing_brands = "Availability" then Respondent_ID end) as Availability, 
	count(respondent_ID) as Total_Customers
from fact_survey_responses
join dim_respondents using (respondent_id)
join dim_cities using (city_id)
where current_brands = "CodeX"
group by city;