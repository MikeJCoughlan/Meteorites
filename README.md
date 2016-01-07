# Meteorites
Simulations for sinking meteorites in glaciers, 1D

README

The folder "MATLAB" has four m files.

1.
---------------------------------------------------------------------------

The file "COLD.m" is a function to run the simulation of the Antarctic case. It takes arguments of:  
1. The number of years for the simulation. 
2. The meteorite conductivity.
3. The attenuation coefficient for ice (gamma).
4. The size of the meteorite (w).

The function outputs a structure with components:
"time" - the time variable
"b" - the depth of the top of the meteorite
"water" - the size of the water layer
"velocity" - the velocity of the meteorite
"temp" - the surface temperature
"Q", "S" and "L" are components of the SEB and were only used for testing.

Nothing in this needs to be changed.


2.
----------------------------------------------------------------------------

The file "EXPERIMENT.m" is a function to run the simulation of the experimental case. It takes arguments of:  
1. The number of hours for the simulation. 
2. The meteorite conductivity.
3. The attenuation coefficient for ice (gamma).
4. The initial depth of the meteorite.

The function outputs a structure with components:
"time" - the time variable
"a" - the depth of the ice-water interface
"b" - the depth of the top of the meteorite
"water" - the size of the water layer
"a_dot" - the velocity of the ice-water interface
"b_dot" - the velocity of the meteorite
"temp" - the surface temperature


Nothing in this needs to be changed.

3.
----------------------------------------------------------------------------
The file "Plots.m" contains all the commands to plot the graphs for the Antarctic case. It specifies variables for the different conductivities and attenuation rates in the first few lines. The length of the simulation is specified at 30 years.
	In the first large block it runs simulations for the plots comparing different values of gamma. The next block runs simulations for different sizes of meteorites. Plot commands follow. These commands include textarrows. A horizontal line is included at the surface (z=0).

4.
----------------------------------------------------------------------------
The file "ExperimentPlot.m" contains all the commands to plot the graphs for the experiment. It reads in the 5 datafiles ("Iron1.csv", "Iron2.csv", "Iron3.csv", "Chon1.csv" and "Chon2.csv") and runs a corresponding simulation of the experimental model for each datafile. 
	In a commented line there is a command to plot each datafile and simulation on one plot. The uncommented code plots two graphs of the iron experiments and chondrite experiments side by side with their corresponding simulations.

