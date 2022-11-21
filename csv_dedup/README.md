# CSV Dedup

### Overview
When exporting tracking data from one of my tracking apps, a fully duplicate set of row data is created. This CSV simply reduces an existing CSV to a new CSV with fully unique rows.

### In Use
`ruby main.rb`

Right now there is some debugging logs in the output as I try to figure out what data is actually different between my 3 CSV exports:

```log
in/20200902_20221121_Habit_all.csv :: Col 3 sum 286907 :: Row count 6007 :: Deduped row count 1558
in/20200902_20221121_Habit_first.csv :: Col 3 sum 220604 :: Row count 4608 :: Deduped row count 1558
in/20200902_20221121_Habit_second.csv :: Col 3 sum 74981 :: Row count 1564 :: Deduped row count 1558
```
