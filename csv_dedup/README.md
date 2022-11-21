# CSV Dedup

### Overview
When exporting tracking data from one of my tracking apps, a fully duplicate set of row data is created. This CSV simply reduces an existing CSV to a new CSV with fully unique rows.

### In Use
`ruby main.rb`

There is some debugging logs in the output which I used to prove that the data was the same in my 3 exports after deduping rows. The format is filename, then before stats, then after stats:

```log
in/20200902_20221121_Habit_all.csv
Col 3 sum 288282 :: Row count 6007
Col 3 sum 75145 :: Row count 1558
in/20200902_20221121_Habit_first.csv
Col 3 sum 221636 :: Row count 4608
Col 3 sum 75145 :: Row count 1558
in/20200902_20221121_Habit_second.csv
Col 3 sum 75325 :: Row count 1564
Col 3 sum 75145 :: Row count 1558
```
