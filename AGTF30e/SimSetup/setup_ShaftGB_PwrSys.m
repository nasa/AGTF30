function MWS = setup_ShaftGB_PwrSys(MWS,DEM,VEATE)

% setup variables for power system and shaft/gearbox. Creates substructures
% PowerSystem and Shaft.

% Inputs DEM and VEATE define parameters for the dedicated EM and VEATE
% approaches respectively

% General Parameters -----------------------------------------------------%

% Engine Shafts
% -- Low pressure shaft inertia, slugs*ft2
J_LPS = ((450102/(3.1*3.1)) + 17796 + 16237) /32.2/144.; 
MWS.Shaft.LPS_Eff = 0.99;
% -- High pressure shaft inertia, slugs*ft2
J_HPS = 8627/32.2/144.;

% Sizing Parameters
Vtip = 100/0.3048; %maximum EM rotor tip velocity
N2min = 2500; %Min LP Speed
N2max = 6831; %Max LP Speed
N2max_PEx = 6000; %Max LP Speed with PEx
N3min = 16000; %Min HP Speed
N3max = 23549; %Max HP Speed
N3max_PEx = 21500; %Max HP Speed with PEx

% Relation of NKnee to NMax (NKnee is the point where EM max continuous
% power and torque intersect and Nmax is the maximum EM speed)
NMax_vec = [0 1000 6831 10000 15000 20000 30000 100000];
PMax_vec = [0 400 750 2000];
%           PMax =    0  250 750  2000  %NMax
NFracKnee_array = [0.5 0.5 0.5   0.5;  %0
                   0.5 0.5 0.5   0.5;  %1000
                   0.5 0.5 0.55  0.55; %6831
                   0.5 0.5 0.60  0.60; %10000
                   0.5 0.5 0.65  0.65; %15000
                   0.5 0.5 0.7   0.7;  %20000
                   0.5 0.5 0.7   0.7;  %30000
                   0.5 0.5 0.7   0.7]; %100000

% Maximum power allowed per EM 
%   Used to determine the number of EMS on the given component and splits
%   the power (and torque) among multiple EMs if needed. This impacts the
%   weight estimate and inertia. In the model, it still applies a the power
%   as if done so through a single EM on each component. 
PMaxPerEM = 750; % hp

% Dedicated EM Approach --------------------------------------------------%

% Gear Ratios
if isempty(DEM)
    % -- LPS EM
    MWS.Shaft.DEM.LPSGB.GR = 3; %GR = Nem/Nspool
    % -- HPS EM
    MWS.Shaft.DEM.HPSGB.GR = 1.25; %GR = Nem/Nspool
else
    % -- LPS EM
    MWS.Shaft.DEM.LPSGB.GR = DEM.LPSGB.GR; %GR = Nem/Nspool
    % -- HPS EM
    MWS.Shaft.DEM.HPSGB.GR = DEM.HPSGB.GR; %GR = Nem/Nspool
end

% Max Power and Torque
PeakPwrFactor = 1.2; %Peak Power / Max Continuous Power
PeakTrqFactor = 1.2; %Peak Torque / Max Continuous Torque
% -- LP EM
if MWS.In.Options.HybridConfig == 1 % standard
    MWS.PowerSystem.EML.PMaxC = 300; 
elseif MWS.In.Options.HybridConfig == 2 % boost
    MWS.PowerSystem.EML.PMaxC = 2000; 
else % PEx
    MWS.PowerSystem.EML.PMaxC = 750; 
end
if MWS.In.Options.HybridConfig == 1 || MWS.In.Options.HybridConfig == 2
    MWS.PowerSystem.EML.NMax = N2max*MWS.Shaft.DEM.LPSGB.GR;
else
    MWS.PowerSystem.EML.NMax = N2max_PEx*MWS.Shaft.DEM.LPSGB.GR;
end
MWS.PowerSystem.EML.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EML.PMaxC,MWS.PowerSystem.EML.NMax); %fraction of max EM speed where torque and power limit meet
MWS.PowerSystem.EML.PMax = MWS.PowerSystem.EML.PMaxC*PeakPwrFactor;
MWS.PowerSystem.EML.NMax = N2max*MWS.Shaft.DEM.LPSGB.GR;
MWS.PowerSystem.EML.NKnee = MWS.PowerSystem.EML.NMax*MWS.PowerSystem.EML.NfracKnee;
MWS.PowerSystem.EML.TrqMaxC = MWS.PowerSystem.EML.PMaxC*5252.113/MWS.PowerSystem.EML.NKnee;
MWS.PowerSystem.EML.TrqMax = MWS.PowerSystem.EML.TrqMaxC*PeakTrqFactor;
% -- HP EM
if MWS.In.Options.HybridConfig == 1 % standard
    MWS.PowerSystem.EMH.PMaxC = 250; 
elseif MWS.In.Options.HybridConfig == 2 % boost
    MWS.PowerSystem.EMH.PMaxC = 250; 
else % PEx
    MWS.PowerSystem.EMH.PMaxC = 1000; 
end
if MWS.In.Options.HybridConfig == 1 || MWS.In.Options.HybridConfig == 2
    MWS.PowerSystem.EMH.NMax = N3max*MWS.Shaft.DEM.HPSGB.GR;
else
    MWS.PowerSystem.EMH.NMax = N3max_PEx*MWS.Shaft.DEM.HPSGB.GR;
end
MWS.PowerSystem.EMH.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMH.PMaxC,MWS.PowerSystem.EMH.NMax); %fraction of max EM speed where torque and power limit meet
MWS.PowerSystem.EMH.PMax = MWS.PowerSystem.EMH.PMaxC*PeakPwrFactor;
MWS.PowerSystem.EMH.NKnee = MWS.PowerSystem.EMH.NMax*MWS.PowerSystem.EMH.NfracKnee;
MWS.PowerSystem.EMH.TrqMaxC = MWS.PowerSystem.EMH.PMaxC*5252.113/MWS.PowerSystem.EMH.NKnee;
MWS.PowerSystem.EMH.TrqMax = MWS.PowerSystem.EMH.TrqMaxC*PeakTrqFactor;

