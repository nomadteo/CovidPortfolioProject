select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2;

-- Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%'
order by 1.2;

-- Percentage of population got Covid
select location, date, total_cases, total_deaths, population, (total_cases/population)*100 as CasePercentage
from coviddeaths
where location like '%states%'
order by 1.2;

-- Countries with highest infection rate compared to population
select location, population, max(total_cases) as MaxCovidCases, max((total_cases/population))*100 as CasePercentage
from coviddeaths
where continent is not null
group by location, population
order by CasePercentage DESC;

-- Countries with highest deaths rate compared to population
select location, population, max(total_deaths) as HighestDeathRate, max((total_deaths/population))*100 as DeathPercentage
from coviddeaths
where continent is not null
group by location, population
order by DeathPercentage DESC;

-- Countries with the Total highest death
select location, max(total_deaths) as TotalDeaths
from coviddeaths
where continent is not null
group by location
order by TotalDeaths desc;

-- Total deaths by Continent
select location, max(total_deaths) as TotalDeathsCont
from coviddeaths
where continent is null
group by location
order by TotalDeathsCont desc;

-- Total cases by Continent
select location, max(total_cases) as TotalCasesCont
from coviddeaths
where continent is null
group by location
order by TotalCasesCont desc;

-- Global Numbers
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/ sum(new_cases)*100 as GlobalDeathPercentage
from coviddeaths;

-- Population vs Vaccinations
with PopVac(continent, location, date, population, newvaccinations, pplvaccinated)
as
(
select dea.continent, dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y'), dea.population, cast(vac.new_vaccinations as signed)
       , sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y'))
as pplvaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
    )
select *, (pplvaccinated/population)*100
from PopVac


create view PercentPopulationVaccinated as
select dea.continent, dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y'), dea.population, cast(vac.new_vaccinations as signed)
       , sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y'))
as pplvaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated

