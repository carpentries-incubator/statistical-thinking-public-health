library(NHANES)
library(RNHANES)
library(dplyr)

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

#save(dat, file = "../bin/data.RData")