% EM Weight and Inertia
% -- LP EM
numEM = ceil(MWS.PowerSystem.EML.PMaxC/PMaxPerEM);
MWS.PowerSystem.EML.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EML.TrqMaxC/numEM)^0.828;
MWS.PowerSystem.EML.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EML.NMax);
MWS.PowerSystem.EML.J = (1/2)*MWS.PowerSystem.EML.Mass*(MWS.PowerSystem.EML.Drotor/2)^2;
% -- HP EM
numEM = ceil(MWS.PowerSystem.EMH.PMaxC/PMaxPerEM);
MWS.PowerSystem.EMH.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMH.TrqMaxC/numEM)^0.828;
MWS.PowerSystem.EMH.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMH.NMax);
MWS.PowerSystem.EMH.J = (1/2)*MWS.PowerSystem.EMH.Mass*(MWS.PowerSystem.EMH.Drotor/2)^2;

% Spool Inertias
MWS.Shaft.DEM.LPS_Inertia = J_LPS + MWS.Shaft.DEM.LPSGB.GR^2*MWS.PowerSystem.EML.J;
MWS.Shaft.DEM.HPS_Inertia = J_HPS + MWS.Shaft.DEM.HPSGB.GR^2*MWS.PowerSystem.EMH.J;

% VEATE Gearbox Approach (Planetary Gearbox) -----------------------------%

if isempty(VEATE) %default (update later)
    % -- Coupling EM Power
    if MWS.In.Options.HybridConfig == 1 %standard
        MWS.Shaft.PGB.CouplingEMPwr = 250;
    elseif MWS.In.Options.HybridConfig == 2 %boost
        MWS.Shaft.PGB.CouplingEMPwr = 500;
    else %PEx
        MWS.Shaft.PGB.CouplingEMPwr = 500;
    end
    % -- Sun Gear EM
    MWS.Shaft.PGB.Sun.GR_int = 1.25; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Sun.GR_gb = 1/(2*1.25); %GR = NS/Nint
    MWS.Shaft.PGB.Sun.r = 0.25; %0.15; %radius of sun gear, ft
    MWS.Shaft.PGB.Sun.J_go = 0.0025; %inertia of gear only, slug-ft2
    % -- Ring Gear EM
    MWS.Shaft.PGB.Ring.GR_int = 1; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Ring.GR_gb = 1/1.25; %GR = NR/Nint
    MWS.Shaft.PGB.Ring.r = 0.33; %radius of ring gear, ft
    MWS.Shaft.PGB.Ring.J_go = 0.01; %inertia of gear only, slug-ft2
    % -- Carrier EM
    MWS.Shaft.PGB.Carrier.GR_int = 3; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Carrier.GR_gb = 1; %GR = NC/Nint
    MWS.Shaft.PGB.Carrier.J_go = 0.01; %inertia of gear only, slug-ft2
    % -- Planet Gear EM
    MWS.Shaft.PGB.Planet.GR_gb = 1; %GR = NP/Nem
    MWS.Shaft.PGB.Planet.nP = 4; %number of planets
    MWS.Shaft.PGB.Planet.mP = 0.05; %mass of planets, slugs
    MWS.Shaft.PGB.Planet.J_go = 0.0005; %inertia of gear only, slug-ft2
else %use VEATE design given as input
    % -- Coupling EM Power
    MWS.Shaft.PGB.CouplingEMPwr = VEATE.CouplingEMPwr;
    % -- Sun Gear EM
    MWS.Shaft.PGB.Sun.GR_int = VEATE.Sun.GR_int; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Sun.GR_gb = VEATE.Sun.GR_gb; %GR = NS/Nint
    MWS.Shaft.PGB.Sun.r = VEATE.Sun.r; %radius of sun gear, ft
    MWS.Shaft.PGB.Sun.J_go = VEATE.Sun.J_go; %0.0025; %inertia of gear only, slug-ft2
    % -- Ring Gear EM
    MWS.Shaft.PGB.Ring.GR_int = VEATE.Ring.GR_int; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Ring.GR_gb = VEATE.Ring.GR_gb; %GR = NR/Nint
    MWS.Shaft.PGB.Ring.r = VEATE.Ring.r; %radius of ring gear, ft
    MWS.Shaft.PGB.Ring.J_go = VEATE.Ring.J_go; %0.01; %inertia of gear only, slug-ft2
    % -- Carrier EM
    MWS.Shaft.PGB.Carrier.GR_int = VEATE.Carrier.GR_int; %GR = Nint/Ncomp
    MWS.Shaft.PGB.Carrier.GR_gb = VEATE.Carrier.GR_gb; %GR = NC/Nint
    MWS.Shaft.PGB.Carrier.J_go = VEATE.Carrier.J_go; %0.01; %inertia of gear only, slug-ft2
    % -- Planet Gear EM
    MWS.Shaft.PGB.Planet.GR_gb = VEATE.Planet.GR_gb; %GR = NP/Nem
    MWS.Shaft.PGB.Planet.nP = VEATE.PGB.Planet.nP; %4; %number of planets
    MWS.Shaft.PGB.Planet.mP = VEATE.PGB.Planet.mP; %0.05; %mass of planets, slugs
    MWS.Shaft.PGB.Planet.J_go = VEATE.Planet.J_go; %0.0005; %inertia of gear only, slug-ft2
end

% Combined determination of EM Power and Torque along with EM and gearbox
% component inertias. Also checks to assure the design favors the LP (power
% added to coupling component results in power transfer from the HP to the
% LP) across the speed range.
% -- Speed ratios
%   minimum and maximumum N3/N2 for each mode [low power, high power]
%       Standard: [6.590 3.109]
%       Boost: [6.590 2.936]
%       PEx: [6.618 3.066]
%   simplify by making relevant range [6.62 2.93]
N3qN2_lowPwr = 6.62;
N3qN2_hiPwr = 2.93;
if MWS.In.Options.HybridConfig == 3
    N3qN2_hiPwr = 3.4;
end
% -- set Max N2 and N3
if MWS.In.Options.HybridConfig == 1 || MWS.In.Options.HybridConfig == 2
    N3MAX = N3max;
    N2MAX = N2max;
else
    N3MAX = N3max_PEx;
    N2MAX = N2max_PEx;
