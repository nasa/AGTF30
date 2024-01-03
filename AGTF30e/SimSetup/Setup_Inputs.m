function [MWS] = Setup_Inputs(MWS,method,In,filename)
%Setup_Inputs.m Summary
%   Written By: Jonathan Kratz
%   Date: June, 2023
%   Description: This function is ran prior to execuation of the AGTF30-e
%   engine model to setup the model inputs. This mainly consists
%   of environmental variables the define the flight profiles as well as
%   control input setting and hybrid configuration. 
%
%   Inputs:
%       method - 1: use Input structure In
%                2: use data in structured excel file given by filename
%                any other entry: use default inputs
%       In - input structure that defines the inputs
%       filename - string with the name (and file extension if necessary) 
%                of the file that contains the data to be used for defining
%                the inputs
%   Outputs:
%       MWS structure with "In" element that defines the inputs

% Simulation Time Step & Control Time Step
MWS.In.Ts = 0.015;

if method == 1 % use input struction In
    
    % Enable Limit Violtation Simulation Halts
    MWS.In.EnLimitStop_Prim = In.EnLimitStop_Prim;
    MWS.In.EnLimitStop_VBV = In.EnLimitStop_VBV;
    MWS.In.EnLimitStop_VAFN = In.EnLimitStop_VAFN;

    % Options
    % -- Hybrid Option (1-Standard Engine, 2-Boost, 3-PEx)
    MWS.In.Options.HybridConfig = In.Options.HybridConfig; 
    % -- Engine-EM Integration Option (1-Dedicated EM Approach, 2-VEATE Gearbox Approach)
    MWS.In.Options.EngineEMInt = In.Options.EngineEMInt;
    % -- VEATE Gearbox Configuration Option
    % ---- 1 - HP coupled to sun gear, LP coupled to ring gear
    % ---- 2 - HP coupled to sun gear, LP coupled to carrier
    % ---- 3 - HP coupled to ring gear, LP coupled to sun gear
    % ---- 4 - HP coupled to ring gear, LP coupled to carrier
    % ---- 5 - HP coupled to carrier, LP coupled to sun gear
    % ---- 6 - HP coupled to carrier, LP coupled to ring gear
    MWS.In.Options.PGBConfig = In.Options.PGBConfig;
    % -- Fuel Flow Transient Logic Option (1-Generic limiter, 2-Ratio Unit Limiter)
    MWS.In.Options.WfTransientLogic = In.Options.WfTransientLogic;
    % -- Turbine Electrified Energy Managment Option (0-Disable, 1-Enable)
    MWS.In.Options.TEEM = In.Options.TEEM;

    % Engine Input Variables
    % -- Altitude, ft
    MWS.In.t_Alt = In.t_Alt;
    MWS.In.Alt = In.Alt;
    % -- Ambient Temperature Difference from Standard Day, degR or degF
    MWS.In.t_dTamb = In.t_dTamb;
    MWS.In.dTamb = In.dTamb;
    % -- Mach Number
    MWS.In.t_MN = In.t_MN;
    MWS.In.MN = In.MN;
    % -- Aircraft Power Load
    MWS.In.t_PExAC = In.t_PExAC;
    MWS.In.PExAC = In.PExAC;

    % Control Inputs
    % -- Power Lever Angle, deg
    MWS.In.t_PLA = In.t_PLA;
    MWS.In.PLA = In.PLA;
    % -- Boost Toggle
    MWS.In.t_Boost = In.t_Boost;
    MWS.In.Boost = In.Boost;
    % -- EPT Toggle
    MWS.In.t_EPT = In.t_EPT;
    MWS.In.EPT = In.EPT;
    % --- Charging Toggle
    MWS.In.t_Charge = In.t_Charge;
    MWS.In.Charge = In.Charge;
    % -- Manual Control Inputs
    % ---- N1c Set-Point
    MWS.In.N1cManEn = In.N1cManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_N1cMan = In.t_N1cMan;
    MWS.In.N1cMan = In.N1cMan;
    % ---- Fuel Flow, lbm/s
    MWS.In.WfManEn = In.WfManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_WfMan = In.t_WfMan; 
    MWS.In.WfMan = In.WfMan;
    % ---- Variable bleed valve, frac. open
    MWS.In.VBVManEn = In.VBVManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_VBVMan = In.t_VBVMan; 
    MWS.In.VBVMan = In.VBVMan;
    % ---- Variable area fan nozzle, sqin
    MWS.In.VAFNManEn = In.VAFNManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_VAFNMan = In.t_VAFNMan; 
    MWS.In.VAFNMan = In.VAFNMan;
    % ---- LPS Additional Power (nominal), hp
    MWS.In.PwrInLPNomManEn = In.PwrInLPNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPNomMan = In.t_PwrInLPNomMan; 
    MWS.In.PwrInLPNomMan = In.PwrInLPNomMan;
    % ---- LPS Additional Power (off-nominal), hp
    MWS.In.PwrInLPOffNomManEn = In.PwrInLPOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPOffNomMan = In.t_PwrInLPOffNomMan; 
    MWS.In.PwrInLPOffNomMan = In.PwrInLPOffNomMan;
    % ---- HPS Additional Power (nominal), hp
    MWS.In.PwrInHPNomManEn = In.PwrInHPNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPNomMan = In.t_PwrInHPNomMan; 
    MWS.In.PwrInHPNomMan = In.PwrInHPNomMan;
    % ---- HPS Additional Power (off-nominal), hp
    MWS.In.PwrInHPOffNomManEn = In.PwrInHPOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPOffNomMan = In.t_PwrInHPOffNomMan; 
    MWS.In.PwrInHPOffNomMan = In.PwrInHPOffNomMan;
    % ---- LPS Electric Machine Power (nominal), hp
    MWS.In.PwrInLPEMNomManEn = In.PwrInLPEMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMNomMan = In.t_PwrInLPEMNomMan; 
    MWS.In.PwrInLPEMNomMan = In.PwrInLPEMNomMan;
    % ---- LPS Electric Machine Power (off-nominal), hp
    MWS.In.PwrInLPEMOffNomManEn = In.PwrInLPEMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMOffNomMan = In.t_PwrInLPEMOffNomMan; 
    MWS.In.PwrInLPEMOffNomMan = In.PwrInLPEMOffNomMan;
    % ---- HPS Electric Machine Power (nominal), hp
    MWS.In.PwrInHPEMNomManEn = In.PwrInHPEMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMNomMan = In.t_PwrInHPEMNomMan; 
    MWS.In.PwrInHPEMNomMan = In.PwrInHPEMNomMan;
    % ---- HPS Electric Machine Power (off-nominal), hp
    MWS.In.PwrInHPEMOffNomManEn = In.PwrInHPEMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMOffNomMan = In.t_PwrInHPEMOffNomMan; 
    MWS.In.PwrInHPEMOffNomMan = In.PwrInHPEMOffNomMan;
    % ---- Sun Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInSEMNomManEn = In.PwrInSEMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMNomMan = In.t_PwrInSEMNomMan; 
    MWS.In.PwrInSEMNomMan = In.PwrInSEMNomMan;
    % ---- Sun Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInSEMOffNomManEn = In.PwrInSEMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMOffNomMan = In.t_PwrInSEMOffNomMan; 
    MWS.In.PwrInSEMOffNomMan = In.PwrInSEMOffNomMan;
    % ---- Ring Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInREMNomManEn = In.PwrInREMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMNomMan = In.t_PwrInREMNomMan; 
    MWS.In.PwrInREMNomMan = In.PwrInREMNomMan;
    % ---- Ring Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInREMOffNomManEn = In.PwrInREMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMOffNomMan = In.t_PwrInREMOffNomMan; 
    MWS.In.PwrInREMOffNomMan = In.PwrInREMOffNomMan;
    % ---- Carrier Electric Machine Power (nominal), hp
    MWS.In.PwrInCEMNomManEn = In.PwrInCEMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMNomMan = In.t_PwrInCEMNomMan; 
    MWS.In.PwrInCEMNomMan = In.PwrInCEMNomMan;
    % ---- Carrier Electric Machine Power (off-nominal), hp
    MWS.In.PwrInCEMOffNomManEn = In.PwrInCEMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMOffNomMan = In.t_PwrInCEMOffNomMan; 
    MWS.In.PwrInCEMOffNomMan = In.PwrInCEMOffNomMan;
    % ---- Planet Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInPEMNomManEn = In.PwrInPEMNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMNomMan = In.t_PwrInPEMNomMan; 
    MWS.In.PwrInPEMNomMan = In.PwrInPEMNomMan;
    % ---- Planet Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInPEMOffNomManEn = In.PwrInPEMOffNomManEn; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMOffNomMan = In.t_PwrInPEMOffNomMan; 
    MWS.In.PwrInPEMOffNomMan = In.PwrInPEMOffNomMan;
    
