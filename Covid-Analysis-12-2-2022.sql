-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From CovidDeaths$
Where location like '%nether%' -- '%greece%'
and continent is not null 
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (cast(total_cases as float)/population)*100 as PercentPopulationInfected
From CovidDeaths$
Where location like '%nether%' -- '%greece%'
order by 1,2

-- Compare countries infection by changing the location

select top 1 location, date, total_cases, population, round((cast(total_cases as float)/population)*100,2) as case_perc
-- this shows % population infected
from CovidDeaths$
where location like '%nether%' 
order by case_perc desc; 

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
Max((cast(total_cases as float)/population))*100 as PercentPopulationInfected
From CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest number of deaths per Population

Select Location, MAX(cast(Total_deaths as float)) as TotalDeathCount
From CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Continent with the most deaths per population

Select continent, MAX(cast(Total_deaths as float)) as TotalDeathCount
From CovidDeaths$
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(cast(new_cases as float)) as total_cases, 
 SUM(cast(new_deaths as float)) as total_deaths, 
 SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
From CovidDeaths$
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations
-- Show percentage of population took at least the first vaccine shot
-- People who get 2 or 3 shots are added to the total amount

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%greece%'
order by 2,3

-- What is the percentage of people get vaccinated over the dates

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From  CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