end
% -- Initialize PGB component inertias to 
if MWS.In.Options.PGBConfig == 1 %HP-Sun, LP-Ring
    JS = MWS.Shaft.PGB.Sun.J_go + J_HPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JR = MWS.Shaft.PGB.Ring.J_go + J_LPS/(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    JC = MWS.Shaft.PGB.Carrier.J_go;
    JP = MWS.Shaft.PGB.Planet.J_go;
elseif MWS.In.Options.PGBConfig == 2 %HP-Sun, LP-Carrier
    JS = MWS.Shaft.PGB.Sun.J_go + J_HPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JR = MWS.Shaft.PGB.Ring.J_go;
    JC = MWS.Shaft.PGB.Carrier.J_go + J_LPS/(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
    JP = MWS.Shaft.PGB.Planet.J_go;
elseif MWS.In.Options.PGBConfig == 3 %HP-Ring, LP-Sun
    JS = MWS.Shaft.PGB.Sun.J_go + J_LPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JR = MWS.Shaft.PGB.Ring.J_go + J_HPS/(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    JC = MWS.Shaft.PGB.Carrier.J_go;
    JP = MWS.Shaft.PGB.Planet.J_go;
elseif MWS.In.Options.PGBConfig == 4 %HP-Ring, LP-Carrier
    JS = MWS.Shaft.PGB.Sun.J_go;
    JR = MWS.Shaft.PGB.Ring.J_go + J_HPS/(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    JC = MWS.Shaft.PGB.Carrier.J_go + J_LPS/(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
    JP = MWS.Shaft.PGB.Planet.J_go;
elseif MWS.In.Options.PGBConfig == 5 %HP-Carrier, LP-Sun
    JS = MWS.Shaft.PGB.Sun.J_go + J_LPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JR = MWS.Shaft.PGB.Ring.J_go;
    JC = MWS.Shaft.PGB.Carrier.J_go + J_HPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JP = MWS.Shaft.PGB.Planet.J_go;
else %HP-Carrier, LP-Ring
    JS = MWS.Shaft.PGB.Sun.J_go;
    JR = MWS.Shaft.PGB.Ring.J_go + J_LPS/(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    JC = MWS.Shaft.PGB.Carrier.J_go + J_HPS/(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    JP = MWS.Shaft.PGB.Planet.J_go;
end
% -- Calculate Torque coefficients
rS = MWS.Shaft.PGB.Sun.r;
rR = MWS.Shaft.PGB.Ring.r; 
rP = 0.5*(rR-rS);
nP = MWS.Shaft.PGB.Planet.nP;
mP = MWS.Shaft.PGB.Planet.mP;
[TrqCoeff,JEff] = PGBimpact(rS,rR,nP,mP,JS,JR,JC,JP);
% -- Calculate relevant power coefficients + max continus power and EM
%    speed at which power and torque limits intersect 
if MWS.In.Options.PGBConfig == 1 %HP-Sun, LP-Ring
    GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N3
    GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N2
    NSqNR = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_S/GR_R);
    NSqNC = NSqNR.*(rR+rS)./(rR+NSqNR*rS);
    NRqNC = NSqNC./NSqNR;
    CH = TrqCoeff.CTrqSC*NSqNC; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqRC*NRqNC; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = 250; 
        MWS.PowerSystem.EMR.PMaxC = 0;
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMR.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
        MWS.PowerSystem.EMR.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = N3MAX*MWS.Shaft.PGB.Sun.GR_int;
    MWS.PowerSystem.EMR.NMax = N2MAX*MWS.Shaft.PGB.Ring.GR_int;
    MWS.PowerSystem.EMC.NMax = max(abs(([N3min N3MAX]*GR_S./NSqNC)/MWS.Shaft.PGB.Carrier.GR_gb));
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_S./NSqNC) - [N3min N3MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
elseif MWS.In.Options.PGBConfig == 2 %HP-Sun, LP-Carrier
    GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N3
    GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N2
    NSqNC = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_S/GR_C);
    NSqNR = NSqNC./(1+(rS/rR)*(1-NSqNC));
    NCqNR = NSqNR./NSqNC;
    CH = TrqCoeff.CTrqSR*NSqNR; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqCR*NCqNR; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = 250; 
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMC.PMaxC = 0;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMC.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMC.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = N3MAX*MWS.Shaft.PGB.Sun.GR_int;
    MWS.PowerSystem.EMR.NMax = max(abs(([N3min N3MAX]*GR_S./NSqNR)/MWS.Shaft.PGB.Ring.GR_gb));
    MWS.PowerSystem.EMC.NMax = N2MAX*MWS.Shaft.PGB.Carrier.GR_int; 
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*([N2min N2MAX]*GR_C - [N3min N3MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
elseif MWS.In.Options.PGBConfig == 3 %HP-Ring, LP-Sun
    GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N3;
    GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N2
    NRqNS = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_R/GR_S);
    NRqNC = NRqNS.*(rS+rR)./(rs+NRqNS*rR);
    NSqNC = NRqNC./NRqNS;
    CH = TrqCoeff.CTrqSR*NRqNC; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqCR*NSqNC; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = 0; 
        MWS.PowerSystem.EMR.PMaxC = 250;
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMR.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMR.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
        MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = N2MAX*MWS.Shaft.PGB.Sun.GR_int; 
    MWS.PowerSystem.EMR.NMax = N3MAX*MWS.Shaft.PGB.Ring.GR_int;
    MWS.PowerSystem.EMC.NMax = max(abs(([N3min N3MAX]*GR_R./NSqNC)/MWS.Shaft.PGB.Carrier.GR_gb));
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_R./NSqNC) - [N2min N2MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
elseif MWS.In.Options.PGBConfig == 4 %HP-Ring, LP-Carrier 
    GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N3
    GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N2
    NRqNC = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_R/GR_C);
    NRqNS = NRqNC./(1+(rR/rS)*(1-NRqNC));
    NCqNS = NRqNS./NRqNC;
    CH = TrqCoeff.CTrqSR*NRqNS; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqCR*NCqNS; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = 250;
        MWS.PowerSystem.EMC.PMaxC = 0;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMC.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
        MWS.PowerSystem.EMC.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = max(abs(([N3min N3MAX]*GR_R./NRqNS)/MWS.Shaft.PGB.Sun.GR_gb));
    MWS.PowerSystem.EMR.NMax = N3MAX*MWS.Shaft.PGB.Ring.GR_int;
    MWS.PowerSystem.EMC.NMax = N2MAX*MWS.Shaft.PGB.Carrier.GR_int;
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N2min N2MAX]*GR_C - [N3min N3MAX]*GR_R./NRqNS))/MWS.Shaft.PGB.Planet.GR_gb)); 
elseif MWS.In.Options.PGBConfig == 5 %HP-Carrier, LP-Sun
    GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N3
    GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N2
    NCqNS = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_C/GR_S);
    NCqNR = NCqNS.*rR./(NCqNS*(rS+rR)-rS);
    NSqNR = NCqNR./NCqNS;
    CH = TrqCoeff.CTrqSR*NCqNR; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqCR*NSqNR; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = 0;
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMC.PMaxC = 250;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMC.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr; 
        MWS.PowerSystem.EMC.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = N2MAX*MWS.Shaft.PGB.Sun.GR_int;
    MWS.PowerSystem.EMR.NMax = max(abs(([N3min N3MAX]*GR_C./NCqNR)/MWS.Shaft.PGB.Ring.GR_gb));
    MWS.PowerSystem.EMC.NMax = N3MAX*MWS.Shaft.PGB.Carrier.GR_int;
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_C - [N2min N2MAX]*GR_S))/MWS.Shaft.PGB.Planet.GR_gb)); 
else %HP-Carrier, LP-Ring
    GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N3
    GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N2;
    NCqNR = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_C/GR_R);
    NCqNS = NCqNR.*rS./(NCqNR*(rS+rR)-rR);
    NRqNS = NCqNS./NCqNR;
    CH = TrqCoeff.CTrqSR*NCqNS; %[CH_lowPwr CH_highPwr]
    CL = TrqCoeff.CTrqCR*NRqNS; %[CL_lowPwr CL_highPwr]
    if CH(1) >= 0 || CH(2) >= 0
        MWS.Shaft.PGB.Check = 0;
        disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
    else
        MWS.Shaft.PGB.Check = 1;
    end
    if MWS.In.Options.HybridConfig == 1 % standard
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = 0;
        MWS.PowerSystem.EMC.PMaxC = 250;
        MWS.PowerSystem.EMP.PMaxC = 0;
    elseif MWS.In.Options.HybridConfig == 2 % boost
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMC.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
        MWS.PowerSystem.EMP.PMaxC = 0;
    else % PEx
        MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
        MWS.PowerSystem.EMR.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
        MWS.PowerSystem.EMC.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]);
        MWS.PowerSystem.EMP.PMaxC = 0;
    end
    MWS.PowerSystem.EMS.NMax = max(abs(([N3min N3MAX]*GR_C./NCqNS)/MWS.Shaft.PGB.Sun.GR_gb));
    MWS.PowerSystem.EMR.NMax = N2MAX*MWS.Shaft.PGB.Ring.GR_int;
    MWS.PowerSystem.EMC.NMax = N3MAX*MWS.Shaft.PGB.Carrier.GR_int;
    MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_C - [N2min N2MAX]*GR_R./NRqNS))/MWS.Shaft.PGB.Planet.GR_gb));