elseif method == 2 % use input from formated excel file
    
    %Note that the excel file has to be formated appropriately and the
    %inputs you wish to use should be on the first sheet in the
    %spreadsheet. The file should also be saved in the active directory or 
    %the full file extension should be provided in the file name. The data
    %set length is limited to 10000 time instances per variable. The excel
    %file should be formated as follows (note x is the row number 
    %corresponding to the last entry for each individual data set which 
    %must have time and value vectors of the same length):
    %   Option.HybridConfig: B12
    %   Option.EngineEMInt: B13
    %   Option.PGBConfig: B14
    %   Option.WfTransientLogic: B15
    %   Option.TEEM: B16
    %   t_Alt: A22:Ax
    %   Alt: B22:Bx
    %   t_dTamb: C22:Cx
    %   dTamb: D22:Dx
    %   t_MN: E22:Ex
    %   MN: F22:Fx
    %   t_PExAC: G22:Gx
    %   PExAC: H22:Hx
    %   t_PLA: J22:Jx
    %   PLA: K22:Kx
    %   t_Boost: L22:Lx
    %   Boost: M22:Mx
    %   t_EPT: N22:Nx
    %   EPT: O22:Ox
    %   t_Charge: P22:Px
    %   Charge: Q22:Qx
    %   N1cManEn = BG20
    %   t_N1cMan: R22:Rx
    %   N1cMan: S22:SSx
    %   WfManEn = BG21
    %   t_WfMan: T22:Tx
    %   WfMan: U22:Ux
    %   VBVManEn = BG22
    %   t_VBVMan: V22:Vx
    %   VBVMan: W22:Wx
    %   VAFNManEn = BG23
    %   t_VAFNMan: X22:Xx
    %   VAFNMan: Y22:Yx
    %   PwrInLPNomManEn = BG24
    %   t_PwrInLPNomMan: Z22:Zx
    %   PwrInLPNomMan: AA22:AAx
    %   PwrInLPOffNomManEn = BG25
    %   t_PwrInLPOffNomMan: AB22:ABx
    %   PwrInLPOffNomMan: AC22:ACx
    %   PwrInHPNomManEn = BG26
    %   t_PwrInHPNomMan: AD22:ADx
    %   PwrInHPNomMan: AE22:AEx
    %   PwrInHPOffNomManEn = BG27
    %   t_PwrInHPOffNomMan: AF22:AFx
    %   PwrInHPOffNomMan: AG22:AGx
    %   PwrInLPEMNomManEn = BG28
    %   t_PwrInLPEMNomMan: AH22:AHx
    %   PwrInLPEMNomMan: AI22:AIx
    %   PwrInLPEMOffNomManEn = BG29
    %   t_PwrInLPEMOffNomMan: AJ22:AJx
    %   PwrInLPEMOffNomMan: AK22:AKx
    %   PwrInHPEMNomManEn = BG30
    %   t_PwrInHPEMNomMan: AL22:ALx
    %   PwrInHPEMNomMan: AM22:AMx
    %   PwrInHPEMOffNomManEn = BG31
    %   t_PwrInHPEMOffNomMan: AN22:ANx
    %   PwrInHPEMOffNomMan: AO22:AOx
    %   PwrInSEMNomManEn = BG32
    %   t_PwrInSEMNomMan: AP22:APx
    %   PwrInSEMNomMan: AQ22:AQx
    %   PwrInSEMOffNomManEn = BG33
    %   t_PwrInSEMOffNomMan: AR22:ARx
    %   PwrInSEMOffNomMan: AS22:ASx
    %   PwrInREMNomManEn = BG34
    %   t_PwrInREMNomMan: AT22:ATx
    %   PwrInREMNomMan: AU22:AUx
    %   PwrInREMOffNomManEn = BG35
    %   t_PwrInREMOffNomMan: AV22:AVx
    %   PwrInREMOffNomMan: AW22:AWx
    %   PwrInCEMNomManEn = BG36
    %   t_PwrInCEMNomMan: AX22:AXx
    %   PwrInCEMNomMan: AY22:AYx
    %   PwrInCEMOffNomManEn = BG37
    %   t_PwrInCEMOffNomMan: AZ22:AZx
    %   PwrInCEMOffNomMan: BA22:BAx
    %   PwrInPEMNomManEn = BG38
    %   t_PwrInPEMNomMan: BB22:BBx
    %   PwrInCEMNomMan: BC22:BCx
    %   PwrInPEMOffNomManEn = BG39
    %   t_PwrInPEMOffNomMan: BD22:BDx
    %   PwrInPEMOffNomMan: BE22:BEx
    %   EnLimitStop_Prim: BJ20:BJ48
    %   EnLimitStop_VBV: BM20:BM21
    %   EnLimitStop_VAFN: BM25:BM26
    
    % Enable Limit Violtation Simulation Halts
    MWS.In.EnLimitStop_Prim = xlsread(filename,'BJ20:BJ48');
    MWS.In.EnLimitStop_VBV = xlsread(filename,'BM20:BM21');
    MWS.In.EnLimitStop_VAFN = xlsread(filename,'BM25:BM26');

    % Options
    % -- Hybrid Option (1-Standard Engine, 2-Boost, 3-PEx)
    MWS.In.Options.HybridConfig = xlsread(filename,'B12:B12'); 
    % -- Engine-EM Integration Option (1-Dedicated EM Approach, 2-VEATE Gearbox Approach)
    MWS.In.Options.EngineEMInt = xlsread(filename,'B13:B13'); 
    % -- VEATE Gearbox Configuration Option
    % ---- 1 - HP coupled to sun gear, LP coupled to ring gear
    % ---- 2 - HP coupled to sun gear, LP coupled to carrier
    % ---- 3 - HP coupled to ring gear, LP coupled to sun gear
    % ---- 4 - HP coupled to ring gear, LP coupled to carrier
    % ---- 5 - HP coupled to carrier, LP coupled to sun gear
    % ---- 6 - HP coupled to carrier, LP coupled to ring gear
    MWS.In.Options.PGBConfig = xlsread(filename,'B14:B14'); 
    % -- Fuel Flow Transient Logic Option (1-Generic limiter, 2-Ratio Unit Limiter)
    MWS.In.Options.WfTransientLogic = xlsread(filename,'B15:B15'); 
    % -- Turbine Electrified Energy Managment Option (0-Disable, 1-Enable)
    MWS.In.Options.TEEM = xlsread(filename,'B16:B16'); 

    % Engine Input Variables
    % -- Altitude, ft
    MWS.In.t_Alt = xlsread(filename,'A22:A10022');
    MWS.In.Alt = xlsread(filename,'B22:B10022');
    % -- Ambient Temperature Difference from Standard Day, degR or degF
    MWS.In.t_dTamb = xlsread(filename,'C22:C10022');
    MWS.In.dTamb = xlsread(filename,'D22:D10022');
    % -- Mach Number
    MWS.In.t_MN = xlsread(filename,'E22:E10022');
    MWS.In.MN = xlsread(filename,'F22:F10022');
    % -- Aircraft Power Load
    MWS.In.t_PExAC = xlsread(filename,'G22:G10022');
    MWS.In.PExAC = xlsread(filename,'H22:H10022');

    % Control Inputs
    % -- Power Lever Angle, deg
    MWS.In.t_PLA = xlsread(filename,'J22:J10022');
    MWS.In.PLA = xlsread(filename,'K22:K10022');
    % -- Boost Toggle
    MWS.In.t_Boost = xlsread(filename,'L22:L10022');
    MWS.In.Boost = xlsread(filename,'M22:M10022');
    % -- EPT Toggle
    MWS.In.t_EPT = xlsread(filename,'N22:N10022');
    MWS.In.EPT = xlsread(filename,'O22:O10022');
    % --- Charging Toggle
    MWS.In.t_Charge = xlsread(filename,'P22:P10022');;
    MWS.In.Charge = xlsread(filename,'Q22:Q10022');;
    % -- Manual Control Inputs
    % ---- Corrected Fan Speed Command, rpm
    MWS.In.N1cManEn = xlsread(filename,'BG20:BG20'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_N1cMan = xlsread(filename,'R22:R10022'); 
    MWS.In.N1cMan = xlsread(filename,'S22:S10022');
    % ---- Fuel Flow, lbm/s
    MWS.In.WfManEn = xlsread(filename,'BG21:BG21'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_WfMan = xlsread(filename,'T22:T10022'); 
    MWS.In.WfMan = xlsread(filename,'U22:U10022');
    % ---- Variable bleed valve, frac. open
    MWS.In.VBVManEn = xlsread(filename,'BG22:BG22'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_VBVMan = xlsread(filename,'V22:V10022');
    MWS.In.VBVMan = xlsread(filename,'W22:W10022');
    % ---- Variable area fan nozzle, sqin
    MWS.In.VAFNManEn = xlsread(filename,'BG23:BG23'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_VAFNMan = xlsread(filename,'X22:X10022');
    MWS.In.VAFNMan = xlsread(filename,'Y22:Y10022');
    % ---- LPS Additional Power (nominal), hp
    MWS.In.PwrInLPNomManEn = xlsread(filename,'BG24:BG24'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPNomMan = xlsread(filename,'Z22:Z10022');
    MWS.In.PwrInLPNomMan = xlsread(filename,'AA22:AA10022');
    % ---- LPS Additional Power (off-nominal), hp
    MWS.In.PwrInLPOffNomManEn = xlsread(filename,'BG25:BG25'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPOffNomMan = xlsread(filename,'AB22:AB10022');
    MWS.In.PwrInLPOffNomMan = xlsread(filename,'AC22:AC10022');
    % ---- HPS Additional Power (nominal), hp
    MWS.In.PwrInHPNomManEn = xlsread(filename,'BG26:BG26'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPNomMan = xlsread(filename,'AD22:AD10022'); 
    MWS.In.PwrInHPNomMan = xlsread(filename,'AE22:AE10022');
    % ---- HPS Additional Power (off-nominal), hp
    MWS.In.PwrInHPOffNomManEn = xlsread(filename,'BG27:BG27'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPOffNomMan = xlsread(filename,'AF22:AF10022'); 
    MWS.In.PwrInHPOffNomMan = xlsread(filename,'AG22:AG10022');
    % ---- LPS Electric Machine (nominal), hp
    MWS.In.PwrInLPEMNomManEn = xlsread(filename,'BG28:BG28'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMNomMan = xlsread(filename,'AH22:AH10022');
    MWS.In.PwrInLPEMNomMan = xlsread(filename,'AI22:AI10022');
    % ---- LPS Electric Machine (off-nominal), hp
    MWS.In.PwrInLPEMOffNomManEn = xlsread(filename,'BG29:BG29'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMOffNomMan = xlsread(filename,'AJ22:AJ10022');
    MWS.In.PwrInLPEMOffNomMan = xlsread(filename,'AK22:AK10022');
    % ---- HPS Electric Machine (nominal), hp
    MWS.In.PwrInHPEMNomManEn = xlsread(filename,'BG30:BG30'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMNomMan = xlsread(filename,'AL22:AL10022'); 
    MWS.In.PwrInHPEMNomMan = xlsread(filename,'AM22:AM10022');
    % ---- HPS Electric Machine (off-nominal), hp
    MWS.In.PwrInHPEMOffNomManEn = xlsread(filename,'BG31:BG31'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMOffNomMan = xlsread(filename,'AN22:AN10022'); 
    MWS.In.PwrInHPEMOffNomMan = xlsread(filename,'AO22:AO10022');
    % ---- Sun Gear Electric Machine (nominal), hp
    MWS.In.PwrInSEMNomManEn = xlsread(filename,'BG32:BG32'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMNomMan = xlsread(filename,'AP22:AP10022'); 
    MWS.In.PwrInSEMNomMan = xlsread(filename,'AQ22:AQ10022');
    % ---- Sun Gear Electric Machine (off-nominal), hp
    MWS.In.PwrInSEMOffNomManEn = xlsread(filename,'BG33:BG33'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMOffNomMan = xlsread(filename,'AR22:AR10022'); 
    MWS.In.PwrInSEMOffNomMan = xlsread(filename,'AS22:AS10022');
    % ---- Ring Gear Electric Machine (nominal), hp
    MWS.In.PwrInREMNomManEn = xlsread(filename,'BG34:BG34'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMNomMan = xlsread(filename,'AT22:AT10022'); 
    MWS.In.PwrInREMNomMan = xlsread(filename,'AU22:AU10022');
    % ---- Ring Gear Electric Machine (off-nominal), hp
    MWS.In.PwrInREMOffNomManEn = xlsread(filename,'BG35:BG35'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMOffNomMan = xlsread(filename,'AV22:AV10022'); 
    MWS.In.PwrInREMOffNomMan = xlsread(filename,'AW22:AW10022');
    % ---- Carrier Electric Machine (nominal), hp
    MWS.In.PwrInCEMNomManEn = xlsread(filename,'BG36:BG36'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMNomMan = xlsread(filename,'AX22:AX10022'); 
    MWS.In.PwrInCEMNomMan = xlsread(filename,'AY22:AY10022');
    % ---- Carrier Electric Machine (off-nominal), hp
    MWS.In.PwrInCEMOffNomManEn = xlsread(filename,'BG37:BG37'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMOffNomMan = xlsread(filename,'AZ22:AZ10022'); 
    MWS.In.PwrInCEMOffNomMan = xlsread(filename,'BA22:BA10022');
    % ---- Planet Gear Electric Machine (nominal), hp
    MWS.In.PwrInPEMNomManEn = xlsread(filename,'BG38:BG38'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMNomMan = xlsread(filename,'BB22:BB10022'); 
    MWS.In.PwrInPEMNomMan = xlsread(filename,'BC22:BC10022');
    % ---- Planet Gear Electric Machine (off-nominal), hp
    MWS.In.PwrInPEMOffNomManEn = xlsread(filename,'BG39:BG39'); % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMOffNomMan = xlsread(filename,'BD22:BD10022'); 
    MWS.In.PwrInPEMOffNomMan = xlsread(filename,'BE22:BE10022');

else % use default inputs
    
    % Enable Limit Violtation Simulation Halts
    MWS.In.EnLimitStop_Prim = zeros(29,1);
    MWS.In.EnLimitStop_VBV = [0; 0];
    MWS.In.EnLimitStop_VAFN = [0; 0];

    % Options
    % -- Hybrid Option (1-Standard Engine, 2-Boost, 3-PEx)
    MWS.In.Options.HybridConfig = 1; 
    % -- Engine-EM Integration Option (1-Dedicated EM Approach, 2-VEATE Gearbox Approach)
    MWS.In.Options.EngineEMInt = 1;
    % -- VEATE Gearbox Configuration Option
    % ---- 1 - HP coupled to sun gear, LP coupled to ring gear
    % ---- 2 - HP coupled to sun gear, LP coupled to carrier
    % ---- 3 - HP coupled to ring gear, LP coupled to sun gear
    % ---- 4 - HP coupled to ring gear, LP coupled to carrier
    % ---- 5 - HP coupled to carrier, LP coupled to sun gear
    % ---- 6 - HP coupled to carrier, LP coupled to ring gear
    MWS.In.Options.PGBConfig = 2;
    % -- Fuel Flow Transient Logic Option (1-Generic limiter, 2-Ratio Unit Limiter)
    MWS.In.Options.WfTransientLogic = 1;
    % -- Turbine Electrified Energy Managment Option (0-Disable, 1-Enable)
    MWS.In.Options.TEEM = 0;

    % Engine Input Variables
    % -- Altitude, ft
    MWS.In.t_Alt = [0 10];
    MWS.In.Alt = In.Alt;
    % -- Ambient Temperature Difference from Standard Day, degR or degF
    MWS.In.t_dTamb = [0 10];
    MWS.In.dTamb = In.dTamb;
    % -- Mach Number
    MWS.In.t_MN = [0 10];
    MWS.In.MN = In.MN;
    % -- Aircraft Power Load
    MWS.In.t_PExAC = [0 10];
    MWS.In.PExAC = In.PExAC;

    % Control Inputs
    % -- Power Lever Angle, deg
    MWS.In.t_PLA = [0 10];
    MWS.In.PLA = [80 80];
    % -- Boost Toggle
    MWS.In.t_Boost = [0 10];
    MWS.In.Boost = [0 0];
    % -- EPT Toggle
    MWS.In.t_EPT = [0 10];
    MWS.In.EPT = [0 0];
    % --- Charging Toggle
    MWS.In.t_Charge = [0 10];
    MWS.In.Charge = [0 0];
    % -- Manual Control Inputs
    % ---- N1c Set-Point
    MWS.In.N1cManEn = [0 10]; % 0-use control loop, 1-use manual prescription
    MWS.In.t_N1cMan = [0 10];
    MWS.In.N1cMan = [2003.2 2003.2];
    % ---- Fuel Flow, lbm/s
    MWS.In.WfManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_WfMan = [0 10]; 
    MWS.In.WfMan = [1.5379 1.5379];
    % ---- Variable bleed valve, frac. open
    MWS.In.VBVManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_VBVMan = [0 10]; 
    MWS.In.VBVMan = [0 0];
    % ---- Variable area fan nozzle, sqin
    MWS.In.VAFNManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_VAFNMan = [0 10];
    MWS.In.VAFNMan = [6105.5 6105.5];
    % ---- LPS Additional Power (nominal), hp
    MWS.In.PwrInLPNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPNomMan = [0 10];
    MWS.In.PwrInLPNomMan = [0 0];
    % ---- LPS Additional Power (off-nominal), hp
    MWS.In.PwrInLPOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPOffNomMan = [0 10]; 
    MWS.In.PwrInLPOffNomMan = [0 0];
    % ---- HPS Additional Power (nominal), hp
    MWS.In.PwrInHPNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPNomMan = [0 10];
    MWS.In.PwrInHPNomMan = [0 0];
    % ---- HPS Additional Power (off-nominal), hp
    MWS.In.PwrInHPOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPOffNomMan = [0 10];
    MWS.In.PwrInHPOffNomMan = [0 0];
    % ---- LPS Electric Machine Power (nominal), hp
    MWS.In.PwrInLPEMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMNomMan = [0 10];
    MWS.In.PwrInLPEMNomMan = [0 0];
    % ---- LPS Electric Machine Power (off-nominal), hp
    MWS.In.PwrInLPEMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInLPEMOffNomMan = [0 10];
    MWS.In.PwrInLPEMOffNomMan = [0 0];
    % ---- HPS Electric Machine Power (nominal), hp
    MWS.In.PwrInHPEMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMNomMan = [0 10];
    MWS.In.PwrInHPEMNomMan = [0 0];
    % ---- HPS Electric Machine Power (off-nominal), hp
    MWS.In.PwrInHPEMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInHPEMOffNomMan = [0 10];
    MWS.In.PwrInHPEMOffNomMan = [0 0];
    % ---- Sun Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInSEMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMNomMan = [0 10];
    MWS.In.PwrInSEMNomMan = [0 0];
    % ---- Sun Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInSEMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInSEMOffNomMan = [0 10];
    MWS.In.PwrInSEMOffNomMan = [0 0];
    % ---- Ring Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInREMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMNomMan = [0 10]; 
    MWS.In.PwrInREMNomMan = [0 0];
    % ---- Ring Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInREMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInREMOffNomMan = [0 10];
    MWS.In.PwrInREMOffNomMan = [0 0];
    % ---- Carrier Electric Machine Power (nominal), hp
    MWS.In.PwrInCEMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMNomMan = [0 10]; 
    MWS.In.PwrInCEMNomMan = [0 0];
    % ---- Carrier Electric Machine Power (off-nominal), hp
    MWS.In.PwrInCEMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInCEMOffNomMan = [0 10]; 
    MWS.In.PwrInCEMOffNomMan = [0 0];
    % ---- Planet Gear Electric Machine Power (nominal), hp
    MWS.In.PwrInPEMNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMNomMan = [0 10];
    MWS.In.PwrInPEMNomMan = [0 0];
    % ---- Planet Gear Electric Machine Power (off-nominal), hp
    MWS.In.PwrInPEMOffNomManEn = 0; % 0-use control loop, 1-use manual prescription
    MWS.In.t_PwrInPEMOffNomMan = [0 10];
    MWS.In.PwrInPEMOffNomMan = [0 0];
    
end

% Simulation End Time
MWS.In.tend = max([MWS.In.t_Alt(end) MWS.In.t_dTamb(end) MWS.In.t_MN(end) ...
    MWS.In.t_PExAC(end) MWS.In.t_PLA(end) MWS.In.t_Boost(end) MWS.In.t_EPT(end) ...
    MWS.In.t_Charge(end) MWS.In.t_N1cMan(end) MWS.In.t_WfMan(end) MWS.In.t_VBVMan(end) ...
    MWS.In.t_VAFNMan(end) MWS.In.t_PwrInLPNomMan(end) MWS.In.t_PwrInLPOffNomMan(end) ...
    MWS.In.t_PwrInHPNomMan(end) MWS.In.t_PwrInHPOffNomMan(end) MWS.In.t_PwrInLPEMNomMan(end) ...
    MWS.In.t_PwrInLPEMOffNomMan(end) MWS.In.t_PwrInHPEMNomMan(end) MWS.In.t_PwrInHPEMOffNomMan(end) ...
    MWS.In.t_PwrInSEMNomMan(end) MWS.In.t_PwrInSEMOffNomMan(end) MWS.In.t_PwrInREMNomMan(end) ...
    MWS.In.t_PwrInREMOffNomMan(end) MWS.In.t_PwrInCEMNomMan(end) MWS.In.t_PwrInCEMOffNomMan(end) ...
    MWS.In.t_PwrInPEMNomMan(end) MWS.In.t_PwrInPEMOffNomMan(end)]);

end

