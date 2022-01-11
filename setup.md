---
title: Setup
---
Please make sure the following packages are loaded before starting this lesson:

~~~
library(NHANES)
library(RNHANES)
library(ggplot2)
library(dplyr)
library(tidyr)
~~~
{: .language-r}

To obtain the data for this lesson, run the following code:

~~~
# proportions representing a simple random sample
prop <- as.numeric(table(NHANES$Race1)/nrow(NHANES))

set.seed(1000) # reproducible

# take sample from NHANESraw that represents a simple random sample
dat <- NHANESraw %>%
  
  # add sample weights
  mutate(weight = case_when(Race1 == "Black" ~ prop[1],
                            Race1 == "Hispanic" ~ prop[2],
                            Race1 == "Mexican" ~ prop[3],
                            Race1 == "White" ~ prop[4],
                            Race1 == "Other" ~ prop[5])) %>%
  group_by(Race1) %>%
  sample_n(10000 * weight) %>% # sample from each according to prop to obtain 10000 obvs in total
  rename(Sex = Gender) %>%
  select(-c(weight, 
            WTINT2YR, WTMEC2YR, 
            SDMVPSU, SDMVSTRA)) %>% # remove weighting columns
  select(-c(SurveyYr, HHIncomeMid,
            Length, HeadCirc,
            BMICatUnder20yrs,
            BPSys1, BPSys2,
            BPDia1, BPDia2,
            BPSys3, BPDia3,
            UrineVol2,
            UrineFlow2,
            PregnantNow)) %>% # remove variables which will not be used
  select(-c(Race3, 
            Testosterone,
            TVHrsDay, 
            CompHrsDay,
            TVHrsDayChild,
            CompHrsDayChild)) %>% # remove data which was only recorded for 
  # one out of two survey rounds
  ungroup(Race1)

# Add FEV1 variable
dat <- nhanes_load_data(c("SPX_F"), "2009-2010") %>%
  select(SEQN, SPXNFEV1) %>%
  bind_rows(nhanes_load_data(c("SPX_G"), "2011-2012") %>% 
              select(SEQN, SPXNFEV1)) %>%
  filter(SEQN %in% dat$ID) %>%
  rename(FEV1 = SPXNFEV1) %>%
  right_join(dat, by = c("SEQN" = "ID")) %>%
  rename(ID = SEQN)

rm(prop)
~~~
{: .language-r}

