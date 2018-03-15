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

% T5 sensor inputs
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
