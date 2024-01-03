function MWS = setup_Actuators(MWS)
% setup actuator variables

%------------- Fuel Metering Valve -----------------------
MWS.Act.FMV.min = 0; % min FMV actuator position (pps)
MWS.Act.FMV.max = 2.5; % max FMV actuator postion (pps)

MWS.Act.FMV.Tau = 0.1;
MWS.Act.FMV.Gain = 1;

FMV_stepResponseTime = 1.0;    % seconds to go from 10% to 90%
MWS.Act.FMV.rateLimit = 0.9*(MWS.Act.FMV.max-MWS.Act.FMV.min)/FMV_stepResponseTime;

MWS.Act.FMV.TWf_dly = 0.040;        % 40 ms fuel flow delay between actuator and combustion

%------------- Variable Bleed Valve -----------------------
MWS.Act.VBV.min = 0; % min VBV actuator position, fully closed
MWS.Act.VBV.max = 1; % max VBV actuator position, fully open

MWS.Act.VBV.Tau = 0.0435;
MWS.Act.VBV.Gain = 1;

%------------- Variable Area Fan Nozzle -----------------------

Type = 'common';
% -------------Type 1
MWS.Act.VAFN_max = 8500;

switch(Type)
    case 'advanced'
        % theoretical thermal actuation
        MWS.Act.VAFN.BW = 0.3;
        MWS.Act.VAFN.A = -MWS.Act.VAFN.BW;
        MWS.Act.VAFN.B = MWS.Act.VAFN.BW;
        MWS.Act.VAFN.C = 1;
        MWS.Act.VAFN.D = 0;
    case 'common'
        % fast actuation
        MWS.Act.VAFN.BW = 5;
        MWS.Act.VAFN.A = -MWS.Act.VAFN.BW;
        MWS.Act.VAFN.B = MWS.Act.VAFN.BW;
        MWS.Act.VAFN.C = 1;
        MWS.Act.VAFN.D = 0;
    otherwise
        % default to common type
        MWS.Act.VAFN.BW = 10;
        MWS.Act.VAFN.A = -MWS.Act.VAFN.BW;
        MWS.Act.VAFN.B = MWS.Act.VAFN.BW;
        MWS.Act.VAFN.C = 1;
        MWS.Act.VAFN.D = 0;
end

%------------- Electric Machines -----------------------

% LPS EM
MWS.Act.EML.BW = 20;
MWS.Act.EML.A = -MWS.Act.EML.BW;
MWS.Act.EML.B = MWS.Act.EML.BW;
MWS.Act.EML.C = 1;
MWS.Act.EML.D = 0;
MWS.Act.EML.RLmin = -inf;
MWS.Act.EML.RLmax = inf;

% HPS EM
MWS.Act.EMH.BW = 20;
MWS.Act.EMH.A = -MWS.Act.EMH.BW;
MWS.Act.EMH.B = MWS.Act.EMH.BW;
MWS.Act.EMH.C = 1;
MWS.Act.EMH.D = 0;
MWS.Act.EMH.RLmin = -inf;
MWS.Act.EMH.RLmax = inf;

% Sun Gear EM
MWS.Act.EMS.BW = 20;
MWS.Act.EMS.A = -MWS.Act.EMS.BW;
MWS.Act.EMS.B = MWS.Act.EMS.BW;
MWS.Act.EMS.C = 1;
MWS.Act.EMS.D = 0;
MWS.Act.EMS.RLmin = -inf;
MWS.Act.EMS.RLmax = inf;

% Ring Gear EM
MWS.Act.EMR.BW = 20;
MWS.Act.EMR.A = -MWS.Act.EMR.BW;
MWS.Act.EMR.B = MWS.Act.EMR.BW;
MWS.Act.EMR.C = 1;
MWS.Act.EMR.D = 0;
MWS.Act.EMR.RLmin = -inf;
MWS.Act.EMR.RLmax = inf;

% Carrier EM
MWS.Act.EMC.BW = 20;
MWS.Act.EMC.A = -MWS.Act.EMC.BW;
MWS.Act.EMC.B = MWS.Act.EMC.BW;
MWS.Act.EMC.C = 1;
MWS.Act.EMC.D = 0;
MWS.Act.EMC.RLmin = -inf;
MWS.Act.EMC.RLmax = inf;

% Planet Gear EM
MWS.Act.EMP.BW = 20;
MWS.Act.EMP.A = -MWS.Act.EMP.BW;
MWS.Act.EMP.B = MWS.Act.EMP.BW;
MWS.Act.EMP.C = 1;
MWS.Act.EMP.D = 0;
MWS.Act.EMP.RLmin = -inf;
MWS.Act.EMP.RLmax = inf;