# Data Engineering Challenge

## load_data.py

- it contains a function that takes file path as input and then return a cleaned pandas Dataframe.
- it will also add a column name `Hourly_Timestamp` which will be used later to group data hourly.

## task2_run_hours.py

- it will group the data on "Hourly_Timestamp" column and then apply `run_hours` function
- this way the function will receive the data into hourly chuncks so we can calculate run hours using
  `str.contains()`. str.contains() returns a series of Boolean which will come in handy in task 3 as well

## task3_power_kw.py

- it will the same logic in task 2 but only difference is that it use the Series of Boolean that can be later used as a mask for `loc()` function in pandas. why this is beneficial? its because it saves us from using nested for loop that iterate over the series return by `str.contains()` to check if `source_tag is True` so we can apply the formula.

## requirements

- all the modules require to run the files or recreate the project are mentioned requirements.txt file
