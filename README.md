# Happy Developer Happy Company

- Author: Ray Wen
- Date: April 27, 2022
- E-mail: ray.wen@mail.utoronto.ca

## Overview of the paper

This repository investigates and explores the key factors influencing a developer's overall job satisfaction

## Obtaining data

The data is available on https://insights.stackoverflow.com/survey

- Past Years -> 2019 -> Download Full Data Set (CSV)

Please note, due to the large dataset, the raw data is **not** included in the repository. Please download the data and place the file "survey_results_public.csv" inside inputs/data folder

## Preprocess data

After obtaining the raw CSV data, the script "01-data_preparation.R", located in "scripts/01-data_preparation.R", can be used to preprocess the data and save the file as a csv file for both the training and testing data in the directory "outputs/data/factorized.csv" and "outputs/data/test.csv".

## Building the Report

The RMardDown document is located in outputs/paper folder with the name "paper.rmd". It contains the R code and paper inputs and it is used to compile the paper "Happy Developer Happy Company". The reference bibtex file is also located in "outputs/paper" folder as "references.bib".

## Datasheet

There is a datasheet located in "inputs/data" folder as "datasheet.pdf" and "datasheet.rmd". It contained informations regarding the preprocessed and cleaned datasheet created by Ray Wen.

## File Structure

1. Inputs
- This folder contains the raw data as well as the datasheet that was created regarding this cleaned data.

2. Outputs
- In this folder you will find a reference file, RMarkdown file, and a pdf document of the paper.

3. Scripts
- This folder contains R-Scripts to import and clean the dataset.

4. Licence
- Typical MIT licence for re usability



