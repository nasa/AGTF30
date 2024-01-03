function MWS = setup_AllEng(MWS,DEM,VEATE)

MWS.iDesign = 2;

%Inlet
MWS.Inlet.eRam = 1;
% for MN = low, 0.00,  0.10,  0.20,  0.30,  0.40,  0.60,  0.80,  0.90
MWS.Inlet.eRamVec = [0.9 1.0   1.007  1.028  1.065  1.117  1.276  1.525  1.692];
MWS.Inlet.eRamTBL = [0.995 0.995, 0.996, 0.997, 0.997, 0.998, 0.998, 0.998, 0.998];


%Components
MWS = setup_FAN(MWS);
MWS = setup_LPC(MWS);
MWS = setup_HPC(MWS);
MWS = setup_HPT(MWS);
MWS = setup_LPT(MWS);

%VBV
MWS.VBV.fullopen   = 1;
MWS.VBV.fullclosed = 0;
MWS.VBV.Ae = 4;  % effective area (in2)
MWS.VBV.PRVec = [1, 1.1, 2, 5]; % pressure ratio vector
MWS.VBV.Flowe = [0, 0.3, 0.5, 0.99]*10; % effective flow array

%Burner
MWS.Burn.LHV = 18400;
MWS.Burn.dPqP_dmd = 0.04;
MWS.Burn.Eff = 0.9990;

%Nozzles
MWS.NozByp.Cfg = 0.9975;
MWS.NozByp.WDes = 780.95;

MWS.NozCor.Ath  = 393.43;
MWS.NozCor.Cfg = 0.9999;
MWS.NozCor.WDes = 33.34;

%Ducts
MWS = setup_Duct(MWS);

%Gearbox
MWS.GearBox.GearRatio = 3.1;  % Note: NPSS data states this value is 3.0, though 3.1 fits the data better.
MWS.GearBox.Eff = 1.0;

%Sensors
MWS = setup_Sensor(MWS);

%Actuators
MWS = setup_Actuators(MWS);

%Shaft, Gearboxes, and Power System
MWS = setup_ShaftGB_PwrSys(MWS,DEM,VEATE);
% % Low pressure shaft inertia slugs * ft2
% % MWS.Shaft.LPS_Inertia = (484135.-450102.)/32.2/144.; %old
% MWS.Shaft.LPS_Inertia = ((450102/(3.1*3.1)) + 17796 + 16237) /32.2/144.; 
% MWS.Shaft.LPS_Eff = 0.99;
% % High pressure shaft inertia, slugs*ft2
% MWS.Shaft.HPS_Inertia = 8627/32.2/144.;