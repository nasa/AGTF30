function varargout = inEnvelope(MWS)
% This function determines if the engine is within the flight envelope
% cond = inEvelope(MWS)
% cond = 1 - IC is within the flight envelope
% cond = 0 - IC is not within the flight envelope

% *************************************************************************
% written by Jeffryes Chapman
% NASA Glenn Research Center, Cleveland, OH
% Aug 15th, 2016
%
% *************************************************************************

cond = 1;

%High limit
MN_mx = 0.8;
MN_mn = 0;

MN_hi  = [MN_mn, 0.2, 0.5, 0.6, 0.7, MN_mx];
Alt_hi = [  1.0, 1.0, 2.5, 3.5, 4.0,   4.0]*10^4;

MN_low  = [MN_mn, 0.5, 0.6, 0.7, MN_mx];
Alt_low = [  0.0,   0, 1.0, 2.0,    25]*10^3;

dT_hi  =  30;
dT_low = -30;

% Gather flight envelope data
Alt = MWS.In.AltIC;
MN  = MWS.In.MNIC;
dT  = MWS.In.dTambIC;

% Determine if dT is in bounds
if dT_hi < dT || dT_low > dT
    fprintf('dT initial condition is out of the flight envelope\n');
    cond = 0;
    dT = max(min(dT,dT_hi),dT_low);
end

% Determine if MN is in bounds
if MN_mx < MN || MN_mn > MN
    fprintf('MN initial condition is out of the flight envelope\n');
    cond = 0;
    MN = max(min(MN,MN_mx),MN_mn);
end

% Determine if Alt is in bounds
if cond == 1
    Alt_hi_calc = interp1(MN_hi,Alt_hi,MN);
    Alt_low_calc = interp1(MN_low,Alt_low,MN);
    if Alt > Alt_hi_calc || Alt < Alt_low_calc;
        fprintf('Alt initial condition is out of the flight envelope\n');
        cond = 0;
        Alt = max(min(Alt,Alt_hi_calc),Alt_low_calc);
    end
end

if nargout == 1
    varargout = {cond};
elseif nargout == 2
    varargout = {cond,Alt};
elseif nargout == 3
    varargout = {cond,Alt,MN};
elseif nargout == 4
    varargout = {cond,Alt,MN,dT};
else
    varargout = {cond};
end
    

