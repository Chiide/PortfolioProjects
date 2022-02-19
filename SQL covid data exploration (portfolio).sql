SELECT * 
FROM Covid_deaths$
WHERE continent is not null
ORDER BY 3,4;

--SELECT * 
--FROM Covid_Vaccination$
--ORDER BY 3,4;

SELECT location, date, total_cases, new_cases,total_deaths,population
FROM Covid_deaths$
WHERE continent is not null
ORDER BY 1,2;

---Total cases vs Total deaths
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_rate
FROM Covid_deaths$
WHERE continent is not null
ORDER BY 1,2;

--- Percentage of the population that died as a result of covid in Nigeria
---Total cases vs Total deaths in Nigeria
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_rate
FROM Covid_deaths$
WHERE location like '%Nigeria%' 
ORDER BY 1,2;

--- Percentage of population that got covid in Nigeria.
---Total cases vs Population 
SELECT location, date,population,total_cases, (total_cases/population)*100 as Death_rate
FROM Covid_deaths$
WHERE location like '%Nigeria%'
ORDER BY 1,2;

--- Percentage of population that got covid in the world.
---Total cases vs Population
SELECT location, date,population,total_cases, (total_cases/population)*100 as Percentage_affected
FROM Covid_deaths$
WHERE continent is not null
ORDER BY 1,2;

---Countries with highest infection rates per population.
SELECT location,population, max(total_cases)as highestcase_count, max(total_cases/population)*100 as Percentage_affected
FROM Covid_deaths$
WHERE continent is not null
Group by location,population
ORDER BY Percentage_affected desc;

---Countries with highest death rate per population
SELECT location, max(cast(total_deaths as int))as Totaldeathscount
FROM Covid_deaths$
WHERE continent is not null
Group by location
ORDER BY Totaldeathscount desc;

---Continent with the highest death rate.
SELECT location, max(cast(total_deaths as int))as Totaldeathscount
FROM Covid_deaths$
WHERE continent is null
Group by location
ORDER BY Totaldeathscount desc;

---Creating view of continent with the highest death rate

Create view Highestdeathratecontinent as
 SELECT location, max(cast(total_deaths as int))as Totaldeathscount
 FROM Covid_deaths$
 WHERE continent is null
 Group by location

 select *
 from Highestdeathratecontinent

---GLOBAL DEATH RATE

SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as death_rate
FROM Covid_deaths$
WHERE continent is not null
---Group by date
ORDER BY 1,2;

SELECT *
FROM Covid_deaths$ as Deaths
JOIN Covid_Vaccination$ as Vaccine
ON Deaths.location = Vaccine.location
AND Deaths.date = Vaccine.date;

---Total people vaccinated in the world.

Select Deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(bigint,vaccine.new_vaccinations)) OVER (Partition by deaths.Location 
Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths$ Deaths
Join PortfolioProject..Covid_Vaccination$ Vaccine
	On deaths.location = Vaccine.location
	and deaths.date = Vaccine.date
where deaths.continent is not null 
order by 2,3

---Using CTE

With popvsvac (continent,location, date, population,new_vaccinations,RollingPeoplevaccinated)
as 
 (Select Deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(bigint,vaccine.new_vaccinations)) OVER (Partition by deaths.Location 
Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths$ Deaths
Join PortfolioProject..Covid_Vaccination$ Vaccine
	On deaths.location = Vaccine.location
	and deaths.date = Vaccine.date
where deaths.continent is not null)

Select *,(RollingPeoplevaccinated/population)*100
FROM popvsvac

---TEMP table
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated 
 Select Deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(bigint,vaccine.new_vaccinations)) OVER (Partition by deaths.Location 
Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths$ Deaths
Join PortfolioProject..Covid_Vaccination$ Vaccine
	On deaths.location = Vaccine.location
	and deaths.date = Vaccine.date
--where deaths.continent is not null)

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

---Creating view to use for visualization

Create View PercentPopulationVaccinated as
Select Deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(bigint,vaccine.new_vaccinations)) OVER (Partition by deaths.Location 
Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths$ Deaths
Join PortfolioProject..Covid_Vaccination$ Vaccine
	On deaths.location = Vaccine.location
	and deaths.date = Vaccine.date
   where deaths.continent is not null

  Select * 
  from PercentPopulationVaccinated