end
MWS.PowerSystem.EMS.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMS.PMaxC,MWS.PowerSystem.EMS.NMax); 
MWS.PowerSystem.EMR.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMR.PMaxC,MWS.PowerSystem.EMR.NMax); 
MWS.PowerSystem.EMC.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMC.PMaxC,MWS.PowerSystem.EMC.NMax); 
MWS.PowerSystem.EMP.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMP.PMaxC,MWS.PowerSystem.EMP.NMax); 
MWS.PowerSystem.EMS.PMax = MWS.PowerSystem.EMS.PMaxC*PeakPwrFactor; 
MWS.PowerSystem.EMR.PMax = MWS.PowerSystem.EMR.PMaxC*PeakPwrFactor;
MWS.PowerSystem.EMC.PMax = MWS.PowerSystem.EMC.PMaxC*PeakPwrFactor;
MWS.PowerSystem.EMP.PMax = MWS.PowerSystem.EMP.PMaxC*PeakPwrFactor;
MWS.PowerSystem.EMS.NKnee = MWS.PowerSystem.EMS.NMax*MWS.PowerSystem.EMS.NfracKnee;
MWS.PowerSystem.EMR.NKnee = MWS.PowerSystem.EMR.NMax*MWS.PowerSystem.EMR.NfracKnee;
MWS.PowerSystem.EMC.NKnee = MWS.PowerSystem.EMC.NMax*MWS.PowerSystem.EMC.NfracKnee;
MWS.PowerSystem.EMP.NKnee = MWS.PowerSystem.EMP.NMax*MWS.PowerSystem.EMP.NfracKnee;
MWS.PowerSystem.EMS.TrqMaxC = MWS.PowerSystem.EMS.PMaxC*5252.113/MWS.PowerSystem.EMS.NKnee;
MWS.PowerSystem.EMR.TrqMaxC = MWS.PowerSystem.EMR.PMaxC*5252.113/MWS.PowerSystem.EMR.NKnee;
MWS.PowerSystem.EMC.TrqMaxC = MWS.PowerSystem.EMC.PMaxC*5252.113/MWS.PowerSystem.EMC.NKnee;
MWS.PowerSystem.EMP.TrqMaxC = MWS.PowerSystem.EMP.PMaxC*5252.113/MWS.PowerSystem.EMP.NKnee;
MWS.PowerSystem.EMS.TrqMax = MWS.PowerSystem.EMS.TrqMaxC*PeakTrqFactor;
MWS.PowerSystem.EMR.TrqMax = MWS.PowerSystem.EMR.TrqMaxC*PeakTrqFactor;
MWS.PowerSystem.EMC.TrqMax = MWS.PowerSystem.EMC.TrqMaxC*PeakTrqFactor;
MWS.PowerSystem.EMP.TrqMax = MWS.PowerSystem.EMP.TrqMaxC*PeakTrqFactor;
% Determine EM Weight and Inertia
numEM = ceil(MWS.PowerSystem.EMS.PMaxC/PMaxPerEM);
MWS.PowerSystem.EMS.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMS.TrqMaxC/max([numEM, 1]))^0.828;
numEM = ceil(MWS.PowerSystem.EMR.PMaxC/PMaxPerEM);
MWS.PowerSystem.EMR.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMR.TrqMaxC/max([numEM, 1]))^0.828;
numEM = ceil(MWS.PowerSystem.EMC.PMaxC/PMaxPerEM);
MWS.PowerSystem.EMC.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMC.TrqMaxC/max([numEM, 1]))^0.828;
numEM = ceil(MWS.PowerSystem.EMP.PMaxC/PMaxPerEM);
MWS.PowerSystem.EMP.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMP.TrqMaxC/max([numEM, 1]))^0.828;
MWS.PowerSystem.EMS.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMS.NMax);
MWS.PowerSystem.EMR.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMR.NMax);
MWS.PowerSystem.EMC.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMC.NMax);
MWS.PowerSystem.EMP.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMP.NMax);
MWS.PowerSystem.EMS.J = (1/2)*MWS.PowerSystem.EMS.Mass*(MWS.PowerSystem.EMS.Drotor/2)^2;
MWS.PowerSystem.EMR.J = (1/2)*MWS.PowerSystem.EMR.Mass*(MWS.PowerSystem.EMR.Drotor/2)^2;
MWS.PowerSystem.EMC.J = (1/2)*MWS.PowerSystem.EMC.Mass*(MWS.PowerSystem.EMC.Drotor/2)^2;
MWS.PowerSystem.EMP.J = (1/2)*MWS.PowerSystem.EMP.Mass*(MWS.PowerSystem.EMP.Drotor/2)^2;
% -- Repeat until the component inertias converge within tolerance
JSold = JS;
JRold = JR;
JCold = JC;
JPold = JP;
JSbase = JS;
JRbase = JR;
JCbase = JC;
JPbase = JP;
JS = JSbase + MWS.PowerSystem.EMS.J/MWS.Shaft.PGB.Sun.GR_gb^2;
JR = JRbase + MWS.PowerSystem.EMR.J/MWS.Shaft.PGB.Ring.GR_gb^2;
JC = JCbase + MWS.PowerSystem.EMC.J/MWS.Shaft.PGB.Carrier.GR_gb^2;
JP = JPbase + MWS.PowerSystem.EMP.J/MWS.Shaft.PGB.Planet.GR_gb^2;
JErr = max([JS JR JC JP] - [JSold JRold JCold JPold]);
iter = 0;
while JErr > 0.01
    % repeat calculations
    [TrqCoeff,JEff] = PGBimpact(rS,rR,nP,mP,JS,JR,JC,JP);
    % -- Calculate relevant power coefficients + max continus power and EM
    %    speed at which power and torque limits intersect 
    if MWS.In.Options.PGBConfig == 1 %HP-Sun, LP-Ring
        GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N3
        GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N2
        NSqNR = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_S/GR_R);
        NSqNC = NSqNR.*(rR+rS)./(rR+NSqNR*rS);
        NRqNC = NSqNC./NSqNR;
        CH = TrqCoeff.CTrqSC*NSqNC; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqRC*NRqNC; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = 250; 
            MWS.PowerSystem.EMR.PMaxC = 0;
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMR.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
            MWS.PowerSystem.EMR.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = N3MAX*MWS.Shaft.PGB.Sun.GR_int;
        MWS.PowerSystem.EMR.NMax = N2MAX*MWS.Shaft.PGB.Ring.GR_int;
        MWS.PowerSystem.EMC.NMax = max(abs(([N3min N3MAX]*GR_S./NSqNC)/MWS.Shaft.PGB.Carrier.GR_gb));
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_S./NSqNC) - [N3min N3MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
    elseif MWS.In.Options.PGBConfig == 2 %HP-Sun, LP-Carrier
        GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N3
        GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N2
        NSqNC = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_S/GR_C);
        NSqNR = NSqNC./(1+(rS/rR)*(1-NSqNC));
        NCqNR = NSqNR./NSqNC;
        CH = TrqCoeff.CTrqSR*NSqNR; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqCR*NCqNR; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = 250; 
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMC.PMaxC = 0;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMC.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMC.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = N3MAX*MWS.Shaft.PGB.Sun.GR_int;
        MWS.PowerSystem.EMR.NMax = max(abs(([N3min N3MAX]*GR_S./NSqNR)/MWS.Shaft.PGB.Ring.GR_gb));
        MWS.PowerSystem.EMC.NMax = N2MAX*MWS.Shaft.PGB.Carrier.GR_int; 
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*([N2min N2MAX]*GR_C - [N3min N3MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
    elseif MWS.In.Options.PGBConfig == 3 %HP-Ring, LP-Sun
        GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N3;
        GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N2
        NRqNS = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_R/GR_S);
        NRqNC = NRqNS.*(rS+rR)./(rs+NRqNS*rR);
        NSqNC = NRqNC./NRqNS;
        CH = TrqCoeff.CTrqSR*NRqNC; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqCR*NSqNC; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = 0; 
            MWS.PowerSystem.EMR.PMaxC = 250;
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMR.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMR.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
            MWS.PowerSystem.EMC.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = N2MAX*MWS.Shaft.PGB.Sun.GR_int; 
        MWS.PowerSystem.EMR.NMax = N3MAX*MWS.Shaft.PGB.Ring.GR_int;
        MWS.PowerSystem.EMC.NMax = max(abs(([N3min N3MAX]*GR_R./NSqNC)/MWS.Shaft.PGB.Carrier.GR_gb));
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_R./NSqNC) - [N2min N2MAX]*GR_S)/MWS.Shaft.PGB.Planet.GR_gb)); 
    elseif MWS.In.Options.PGBConfig == 4 %HP-Ring, LP-Carrier 
        GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N3
        GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N2
        NRqNC = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_R/GR_C);
        NRqNS = NRqNC./(1+(rR/rS)*(1-NRqNC));
        NCqNS = NRqNS./NRqNC;
        CH = TrqCoeff.CTrqSR*NRqNS; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqCR*NCqNS; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = 250;
            MWS.PowerSystem.EMC.PMaxC = 0;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMC.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]); 
            MWS.PowerSystem.EMC.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = max(abs(([N3min N3MAX]*GR_R./NRqNS)/MWS.Shaft.PGB.Sun.GR_gb));
        MWS.PowerSystem.EMR.NMax = N3MAX*MWS.Shaft.PGB.Ring.GR_int;
        MWS.PowerSystem.EMC.NMax = N2MAX*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N2min N2MAX]*GR_C - [N3min N3MAX]*GR_R./NRqNS))/MWS.Shaft.PGB.Planet.GR_gb)); 
    elseif MWS.In.Options.PGBConfig == 5 %HP-Carrier, LP-Sun
        GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N3
        GR_S = MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb; %NS/N2
        NCqNS = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_C/GR_S);
        NCqNR = NCqNS.*rR./(NCqNS*(rS+rR)-rS);
        NSqNR = NCqNR./NCqNS;
        CH = TrqCoeff.CTrqSR*NCqNR; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqCR*NSqNR; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = 0;
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMC.PMaxC = 250;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMC.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMR.PMaxC = MWS.Shaft.PGB.CouplingEMPwr; 
            MWS.PowerSystem.EMC.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = N2MAX*MWS.Shaft.PGB.Sun.GR_int;
        MWS.PowerSystem.EMR.NMax = max(abs(([N3min N3MAX]*GR_C./NCqNR)/MWS.Shaft.PGB.Ring.GR_gb));
        MWS.PowerSystem.EMC.NMax = N3MAX*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_C - [N2min N2MAX]*GR_S))/MWS.Shaft.PGB.Planet.GR_gb)); 
    else %HP-Carrier, LP-Ring
        GR_C = MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb; %NC/N3
        GR_R = MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb; %NR/N2;
        NCqNR = [N3qN2_lowPwr N3qN2_hiPwr]*(GR_C/GR_R);
        NCqNS = NCqNR.*rS./(NCqNR*(rS+rR)-rR);
        NRqNS = NCqNS./NCqNR;
        CH = TrqCoeff.CTrqSR*NCqNS; %[CH_lowPwr CH_highPwr]
        CL = TrqCoeff.CTrqCR*NRqNS; %[CL_lowPwr CL_highPwr]
        if CH(1) >= 0 || CH(2) >= 0
            MWS.Shaft.PGB.Check = 0;
            disp('WARNING: The gearbox design does not favor the LPS across the entire engine power range and will not be consistent with the control algorithm')
        else
            MWS.Shaft.PGB.Check = 1;
        end
        if MWS.In.Options.HybridConfig == 1 % standard
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = 0;
            MWS.PowerSystem.EMC.PMaxC = 250;
            MWS.PowerSystem.EMP.PMaxC = 0;
        elseif MWS.In.Options.HybridConfig == 2 % boost
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = max([2000-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMC.PMaxC = max([-CH(2)*MWS.Shaft.PGB.CouplingEMPwr-175, 250]); 
            MWS.PowerSystem.EMP.PMaxC = 0;
        else % PEx
            MWS.PowerSystem.EMS.PMaxC = MWS.Shaft.PGB.CouplingEMPwr;
            MWS.PowerSystem.EMR.PMaxC = max([750-CL(2)*MWS.Shaft.PGB.CouplingEMPwr, 0]);
            MWS.PowerSystem.EMC.PMaxC = max([1000-CH(2)*MWS.Shaft.PGB.CouplingEMPwr, 250]);
            MWS.PowerSystem.EMP.PMaxC = 0;
        end
        MWS.PowerSystem.EMS.NMax = max(abs(([N3min N3MAX]*GR_C./NCqNS)/MWS.Shaft.PGB.Sun.GR_gb));
        MWS.PowerSystem.EMR.NMax = N2MAX*MWS.Shaft.PGB.Ring.GR_int;
        MWS.PowerSystem.EMC.NMax = N3MAX*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.PowerSystem.EMP.NMax = max(abs((rS/rP)*(([N3min N3MAX]*GR_C - [N2min N2MAX]*GR_R./NRqNS))/MWS.Shaft.PGB.Planet.GR_gb));
    end
    MWS.PowerSystem.EMS.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMS.PMaxC,MWS.PowerSystem.EMS.NMax); 
    MWS.PowerSystem.EMR.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMR.PMaxC,MWS.PowerSystem.EMR.NMax); 
    MWS.PowerSystem.EMC.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMC.PMaxC,MWS.PowerSystem.EMC.NMax); 
    MWS.PowerSystem.EMP.NfracKnee = interp2(PMax_vec,NMax_vec,NFracKnee_array,MWS.PowerSystem.EMP.PMaxC,MWS.PowerSystem.EMP.NMax); 
    MWS.PowerSystem.EMS.PMax = MWS.PowerSystem.EMS.PMaxC*PeakPwrFactor; 
    MWS.PowerSystem.EMR.PMax = MWS.PowerSystem.EMR.PMaxC*PeakPwrFactor;
    MWS.PowerSystem.EMC.PMax = MWS.PowerSystem.EMC.PMaxC*PeakPwrFactor;
    MWS.PowerSystem.EMP.PMax = MWS.PowerSystem.EMP.PMaxC*PeakPwrFactor;
    MWS.PowerSystem.EMS.NKnee = MWS.PowerSystem.EMS.NMax*MWS.PowerSystem.EMS.NfracKnee;
    MWS.PowerSystem.EMR.NKnee = MWS.PowerSystem.EMR.NMax*MWS.PowerSystem.EMR.NfracKnee;
    MWS.PowerSystem.EMC.NKnee = MWS.PowerSystem.EMC.NMax*MWS.PowerSystem.EMC.NfracKnee;
    MWS.PowerSystem.EMP.NKnee = MWS.PowerSystem.EMP.NMax*MWS.PowerSystem.EMP.NfracKnee;
    MWS.PowerSystem.EMS.TrqMaxC = MWS.PowerSystem.EMS.PMaxC*5252.113/MWS.PowerSystem.EMS.NKnee;
    MWS.PowerSystem.EMR.TrqMaxC = MWS.PowerSystem.EMR.PMaxC*5252.113/MWS.PowerSystem.EMR.NKnee;
    MWS.PowerSystem.EMC.TrqMaxC = MWS.PowerSystem.EMC.PMaxC*5252.113/MWS.PowerSystem.EMC.NKnee;
    MWS.PowerSystem.EMP.TrqMaxC = MWS.PowerSystem.EMP.PMaxC*5252.113/MWS.PowerSystem.EMP.NKnee;
    MWS.PowerSystem.EMS.TrqMax = MWS.PowerSystem.EMS.TrqMaxC*PeakTrqFactor;
    MWS.PowerSystem.EMR.TrqMax = MWS.PowerSystem.EMR.TrqMaxC*PeakTrqFactor;
    MWS.PowerSystem.EMC.TrqMax = MWS.PowerSystem.EMC.TrqMaxC*PeakTrqFactor;
    MWS.PowerSystem.EMP.TrqMax = MWS.PowerSystem.EMP.TrqMaxC*PeakTrqFactor;
    % Determine EM Weight and Inertia
    numEM = ceil(MWS.PowerSystem.EMS.PMaxC/PMaxPerEM);
    MWS.PowerSystem.EMS.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMS.TrqMaxC/max([numEM, 1]))^0.828;
    numEM = ceil(MWS.PowerSystem.EMR.PMaxC/PMaxPerEM);
    MWS.PowerSystem.EMR.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMR.TrqMaxC/max([numEM, 1]))^0.828;
    numEM = ceil(MWS.PowerSystem.EMC.PMaxC/PMaxPerEM);
    MWS.PowerSystem.EMC.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMC.TrqMaxC/max([numEM, 1]))^0.828;
    numEM = ceil(MWS.PowerSystem.EMP.PMaxC/PMaxPerEM);
    MWS.PowerSystem.EMP.Mass = numEM*0.0685218*0.2417*(MWS.PowerSystem.EMP.TrqMaxC/max([numEM, 1]))^0.828;
    MWS.PowerSystem.EMS.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMS.NMax);
    MWS.PowerSystem.EMR.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMR.NMax);
    MWS.PowerSystem.EMC.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMC.NMax);
    MWS.PowerSystem.EMP.Drotor = 60*Vtip/(pi*MWS.PowerSystem.EMP.NMax);
    MWS.PowerSystem.EMS.J = (1/2)*MWS.PowerSystem.EMS.Mass*(MWS.PowerSystem.EMS.Drotor/2)^2;
    MWS.PowerSystem.EMR.J = (1/2)*MWS.PowerSystem.EMR.Mass*(MWS.PowerSystem.EMR.Drotor/2)^2;
    MWS.PowerSystem.EMC.J = (1/2)*MWS.PowerSystem.EMC.Mass*(MWS.PowerSystem.EMC.Drotor/2)^2;
    MWS.PowerSystem.EMP.J = (1/2)*MWS.PowerSystem.EMP.Mass*(MWS.PowerSystem.EMP.Drotor/2)^2;
    % calculate inertia error
    JSold = JS;
    JRold = JR;
    JCold = JC;
    JPold = JP;
    JS = JSbase + MWS.PowerSystem.EMS.J/MWS.Shaft.PGB.Sun.GR_gb^2;
    JR = JRbase + MWS.PowerSystem.EMR.J/MWS.Shaft.PGB.Ring.GR_gb^2;
    JC = JCbase + MWS.PowerSystem.EMC.J/MWS.Shaft.PGB.Carrier.GR_gb^2;
    JP = JPbase + MWS.PowerSystem.EMP.J/MWS.Shaft.PGB.Planet.GR_gb^2;
    JErr = max([JS JR JC JP] - [JSold JRold JCold JPold]);
    % update iteration counter
    iter = iter + 1;
    if iter > 20
        disp('WARNING: Failed to converge on EM inertias')
        break
    end
