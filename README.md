# Replication Package for: [Young people and household caring in the postwar: Evidence from the FARC cease-fire in Colombia](https://repository.urosario.edu.co/items/83419cf8-37c4-4a29-a153-04e36ff86211)
This paper examines the impact of violence-related governmental policies on time allocation in Colombia. More specifically, using data from the Encuesta Nacional del Uso de Tiempo, and FARC-EP related conflict by municipality, I employed a difference-in-differences identification strategy to analyze the behavior towards time use of young individuals (between the ages of 14 and 28) before and after the 2014 ceasefire. Results show that the absence of violence increased their time spent in taking care of other household members and encouraged them to immerse in the labour market, with the trade off of decreasing their time sleeping. Furthermore, by increasing the amount of time spent on household activities for young men and reducing it for young women, the latter increased the time spent and the probability of entering the labour market, thereby benefiting from a more equal household distribution of chores. Finally, young people in households with higher levels of education and greater possession of goods were able to prioritize entry into the labour market despite increasing their time spent on care-giving, even if this meant sacrificing hours of education and sleep. In contrast, those from less advantaged households tended to increase their time mainly in care-giving and household activities. The results are proven to be time sensitive and robust to selective migration patterns.

## Code
Code is organized into the `\01_code` folder as follows:

### Main code
* `0_master.do`: Main do file that runs all STATA code.

### Subcode
All code tagged with “(DANE)” must be executed under the supervision of the Departamento Administrativo Nacional de Estadística (DANE), as it relies on restricted data that can only be accessed through DANE’s secure data rooms.

* `1_covars.do`: The code creates additional variables for the analysis from external databases
* `2_cleaning.do`: The code cleans the full ENUT data and merges all years (DANE)
* `3_vars.do`: The code creates the relevant variables from the ENUT database (DANE)
* `4_final_database.do`: The code merges the additional variables with the ENUT database to create the final database (DANE)
* `5_regs_main.do`: The code runs the main regressions (DANE)
* `6_1_heter_eff_age.do`: The code runs heterogeneous effects by age of respondent (DANE)
* `6_2_heter_eff_gender.do`: The code runs heterogeneous effects by gender of respondent (DANE)
* `6_3_heter_eff_edu.do`: The code runs heterogeneous effects by education level of respondent (DANE)
* `6_4_heter_eff_act.do`: The code runs heterogeneous effects by income level of household (DANE)
* `7_1_mechanisms.do`: The code runs the migration patterns mechanism
* `7_2_mechanisms.do`: The code runs the household composition mechanism (DANE)
* `7_3_mechanisms.do`: The code runs the night lights mechanism
* `8_1_robustness.do`: The code runs robustness by Propensity Score Matching (PSM) and parallel trends (DANE)
* `8_2_robustness.do`: The code runs robustness by an alternative conflict measure (DANE)
* `8_3_robustness.do`: The code runs robustness by selective migration patterns
* `9_stats.do`: The code runs descriptive statistics and behaviour graphs (DANE)

## Data
The data is organized into a `\02_data` folder in [Dropbox](https://www.dropbox.com/scl/fo/jb7r6jz8zqgmdrgvb4ehm/h?rlkey=kbf16ami0e3jdzaq91gfnecnj&dl=0). The raw data, that serves as main imput for the project, can be located in the `\raw` subfolder, as its name indicates. Manipulated data in the code will be saved in the `\coded` subfolder.

The main data source is:
1. **Encuesta Nacional de Uso del Tiempo (ENUT)** – Colombian national household survey on time use, conducted by DANE. Waves: 2012–2013, 2016–2017, and 2020–2021. Access is _restricted_ and must be requested and used under DANE supervision in their secure data rooms.

Secondary data sources are stored in the `\02_data` Dropbox folder. To obtain the original datasets, please refer directly to the providers listed below:
3. **CERAC Conflict Database** – Municipal-level data on conflict-related events, based on Justicia y Paz from Noche y Niebla (CINEP and Comisión Intercongregacional de Justicia y Paz). Access is _restricted_ and available only through CERAC with proper authorization.
4. **CEDE Municipality Panel Database** – Panel dataset (1993–2020) developed by Universidad de los Andes, with information on agriculture, governance, conflict, education, health, and other municipal characteristics. Publicly available from CEDE’s website (registration may be required).
5. **2018 Colombian Population and Housing Census** – Conducted by DANE, providing household- and individual-level sociodemographic data. Publicly available through DANE’s website.
6. **Global Nighttime Lights Dataset (Li et al., 2020)** – Recalibrated, globally harmonized satellite-based nightlights data (1992–2021). Open-access dataset.
7. **Colombia Municipal Shapefile** – Geographic boundaries from the Humanitarian Data Exchange (HDX, OCHA, 2022). Open-access dataset.

## Figures and Tables
Figures, maps and tables will be found inside the `\03_outputs` folder when produced by the code.

## To replicate analysis
It is possible to reproduce all the analysis using only the codes available in GitHub. 

1. Download the `\conflict_time_use` .zip folder from Github and unzip it.
2. Inside the `\conflict_time_use` folder, create a new folder called "output".
3. Download the `\02_data` .zip folder from [Dropbox](https://www.dropbox.com/scl/fo/jb7r6jz8zqgmdrgvb4ehm/h?rlkey=kbf16ami0e3jdzaq91gfnecnj&dl=0), and save it inside the `\conflict_time_use` folder. This way, the `\conflict_time_use` folder must contain the folders `\01_code`, `\03_outputs` and `\02_data`, the master code file and the `README.md`.
6. In the master code file, update the directory path to the one your computer or the DANE computer that leads to the project's folder.
7. Run the master code file.

Eveything should run smoohtly. If any inconvenience is encountered, please don't hesitate on reaching out to the authors.
