
# FieldDataCollection_VisualizingFieldData_PlotCV2X

<!--
The following template is based on:
Best-README-Template
Search for this, and you will find!
>
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h2 align="center"> # FieldDataCollection_VisualizingFieldData_PlotCV2X
  </h2>

  <pre align="center">
    <img src=".\Images\plotRoad.jpg" alt="Plot of a trace on the road of LTI Test Track" width="960" height="540">
</pre>

  <p align="center">
    The purpose of this code is to plot CV2X data for the purposes of analyzing RSU and OBU performance. The basic goals are to assess RSU range and agreement of this with OBU measurements, assess RSU coverage areas (start and end of coverage on roads), and to assess OBU safety metrics such as velocity, lane position, location of lane changes, etc.
    <br />
  </p>
</p>

***

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
        <a href="#getting-started">Getting Started</a>
        <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#repo-structure">Repo Structure</a>
      <ul>
        <li><a href="#directories">Top-Level Directories</li>
        <li><a href="#dependencies">Dependencies</li>
      </ul>
    </li>
      <li><a href="#functions">Functions</li>
      <ul>
        <li><a href="#core-functions">Core Functions</li>
        <ul>
          <li><a href="#fcn_plotcv2x_loaddatafromfile">fcn_plotCV2X_loadDataFromFile - loads time+ENU and time+LLA data from file</li>
          <li><a href="#fcn_plotcv2x_rangersu_circle">fcn_plotCV2X_plotRSURangeCircle - given a RSU ID, plots range circles</li>
          <li><a href="#fcn_plotcv2x_assesstime">fcn_plotCV2X_assessTime - classifies the time vector of the data for errors</li>
          <li><a href="#fcn_plotcv2x_calcvelocity">fcn_plotCV2X_calcVelocity - calculates velocity given tENU coordinates</li>
        </ul>
        <li><a href="#supporting-functions">Supporting Functions</li>
        <ul>
          <li><a href="#fcn_PlotCV2X_calcrectanglexyz">fcn_PlotCV2X_calcRectangleXYZ - finds the XY(Z) coordinates of a rectangle</li>
          <li><a href="#fcn_PlotCV2X_breakarraybynans">fcn_PlotCV2X_breakArrayByNans - breaks data separated by nan into subdata</li>
          <li><a href="#fcn_PlotCV2X_plottracexy">fcn_PlotCV2X_plotTraceXY - plots EN components of ENU data as a trace</li>
          <li><a href="#fcn_PlotCV2X_plottracell">fcn_PlotCV2X_plotTraceLL - plots LL components of LLA data as a trace</li>
          <li><a href="#fcn_PlotCV2X_plottraces">fcn_PlotCV2X_plotTraces - plots traces in LLA, ENU, and/or STH coords</li>
        </ul>
      </ul>
    <li><a href="#usage">Usage Examples</a></li>
     <ul>
     <li><a href="#general-usage">General Usage</li>
     <li><a href="#examples">Advanced Examples</li>
     </ul>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

A little about the ADS project for which this repository was created:

The USDOT ADS Demonstration Grants Program appropriated funding for a "highly automated vehicle research and development program" to fund planning, direct research, and demonstration grants for ADS and other driving automation systems and technologies. The demonstration grant included funds for testing the safe integration of ADS into our Nation's on-road transportation system. PennDOT plans to utilize these funds for research and development, planning, testing, demonstrating, and deploying the safe integration of AVs in the work zones through this grant. Through this demonstration, PennDOT and the project team aim to solve the challenge of safe integration of AVs into most work zones by examining if improved connectivity, enhanced visibility, and HD mapping will enable AVs to safely travel the work zones. The team will demonstrate how the operation of AVs in work zones can be tested, improved and standardized in three phases, this repository is built for phase 2.

The team has identified 17 common work zone scenarios/configurations in different urban, rural, and suburban settings on limited access facilities and urban arterials, typical to not only Pennsylvania, but other states too. Connected vehicle equipment will be added to the appropriate traffic control devices, construction workers and vehicles (collectively called work zone artifacts). Pavement markings and work zone artifacts will be enhanced with special coatings to improve visibility specifically for the AVs. For each of the work zone scenarios, the team will conduct simulation and closed track testing at the PSU test track.

