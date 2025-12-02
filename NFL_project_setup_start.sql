drop database if exists NflInjury;
CREATE DATABASE NflInjury;
use NflInjury;

drop table if exists injury;
drop table if exists player_on_team;
drop table if exists ir;
drop table if exists player;
create table player (
	player_id INT PRIMARY KEY AUTO_INCREMENT,
	player_first varchar(45),
    player_last varchar(45),
    dob date
);

drop table if exists team;
create table team (
	team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name varchar(45),
    bye_week int,
    confrence varchar(45),
    division varchar(45)
);
    
create table player_on_team (
	player_id int,
	CONSTRAINT fk_player_id FOREIGN KEY (player_id) REFERENCES player (player_id),
    team_id int,
    CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES team (team_id),
    position varchar(45),
    year int
);

drop table if exists week;
create table week (
	week_id int primary key,
    start_date date,
    end_date date
);

create table injury (
	player_id int,
    CONSTRAINT fk_injury_player_id FOREIGN KEY (player_id) REFERENCES player (player_id),
    injury varchar(45),
    week_id int,
    CONSTRAINT fk_injury_week FOREIGN KEY (week_id) REFERENCES week (week_id),
    game_status varchar(45)
);

create table ir (
	player_id int,
	CONSTRAINT fk_ir_player_id FOREIGN KEY (player_id) REFERENCES player (player_id),
	week_id int,
    CONSTRAINT fk_ir_injury_week FOREIGN KEY (week_id) REFERENCES week (week_id)
);

set global local_infile=ON;


LOAD DATA LOCAL INFILE '/Users/francisbunker/Documents/NFL/database/player_table.csv'
INTO TABLE player
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 rows;

LOAD DATA LOCAL INFILE '/Users/francisbunker/Documents/NFL/database/weeks.csv'
INTO TABLE week
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 rows;

LOAD DATA LOCAL INFILE '/Users/francisbunker/Documents/NFL/database/injury_table.csv'
INTO TABLE injury
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 rows;


LOAD DATA LOCAL INFILE '/Users/francisbunker/Documents/NFL/database/teams_table.csv'
INTO TABLE team
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 rows;

LOAD DATA LOCAL INFILE '/Users/francisbunker/Documents/NFL/database/player_on_team.csv'
INTO TABLE player_on_team
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 rows;


    
select * from player_on_team;
