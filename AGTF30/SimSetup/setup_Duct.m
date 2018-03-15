function MWS = setup_Duct(MWS)
% set as a slewing dP defined as dP = dPdes * (MN/MNdes)^2

% Duct 2
MWS.Duct.D2  = 0.01;
MWS.Duct.MNdes2 = 0.45;
MWS.Duct.Ath2 = 286.9;
% Duct 25
MWS.Duct.D25 = 0.015;
MWS.Duct.MNdes25 = 0.45;
MWS.Duct.Ath25 = 115.6;
% Duct 45
MWS.Duct.D45 = 0.005;
MWS.Duct.MNdes45 = 0.3;
MWS.Duct.Ath45 = 66.3;
% Duct 5
MWS.Duct.D5  = 0.01;
MWS.Duct.MNdes5 = 0.35;
MWS.Duct.Ath5 = 945.0;
% Duct 17
MWS.Duct.D17 = 0.015;
MWS.Duct.MNdes17 = 0.45;
MWS.Duct.Ath17 = 6917.7;