You can find more information about the ADS project at :
<a href="https://www.penndot.pa.gov/ProjectAndPrograms/ResearchandTesting/Autonomous%20_Vehicles/Pages/ADS-Demonstration.aspx">PennDOT ADS Project</a>

This repository was created to better visualize and plot the location and time data collected by the CV2X communication system. The functions in this repo can also be used to plot geometric shapes that represenat range of coverage and Autonomous Vehicle (as a rectangle).

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

## Getting Started

### Installation

1. Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo

   ```sh
   git clone https://github.com/ivsg-psu/fielddatacollection_visualizingfielddata_PlotCV2X/commits/main/
   ```

3. Run the main code in the root of the folder (script_demo_plotTestTrack.m). This will download the required utilities for this code, unzip the zip files into a Utilities folder (.\Utilities), and update the MATLAB path to include the Utility locations. This install process will only occur the first time. Note: to force the install to occur again, delete the Utilities directory

4. Confirm it works! Run script_demo_plotTestTrack. If the code works, the script should run without errors. This script produces numerous example images such as those in this README file.

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

## Repo Structure

### Top-Level Directories

The following are the top level directories within the repository:
<ul>
<li>/Data folder: The data folder contains any .mat or csv files that are used as inputs for the plotting functions</li>
 <li>/Functions folder: Contains all functions and their test scripts.</li>
 <li>/Images folder: Images that are pertinant to the functions or any   documentations are stored in this folder.</li>
 <li>/Utilities: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often other cloned repositories.</li>
</ul>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

### Dependencies