end
% -- Extract results
%add Trq Coeff
MWS.Shaft.PGB.TrqCoeff.CTrqSR = TrqCoeff.CTrqSR;
MWS.Shaft.PGB.TrqCoeff.CTrqSC = TrqCoeff.CTrqSC;
MWS.Shaft.PGB.TrqCoeff.CTrqSP = TrqCoeff.CTrqSP;
MWS.Shaft.PGB.TrqCoeff.CTrqRS = TrqCoeff.CTrqRS;
MWS.Shaft.PGB.TrqCoeff.CTrqRC = TrqCoeff.CTrqRC;
MWS.Shaft.PGB.TrqCoeff.CTrqRP = TrqCoeff.CTrqRP;
MWS.Shaft.PGB.TrqCoeff.CTrqCS = TrqCoeff.CTrqCS;
MWS.Shaft.PGB.TrqCoeff.CTrqCR = TrqCoeff.CTrqCR;
MWS.Shaft.PGB.TrqCoeff.CTrqCP = TrqCoeff.CTrqCP;
MWS.Shaft.PGB.Sun.J = JS;
MWS.Shaft.PGB.Ring.J = JR;
MWS.Shaft.PGB.Carrier.J = JC;
MWS.Shaft.PGB.Planet.J = JP;
MWS.Shaft.PGB.Sun.JEff = JEff.Sun;
MWS.Shaft.PGB.Ring.JEff = JEff.Ring;
MWS.Shaft.PGB.Carrier.JEff = JEff.Carrier;

