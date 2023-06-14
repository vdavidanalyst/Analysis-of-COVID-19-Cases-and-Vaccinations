select * 
FROM PortFolioProjects..CovidDeaths$
where continent is not null 
ORDER BY 3,4 

--select * 
--FROM PortFolioProjects..CovidVaccinations$
--ORDER BY 3,4 

--select the data that will need

select location, date, total_cases, new_cases,total_deaths, population
from PortFolioProjects..CovidDeaths$
where continent is not null
order by 1,2

--looking at total cases vs total deaths
--shows the likelihood of dying in your country
select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortFolioProjects..CovidDeaths$
where location like '%states%' and continent is not null
order by 1, 2

--looking at the total cases vs the percentage
--shows population that got covid

select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from PortFolioProjects..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
order by 1, 2

--countries with highest infection rate compared to population 

select location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortFolioProjects..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by population, location
order by PercentPopulationInfected desc

--showing the countries with the higest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortFolioProjects..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by location
order by TotalDeathCount desc


--breakdown by continents

--select location, MAX(cast(total_deaths as int)) as TotalDeathCount
--from PortFolioProjects..CovidDeaths$
----where location like '%Nigeria%'
--where continent is null
--group by location
--order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortFolioProjects..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount desc

--showing the continents with the highest deathcount per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortFolioProjects..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount desc


--global numbers

select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortFolioProjects..CovidDeaths$
where continent is not null 

order by 1,2
--aggregate functions for the above

select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100  as DeathPercentage
from PortFolioProjects..CovidDeaths$
where continent is not null 
group by date 
order by 1,2

--just the total deaths
select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100  as DeathPercentage
from PortFolioProjects..CovidDeaths$
where continent is not null  
order by 1,2


--checking total population vs vacinations
--select *
--from PortFolioProjects..CovidDeaths$ dea
--join PortFolioProjects..CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortFolioProjects..CovidDeaths$ dea
join PortFolioProjects..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2

--to get a rolling count

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) 
from PortFolioProjects..CovidDeaths$ dea
join PortFolioProjects..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
order by 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeolpleVaccinated,
FROM PortFolioProjects..CovidDeaths$ dea
JOIN PortFolioProjects..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1, 2



--CTE using the RollingPeolpleVaccinated max number/ population to know the population vaccinated 


WITH popvsVac (continent, location, date, population,new_vaccinations, RollingPeolpleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeolpleVaccinated
FROM PortFolioProjects..CovidDeaths$ dea
JOIN PortFolioProjects..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 1, 2
)
select *, (RollingPeolpleVaccinated/population)*100
from popvsVac


--Temp Table

IF OBJECT_ID('tempdb..#PercentPopulationVaccinated', 'U') IS NOT NULL
    DROP TABLE #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeolpleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeolpleVaccinated
FROM PortFolioProjects..CovidDeaths$ dea
JOIN PortFolioProjects..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 1, 2

select *, (RollingPeolpleVaccinated/population)*100
from #PercentPopulationVaccinated



--creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeolpleVaccinated
FROM PortFolioProjects..CovidDeaths$ dea
JOIN PortFolioProjects..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 1, 2

select * 
from PercentPopulationVaccinated