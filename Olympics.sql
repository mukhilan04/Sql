create schema olympics;
select * from athlete_events;
select * from noc_regions;

-- How many olympics games have been held?

select count(distinct games) Total_Olympic_Games from athlete_events;

-- List down all Olympics games held so far

select distinct year,season,city from athlete_events
order by year;

-- Mention the total no of nations who participated in each olympics game?

select games,count(distinct NOC) from athlete_events 
group by games order by games;

-- Which year saw the highest and lowest no of countries participating in olympics?

SELECT
    year,
    COUNT(DISTINCT NOC) AS Total_Nations
FROM
    athlete_events
GROUP BY
    year
HAVING
    COUNT(DISTINCT NOC) = (
        SELECT
            COUNT(DISTINCT NOC)
        FROM
            athlete_events
        GROUP BY
            year
        ORDER BY
            COUNT(DISTINCT NOC) DESC
        LIMIT 1
    )
    OR COUNT(DISTINCT NOC) = (
        SELECT
            COUNT(DISTINCT NOC)
        FROM
            athlete_events
        GROUP BY
            year
        ORDER BY
            COUNT(DISTINCT NOC) ASC
        LIMIT 1
    );
    
    -- Which nation has participated in all of the olympic games?
    
select count(distinct games) from athlete_events;
select noc from(
select distinct noc,count(distinct games) total from athlete_events 
group by noc) as participation_count
where total=(select count(distinct games) from athlete_events);

-- Identify the sport which was played in all summer olympics.

SELECT Sport
FROM (
    SELECT DISTINCT Sport, COUNT(DISTINCT games) AS TotalYears
    FROM athlete_events
    WHERE Season = 'Summer'
    GROUP BY Sport
) AS SummerSports
WHERE TotalYears = (SELECT COUNT(DISTINCT games) FROM athlete_events WHERE Season = 'Summer');

-- Which Sports were just played only once in the olympics.

select sport from(
select sport,count(distinct year) nos 
from athlete_events
group by sport) as sports_participation
where nos=1;

-- Fetch the total no of sports played in each olympic games.

select games,count(distinct Sport) no_sports from athlete_events
group by Games
order by no_sports desc;

-- Fetch oldest athletes to win a gold medal

select * from athlete_events
where Medal='Gold'
order by age desc limit 1;

-- Find the Ratio of male and female athletes participated in all olympic games.

select sex,count(*) tot,
count(*)*100/(select count(*)from athlete_events) as participation
from athlete_events
group by sex;

-- Fetch the top 5 athletes who have won the most gold medals.

select name,count(*) gold from athlete_events
where medal='Gold'
group by name
order by gold desc 
limit 5;

-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

select name,count(medal) total from athlete_events
group by name
order by total desc
limit 5;

-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

select team,count(Medal) medals_won
from athlete_events
group by team
order by medals_won desc limit 5;

-- List down total gold, silver and bronze medals won by each country.

select team,
count(case when Medal='Gold' then 1 end) Gold_Medals,
count(case when Medal='Silver' then 1 end) Silver_Medals,
count(case when Medal='Bronze' then 1 end) Bronze_Medals
from athlete_events
group by team
order by gold_medals desc;

-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games.

select games,team,
count(case when Medal='Gold' then 1 end) Gold_Medals,
count(case when Medal='Silver' then 1 end) Silver_Medals,
count(case when Medal='Bronze' then 1 end) Bronze_Medals
from athlete_events
group by games,team
order by gold_medals desc;

-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.

with cte1 as
(select games,team,medal,count(*) as medal_count
from athlete_events
where medal in('Gold','Silver','Bronze')
group by games,team,medal)

select games,
max(case when Medal='Gold' then team end) most_Gold_Medals,
max(case when Medal='Silver' then team end) most_Silver_Medals,
max(case when Medal='Bronze' then team end) most_Bronze_Medals
from cte1 group by games;

-- Which countries have never won gold medal but have won silver/bronze medals?

select distinct(team) from athlete_events
where medal in('Silver','Bronze') and
team not in
(select distinct(team) 
from athlete_events 
where Medal='Gold');

-- In which Sport/event, India has won highest medals.

select sport,count(medal) total_medals
from athlete_events
group by sport
order by total_medals desc
limit 1;
