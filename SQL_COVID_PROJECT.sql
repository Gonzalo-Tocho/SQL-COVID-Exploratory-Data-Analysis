

select * 
from CovidProject..CovidDeaths
order by 3, 4

select *
from CovidProject..CovidVaccinations


-- Total Cases and Deaths by Country

select location, max(total_cases) as Total_Cases, max(cast(total_deaths as int)) Total_Deaths
from CovidProject..CovidDeaths
where continent is not null
group by location
order by Total_Cases desc

-- Total Cases by Country per day

select location,  convert(date, date) as date, max(total_cases) as Total_cases
from CovidProject..CovidDeaths
where continent is not null
group by location, date
order by 1, 2

-- Total deaths by Country per day

select location, convert(date, date) as date, max(total_cases) as Total_cases, sum(cast(new_deaths as int))as Total_Deaths
from CovidProject..CovidDeaths
where continent is not null
group by location, date
order by 1, 2

-- Infected Rate by Country

select location, population, max(total_cases) as Total_Cases, round(max((total_cases)/population)*100, 2) as Infected_Rate
from CovidProject..CovidDeaths
where continent is not null
group by location, population
order by Infected_Rate desc

-- Mortality Rate by Country

select location, max(total_cases) as Total_Cases,  max(cast(total_deaths as int)) as Total_Deaths, round(max(cast(total_deaths as int))/max(total_cases)*100, 2) as Mortality_Rate
from CovidProject..CovidDeaths
where continent is not null
group by location, population
order by Mortality_Rate desc 

-- Total Cases and deaths by Continent

select location, max(total_cases) as Total_Cases,  max(cast(total_deaths as int)) as Total_Deaths
from CovidProject..CovidDeaths
where continent is null and location not in ('World', 'European Union', 'International')
group by location
order by Total_Cases desc

-- Infected Rate by Continent

select location, max(total_cases) as Total_Cases,  round(max((total_cases) / population)*100, 2) as Infected_Rate
from CovidProject..CovidDeaths
where continent is null and location not in ('World', 'European Union', 'International')
group by location
order by Total_Cases desc

-- Mortality Rate by Continent

select location, max(total_cases) as Total_Cases,  max(cast(total_deaths as int)) as Total_Deaths, round(max(cast(total_deaths as int))/max(total_cases)*100, 2) as Mortality_Rate
from CovidProject..CovidDeaths
where continent is null and location not in ('World', 'European Union', 'International')
group by location
order by Total_Cases desc

-- Global Numbers

 select location,  format(population, 'N0') AS Population,
 format(max(total_cases), 'N0') as Total_Cases, 
 format(max(cast(total_deaths as int)), 'N0') as Total_Deaths, 
 round(max((total_cases) / population)*100, 2) as Infected_Rate, 
 round(max(cast(total_deaths as int))/max(total_cases)*100, 2) as Mortality_Rate
 from CovidProject..CovidDeaths
where continent is null and location='World'
group by location, population
order by Total_Cases desc


-- Shows Percentage of Population that has recieved at least one Covid Vaccine
-- Also Vaccinated People by date

with PopvsVac (continent, location, date, population, new_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, convert(date, dea.date) as date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVac
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *, round((RollingPeopleVaccinated/Population)*100, 4) as Vaccinated_Rate
From PopvsVac

