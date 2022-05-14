---
title: Setup
---
To get set up for this lesson, there are a few steps that you will need to follow, as explained below:
1. Install R and RStudio, or update these if you already have the programs installed. 
2. Download the RStudio Project environment for this lesson.
3. Set up the packages used in this lesson using `renv`.

### Installing or updating R and RStudio
If you do not have R and RStudio installed on your computer, follow the installation instructions [here](https://datacarpentry.org/R-ecology-lesson/#Install_R_and_RStudio). If you have R and RStudio installed, please make sure that your computer is running the latest versions by following the instructions [here](https://datacarpentry.org/R-ecology-lesson/#Update_R_and_RStudio).

### Downloading the RStudio Project environment
To ensure that you have the data and packages used in this lesson, you can use a dedicated RStudio Project environment. 
Please follow the following steps:
1. Create a folder on your computer for the lesson, e.g. `statistical-thinking-lesson` in your documents folder.
2. Download the environment as a zipped folder by **left** clicking [here](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fcarpentries-incubator%2Fstatistics-r-public-health%2Ftree%2Fgh-pages%2Fworkshop-project). 
3. Unzip the downloaded folder into the `statistical-thinking-lesson` folder.

### Setting up the packages used in the lesson
To ensure that everyone is using the same versions of packages used in this lesson, as well as to avoid clashes with 
packages installed on your computer, the RStudio Project environment has a pre-defined package library using `renv`.
To install the required packages, please follow the following steps:
1. Launch the RStudio Project by double-clicking on the `workshop-project.RProj` file in `statistical-thinking-lesson`. 
2. Allow `renv` to install the required packages locally by typing `renv::restore()` in the console.
3. When the prompt comes up, answer it with `Y`. 
4. After installation has completed, load the required packages by typing `source("scripts/load_packages.R")` into the console.
5. You are now set up for the lesson! 

Note: the lesson data should be in your Environment under the name `dat`. If you would like more information 
about the data, see the [data][lesson-data] page.



{% include links.md %}
