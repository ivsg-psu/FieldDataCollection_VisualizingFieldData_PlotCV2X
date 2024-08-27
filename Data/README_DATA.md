# README_DATA.md

<!--
Last update:  2022-07-08 by S. Brennan

This readme is based on the IVSG README template in the repository: Errata_Tutorials_ReadmeTemplate. The goal of a readme is to guide users by providing information on how to get started, installations, Help and other information about your project. In IVSG, we typically edit markdown files (such as README.md) in Visual Code Studio (vscode) because it allows preview of the markdown. To see the preview in vscode, you can right-click on the editor Tab and select Open Preview (Ctrl+Shift+V) or use the Command Palette (Ctrl+Shift+P) to run the Markdown: Open Preview to the Side command (Ctrl+K V). In general, opening the preview to the side is easier to edit (Ctrl+K V).

## Description

<--Explain what data exists in this area. Your description should explain concisely - in one paragraph - the reasons for the data: what does it contain? why was it saved? who created it? Which codes or methods created the data? when? how is it typically used? when was it last updated? what are the major releases of the data? 

For lengthy explanations, use the wiki feature and link to it here at the bottom of the description.

---

## Getting Started

* Which file should someone start with to see how the data is used?

### Dependencies

* Codes which use this data?
* Other data that must be installed?
* Other codes that are needed to use the data?

### Installing

* The install instructios area should note:

1. what type and version of software is needed? (MATLAB 2021a, ROS Kinetic, Ubuntu 20.04LTS, Windows 11?)
2. what file to read first?
3. what code to execute first?
4. how does one know that the installation worked after unning the code?

* Hopefully, this information is on the main README.md for your code repo.

### Executing program
* This area should explain how to run the code to see and confirm the data's integrity.

---
## Help

### Documentation

- Tell the user where in the documentation to find information on how to use the data.
-->

Last update:  2024-08-15 by S. Brennan

This is a summary of the CV2X files that are placed within this DATA directory.

## Description

Each of the files contains 4 columns of data that were collected using the Commsignia RSUs as part of the PennDOT ADS project to test Autonomous Vehicles in work zones. The data was collected by Yao Sun during 2024. Files include:

* TestTrack_PendulumRSU_InstallTest_2024_08_09a.csv - this is the first CSV file of a vehicle driving the outer lane as measured from the new antennas place near the top of the pendulum at the PennState test track

## Getting Started

* The data can be loaded using fcn_plotCV2X_loadDataFromFile. See the test script for this function to find examples.

### Dependencies

* None

### Installing

See main repo.

### Executing program

* See getting started

## Help

Contact Sean Brennan, <sbrennan@psu.edu>

### Documentation

See the main repo README.md
