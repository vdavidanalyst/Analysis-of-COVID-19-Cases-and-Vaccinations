# Project Title: Analysis of COVID-19 Cases and Vaccinations

# Introduction:
  The "Analysis of COVID-19 Cases and Vaccinations" project focuses on analyzing data related to COVID-19 cases and vaccinations. The project utilizes two datasets: CovidDeaths$ and CovidVaccinations$ from the PortFolioProjects database. The objective is to gain insights into the global impact of the pandemic, including total cases, total deaths, death percentages, population percentages affected, and vaccination progress.

# Objectives:
- Calculate the likelihood of dying from COVID-19 in each country.
- Analyze the population percentage affected by COVID-19 in each country.
- Identify countries with the highest infection rates compared to their population.
- Determine countries with the highest death counts per population.
- Analyze COVID-19 cases, deaths, and death percentages globally.
- Track the cumulative number of people vaccinated by country and calculate the percentage of the population vaccinated.
- Store the data in a view for future visualization.

# Project Workflow:
# Data Preparation:
- Select data from the CovidDeaths$ table where the continent is not null and order it by location and date.
- Retrieve relevant columns: location, date, total_cases, new_cases, total_deaths, and population.
# Likelihood of Dying:
- Calculate the death percentage in countries with "states" in their name.
- Calculate the death percentage as (total_deaths/total_cases)*100.
- Order the results by location and date.
# Population Percentage Affected:
- Calculate the population percentage affected by COVID-19.
- Calculate the percentage as (total_cases/population)*100.
- Order the results by location and date.
# Highest Infection Rates:
- Identify countries with the highest infection rates compared to their population.
- Group the data by population and location.
- Calculate the percentage of the population infected as (total_cases/population)*100.
- Order the results by the percentage population infected in descending order.
# Highest Death Counts:
- Identify countries with the highest death counts per population.
- Group the data by location.
- Calculate the maximum total death count for each country.
- Order the results by the total death count in descending order.
# Breakdown by Continents:
- Analyze the total death count by continent.
- Group the data by continent.
- Calculate the maximum total death count for each continent.
- Order the results by the total death count in descending order.
# Global Numbers:
- Analyze global COVID-19 cases, total deaths, and death percentages.
- Order the results by date and total cases.
# Aggregate Functions:
- Calculate the total cases, total deaths, and death percentages using aggregate functions.
- Group the data by date.
- Order the results by date and total cases.
# Checking Population vs. Vaccinations:
- Retrieve data on population and new vaccinations from both the CovidDeaths$ and CovidVaccinations$ tables.
- Join the tables on location and date.
- Order the results by continent and location.
# Rolling Count of People Vaccinated:
- Calculate the rolling count of people vaccinated using a cumulative sum.
- Partition the data by location and order it by location and date.
# CTE and Temp Table:
- Use a common table expression (CTE) or a temporary table to store the data on population, vaccinations, and the rolling count of vaccinated people.
- Calculate the percentage of the population vaccinated as (RollingPeolpleVaccinated/population)*100.
- Retrieve the data from the CTE or temporary table.
# Creating a View:
- Create a view named "PercentPopulationVaccinated" to store the data on population, vaccinations, and the rolling count of vaccinated people.
- Include a WHERE clause to filter the data by continent.
- Retrieve the data from the view.


# Conclusion:
  The "Analysis of COVID-19 Cases and Vaccinations" project provides valuable insights into the global impact of the pandemic. By analyzing COVID-19 cases, deaths, death percentages, and vaccination data, this project allows for a comprehensive understanding of the virus's effects on different countries and continents. The project employs SQL queries to perform data manipulation and aggregation, facilitating data-driven decision-making and visualization.