% Effective Spool Inertias -----------------------------------------------%

if MWS.In.Options.EngineEMInt == 1
    MWS.Shaft.JlpsEff = MWS.Shaft.DEM.LPS_Inertia;
    MWS.Shaft.JhpsEff = MWS.Shaft.DEM.HPS_Inertia;
else
    JSEff = MWS.Shaft.PGB.Sun.JEff;
    JREff = MWS.Shaft.PGB.Ring.JEff;
    JCEff = MWS.Shaft.PGB.Carrier.JEff;
    if MWS.In.Options.PGBConfig == 1 %HP-Sun, LP-Ring
        MWS.Shaft.JlpsEff = JREff*(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
        MWS.Shaft.JhpsEff = JSEff*(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    elseif MWS.In.Options.PGBConfig == 2 %HP-Sun, LP-Carrier
        MWS.Shaft.JlpsEff = JCEff*(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
        MWS.Shaft.JhpsEff = JSEff*(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
    elseif MWS.In.Options.PGBConfig == 3 %HP-Ring, LP-Sun
        MWS.Shaft.JlpsEff = JSEff*(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
        MWS.Shaft.JhpsEff = JREff*(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    elseif MWS.In.Options.PGBConfig == 4 %HP-Ring, LP-Carrier
        MWS.Shaft.JlpsEff = JCEff*(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
        MWS.Shaft.JhpsEff = JREff*(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
    elseif MWS.In.Options.PGBConfig == 5 %HP-Carrier, LP-Sun
        MWS.Shaft.JlpsEff = JSEff*(MWS.Shaft.PGB.Sun.GR_int*MWS.Shaft.PGB.Sun.GR_gb)^2;
        MWS.Shaft.JhpsEff = JCEff*(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
    else %HP-Carrier, LP-Ring
        MWS.Shaft.JlpsEff = JREff*(MWS.Shaft.PGB.Ring.GR_int*MWS.Shaft.PGB.Ring.GR_gb)^2;
        MWS.Shaft.JhpsEff = JCEff*(MWS.Shaft.PGB.Carrier.GR_int*MWS.Shaft.PGB.Carrier.GR_gb)^2;
    end
end

% Power System Parameters ------------------------------------------------%

% EM Reference Map
% COULD BE INTRODUCED LATER
% Reference.MotorTable.Speed = ...
% [0      7     20     50     100     200     500    1000    1500    2000    2500    3000    3500    4000    4500    5000]';
% 
% Reference.MotorTable.Torque = ...
% [0      7     20     30     50     100     200     500    1000    2000    3000    4000    5000]';
% 
% Reference.MotorTable.Eff = ...
% [
%    0.025757   0.15597   0.34316   0.4357    0.55134   0.66986   0.70504   0.60652   0.45787   0.30199   0.22466   0.17875   0.1484
%    0.025726   0.15597   0.3452    0.44105   0.56637   0.7168    0.81826   0.86384   0.83221   0.74271   0.66495   0.6008    0.54755
%    0.025674   0.15572   0.34499   0.44116   0.56758   0.7219    0.83249   0.90534   0.91302   0.88215   0.84418   0.80728   0.77271
%    0.025579   0.15522   0.34421   0.44043   0.5672    0.72294   0.83678   0.91941   0.94249   0.93906   0.92467   0.90808   0.89107
%    0.025439   0.15449   0.34297   0.43911   0.56601   0.72242   0.83763   0.92392   0.95259   0.95962   0.95497   0.94749   0.93899
%    0.02518    0.15312   0.34062   0.43656   0.56351   0.72061   0.83702   0.92567   0.95745   0.9701    0.97078   0.96843   0.96488
%    0.024473   0.14938   0.3341    0.42941   0.55638   0.71488   0.8335    0.92518   0.95955   0.97607   0.98023   0.98122   0.98094
%    0.023435   0.14382   0.32429   0.41857   0.54541   0.7058    0.82741   0.92258   0.95894   0.97739   0.98297   0.98522   0.98613
%    0.02251    0.13882   0.31533   0.40858   0.53518   0.69719   0.82151   0.91977   0.95768   0.97729   0.98351   0.98628   0.98765
%    0.021669   0.13423   0.30699   0.39921   0.52549   0.68892   0.81576   0.91694   0.95628   0.97683   0.98351   0.9866    0.98825
%    0.020893   0.12996   0.29912   0.39031   0.51619   0.68089   0.81011   0.91412   0.95482   0.97623   0.98329   0.98663   0.98847
%    0.020178   0.12599   0.29172   0.38188   0.50731   0.67312   0.80459   0.91132   0.95334   0.97557   0.98296   0.98652   0.98851
%    0.019516   0.12229   0.28474   0.37388   0.4988    0.66559   0.79919   0.90856   0.95187   0.97487   0.98258   0.98632   0.98845
%    0.0189     0.11883   0.27813   0.36626   0.49063   0.65827   0.7939    0.90583   0.95039   0.97416   0.98216   0.98607   0.98832
%    0.018325   0.11557   0.27185   0.35898   0.48277   0.65116   0.78871   0.90313   0.94893   0.97343   0.98172   0.98579   0.98816
%    0.017788   0.11251   0.26589   0.35203   0.4752    0.64424   0.78361   0.90045   0.94746   0.9727    0.98126   0.98549   0.98796
% ];

% LPS EM 
MWS.PowerSystem.EML.Speed = [0 100000]; 
MWS.PowerSystem.EML.Torque = [-10000 10000];
MWS.PowerSystem.EML.Eff = [1.0 1.0; 1.0 1.0];

% LPS EM
MWS.PowerSystem.EMH.Speed = [0 100000]; 
MWS.PowerSystem.EMH.Torque = [-10000 10000];
MWS.PowerSystem.EMH.Eff = [1.0 1.0; 1.0 1.0];

% Sun Gear EM
MWS.PowerSystem.EMS.Speed = [0 100000]; 
MWS.PowerSystem.EMS.Torque = [-10000 10000];
MWS.PowerSystem.EMS.Eff = [1.0 1.0; 1.0 1.0];

% Ring Gear EM
MWS.PowerSystem.EMR.Speed = [0 100000]; 
MWS.PowerSystem.EMR.Torque = [-10000 10000];
MWS.PowerSystem.EMR.Eff = [1.0 1.0; 1.0 1.0];

% Carrier EM 
MWS.PowerSystem.EMC.Speed = [0 100000]; 
MWS.PowerSystem.EMC.Torque = [-10000 10000];
MWS.PowerSystem.EMC.Eff = [1.0 1.0; 1.0 1.0];

% Planet Gear EM 
MWS.PowerSystem.EMP.Speed = [0 100000]; 
MWS.PowerSystem.EMP.Torque = [-10000 10000];
MWS.PowerSystem.EMP.Eff = [1.0 1.0; 1.0 1.0];

% LPS Inverter/Rectifier 
MWS.PowerSystem.EMLInverter.Eff = 1.00;

% HPS Inverter/Rectifier 
MWS.PowerSystem.EMHInverter.Eff = 1.00;

% Sun Gear EM Inverter/Rectifier 
MWS.PowerSystem.EMSInverter.Eff = 1.00;

% Ring Gear EM Inverter/Rectifier 
MWS.PowerSystem.EMRInverter.Eff = 1.00;

% Carrier EM Inverter/Rectifier 
MWS.PowerSystem.EMCInverter.Eff = 1.00;

% Planet Gear EM Inverter/Rectifier 
MWS.PowerSystem.EMPInverter.Eff = 1.00;

% EM Motor Cables 
MWS.PowerSystem.MotorCable.Eff = 1.00;

% DCDC Converter 
MWS.PowerSystem.DCDC.Eff = 1.00;

% Supply Cable 
MWS.PowerSystem.SupplyCable.Eff = 1.00;

% Energy Storage 
MWS.PowerSystem.ESD.Eff = 1.0;
if MWS.In.Options.HybridConfig == 2 %Boost
    MWS.PowerSystem.ESD.EnergyCapacity = 150.0; %kW-hr
else %standard & PEx
    MWS.PowerSystem.ESD.EnergyCapacity = 3.0; %kW-hr
end

% END --------------------------------------------------------------------%