function MWS = setup_Sensor(MWS)
% set sensor responses

% P2 sensor inputs
MWS.Sensor.P2.Tau = 1/25;
MWS.Sensor.P2.Max = 30;
MWS.Sensor.P2.Min = 1;

% P25 sensor inputs
MWS.Sensor.P25.Tau = 1/25;
MWS.Sensor.P25.Max = 300;
MWS.Sensor.P25.Min = 1;

% Ps3 sensor inputs
MWS.Sensor.Ps3.Tau = 1/25;
MWS.Sensor.Ps3.Max = 800;
MWS.Sensor.Ps3.Min = 10;

% P5 sensor inputs
MWS.Sensor.P5.Tau = 1/25;
MWS.Sensor.P5.Max = 400;
MWS.Sensor.P5.Min = 1;

% Temperature Sensors

% T2 sensor inputs
MWS.Sensor.T2.Tau = 1/1.43;
MWS.Sensor.T2.Max = 700;
MWS.Sensor.T2.Min = 300;

% T25 sensor inputs
MWS.Sensor.T25.Tau = 1/1.43;
MWS.Sensor.T25.Max = 900;
MWS.Sensor.T25.Min = 300;

% T3 sensor inputs
MWS.Sensor.T3.Tau = 1/1.43;
MWS.Sensor.T3.Max = 2000;
MWS.Sensor.T3.Min = 1;

% T4 sensor inputs
MWS.Sensor.T4.Tau = 1/1.43;
MWS.Sensor.T4.Max = 4000;
MWS.Sensor.T4.Min = 1;

% T45 sensor inputs
MWS.Sensor.T45.Tau = 1/1.43;
MWS.Sensor.T45.Max = 3000;
MWS.Sensor.T45.Min = 1;

% Speed Sensors
% N1 sensor inputs - Fan speed
MWS.Sensor.N1.Tau = 1/50;
MWS.Sensor.N1.Max = 10000;
MWS.Sensor.N1.Min = 500;

% N2 sensor inputs - LP shaft speed
MWS.Sensor.N2.Tau = 1/50;
MWS.Sensor.N2.Max = 10000;
MWS.Sensor.N2.Min = 500;

% N3 sensor inputs - HP shaft speed
MWS.Sensor.N3.Tau = 1/50;
MWS.Sensor.N3.Max = 30000;
MWS.Sensor.N3.Min = 500;

% NemL sensor inputs - LP electric machine speed (DEM option)
MWS.Sensor.NemL.Tau = 1/50;
MWS.Sensor.NemL.Max = 50000;
MWS.Sensor.NemL.Min = 500;

% NemH sensor inputs - HP electric machine speed (DEM option)
MWS.Sensor.NemH.Tau = 1/50;
MWS.Sensor.NemH.Max = 50000;
MWS.Sensor.NemH.Min = 500;

% NemS sensor inputs - sun gear electric machine speed (VEATE option)
MWS.Sensor.NemS.Tau = 1/50;
MWS.Sensor.NemS.Max = 100000;
MWS.Sensor.NemS.Min = 100;

% NemR sensor inputs - ring gear electric machine speed (VEATE option)
MWS.Sensor.NemR.Tau = 1/50;
MWS.Sensor.NemR.Max = 100000;
MWS.Sensor.NemR.Min = 100;

% NemC sensor inputs - Carrier electric machine speed (VEATE option)
MWS.Sensor.NemC.Tau = 1/50;
MWS.Sensor.NemC.Max = 100000;
MWS.Sensor.NemC.Min = 100;

% NemP sensor inputs - Planet gear electric machine speed (VEATE option)
MWS.Sensor.NemP.Tau = 1/50;
MWS.Sensor.NemP.Max = 100000;
MWS.Sensor.NemP.Min = 100;

% SOC sensor inputs
MWS.Sensor.SOC.Tau = 1/50;
MWS.Sensor.SOC.Max = 100;
MWS.Sensor.SOC.Min = 0;