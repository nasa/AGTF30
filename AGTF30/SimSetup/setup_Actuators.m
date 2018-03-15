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
MWS.Act.VAFN_max = MWS.Cntrl.VAFN_max;

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

