select * 
from PortfolioProject..coviddeath


select * 
from PortfolioProject..coviddeath
where Location like 'world%' 
order by 3,4

--select * 
--from PortfolioProject..covidvac
--order by 3,4 

--select the data we are going to be using

select Location,date, total_cases, new_cases, total_deaths, population
from PortfolioProject..coviddeath
where continent is not null
order by 1,2

--total cases vs total deaths
--Likelihood of dying per 100 covid infection in india

select Location,date, total_cases, total_deaths, total_deaths/total_cases*100 as deathpercentage
from PortfolioProject..coviddeath
where Location like 'india%' and continent is not null
order by 1,2

-- deadliest days in worl
--select * 
--from PortfolioProject..covidvac
--order by 3,4 
select date, new_cases, new_deaths, new_deaths/new_cases*100 as dailydeathpercentage
from PortfolioProject..coviddeath
where Location like 'india%' and new_cases != 0
order by 4 desc



--total cases vs popoulation
-- what percentage of population got covid

select Location,date, total_cases, population, total_cases/population*100 as covidpercentage
from PortfolioProject..coviddeath
where Location like 'india%' and continent is not null
order by 1,2

--looking at countries with highest infection rate
select Location, max(total_cases) as totalcases, population, max(total_cases/population*100) as covidpercentage
from PortfolioProject..coviddeath
where continent is not null
group by population, Location
order by covidpercentage desc

--looking at countries with highest death 
 select Location, max(cast (total_deaths as int))as highestdeath
from PortfolioProject..coviddeath
where continent is not null
group by Location
order by highestdeath desc

--analysis by continent (by creating a view) 
--if we look at the data, we see that there are numeric data for each continent(location) 
--and these continent(location) has NULL value in continent column hence the continent is null clause
create view death_by_continent
as
select location, max(cast (total_deaths as int))as highestdeath
from PortfolioProject..coviddeath
where continent is null
group by location
--looking at the view that was created
select * from death_by_continent
order by highestdeath desc

-- global numbers per day

select date, total_cases, total_deaths, total_deaths/total_cases*100 as deathpercentage
from PortfolioProject..coviddeath
where Location like 'world%'
--and continent is not null
order by 1,2

--global numbers aggregate
select max(total_cases), max(total_deaths), max(total_deaths)/max(total_cases)*100 as deathpercentage
from PortfolioProject..coviddeath
where Location like 'world%'
--and continent is not null
order by 1,2

--highest death percentage across the globe by date
select date, total_cases, total_deaths, total_deaths/total_cases*100 as deathpercentage
from PortfolioProject..coviddeath
where Location like 'world%'
--and continent is not null
order by 4 desc


-- deadliest days in world
select date, new_cases, new_deaths, new_deaths/new_cases*100 as dailydeathpercentage
from PortfolioProject..coviddeath
where Location like 'world%' and new_cases != 0
order by 4 desc


--VACCINATION table join

select *
from PortfolioProject..coviddeath as d
inner join PortfolioProject..covidvac as v
on d.date=v.date and d.location=v.location
order by 3,4;


--total population vs vaccination

select  DISTINCT dea.date, dea.continent, dea.location, dea.population, vac.new_vaccinations, vac.total_vaccinations
from PortfolioProject..coviddeath as dea
join PortfolioProject..covidvac as vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
--and dea.location like 'india%'
order by 3,2,1;

--use CTE

with pop_vs_vac ( Date, Continent, location, Population, new_vaccinations, total_vaccinations)
as
(
select  DISTINCT dea.date, dea.continent, dea.location, dea.population, vac.new_vaccinations, vac.total_vaccinations
from PortfolioProject..coviddeath as dea
join PortfolioProject..covidvac as vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 
--order by 3,2,1
)
select *, ((total_vaccinations/ Population) * 100) as vaccination_percentage from pop_vs_vac
order by 3,2,1

--creating view

CREATE VIEW vaccinationpercent as
select  dea.date, dea.continent, dea.location, dea.population, vac.new_vaccinations, vac.total_vaccinations
from PortfolioProject..coviddeath as dea
join PortfolioProject..covidvac as vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null 

-- looking at the created view

select * from vaccinationpercent 
order by 3,2,1

