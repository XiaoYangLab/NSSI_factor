# NSSI Subtyping GUI Based on the Ottawa Self-Injury Inventory (OSI)

## Overview

This project provides a user-friendly MATLAB-based graphical user interface (GUI) designed to perform factor analysis on the functions of non-suicidal self-injury (NSSI), based on responses to the Ottawa Self-Injury Inventory (OSI). The GUI also supports the identification of distinct NSSI subtypes based on participants' factor scores.

The tool is intended for use in research settings to facilitate the psychological profiling and functional understanding of self-injurious behaviors.

---

## Features

- Load OSI questionnaire data 
- Conduct OPNMF on functional items
- Calculat factor loadings, scree plots, and model fit statistics
- Automatically cluster participants into NSSI subtypes based on factor loadings
- GUI interface for intuitive interaction, no coding required

---

## Requirements

- **MATLAB R2022b or newer** (older versions have not been tested and may not be compatible)
- Required toolboxes:
  - Statistics and Machine Learning Toolbox
  - (optional) Signal Processing Toolbox for extended visualization

---

## Getting Started

1. Open MATLAB (R2022b or later)
2. Navigate to the project directory
3. Run the main GUI script:
   FactorCalculation
