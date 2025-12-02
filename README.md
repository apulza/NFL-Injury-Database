# NFL Injury Database - 2024 Season Analysis

A comprehensive relational database analyzing injury patterns across the 2024 NFL regular season. This project examines over 3,440 injury reports spanning 18 weeks to uncover relationships between injuries, player characteristics, and team performance.

## 🎥 Project Presentation
https://www.youtube.com/watch?v=hnI4JNenVm4&feature=youtu.be

## 📊 Project Overview

As sports enthusiasts, we recognized the significant impact injuries have on NFL teams. This database project aims to:
- Track and analyze injury patterns across all 32 NFL teams
- Identify the most common injury types and affected positions
- Examine correlations between injuries and team success
- Provide insights for injury prevention and team management strategies

**Course:** CS3200 Introduction to Databases  
**Institution:** Northeastern University  
**Team:** Francis Bunker, Luis Li, Siddharth Patel, Aryan Ramsinghani

## 🎯 Key Findings

- **Knee injuries dominate**: 592 knee injuries and 495 ankle injuries account for ~30% of all injury reports
- **Injury-win correlation**: Negative correlation between total injuries and team wins (teams with fewer injuries tend to win more)
- **Position vulnerability**: Wide Receivers (479) and Cornerbacks (319) are the most injury-prone positions
- **Injury severity**: 40% of injuries result in "Out" status, while 53% are "Questionable"
- **Peak injury age**: Players aged 23-27 (2nd-6th year players) experience the most injuries
- **Team variance**: Injury counts range from 54 (Denver) to 197 (Carolina) per team

## 🗄️ Database Schema

### Core Tables
- **`injury`**: Central table storing player injuries, injury type, week, and game status
- **`player`**: Player information (name, date of birth)
- **`player_on_team`**: Links players to teams for a specific season (handles mid-season trades)
- **`team`**: Team information (name, conference, division, bye week)
- **`game`**: Game results (winning team, losing team, week, date)
- **`week`**: Week information (start date, end date)
- **`season`**: Season metadata (year, Super Bowl winner)

### Entity-Relationship Highlights
- Composite primary keys for `game` and `player_on_team`
- Foreign key constraints maintain referential integrity
- Designed to handle players switching teams mid-season
- Scalable schema that could support multiple seasons with minor modifications

## 🛠️ Tech Stack

- **Database**: MySQL 8.0
- **Data Collection**: Google Apps Script (web scraping)
- **Data Processing**: Java (data cleaning, ID mapping)
- **Data Sources**: 
  - [NFL.com](https://www.nfl.com/injuries/) - Official injury reports
  - [Pro Football Reference](https://www.pro-football-reference.com/) - Player rosters

## 📥 Data Collection Process

1. **Injury Data**: 
   - Scraped official NFL weekly injury reports using Google Apps Script
   - Each week contains 32 tables (one per team)
   - Script combines all weekly reports into a master dataset
   - Automatically cleans data (separates names, shortens injury descriptions)

2. **Roster Data**:
   - Exported from Pro Football Reference
   - Includes all players who played at least one game during the season

3. **Data Integration**:
   - Custom Java programs match player names to unique IDs
   - Handles data inconsistencies and formatting differences
   - Generates SQL insert statements for database population

## 📈 Sample Queries

### Total Injuries Per Team
```sql
SELECT t.team_name, t.conference, t.division, COUNT(*) AS total_injuries
FROM injury i
JOIN player_on_team pot ON i.player_id = pot.player_id
JOIN team t ON pot.team_id = t.team_id
GROUP BY t.team_id, t.team_name, t.conference, t.division
ORDER BY total_injuries DESC;
```

### Most Common Injury Types
```sql
SELECT injury, COUNT(*) AS occurrence_count
FROM injury
GROUP BY injury
ORDER BY occurrence_count DESC
LIMIT 10;
```

### Injuries by Position
```sql
SELECT pt.position, COUNT(*) AS injury_count
FROM player_on_team pt JOIN injury i USING (player_id)
GROUP BY pt.position
ORDER BY injury_count DESC
LIMIT 5;
```

### Team Wins vs Injuries Correlation
```sql
-- Get wins
SELECT t.team_name, COUNT(g.winning_team_id) AS total_wins
FROM team t
LEFT JOIN game g ON t.team_id = g.winning_team_id
GROUP BY t.team_id, t.team_name
ORDER BY total_wins DESC;

-- Combine with injury data for correlation analysis
```

## 📁 Repository Contents

```
├── NFL_project_setup.sql              # Database creation and data insertion
├── questions.sql                      # Analysis queries
├── db_project_report.pdf              # Full project report
├── NFL_Injury_Database_Slides.pdf     # Presentation slides
└── README.md                          # This file
```

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0 or higher
- MySQL Workbench (optional, for viewing ER diagrams)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/apulza/NFL-Injury-Database.git
cd NFL-Injury-Database
```

2. Create and populate the database:
```bash
mysql -u your_username -p < NFL_project_setup.sql
```

3. Run analysis queries:
```bash
mysql -u your_username -p nflinjury < questions.sql
```

## 🔍 Analysis Questions Answered

1. How many injuries occur per team?
2. How many wins did each team get?
3. How many distinct players got injured per team?
4. What are the most common injuries?
5. How many total injuries per week?
6. What are the top 5 injury age groups?
7. What are the most injury-prone positions?
8. What are the proportions for each injury status (Out/Questionable/Doubtful)?

## 📊 Key Insights

### Injury Distribution
- Significant variance between teams (54-197 injuries)
- No clear trend of increasing injuries as season progresses
- Most teams had 30-45 distinct injured players

### Injury Types & Severity
- Lower body injuries (knee, ankle, hamstring) comprise majority
- Concussions (256) remain a significant concern
- Recurring injuries common (same player injured multiple consecutive weeks)

### Performance Impact
- Teams with fewer injuries correlate with more wins
- Injury management appears critical for competitive success
- Position-specific injury rates suggest targeted prevention strategies needed

## 📝 License

This project was created for educational purposes as part of CS3200 at Northeastern University.

## 🙏 Acknowledgments

- NFL.com for providing comprehensive weekly injury reports
- Pro Football Reference for detailed player roster data
- CS3200 instructors and teaching staff

**Note**: This database contains data through Week 18 of the 2024 NFL regular season (ending January 5, 2025). The Super Bowl winner field in the season table is set to Philadelphia (team_id: 15) as indicated in the project data.