Our data comes from the National Health and Nutrition Examination Survey (NHANES), run by the CDC in the US. This data describes the demographics, physical properties, health and lifestyle of children and adults. Every year 5,000 participants are enrolled and the data is used for research and policy-making purposes. We are using data from the 2009-2010 and 2011-2012 editions of this survey. You can find out more about NHANES on the CDC website [here](https://www.cdc.gov/nchs/nhanes/).

In the original data, particular subsets of the population are oversampled, such that conclusions based on the data are also representative of ethnic minorities. This introduces complications into the analysis. Therefore, we are using a subset of the data that can be treated as a simple random sample of the US population. This subset is suitable for educational purposes, but may not be useful for research applications. The subsetting is done by the code above.

The variable names and the associated descriptions can be found in the table below. 

| Variable        | Definition                                                                                                                                                                                                                                                                                     |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ID              | A unique sample identifier.                                                                                                                                                                                                                                                                    |
| Sex          | Sex of study participant coded as male or female.                                                                                                                                                                                                                                     |
| Age             | Age in years at screening of study participant. Note: Subjects 80 years or older were recorded as 80.                                                                                                                                                                                          |
| Race1           | Reported race of study participant: Mexican, Hispanic, White, Black, or Other.                                                                                                                                                                                                                 |
| Education       | Educational level of study participant reported for participants aged 20 years or older. One of 8thGrade, 9-11thGrade, HighSchool, SomeCollege, or CollegeGrad.                                                                                                                                |
| MaritalStatus   | Marital status of study participant. Reported for participants aged 20 years or older. One of Married, Widowed, Divorced, Separated, NeverMarried, or LivePartner (living with partner).                                                                                                       |
| HHIncome        | Total annual gross income for the household in US dollars. One of 0 - 4999, 5000 - 9,999, 10000 - 14999, 15000 - 19999, 20000 - 24,999, 25000 - 34999, 35000 - 44999, 45000 - 54999, 55000 - 64999, 65000 - 74999, 75000 - 99999, or 100000 or More.                                           |
| Poverty         | A ratio of family income to poverty guidelines. Smaller numbers indicate more poverty.                                                                                                                                                                                                         |
| HomeRooms       | How many rooms are in home of study participant (counting kitchen but not bathroom). 13 rooms = 13 or more rooms.                                                                                                                                                                              |
| HomeOwn         | One of Home, Rent, or Other indicating whether the home of study participant or someone in their family is owned, rented or occupied by some other arrangement.                                                                                                                                |
| Work            | Indicates whether the individual is current working or not. One of Looking, NotWorking or Working.                                                                                                                                                                                             |
| Weight          | Weight in kg.                                                                                                                                                                                                                                                                                  |
| Height          | Standing height in cm. Reported for participants aged 2 years or older.                                                                                                                                                                                                                        |
| BMI             | Body mass index (weight/height2 in kg/m2). Reported for participants aged 2 years or older.                                                                                                                                                                                                    |
| BMI_WHO         | Body mass index category. Reported for participants aged 2 years or older. One of 12.0_18.4, 18.5_24.9, 25.0_29.9, or 30.0_plus.                                                                                                                                                               |
| Pulse           | 60 second pulse rate.                                                                                                                                                                                                                                                                          |
| BPSysAve        | Combined systolic blood pressure reading, following the procedure outlined for BPXSAR.                                                                                                                                                                                                         |
| BPDiaAve        | Combined diastolic blood pressure reading, following the procedure outlined for BPXDAR.                                                                                                                                                                                                        |
| DirectChol      | Direct HDL cholesterol in mmol/L. Reported for participants aged 6 years or older.                                                                                                                                                                                                             |
| TotChol         | Total HDL cholesterol in mmol/L. Reported for participants aged 6 years or older.                                                                                                                                                                                                              |
| UrineVol1       | Urine volume in mL - first test. Reported for participants aged 6 years or older.                                                                                                                                                                                                              |
| UrineFlow1      | Urine flow rate (urine volume/time since last urination) in mL/min - first test. Reported for participants aged 6 years or older.                                                                                                                                                              |
| Diabetes        | Study participant told by a doctor or health professional that they have diabetes. Reported for participants aged 1 year or older as Yes or No.                                                                                                                                                |
| DiabetesAge     | Age of study participant when first told they had diabetes. Reported for participants aged 1 year or older.                                                                                                                                                                                    |
| HealthGen       | Self-reported rating of participant's health in general Reported for participants aged 12 years or older. One of Excellent, Vgood, Good, Fair, or Poor.                                                                                                                                        |
| DaysPhysHlthBad | Self-reported number of days participant's physical health was not good out of the past 30 days. Reported for participants aged 12 years or older.                                                                                                                                             |
| DaysMentHlthBad | Self-reported number of days participant's mental health was not good out of the past 30 days. Reported for participants aged 12 years or older.                                                                                                                                               |
| LittleInterest  | Self-reported number of days where participant had little interest in doing things. Reported for participants aged 18 years or older. One of None, Several, Majority (more than half the days), or AlmostAll.                                                                                  |
| Depressed       | Self-reported number of days where participant felt down, depressed or hopeless. Reported for participants aged 18 years or older. One of None, Several, Majority (more than half the days), or AlmostAll.                                                                                     |
| nPregnancies    | How many times participant has been pregnant. Reported for female participants aged 20 years or older.                                                                                                                                                                                         |
| nBabies         | How many of participants deliveries resulted in live births. Reported for female participants aged 20 years or older.                                                                                                                                                                          |
| Age1stBaby      | Age of participant at time of first live birth. 14 years or under = 14, 45 years or older = 45. Reported for female participants aged 20 years or older.                                                                                                                                       |
| SleepHrsNight   | Self-reported number of hours study participant usually gets at night on weekdays or workdays. Reported for participants aged 16 years and older.                                                                                                                                              |
| SleepTrouble    | Participant has told a doctor or other health professional that they had trouble sleeping. Reported for participants aged 16 years and older. Coded as Yes or No.                                                                                                                              |
| PhysActive      | Participant does moderate or vigorous-intensity sports, fitness or recreational activities (Yes or No). Reported for participants 12 years or older.                                                                                                                                           |
| PhysActiveDays  | Number of days in a typical week that participant does moderate or vigorous-intensity activity. Reported for participants 12 years or older.                                                                                                                                                   |
| Alcohol12PlusYr | Participant has consumed at least 12 drinks of any type of alcoholic beverage in any one year. Reported for participants 18 years or older as Yes or No.                                                                                                                                       |
| AlcoholDay      | Average number of drinks consumed on days that participant drank alcoholic beverages. Reported for participants aged 18 years or older.                                                                                                                                                        |
| AlcoholYear     | Estimated number of days over the past year that participant drank alcoholic beverages. Reported for participants aged 18 years or older.                                                                                                                                                      |
| SmokeNow        | Study participant currently smokes cigarettes regularly. Reported for participants aged 20 years or older as Yes or No, provieded they answered Yes to having somked 100 or more cigarettes in their life time. All subjects who have not smoked 100 or more cigarettes are listed as NA here. |
| Smoke100        | Study participant has smoked at least 100 cigarettes in their entire life. Reported for participants aged 20 years or older as Yes or No.                                                                                                                                                      |
| SmokeAge        | Age study participant first started to smoke cigarettes fairly regularly. Reported for participants aged 20 years or older.                                                                                                                                                                    |
| Marijuana       | Participant has tried marijuana. Reported for participants aged 18 to 59 years as Yes or No.                                                                                                                                                                                                   |
| AgeFirstMarij   | Age participant first tried marijuana. Reported for participants aged 18 to 59 years.                                                                                                                                                                                                          |
| RegularMarij    | Participant has been/is a regular marijuana user (used at least once a month for a year). Reported for participants aged 18 to 59 years as Yes or No.                                                                                                                                          |
| AgeRegMarij     | Age of participant when first started regularly using marijuana. Reported for participants aged 18 to 59 years.                                                                                                                                                                                |
| HardDrugs       | Participant has tried cocaine, crack cocaine, heroin or methamphetamine. Reported for participants aged 18 to 69 years as Yes or No.                                                                                                                                                           |
| SexEver         | Participant has had vaginal, anal, or oral sex. Reported for participants aged 18 to 69 years as Yes or No.                                                                                                                                                                                    |
| SexAge          | Age of participant when they had sex for the first time. Reported for participants aged 18 to 69 years.                                                                                                                                                                                             |
| SexNumPartnLife | Number of opposite sex partners participant has had any kind of sex with over their lifetime. Reported for participants aged 18 to 69 years.                                                                                                                                                   |
| SexNumPartYear  | Number of opposite sex partners participant has had any kind of sex with over the past 12 months. Reported for participants aged 18 to 59 years.                                                                                                                                               |
| SameSex         | Participant has had any kind of sex with a same sex partner. Reported for participants aged 18 to 69 years ad Yes or No.                                                                                                                                                                       |
| SexOrientation  | Participant's sexual orientation (self-described). Reported for participants aged 18 to 59 years. One of Heterosexual, Homosexual, Bisexual.                                                                                                                                                   |


{% include links.md %}
