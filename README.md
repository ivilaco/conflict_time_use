# Replication Package for: [Young people and household caring in the postwar: Evidence from the FARC cease-fire in Colombia](https://repository.urosario.edu.co/items/83419cf8-37c4-4a29-a153-04e36ff86211)
This paper examines the impact of violence-related governmental policies on time allocation in Colombia. More specifically, using data from the Encuesta Nacional del Uso de Tiempo, and FARC-EP related conflict by municipality, I employed a difference-in-differences identification strategy to analyze the behavior towards time use of young individuals (between the ages of 14 and 28) before and after the 2014 ceasefire. Results show that the absence of violence increased their time spent in taking care of other household members and encouraged them to immerse in the labour market, with the trade off of decreasing their time sleeping. Furthermore, by increasing the amount of time spent on household activities for young men and reducing it for young women, the latter increased the time spent and the probability of entering the labour market, thereby benefiting from a more equal household distribution of chores. Finally, young people in households with higher levels of education and greater possession of goods were able to prioritize entry into the labour market despite increasing their time spent on care-giving, even if this meant sacrificing hours of education and sleep. In contrast, those from less advantaged households tended to increase their time mainly in care-giving and household activities. The results are proven to be time sensitive and robust to selective migration patterns.

## Code
Code is organized into the `\code` folder as follows:

### Main code
* `0_master.do`: Main do file that runs all STATA code.

### Subcode
* `1_covars.do`: The code creates additional variables for the analysis from external databases
* `2_cleaning.do`: The code cleans the full ENUT data and merges all years
* `3_vars.do`: The code creates the relevant variables from the ENUT database
* `4_final_database.do`: The code merges the additional variables with the ENUT database to create the final database
* `5_stats.do`: The code runs descriptive statistics and behaviour graphs
* `6_regs_main.do`: The code runs the main regressions
* `7_robustness.do`: The code runs robustness checks
  
## Data
The data is organized into a `\data` folder in [Dropbox](https://www.dropbox.com/scl/fo/jb7r6jz8zqgmdrgvb4ehm/h?rlkey=kbf16ami0e3jdzaq91gfnecnj&dl=0). The raw data, that serves as main imput for the project, can be located in the `\raw` subfolder, as its name indicates. Manipulated data in the code will be saved in the `\coded` subfolder.

The main data sources are:
1. 

## Figures and Tables
Figures, maps and tables will be found inside the `\output` folder when produced by the code.

## To replicate analysis
It is possible to reproduce all the analysis using only the codes available in GitHub. 

1. Download the `\conflict_time_use` .zip folder from Github and unzip it.
2. Inside the `\conflict_time_use` folder, create a new folder called "output".
3. Download the `\data` .zip folder from [Dropbox](https://www.dropbox.com/scl/fo/jb7r6jz8zqgmdrgvb4ehm/h?rlkey=kbf16ami0e3jdzaq91gfnecnj&dl=0), and save it inside the `\conflict_time_use` folder. This way, the `\conflict_time_use` folder must contain the folders `\code`, `\output` and `\data`, the master code file and the `README.md`.
6. In the master code file, update the directory path to the one your computer or the DANE computer that leads to the project's folder.
7. Run the master code file.

Eveything should run smoohtly. If any inconvenience is encountered, please don't hesitate on reaching out to the authors.
