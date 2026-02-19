# Neuroengineering

This repository contains the codes and the final report related to the group project developed for the "**Neuroengineering**" course (AY 2025/2026).

### 🎯 Aim of the project

The aim of this project was to perform a **preliminary hemispheric analysis** of functional Near-Infrared Spectroscopy (**fNIRS**) signals during **Motor Imagery (MI)** tasks. 

The final report details the pipeline. Starting from an open-access dataset, the study investigated whether statistically significant differences in oxygenated hemoglobin ($O_2Hb$) concentration exist between the left and right hemispheres during left-hand and right-hand imagery tasks. The analysis focused on extracting and comparing **temporal features** as mean value, slope and peak amplitude from selected motor-related cortical regions to assess their discriminative power.

### 💻 Technologies

**Data Acquisition**: **NIRScout system** (NIRx GmbH) using 36 measurement channels with a sampling frequency of 10 Hz.

**Signal Processing & Analysis**: 
* **Software**: **MATLAB** (R2025a)
* **Pre-processing**: Modified Beer-Lambert Law (MBLL), Bandpass filtering (0.01-0.2 Hz) and Common Average Reference (CAR)
* **Statistical Tools**: Paired parametric (**t-test**) and non-parametric (**Wilcoxon**) tests based on **Shapiro-Wilk** normality test

**Dataset**: Open-access **EEG+fNIRS dataset** (29 healthy participants) for single-trial classification.