* [Errata_Tutorials_DebugTools](https://github.com/ivsg-psu/Errata_Tutorials_DebugTools) - The DebugTools repo is used for the initial automated folder setup, and for input checking and general debugging calls within subfunctions. The repo can be found at: <https://github.com/ivsg-psu/Errata_Tutorials_DebugTools>

* [PathPlanning_PathTools_PathClassLibrary](https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary) - the PathClassLibrary contains tools used to find intersections of the data with particular line segments, which is used to find start/end/excursion locations in the functions. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary>

* [FieldDataCollection_GPSRelatedCodes_GPSClass](https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass) - This library contains code to support conversions among coordinate systems commonly used for GPS data. These include: East-North-Up (ENU), Latitude-Longitude-Altitude (LLA), and Earth-Centered-Earth-Fixed (ECEF) systems. Note that UTM coordinates are not yet supported. The repo can be found at: <https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass>

* [FeatureExtraction_Association_LineFitting](https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting) - The purpose of this code is Basic line fitting code, including vertical line fitting and regression fitting. The repo can be found at: <https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting>

* [PathPlanning_GeomTools_FindCircleRadius](https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius) - This code calculates the center of a circle from three points given as vectors in x and y. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius>

* [FeatureExtraction_DataClean_BreakDataIntoLaps](https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps) - The purpose of this code is to break data into "laps", e.g. segments of data that are defined by a clear start condition and end condition. The code finds when a given path meets the "start" condition, then meets the "end" condition, and returns every portion of the path that is inside both conditions. The repo can be found at: <https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps>

* [PathPlanning_MapTools_ParseXODR](https://github.com/ivsg-psu/PathPlanning_MapTools_ParseXODR) - Cannot find this library. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_MapTools_ParseXODR>

* [PathPlanning_GeomTools_GeomClassLibrary](https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary) - This is a library of MATLAB functions related to geometric calculations for paths. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary>

<a href="#fielddatacollection_visualizingfielddata_loadworkzone">Back to top</a>

***

## Functions

### Core Functions

#### **fcn_plotCV2X_loadDataFromFile**

loads time+ENU and time+LLA data from file

 **FORMAT:**

  ```Matlab
    [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_plotCV2X_loadDataFromFile.jpg" alt="fcn_plotCV2X_loadDataFromFile picture" width="800" height="400">
  <figcaption>Example of fcn_plotCV2X_loadDataFromFile</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_plotCV2X_plotRSURangeCircle**

given a RSU ID, plots range circles

 **FORMAT:**

  ```Matlab
    [h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_plotCV2X_rangeRSU_circle.gif" alt="fcn_plotCV2X_plotRSURangeCircle picture" width="500" height="400">
  <figcaption>Example of fcn_plotCV2X_plotRSURangeCircle</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_plotCV2X_assessTime**

classifies the time vector of the data for errors

given the tENU data from a CV2X radio, this function assesses whether the
data contain common errors. The time differences between sequential data
are analyzed. 

Common errors include the following:

      * modeJumps - the time suddenly has a different zero intercept

      * offsets - at each individual time sample, for a given intercept,
      the data comes in early, on time, or late. This difference creates
      an offset.

 **FORMAT:**

  ```Matlab
    [modeIndex, modeJumps, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tENU, (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_plotCV2X_assessTime.jpg" alt="fcn_plotCV2X_assessTime picture" width="500" height="400">
  <figcaption>Example of fcn_plotCV2X_assessTime</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***


#### **fcn_plotCV2X_calcVelocity**

calculates velocity given tENU coordinates

 **FORMAT:**

  ```Matlab
  velocity = fcn_plotCV2X_calcVelocity(tENU, (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_plotCV2X_calcVelocity.jpg" alt="fcn_plotCV2X_calcVelocity picture" width="500" height="400">
  <figcaption>Example of fcn_plotCV2X_calcVelocity</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

### Supporting functions

#### **fcn_PlotCV2X_calcRectangleXYZ**

finds the XY(Z) coordinates of a rectangle

 **FORMAT:**

  ```Matlab
    cornersXYZ = fcn_PlotCV2X_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_PlotCV2X_calcRectangleXYZ.jpg" alt="fcn_PlotCV2X_calcRectangleXYZ picture" width="500" height="400">
  <figcaption>Example of fcn_PlotCV2X_calcRectangleXYZ</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_PlotCV2X_breakArrayByNans**

breaks data separated by nan into subdata

 **FORMAT:**

  ```Matlab
    indicies_cell_array = fcn_PlotCV2X_breakArrayByNans(input_array, (fig_num))
  ```

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_PlotCV2X_plotTraceXY**

plots EN components of ENU data as a trace

 **FORMAT:**

  ```Matlab
    h_plot = fcn_PlotCV2X_plotTraceXY(XYdata, (plotFormat), (flag_plot_headers_and_tailers), (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_PlotCV2X_plotTraceXY.jpg" alt="fcn_PlotCV2X_plotTraceXY picture" width="500" height="400">
  <figcaption>Example of fcn_PlotCV2X_plotTraceXY</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_PlotCV2X_plotTraceLL**

plots LL components of LLA data as a trace

 **FORMAT:**

  ```Matlab
    h_plot = fcn_PlotCV2X_plotTraceLL(LLdata, (plotFormat), (flag_plot_headers_and_tailers), (fig_num))
  ```

<pre align="center">
  <img src=".\Images\fcn_PlotCV2X_plotTraceLL.jpg" alt="fcn_PlotCV2X_plotTraceLL picture" width="500" height="400">
  <figcaption>Example of fcn_PlotCV2X_plotTraceLL</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

#### **fcn_PlotCV2X_plotTraces**

plots LL components of LLA data as a trace

 **FORMAT:**

  ```Matlab
          fcn_PlotCV2X_plotTraces(...
         Trace_coordinates, input_coordinates_type,...
         (plotFormat),...
         (reference_unit_tangent_vector),...
         (flag_plot_headers_and_tailers),...
         (LLA_fig_num), (ENU_fig_num), (STH_fig_num));
  ```

<pre align="center">
  <img src=".\Images\fcn_PlotCV2X_plotTraces.jpg" alt="fcn_PlotCV2X_plotTraces picture" width="500" height="400">
  <figcaption>Example of fcn_PlotCV2X_plotTraces</figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

***

<!-- USAGE EXAMPLES -->
### Usage

Each of the functions has an associated test script, using the convention

```sh
script_test_fcn_fcnname
```

where fcnname is the function name as listed above.

As well, each of the functions includes a well-documented header that explains inputs and outputs. These are supported by MATLAB's help style so that one can type:

```sh
help fcn_fcnname
```

for any function to view function details.

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>

<!-- CONTACT -->
## Contact

Sean Brennan - <sbrennan@psu.edu>

Project Link: <https://github.com/ivsg-psu/fielddatacollection_visualizingfielddata_PlotCV2X>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_PlotCV2X">Back to top</a>)</p>
