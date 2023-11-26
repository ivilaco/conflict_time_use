# Replication Package for: [Young people and household caring in the postwar: Evidence from the FARC cease-fire in Colombia](https://repository.urosario.edu.co/items/83419cf8-37c4-4a29-a153-04e36ff86211)
This paper examines the impact of violence-related governmental policies on time allocation in Colombia. More specifically, using data from the Encuesta Nacional del Uso de Tiempo, and FARC-EP related conflict by municipality, I employed a difference-in-differences identification strategy to analyze the behavior towards time use of young individuals (between the ages of 14 and 28) before and after the 2014 ceasefire. Results show that the absence of violence increased their time spent in taking care of other household members and encouraged them to immerse in the labour market, with the trade off of decreasing their time sleeping. Furthermore, by increasing the amount of time spent on household activities for young men and reducing it for young women, the latter increased the time spent and the probability of entering the labour market, thereby benefiting from a more equal household distribution of chores. Finally, young people in households with higher levels of education and greater possession of goods were able to prioritize entry into the labour market despite increasing their time spent on care-giving, even if this meant sacrificing hours of education and sleep. In contrast, those from less advantaged households tended to increase their time mainly in care-giving and household activities. The results are proven to be time sensitive and robust to selective migration patterns.

## Code
Code is organized into the `\code` folder as follows:

### Main code
* `master_1.do`: Main do file that runs all STATA code until do file `13_data_for_matlab.do`

### Subcode
* `1_alldata_analysis_updated2.do`: The code cleans the full survey data, short survey data and administrative data (20 hours to run)
* `2_data_for_geocoding.do`: The code prepares the data to be geocoded (# minutes to run)
  
## Data
The data is organized into a `\data` folder in [Dropbox](https://www.dropbox.com/scl/fo/uqhhfvrcvxlx40dwl0otu/h?rlkey=7aoy43qs2ggrv5w2icd2foslj&dl=0). The raw data, that serves as main imput for the project, can be located in the `\raw` subfolder, as its name indicates. Manipulated data in the code will be saved in the `\coded` and `\mixed_logit` subfolders.

The main data sources are:
1. A 3,800 student-level survey conducted at The University of Delhi (DU) in 2016;
2. A mapping of potential travel routes to all colleges in the choice set, build up with Google Maps and an algorith developed by the author;
3. Safety data from two crowdsourced mobile applications in Delhi, which allowed to assign a safety score to each travel route:
   - SafetiPin, which provides perceived spatial safety data in the form of safety audits conducted at various locations across the Delhi National Capital Region (NCR);
   - Safecity, which provides analytical data on harassment rates by travel mode recorded by users during their travel in the city;

## Figures and Tables
`\figures`, `\maps` and `\tables` subfolders inside the `\output` folder are shell folders that will populate with figures, maps and tables produced by the code.

## To replicate analysis
It is possible to reproduce all the analysis using only the codes available in GitHub. 

1. Download the `\safety-first` .zip folder from Github and unzip it.
2. Inside the `\safety-first` folder, create a new folder called "output". Inside this new "output" folder, create two new folders with the names "figures" and "tables".
3. Download the `\data` .zip folder from [Dropbox](https://www.dropbox.com/scl/fo/uqhhfvrcvxlx40dwl0otu/h?rlkey=7aoy43qs2ggrv5w2icd2foslj&dl=0), and save it inside the `\safety-first` folder. This way, the `\safety-first` folder must contain the folders `\code`, `\excel`, `\output` and `\data`, the 3 master code files and the `README.md`.
6. In the master code files, update the directory paths to the path on your computer that leads to the `\safety-first` folder.
7. Run the master code files in the following order: `master_1.do`, `master_2.m` and `master_3.do`.

Eveything should run smoohtly. If any inconvenience is encountered, please don't hesitate on reaching out to the authors.
