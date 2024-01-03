# AGTF30-e

NOTE: More details are provided in the User Guide found in the "Documentation" folder

The Advanced Geared Turbofan 30,000lbf - electrified (AGTF30-e) is an electrified
geared turbofan that leverages the previously developed Advanced Geared Turbofan
30,000lbf (AGTF30) model. The AGTF30-e introduces a variety of electrification
options. It has three primary modes of operation:
1) standard/conventional engine (like the original AGTF30)
2) boost capable engine - thrust augmentation with electric power on the fan 
	- mimics a parallel hybrid architecture
3) power extraction - significant power is extracted from the engine shafts for the
	purpose of producing thrust elsewhere on the airframe - mimics a partial 
	turboelectric architecture
There are also several secondary electrification options that can be implemented in
combination with each other and the primary electrification options. These include:
1) low engine power electric power transfer (EPT) - power transfer between the engine
	shafts at low engine power with the purpose of extending the operating range to
	lower thrust and fuel burn. 
2) Turbine Electrified Energy Management (TEEM) - use of the electrical power system
	during transients to improve transient operability, particularly with the
	compressors, and to enable better performing turbomachinery. 
3) Charging - use of additional power extraction during the mission to charge 
	energy storage devices that have been discharged. 
The AGTF30-e also considers how the electric power system is integrated with the 
engine shafts. It offers two options. 
1) Dedicated electric machine (DEM) approach - one or more electric machines are 
	integrated directly or through a gearbox to an engine shaft. Each electric machine
	can only influence a single engine shaft.
2) Versatile Electrically Augmented Turbine Engine (VEATE) Planetary Gearbox (PGB)
	approach - the electric machines are integrated with the engine through a 
	planetary gearbox that creates a coupling effect of the engine shafts through
	electric machine use. This approach has some potential benefits that could be
	explored with the model.
	
Like the AGTF30, the AGTF30-e utilizes the Toolbox for the Modeling and Analysis 
of Thermodynamic Systems (T-MATS) to create a steady-state and dynamic engine model 
within MATLAB/Simulink. The engine model is based upon a futuristic geared turbofan 
concept and allows steady-state operation throughout the flight envelope. Dynamic 
operation utilizes a baseline control that is versatile enough to enable all of the
features listed above and to enable various other model changes without significant 
controller updates.

AGTF30-e preparation for use:
1) Install Matlab and Simulink. Developed in MATLAB 2023b (AGTF30 developed in 2015aSP1).
2) A copy of T-MATS is packaged with the AGTF30-e. No installation should be necessary.
	However, if one wishes to attempt to use the AGTF30-e with a different version of 
	T-MATS one can download and install T-MATS (https://github.com/nasa/T-MATS/releases).
	It should be noted that the AGTF30-e has not been tested with all versions of T-MATS
	and is not guaranteed to be compatible with any installation other than the T-MATS 
	files that come with the AGTF30-e download. 

Running AGTF30-e simulation:
1) Navigate to the AGTF30e folder
2) Open the script "run_AGTF30e_script.m". This file provides a template for writing 
	code to run the AGTF30-e.
3) Run script. This should update the workspace with test scenario inputs, open the model,
	run the model, and plot some of the results.

Changing run conditions:

1) Open the "AGTF30e_Inputs.xlsx" file within the "SimSetup" folder and modify the inputs
2) Run the Setup_Simulation command (example in run_AGTF30e_script.m) to initialize 
	the workspace. Make sure that the "inputMethod" variable is set to 2 and the "filename"
	entry is 'AGTF30e_Inputs.xlsx'. Also make sure that the spreadsheet with the data you
	wish to use as inputs is the first spreadsheet in the file. 
3) Run the simulation.

or

if and input structure that matches the structure of MWS.In already exists in the workspace
you can
1) Modify the input structure (Example: change the altitude from MWS.In.Alt = [0 0] to 
	MWS.In.Alt = [35000 35000] to specify an altitude change from 0ft to 35,000ft. In this 
	example the corresponding time vector MWS.In.t_Alt is a two-element vector, lets say 
	MWS.In.t_Alt = [0 10] and the altitude is constant for the duration of the simulation)
2) Run the Setup_Simulation command (example in run_AGTF30e_script.m) to initialize 
	the workspace. Make sure that the "inputMethod" variable is set to 1 and the entry for the
	"In" input is the input structure you wish to use.
3) Run the simulation.

Several system inputs are defined (within the MWS structure) as vectors with each value matching with a time vector.
The linearization and steady-state systems will only make use of the initial values.

Outputs:
1) Steady state simulation output structure: Out_SS, containing a large amount of data. This structure contains 
	engine and solver data.
2) Linearization simulation output structure: Out_Lin, containing a large amount of data. It contains all engine 
	and solver data. Out_xdot and Out_y0 structures consolidates info for state derivatives and outputs.
3) Dynamic simulation output structure: out_Dyn, containing a large amount of data. Additionally, it generate specific
	structures out_*

*REFER TO THE USER GUIDE (FOUND IN THE DOCUMENTATION FOLDER) FOR MORE DETAILS*

References:
1) Jeffryes W. Chapman and Jonathan S. Litt. "Control Design for an Advanced Geared Turbofan Engine", 53rd AIAA/SAE/ASEE Joint Propulsion Conference, AIAA Propulsion and Energy Forum, (AIAA 2017-4820)
2) Jones, S.M., Haller, W.J., Tong, M.T., “An N+3 Technology Level Reference Propulsion System”, NASA/TM-2017-219501, 2017. 
3) Kratz, J.L., "Advanced Geared Turbofan 30,000lbf - Electrified Engine Model User Guide", AGTF30-e software release documentation, 2023.
4) Kratz, J.L., "The Advanced Geared Turbofan 30,000 lbf – electrified (AGTF30-e): A Virtual Testbed for Electrified Aircraft Propulsion Research", AIAA Aviation Forum, 2024. (Publication Pending).