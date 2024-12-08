DROP TABLE IF EXISTS OLYMPICS_HISTORY;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);


DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGIONS;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

select * from olympics_history

/* Ques-1 How many olympics games have been held?*/
select count(distinct games) from olympics_history

/* List down all Olympics games held so far.*/
select distinct games from  olympics_history 

/* Mention the total no of nations who participated in each olympics game? */
select Games, count(distinct noc) from olympics_history
group by Games
order by Games

/* Which year saw the highest and lowest no of countries participating in olympics? */
select Games, count(distinct noc) as count_of_games from olympics_history
group by games
order by count_of_games
limit 1

select Games, count(distinct noc) as count_of_games from olympics_history
group by Games
order by count_of_games desc
limit 1

/* Which nation has participated in all of the olympic games */
Select NOC, COUNT(dISTINCT Games) AS count_of_games
from olympics_history
group by noc
having COUNT(dISTINCT Games)=51
order by count_of_games desc

/* Identify the sport which was played in all summer olympics. */
select distinct sport 
from olympics_history
where season='Summer'

/* Which Sports were just played only once in the olympics?      --not solved */ 
select sport , count(distinct games)
from olympics_history
group by sport
having count(distinct games)=1


Select * from Olympics_history


/*Fetch the total no of sports played in each olympic games.*/
select distinct games , COUNT(distinct sport) as count_sports
from olympics_history 
group by games
order by count_sports desc


/*Fetch details of the oldest athletes to win a gold medal. */
select * from olympics_history 
where Medal= 'Gold' and age !='NA'
order by age desc
limit 2


/* Find the Ratio of male and female athletes participated in all olympic games */
select  count (case when sex='M' then 1 end) as Male ,
count (case when sex ='F' then 1 end ) as Female ,
round(count(case when sex = 'M' then 1 end) * 1.0 / count(case when sex = 'F' then 1 end),3) as ratio
from olympics_history;



/* Fetch the top 5 athletes who have won the most gold medals.*/
select olympics_history.name,team, count(*) as medal_count from olympics_history 
where medal='Gold'
group by name, team
order by medal_count  desc
limit 5

/*Fetch the top 5 athletes who have won the most medals (gold/silver/bronze). */
select olympics_history.name , Team , count(*) as total_medals from olympics_history
where medal='Gold' or medal='Silver' or medal='Bronze'
group by olympics_history.name, Team
order by total_medals desc
limit 5

/* Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won. */
select region , count(*) as total_medals from olympics_history_noc_regions
join olympics_history on olympics_history_noc_regions.noc = olympics_history.noc
where medal in ('Gold', 'Silver','Bronze')
group by region 
order by total_medals desc
limit 5

/*  List down total gold, silver and bronze medals won by each country.*/
SELECT region,COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS gold,COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS silver,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS bronze
FROM olympics_history_noc_regions
JOIN  olympics_history  ON olympics_history_noc_regions.noc = olympics_history.noc
GROUP BY region
ORDER BY total_medals DESC


/* List down total gold, silver and bronze medals won by each country corresponding to each olympic games.*/
select games ,region , count (Case when medal='Gold' then 1 end) as gold ,
count (case when medal ='Silver' then 1 end ) as silver ,
count (case when medal ='Bronze' then 1 end ) as bronze
from olympics_history_noc_regions
join olympics_history ON olympics_history_noc_regions.noc = olympics_history.noc
group by region , games 
order by games , region ;


/* Identify which country won the most gold, most silver and most bronze medals in each olympic games.  -- not solved */
select games ,count (Case when medal='Gold' then 1 end) as gold ,
count (case when medal ='Silver' then 1 end ) as silver ,
count (case when medal ='Bronze' then 1 end ) as bronze
from olympics_history
group by  games 


SELECT 
    games,
    CONCAT(
        COUNT(CASE WHEN medal = 'Gold' THEN 1 END), 
        ' - ', 
        (SELECT region 
         FROM olympics_history_noc_regions as o
         JOIN olympics_history as r ON o.noc = r.noc
         WHERE medal = 'Gold'
         GROUP BY region
         ORDER BY COUNT(*) DESC
         LIMIT 1)
    ) AS gold_won
	from olympics_history
	group by games;


    
 


/* Which countries have never won gold medal but have won silver/bronze medals? */
select region , count (case when medal='Gold' then 1 end) as gold ,
count (case when medal ='Silver' then 1 end ) as silver ,
count (case when medal ='Bronze' then 1 end ) as bronze
from olympics_history_noc_regions
join olympics_history ON olympics_history_noc_regions.noc = olympics_history.noc
where medal in ('Silver' , 'Bronze')  and medal !='NA'
group by region

/* In which Sport/event, India has won highest medals. */ 
select region , sport, count(*) as total_medals from olympics_history_noc_regions
join olympics_history on olympics_history_noc_regions.noc = olympics_history.noc
where medal in ('Gold','Silver','Bronze') and region = 'India'
group by region , sport
order by total_medals desc 
limit 1;

/*  Break down all olympic games where India won medal for Hockey and how many medals in each olympic games */
select region , sport ,team,games, count(*) as total_medals from olympics_history_noc_regions
join olympics_history on olympics_history_noc_regions.noc = olympics_history.noc
where region = 'India' and sport ='Hockey'
group by region , sport, team, games
order by total_medals desc


