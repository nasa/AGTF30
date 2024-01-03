function MWS = setup_initialize(MWS,StartPt,SSsolverSP)
% void setup_initalize()
% MWS = setup_simulation(Input_structure)
% This function defines initial conditions and solver parameters

% *************************************************************************
% written by Jonathan Kratz
% NASA Glenn Research Center, Cleveland, OH
% May 19th, 2023

% Load Steady-State Data
load([cd,'\Data\data_Trim_HPPwrEx.mat']); % loads dataTrim_HPPwrEx
load([cd,'\Data\data_Trim_HPPwrIn.mat']); % loads dataTrim_HPPwrIn
% Consolidate steady-state data
dataTrim.Alt_vec = dataTrim_HPPwrIn.Alt_vec;
dataTrim.MN_vec = dataTrim_HPPwrIn.MN_vec;
dataTrim.PwrInLP_vec = dataTrim_HPPwrIn.PwrInLP_vec;
dataTrim.PwrInHP_vec = [dataTrim_HPPwrEx.PwrInHP_vec dataTrim_HPPwrIn.PwrInHP_vec];
dataTrim.PL_vec = dataTrim_HPPwrIn.PL_vec;
dataTrim.FnFrac(:,:,:,:,1:7) = dataTrim_HPPwrEx.FnFrac;
dataTrim.FnFrac(:,:,:,:,8:14) = dataTrim_HPPwrIn.FnFrac;
dataTrim.Wf(:,:,:,:,1:7) = dataTrim_HPPwrEx.Wf;
dataTrim.Wf(:,:,:,:,8:14) = dataTrim_HPPwrIn.Wf;
dataTrim.VBV(:,:,:,:,1:7) = dataTrim_HPPwrEx.VBV;
dataTrim.VBV(:,:,:,:,8:14) = dataTrim_HPPwrIn.VBV;
dataTrim.VAFN(:,:,:,:,1:7) = dataTrim_HPPwrEx.VAFN;
dataTrim.VAFN(:,:,:,:,8:14) = dataTrim_HPPwrIn.VAFN;
dataTrim.PwrInLP(:,:,:,:,1:7) = dataTrim_HPPwrEx.PwrInLP;
dataTrim.PwrInLP(:,:,:,:,8:14) = dataTrim_HPPwrIn.PwrInLP;
dataTrim.PwrInHP(:,:,:,:,1:7) = dataTrim_HPPwrEx.PwrInHP;
dataTrim.PwrInHP(:,:,:,:,8:14) = dataTrim_HPPwrIn.PwrInHP;
dataTrim.Fn(:,:,:,:,1:7) = dataTrim_HPPwrEx.Fn;
dataTrim.Fn(:,:,:,:,8:14) = dataTrim_HPPwrIn.Fn;
dataTrim.N1(:,:,:,:,1:7) = dataTrim_HPPwrEx.N1;
dataTrim.N1(:,:,:,:,8:14) = dataTrim_HPPwrIn.N1;
dataTrim.N2(:,:,:,:,1:7) = dataTrim_HPPwrEx.N2;
dataTrim.N2(:,:,:,:,8:14) = dataTrim_HPPwrIn.N2;
dataTrim.N3(:,:,:,:,1:7) = dataTrim_HPPwrEx.N3;
dataTrim.N3(:,:,:,:,8:14) = dataTrim_HPPwrIn.N3;
dataTrim.N1c(:,:,:,:,1:7) = dataTrim_HPPwrEx.N1c;
dataTrim.N1c(:,:,:,:,8:14) = dataTrim_HPPwrIn.N1c;
dataTrim.N3c2(:,:,:,:,1:7) = dataTrim_HPPwrEx.N3c2;
dataTrim.N3c2(:,:,:,:,8:14) = dataTrim_HPPwrIn.N3c2;
dataTrim.T2(:,:,:,:,1:7) = dataTrim_HPPwrEx.T2;
dataTrim.T2(:,:,:,:,8:14) = dataTrim_HPPwrIn.T2;
dataTrim.T3(:,:,:,:,1:7) = dataTrim_HPPwrEx.T3;
dataTrim.T3(:,:,:,:,8:14) = dataTrim_HPPwrIn.T3;
dataTrim.T4(:,:,:,:,1:7) = dataTrim_HPPwrEx.T4;
dataTrim.T4(:,:,:,:,8:14) = dataTrim_HPPwrIn.T4;
dataTrim.T45(:,:,:,:,1:7) = dataTrim_HPPwrEx.T45;
dataTrim.T45(:,:,:,:,8:14) = dataTrim_HPPwrIn.T45;
dataTrim.T5(:,:,:,:,1:7) = dataTrim_HPPwrEx.T5;
dataTrim.T5(:,:,:,:,8:14) = dataTrim_HPPwrIn.T5;
dataTrim.P2(:,:,:,:,1:7) = dataTrim_HPPwrEx.P2;
dataTrim.P2(:,:,:,:,8:14) = dataTrim_HPPwrIn.P2;
dataTrim.P25(:,:,:,:,1:7) = dataTrim_HPPwrEx.P25;
dataTrim.P25(:,:,:,:,8:14) = dataTrim_HPPwrIn.P25;
dataTrim.P3(:,:,:,:,1:7) = dataTrim_HPPwrEx.P3;
dataTrim.P3(:,:,:,:,8:14) = dataTrim_HPPwrIn.P3;
dataTrim.Ps3(:,:,:,:,1:7) = dataTrim_HPPwrEx.Ps3;
dataTrim.Ps3(:,:,:,:,8:14) = dataTrim_HPPwrIn.Ps3;
dataTrim.P45(:,:,:,:,1:7) = dataTrim_HPPwrEx.P45;
dataTrim.P45(:,:,:,:,8:14) = dataTrim_HPPwrIn.P45;
dataTrim.P5(:,:,:,:,1:7) = dataTrim_HPPwrEx.P5;
dataTrim.P5(:,:,:,:,8:14) = dataTrim_HPPwrIn.P5;
dataTrim.W(:,:,:,:,1:7) = dataTrim_HPPwrEx.W;
dataTrim.W(:,:,:,:,8:14) = dataTrim_HPPwrIn.W;
dataTrim.BPR(:,:,:,:,1:7) = dataTrim_HPPwrEx.BPR;
dataTrim.BPR(:,:,:,:,8:14) = dataTrim_HPPwrIn.BPR;
dataTrim.FanSM(:,:,:,:,1:7) = dataTrim_HPPwrEx.FanSM;
dataTrim.FanSM(:,:,:,:,8:14) = dataTrim_HPPwrIn.FanSM;
dataTrim.LPCSM(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPCSM;
dataTrim.LPCSM(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPCSM;
dataTrim.HPCSM(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPCSM;
dataTrim.HPCSM(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPCSM;
dataTrim.FanWcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.FanWcMap;
dataTrim.FanWcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.FanWcMap;
dataTrim.FanPRMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.FanPRMap;
dataTrim.FanPRMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.FanPRMap;
dataTrim.FanNcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.FanNcMap;
dataTrim.FanNcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.FanNcMap;
dataTrim.LPCWcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPCWcMap;
dataTrim.LPCWcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPCWcMap;
dataTrim.LPCPRMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPCPRMap;
dataTrim.LPCPRMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPCPRMap;
dataTrim.LPCNcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPCNcMap;
dataTrim.LPCNcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPCNcMap;
dataTrim.HPCWcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPCWcMap;
dataTrim.HPCWcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPCWcMap;
dataTrim.HPCPRMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPCPRMap;
dataTrim.HPCPRMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPCPRMap;
dataTrim.HPCNcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPCNcMap;
dataTrim.HPCNcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPCNcMap;
dataTrim.HPTWcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPTWcMap;
dataTrim.HPTWcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPTWcMap;
dataTrim.HPTPRMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPTPRMap;
dataTrim.HPTPRMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPTPRMap;
dataTrim.HPTNcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.HPTNcMap;
dataTrim.HPTNcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.HPTNcMap;
dataTrim.LPTWcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPTWcMap;
dataTrim.LPTWcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPTWcMap;
dataTrim.LPTPRMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPTPRMap;
dataTrim.LPTPRMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPTPRMap;
dataTrim.LPTNcMap(:,:,:,:,1:7) = dataTrim_HPPwrEx.LPTNcMap;
dataTrim.LPTNcMap(:,:,:,:,8:14) = dataTrim_HPPwrIn.LPTNcMap;
dataTrim.ICs(:,:,:,:,:,1:7) = dataTrim_HPPwrEx.ICs;
dataTrim.ICs(:,:,:,:,:,8:14) = dataTrim_HPPwrIn.ICs;
dataTrim.VBVopt(:,:,:,:,1:7) = dataTrim_HPPwrEx.VBVopt;
dataTrim.VBVopt(:,:,:,:,8:14) = dataTrim_HPPwrIn.VBVopt;
dataTrim.VAFNopt(:,:,:,:,1:7) = dataTrim_HPPwrEx.VAFNopt;
dataTrim.VAFNopt(:,:,:,:,8:14) = dataTrim_HPPwrIn.VAFNopt;
dataTrim.Err(:,:,:,:,1:7) = dataTrim_HPPwrEx.Err;
dataTrim.Err(:,:,:,:,8:14) = dataTrim_HPPwrIn.Err;
dataTrim.Success(:,:,:,:,1:7) = dataTrim_HPPwrEx.Success;
dataTrim.Success(:,:,:,:,8:14) = dataTrim_HPPwrIn.Success;

% Simulation Starting Point ----------------------------------------------%

Alt = MWS.In.Alt(1);
MN = MWS.In.MN(1);
PExAC = MWS.In.PExAC(1);
PLA = MWS.In.PLA(1);
N1cManEn = MWS.In.N1cManEn;
N1cMan = MWS.In.N1cMan(1);
WfManEn = MWS.In.WfManEn;
WfMan = MWS.In.WfMan(1);
VBVManEn = MWS.In.VBVManEn;
VBVMan = MWS.In.VBVMan(1);
VAFNManEn = MWS.In.VAFNManEn;
VAFNMan = MWS.In.VAFNMan(1);
% NOTE: The initialization script will not us the manual input power
% commands to determine ICs. If you intend to modify and use the manual
% inputs for the spool and EM powers, it is recommended to start from known
% nominal power conditions as determined through simulation of the model
% without manual power inputs. The manual inputs may be changed in the
% manual input profile following the initial data point. Below is a list of
% relevant variables.
% PwrInLPNomManEn = MWS.In.PwrInLPNomManEn;
% PwrInLPNomMan = MWS.In.PwrInLPNomMan(1);
% PwrInLPOffNomManEn = MWS.In.PwrInLPOffNomManEn;
% PwrInLPOffNomMan = MWS.In.PwrInLPOffNomMan(1);
% PwrInHPNomManEn = MWS.In.PwrInHPNomManEn;
% PwrInHPNomMan = MWS.In.PwrInHPNomMan(1);
% PwrInHPOffNomManEn = MWS.In.PwrInHPOffNomManEn;
% PwrInHPOffNomMan = MWS.In.PwrInHPOffNomMan(1);
% PwrInLPEMNomManEn = MWS.In.PwrInLPEMNomManEn;
% PwrInLPEMNomMan = MWS.In.PwrInLPEMNomMan(1);
% PwrInLPEMOffNomManEn = MWS.In.PwrInLPEMOffNomManEn;
% PwrInLPEMOffNomMan = MWS.In.PwrInLPEMOffNomMan(1);
% PwrInHPEMNomManEn = MWS.In.PwrInHPEMNomManEn;
% PwrInHPEMNomMan = MWS.In.PwrInHPEMNomMan(1);
% PwrInHPEMOffNomManEn = MWS.In.PwrInHPEMOffNomManEn;
% PwrInHPEMOffNomMan = MWS.In.PwrInHPEMOffNomMan(1);
% PwrInSEMNomManEn = MWS.In.PwrInSEMNomManEn;
% PwrInSEMNomMan = MWS.In.PwrInSEMNomMan(1);
% PwrInSEMOffNomManEn = MWS.In.PwrInSEMOffNomManEn;
% PwrInSEMOffNomMan = MWS.In.PwrInSEMOffNomMan(1);
% PwrInREMNomManEn = MWS.In.PwrInREMNomManEn;
% PwrInREMNomMan = MWS.In.PwrInREMNomMan(1);
% PwrInREMOffNomManEn = MWS.In.PwrInREMOffNomManEn;
% PwrInREMOffNomMan = MWS.In.PwrInREMOffNomMan(1);
% PwrInCEMNomManEn = MWS.In.PwrInCEMNomManEn;
% PwrInCEMNomMan = MWS.In.PwrInCEMNomMan(1);
% PwrInCEMOffNomManEn = MWS.In.PwrInCEMOffNomManEn;
% PwrInCEMOffNomMan = MWS.In.PwrInCEMOffNomMan(1);
% PwrInPEMNomManEn = MWS.In.PwrInPEMNomManEn;
% PwrInPEMNomMan = MWS.In.PwrInPEMNomMan(1);
% PwrInPEMOffNomManEn = MWS.In.PwrInPEMOffNomManEn;
% PwrInPEMOffNomMan = MWS.In.PwrInPEMOffNomMan(1);

% NOTE: for the standard/regular engine and boost mode
% (MWS.In.Options.HybridConfig = 1 & 2) the model is initialized the same.
% For boost mode, the boost feature is initialized as disengaged. Charging
% and EPT is also initialized as disengaged.

% Determine PwrInLP, PwrInHP, and PL
if MWS.In.Options.HybridConfig == 1 || MWS.In.Options.HybridConfig == 2 % standard or boost
    PwrInLP = 0;
    PwrInHP = -PExAC;
    if WfManEn == 1
        WfVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Wf.Wf_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
        PL = interp1(WfVec,MWS.Cntrl.SPSched.PL_vec,WfMan);
    else
        if N1cManEn == 1
            N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
            PL = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cMan);
        else
            FnMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMin.FnMin_array,Alt,MN,PwrInLP,PwrInHP);
            FnMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMax.FnMax_array,Alt,MN,PwrInLP,PwrInHP);
            FnTarg = interp1(MWS.Cntrl.SPSched.PLA_vec,[FnMin FnMax],PLA);
            FnVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Fn.Fn_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
            PL = interp1(FnVec,MWS.Cntrl.SPSched.PL_vec,FnTarg,'linear');
        end
    end
else % power extraction
    % bisection root solver (find PL that matches Fn/Wf/N1c target & satisfies
    % N1cN relation)
    Tol = 0.001;
    iterMax = 20;
    iter = 0;
    % guess A
    N1cN_a = 0;
    Pwr_a = interp3(MWS.Cntrl.Hyb.PEx.PExSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PExSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PExSched.MN_vec,MWS.Cntrl.Hyb.PEx.PExSched.Pwr_array,Alt,N1cN_a,MN);
    PwrSplitHP_a = interp3(MWS.Cntrl.Hyb.PEx.PwrSplitSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.MN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.PwrFracHP_array,Alt,N1cN_a,MN);
    PwrInLP_a = -Pwr_a*(1-PwrSplitHP_a);
    PwrInHP_a = -Pwr_a*PwrSplitHP_a - PExAC;
    if WfManEn == 1
        WfVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Wf.Wf_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
        PL_X_a = interp1(WfVec,MWS.Cntrl.SPSched.PL_vec,WfMan);
    else
        if N1cManEn == 1
            N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
            PL_X_a = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cMan);
        else
            FnMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMin.FnMin_array,Alt,MN,PwrInLP_a,PwrInHP_a);
            FnMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMax.FnMax_array,Alt,MN,PwrInLP_a,PwrInHP_a);
            FnVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Fn.Fn_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_a,PwrInHP_a);
            FnTarg = interp1(MWS.Cntrl.SPSched.PLA_vec,[FnMin FnMax],PLA);
            PL_X_a = interp1(FnVec,MWS.Cntrl.SPSched.PL_vec,FnTarg);
        end
    end
    N1cMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMin.N1cMin_array,Alt,MN,PwrInLP_a,PwrInHP_a);
    N1cMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMax.N1cMax_array,Alt,MN,PwrInLP_a,PwrInHP_a);
    N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_a,PwrInHP_a);
    N1cTarg = N1cN_a*(N1cMax-N1cMin) + N1cMin;
    PL_N1c_a = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cTarg);
    FunA = PL_N1c_a - PL_X_a;
    % guess B
    N1cN_b = 1;
    Pwr_b = interp3(MWS.Cntrl.Hyb.PEx.PExSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PExSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PExSched.MN_vec,MWS.Cntrl.Hyb.PEx.PExSched.Pwr_array,Alt,N1cN_b,MN);
    PwrSplitHP_b = interp3(MWS.Cntrl.Hyb.PEx.PwrSplitSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.MN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.PwrFracHP_array,Alt,N1cN_b,MN);
    PwrInLP_b = -Pwr_b*(1-PwrSplitHP_b);
    PwrInHP_b = -Pwr_b*PwrSplitHP_b - PExAC;
    if WfManEn == 1
        WfVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Wf.Wf_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
        PL_X_b = interp1(WfVec,MWS.Cntrl.SPSched.PL_vec,WfMan);
    else
        if N1cManEn == 1
            N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
            PL_X_b = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cMan);
        else
            FnMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMin.FnMin_array,Alt,MN,PwrInLP_b,PwrInHP_b);
            FnMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMax.FnMax_array,Alt,MN,PwrInLP_b,PwrInHP_b);
            FnVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Fn.Fn_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_b,PwrInHP_b);
            FnTarg = interp1(MWS.Cntrl.SPSched.PLA_vec,[FnMin FnMax],PLA);
            PL_X_b = interp1(FnVec,MWS.Cntrl.SPSched.PL_vec,FnTarg);
        end
    end
    N1cMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMin.N1cMin_array,Alt,MN,PwrInLP_b,PwrInHP_b);
    N1cMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMax.N1cMax_array,Alt,MN,PwrInLP_b,PwrInHP_b);
    N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_b,PwrInHP_b);
    N1cTarg = N1cN_b*(N1cMax-N1cMin) + N1cMin;
    PL_N1c_b = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cTarg);
    FunB = PL_N1c_b - PL_X_b;
    if abs(FunA) < 0.01
        PL_N1c_g = PL_N1c_a;
        PL_X_g = PL_X_a;
        PwrInLP_g = PwrInLP_a;
        PwrInHP_g = PwrInHP_a;
    elseif abs(FunB) < 0.01
        PL_N1c_g = PL_N1c_b;
        PL_X_g = PL_X_b;
        PwrInLP_g = PwrInLP_b;
        PwrInHP_g = PwrInHP_b;
    else
        while (N1cN_b-N1cN_a)/2 > Tol
            % New Guess
            N1cN_g = (N1cN_a+N1cN_b)/2;
            Pwr_g = interp3(MWS.Cntrl.Hyb.PEx.PExSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PExSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PExSched.MN_vec,MWS.Cntrl.Hyb.PEx.PExSched.Pwr_array,Alt,N1cN_g,MN);
            PwrSplitHP_g = interp3(MWS.Cntrl.Hyb.PEx.PwrSplitSched.Alt_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.NcFanN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.MN_vec,MWS.Cntrl.Hyb.PEx.PwrSplitSched.PwrFracHP_array,Alt,N1cN_g,MN);
            PwrInLP_g = -Pwr_g*(1-PwrSplitHP_g);
            PwrInHP_g = -Pwr_g*PwrSplitHP_g - PExAC;
            if WfManEn == 1
                WfVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Wf.Wf_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
                PL_X_g = interp1(WfVec,MWS.Cntrl.SPSched.PL_vec,WfMan);
            else
                if N1cManEn == 1
                    N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP,PwrInHP);
                    PL_X_g = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cMan);
                else
                    FnMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMin.FnMin_array,Alt,MN,PwrInLP_g,PwrInHP_g);
                    FnMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.FnMax.FnMax_array,Alt,MN,PwrInLP_g,PwrInHP_g);
                    FnVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.Fn.Fn_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_g,PwrInHP_g);
                    FnTarg = interp1(MWS.Cntrl.SPSched.PLA_vec,[FnMin FnMax],PLA);
                    PL_X_g = interp1(FnVec,MWS.Cntrl.SPSched.PL_vec,FnTarg);
                end
            end
            N1cMin = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMin.N1cMin_array,Alt,MN,PwrInLP_g,PwrInHP_g);
            N1cMax = interpn(MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.Sched.N1cMax.N1cMax_array,Alt,MN,PwrInLP_g,PwrInHP_g);
            N1cVec = interpn(MWS.Cntrl.SPSched.PL_vec,MWS.Cntrl.SPSched.Alt_vec,MWS.Cntrl.SPSched.MN_vec,MWS.Cntrl.SPSched.PwrInLP_vec,MWS.Cntrl.SPSched.PwrInHP_vec,MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array,MWS.Cntrl.SPSched.PL_vec,Alt,MN,PwrInLP_g,PwrInHP_g);
            N1cTarg = N1cN_g*(N1cMax-N1cMin) + N1cMin;
            PL_N1c_g = interp1(N1cVec,MWS.Cntrl.SPSched.PL_vec,N1cTarg);
            FunG = PL_N1c_g - PL_X_g;
            if FunA*FunG < 0
                N1cN_b = N1cN_g;
            elseif FunB*FunG < 0
                N1cN_a = N1cN_g;
            elseif FunG == 0
                break
            end
            iter = iter + 1;
            if iter > iterMax
                disp('Warning: Reached max iterations while trying to initialize the power level in setup_initialize.m')
                break
            end
        end
    end
    PwrInLP = PwrInLP_g;
    PwrInHP = PwrInHP_g;
    PL = (PL_N1c_g+PL_X_g)/2;
