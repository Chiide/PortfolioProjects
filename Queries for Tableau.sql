Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_deaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Covid_deaths$
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_deaths$
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_deaths$
Group by Location, Population, date
order by PercentPopulationInfected desc

Select Deaths.continent, deaths.location, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(bigint,vaccine.new_vaccinations)) OVER (Partition by deaths.Location 
Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths$ Deaths
Join PortfolioProject..Covid_Vaccination$ Vaccine
	On deaths.location = Vaccine.location
	and deaths.date = Vaccine.date
   where deaths.continent is not null