end

% Initial conditions -----------------------------------------------------%

% Engine Solver Independents
if StartPt == 0 % start at full power sea level static, nominal power (350hp from HP, 0hp from LP)

    % Solver Independents
    W = 1829.8;
    BPR = 26.45;
    FAN_RLine = 1.7494;
    LPC_RLine = 1.9585;
    HPC_RLine = 2.0321;
    HPT_PR = 4.1463;
    LPT_PR = 7.7327;
    N2 = 6210;
    N3 = 21408.6;
    Wf = 1.5379;
    VBV = 0;
    VAFN = 6105.5;
    PwrInLP = 0;
    PwrInHP = -350;

else

    % Solver Independents
    W = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(1,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    BPR = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(5,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    FAN_RLine = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(4,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    LPC_RLine = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(6,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    HPC_RLine = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(3,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    HPT_PR = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(2,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    LPT_PR = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,permute(dataTrim.ICs(7,:,:,:,:,:),[2 3 4 5 6 1]),PL,Alt,MN,PwrInLP,PwrInHP);
    N2 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.N2,PL,Alt,MN,PwrInLP,PwrInHP);
    N3 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.N3,PL,Alt,MN,PwrInLP,PwrInHP);
    Wf = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.Wf,PL,Alt,MN,PwrInLP,PwrInHP);
    if VBVManEn == 1
        VBV = VBVMan;
    else
        VBV = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.VBV,PL,Alt,MN,PwrInLP,PwrInHP);
    end
    if VAFNManEn == 1
        VAFN = VAFNMan;
    else
        VAFN = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.VAFN,PL,Alt,MN,PwrInLP,PwrInHP);
    end
    % PwrInLP determined a priori
    % PwrInHP determined a priori
    
    % Sensors
    MWS.Init.IC.Pa = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.P2,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.P2 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.P2,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.P25 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.P25,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.Ps3 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.Ps3,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.P5 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.P5,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.T2 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.T2,PL,Alt,MN,PwrInLP,PwrInHP);
    %MWS.Init.IC.T25 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.T25,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.T3 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.T3,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.T4 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.T4,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.T45 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.T45,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.N1 = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.N1,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.N2 = N2;
    MWS.Init.IC.N3 = N3;
    MWS.Init.IC.NemL = MWS.Init.IC.N2*MWS.Shaft.DEM.LPSGB.GR;
    MWS.Init.IC.NemH = MWS.Init.IC.N3*MWS.Shaft.DEM.HPSGB.GR;
    rS = MWS.Shaft.PGB.Sun.r;
    rR = MWS.Shaft.PGB.Ring.r;
    rP = (rR-rS)/2;
    if MWS.In.Options.PGBConfig == 1 % HP-Sun, LP-Ring
        MWS.Init.IC.NemS = N3*MWS.Shaft.PGB.Sun.GR_int;
        MWS.Init.IC.NemR = N2*MWS.Shaft.PGB.Ring.GR_int;
        MWS.Init.IC.NemC = (MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb*rS + MWS.Init.IC.NemR*MWS.Shaft.PGB.Ring.GR_gb*rR)/(rS+rR)/MWS.Shaft.PGB.Carrier.GR_gb;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb - MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb)*(rS/rP)/MWS.Shaft.PGB.Planet.GR_gb;
    elseif MWS.In.Options.PGBConfig == 2 % HP-Sun, LP-Carrier
        MWS.Init.IC.NemS = N3*MWS.Shaft.PGB.Sun.GR_int;
        MWS.Init.IC.NemC = N2*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb - MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb)*(rS/rP)/MWS.Shaft.PGB.Planet.GR_gb;
        MWS.Init.IC.NemR = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb*rR + MWS.Init.IC.NemP*MWS.Shaft.PGB.Planet.GR_gb*rP)/rR/MWS.Shaft.PGB.Ring.GR_gb;
    elseif MWS.In.Options.PGBConfig == 3 % HP-Ring, LP-Sun
        MWS.Init.IC.NemS = N2*MWS.Shaft.PGB.Sun.GR_int;
        MWS.Init.IC.NemR = N3*MWS.Shaft.PGB.Ring.GR_int;
        MWS.Init.IC.NemC = (MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb*rS + MWS.Init.IC.NemR*MWS.Shaft.PGB.Ring.GR_gb*rR)/(rS+rR)/MWS.Shaft.PGB.Carrier.GR_gb;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb - MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb)*(rS/rP)/MWS.Shaft.PGB.Planet.GR_gb;
    elseif MWS.In.Options.PGBConfig == 4 % HP-Ring, LP-Carrier
        MWS.Init.IC.NemR = N3*MWS.Shaft.PGB.Ring.GR_int;
        MWS.Init.IC.NemC = N2*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemR*MWS.Shaft.PGB.Ring.GR_gb - MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb)*(rR/rP)/MWS.Shaft.PGB.Planet.GR_gb;
        MWS.Init.IC.NemS = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb*rS - MWS.Init.IC.NemP*MWS.Shaft.PGB.Planet.GR_gb*rP)/rS/MWS.Shaft.PGB.Sun.GR_gb;
    elseif MWS.In.Options.PGBConfig == 5 % HP-Carrier, LP-Sun
        MWS.Init.IC.NemS = N2*MWS.Shaft.PGB.Sun.GR_int;
        MWS.Init.IC.NemC = N3*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb - MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb)*(rS/rP)/MWS.Shaft.PGB.Planet.GR_gb;
        MWS.Init.IC.NemR = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb*rR + MWS.Init.IC.NemP*MWS.Shaft.PGB.Planet.GR_gb*rP)/rR/MWS.Shaft.PGB.Ring.GR_gb;
    else % HP-Carrier, LP-Ring
        MWS.Init.IC.NemR = N2*MWS.Shaft.PGB.Ring.GR_int;
        MWS.Init.IC.NemC = N3*MWS.Shaft.PGB.Carrier.GR_int;
        MWS.Init.IC.NemP = (MWS.Init.IC.NemR*MWS.Shaft.PGB.Ring.GR_gb - MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb)*(rR/rP)/MWS.Shaft.PGB.Planet.GR_gb;
        MWS.Init.IC.NemS = (MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb*rS - MWS.Init.IC.NemP*MWS.Shaft.PGB.Planet.GR_gb*rP)/rS/MWS.Shaft.PGB.Sun.GR_gb;
    end
    MWS.Init.IC.SOC = 85;

    % Controller
    % NOTE: Planetary gearbox power initialization assumes the gearbox
    %   design favors the LP (adding power to the coupling component
    %   transfers power from the HP to the LP)
    MWS.Init.IC.N1c = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.N1c,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.PwrEML = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.PwrInLP,PL,Alt,MN,PwrInLP,PwrInHP);
    MWS.Init.IC.PwrEMH = interpn(dataTrim.PL_vec,dataTrim.Alt_vec,dataTrim.MN_vec,dataTrim.PwrInLP_vec,dataTrim.PwrInHP_vec,dataTrim.PwrInHP,PL,Alt,MN,PwrInLP,PwrInHP);
    if MWS.In.Options.HybridConfig == 1 % standard
        if MWS.In.Options.PGBConfig == 1 || MWS.In.Options.PGBConfig == 2 %Sun on HP
            MWS.Init.IC.PwrEMS = PwrInHP;
            MWS.Init.IC.PwrEMR = 0;
            MWS.Init.IC.PwrEMC = 0;
            MWS.Init.IC.PwrEMP = 0;
        elseif MWS.In.Options.PGBConfig == 3 || MWS.In.Options.PGBConfig == 4 %Ring on HP
            MWS.Init.IC.PwrEMS = 0;
            MWS.Init.IC.PwrEMR = PwrInHP;
            MWS.Init.IC.PwrEMC = 0;
            MWS.Init.IC.PwrEMP = 0;
        else % Carrier on HP
            MWS.Init.IC.PwrEMS = 0;
            MWS.Init.IC.PwrEMR = 0;
            MWS.Init.IC.PwrEMC = PwrInHP;
            MWS.Init.IC.PwrEMP = 0;
        end
    else % boost or PEx
        NS = MWS.Init.IC.NemS*MWS.Shaft.PGB.Sun.GR_gb;
        NR = MWS.Init.IC.NemR*MWS.Shaft.PGB.Ring.GR_gb;
        NC = MWS.Init.IC.NemC*MWS.Shaft.PGB.Carrier.GR_gb;
        if MWS.In.Options.PGBConfig == 1 %HP-Sun, LP-Ring
            PwrFactorL = (NC/NR)/MWS.Shaft.PGB.TrqCoeff.CTrqRC;
            PwrFactorH = (NC/NS)/MWS.Shaft.PGB.TrqCoeff.CTrqSC;
            MWS.Init.IC.PwrEMC = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMR = sign(PwrInLP-MWS.Init.IC.PwrEMC/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMC/PwrFactorL, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMS = sign(PwrInHP-MWS.Init.IC.PwrEMC/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMC/PwrFactorH, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        elseif MWS.In.Options.PGBConfig == 2 %HP-Sun, LP-Carrier
            PwrFactorL = (NR/NC)/MWS.Shaft.PGB.TrqCoeff.CTrqCR;
            PwrFactorH = (NR/NS)/MWS.Shaft.PGB.TrqCoeff.CTrqSR;
            MWS.Init.IC.PwrEMR = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMC = sign(PwrInLP-MWS.Init.IC.PwrEMR/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMR/PwrFactorL, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMS = sign(PwrInHP-MWS.Init.IC.PwrEMR/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMR/PwrFactorH, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        elseif MWS.In.Options.PGBConfig == 3 %HP-Ring, LP-Sun
            PwrFactorL = (NC/NS)/MWS.Shaft.PGB.TrqCoeff.CTrqSC;
            PwrFactorH = (NC/NR)/MWS.Shaft.PGB.TrqCoeff.CTrqRC;
            MWS.Init.IC.PwrEMC = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMS = sign(PwrInLP-MWS.Init.IC.PwrEMC/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMC/PwrFactorL, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMR = sign(PwrInHP-MWS.Init.IC.PwrEMC/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMC/PwrFactorH, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        elseif MWS.In.Options.PGBConfig == 4 %HP-Ring, LP-Carrier
            PwrFactorL = (NS/NC)/MWS.Shaft.PGB.TrqCoeff.CTrqCS;
            PwrFactorH = (NS/NR)/MWS.Shaft.PGB.TrqCoeff.CTrqRS;
            MWS.Init.IC.PwrEMS = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMC = sign(PwrInLP-MWS.Init.IC.PwrEMS/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMS/PwrFactorL, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMR = sign(PwrInHP-MWS.Init.IC.PwrEMS/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMS/PwrFactorH, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        elseif MWS.In.Options.PGBConfig == 5 %HP-Carrier, LP-Sun
            PwrFactorL = (NR/NS)/MWS.Shaft.PGB.TrqCoeff.CTrqSR;
            PwrFactorH = (NR/NC)/MWS.Shaft.PGB.TrqCoeff.CTrqCR;
            MWS.Init.IC.PwrEMR = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMS = sign(PwrInLP-MWS.Init.IC.PwrEMR/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMR/PwrFactorL, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMC = sign(PwrInHP-MWS.Init.IC.PwrEMR/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMR/PwrFactorH, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        else %HP-Carrier, LP-Ring
            PwrFactorL = (NS/NR)/MWS.Shaft.PGB.TrqCoeff.CTrqRS;
            PwrFactorH = (NS/NC)/MWS.Shaft.PGB.TrqCoeff.CTrqCS;
            MWS.Init.IC.PwrEMS = sign(PwrInLP*PwrFactorL)*min(abs([PwrInLP*PwrFactorL, MWS.Cntrl.EMS.PwrMax_Base, MWS.Cntrl.EMS.TrqMax_Base*MWS.Init.IC.NemS/5252.113]));
            MWS.Init.IC.PwrEMR = sign(PwrInLP-MWS.Init.IC.PwrEMS/PwrFactorL)*min(abs([PwrInLP-MWS.Init.IC.PwrEMS/PwrFactorL, MWS.Cntrl.EMR.PwrMax_Base, MWS.Cntrl.EMR.TrqMax_Base*MWS.Init.IC.NemR/5252.113]));
            MWS.Init.IC.PwrEMC = sign(PwrInHP-MWS.Init.IC.PwrEMS/PwrFactorH)*min(abs([PwrInHP-MWS.Init.IC.PwrEMS/PwrFactorH, MWS.Cntrl.EMC.PwrMax_Base, MWS.Cntrl.EMC.TrqMax_Base*MWS.Init.IC.NemC/5252.113]));
            MWS.Init.IC.PwrEMP = 0;
        end
    end

    % Actuators
    MWS.Init.IC.Wf = Wf;
    MWS.Init.IC.VBV = VBV;
    MWS.Init.IC.VAFN = VAFN;
    MWS.Init.IC.TrqEML = MWS.Init.IC.PwrEML*5252.113./MWS.Init.IC.NemL;
    MWS.Init.IC.TrqEMH = MWS.Init.IC.PwrEMH*5252.113./MWS.Init.IC.NemH;
    MWS.Init.IC.TrqEMS = MWS.Init.IC.PwrEMS*5252.113./MWS.Init.IC.NemS;
    MWS.Init.IC.TrqEMR = MWS.Init.IC.PwrEMR*5252.113./MWS.Init.IC.NemR;
    MWS.Init.IC.TrqEMC = MWS.Init.IC.PwrEMC*5252.113./MWS.Init.IC.NemC;
    MWS.Init.IC.TrqEMP = MWS.Init.IC.PwrEMP*5252.113./MWS.Init.IC.NemP;
    
end

% Dynamic Solver ---------------------------------------------------------%

%   ICs are: [Inlet Flow, HPT PR, HPC RLine, Fan RLine, Bypass Ratio, 
%       LPC RLine, LPT PR]
MWS.Init.Solver.Dyn.IC = [W HPT_PR HPC_RLine FAN_RLine BPR LPC_RLine LPT_PR];
% Jacobian perturbation size
MWS.Init.Solver.Dyn.JPer = [0.001*ones(length(MWS.Init.Solver.Dyn.IC),1) -0.001*ones(length(MWS.Init.Solver.Dyn.IC),1)]';
% Maximum solver iterations
MWS.Init.Solver.Dyn.Max_Iter = numel(MWS.Init.Solver.Dyn.JPer) + 50;
% Step-size limiter
MWS.Init.Solver.Dyn.dX = 1; %1
% Solver attempts before Jacobian re-calculation
MWS.Init.Solver.Dyn.NRA = 25; %25
% Iteration condition limits
MWS.Init.Solver.Dyn.Lim = 1e-4; %0.00001; %5e-5, 1e-5

% Auto Simulation Halt Criteria
MWS.Init.Max_IterDyn = MWS.Init.Solver.Dyn.Max_Iter;
MWS.Init.DynRunNonConv = round(0.05*MWS.In.tend/MWS.In.Ts);

% Steady-State Solver ----------------------------------------------------%

%   ICs are: [Inlet Flow, HPT PR, HPC RLine, Fan RLine, Bypass Ratio, 
%       LPC RLine, LPT PR]
MWS.Init.Solver.SS.IC = [W HPT_PR HPC_RLine FAN_RLine BPR LPC_RLine LPT_PR N2 N3 Wf VAFN VBV+1 PwrInLP+5000 PwrInHP+3000];
% Jacobian perturbation size
MWS.Init.Solver.SS.JPer = [0.001*ones(length(MWS.Init.Solver.SS.IC),1) -0.001*ones(length(MWS.Init.Solver.SS.IC),1)]';
% Maximum solver iterations
MWS.Init.Solver.SS.Max_Iter = length(MWS.Init.Solver.SS.IC)*50;
% Step-size limiter
MWS.Init.Solver.SS.dX = 1; %1
% Solver attempts before Jacobian re-calculation
MWS.Init.Solver.SS.NRA = 50; %25
% Iteration condition limits
MWS.Init.Solver.SS.Lim = 1e-5; %1e-5

% Solver Option (1 - Nc1 target, 2 - T4 target, 3 - Fn target, 4-end - limiters in order below) 
MWS.Init.Solver.Targets.Opt = SSsolverSP;
%   Note: Nclps is set by Input NcfanMan or the set-point controller
MWS.Init.Solver.Targets.T4 = 3169.1; %degR
MWS.Init.Solver.Targets.Fn = 31754; %lbf
MWS.Init.Solver.Targets.N1cMap = 1.0;
% Primary Limits
MWS.Init.Solver.Limits.T3_Max = 1651.3; %degR, 3% above T3 at SLS max pwr
MWS.Init.Solver.Limits.T4_Max = 3169.1; %degR, max at SLS
MWS.Init.Solver.Limits.Ps3_Max = 581.22; %psi, 5% above Ps3 at SLS max pwr
MWS.Init.Solver.Limits.N1_Max = 6831/MWS.GearBox.GearRatio; %rpm, 10% above N1 at SLS max pwr, want to leave room for boost
MWS.Init.Solver.Limits.N3_Max = 23549; %rpm, 10% above N3 at SLS max pwr, want to leave room for boost
MWS.Init.Solver.Limits.FAR_Min = 0.0; %unitless, set to zero to eliminate use
MWS.Init.Solver.Limits.FanSM_Min = 1; %pct.
MWS.Init.Solver.Limits.LPCSM_Min = 11; %pct.
MWS.Init.Solver.Limits.HPCSM_Min = 17; %pct.
MWS.Init.Solver.Limits.FanNcMap_Min = 0.35; %rpm
MWS.Init.Solver.Limits.FanNcMap_Max = 1.1; %rpm
MWS.Init.Solver.Limits.FanRL_Min = 1.0; %unitless
MWS.Init.Solver.Limits.FanRL_Max = 3.0; %unitless
MWS.Init.Solver.Limits.LPCNcMap_Min = 0.35; %rpm
MWS.Init.Solver.Limits.LPCNcMap_Max = 1.25; %rpm
MWS.Init.Solver.Limits.LPCRL_Min = 1.2; %unitless
MWS.Init.Solver.Limits.LPCRL_Max = 2.6; %unitless
MWS.Init.Solver.Limits.HPCNcMap_Min = 0.5; %rpm
MWS.Init.Solver.Limits.HPCNcMap_Max = 1.05; %rpm
MWS.Init.Solver.Limits.HPCRL_Min = 1.2; %unitless
MWS.Init.Solver.Limits.HPCRL_Max = 2.8; %unitless
MWS.Init.Solver.Limits.HPTNcMap_Min = 65; %rpm
MWS.Init.Solver.Limits.HPTNcMap_Max = 126; %rpm
MWS.Init.Solver.Limits.HPTPRMap_Min = 3; %unitless
MWS.Init.Solver.Limits.HPTPRMap_Max = 8; %unitless
MWS.Init.Solver.Limits.LPTNcMap_Min = 20; %rpm
MWS.Init.Solver.Limits.LPTNcMap_Max = 120; %rpm
MWS.Init.Solver.Limits.LPTPRMap_Min = 1.25; %unitless
MWS.Init.Solver.Limits.LPTPRMap_Max = 8; %unitless
% Actuator Limits
MWS.Init.Solver.Limits.VBV_Min = 0; %unitless
MWS.Init.Solver.Limits.VBV_Max = 1; %unitless
MWS.Init.Solver.Limits.VAFN_Min = 4000; %sqin
MWS.Init.Solver.Limits.VAFN_Max = 8500; %sqin

% VBV dependent
MWS.Init.Solver.SS.VBVOpt = 2; % 2-drive to zero, 1-drive LPCSM to limit, 3-schedule (after design)
MWS.Init.Solver.SS.VBVOpt_LPCSMtarget = 11.1;

% VAFN dependent
MWS.Init.Solver.SS.VAFNOpt = 1; % 1-drive to Fan RL target, 3-schedule (after design)
MWS.Init.Solver.SS.VAFNOpt_NcVec = [0.5  0.6  0.7  0.8  0.9  0.95 1.0 1.05 1.1];
MWS.Init.Solver.SS.VAFNOpt_RLVec = [1.75 1.75 1.75 1.75 1.75 1.90 2.0 2.0  2.0];