function MWS = setup_Controller(MWS)
% setup variables for controller

% Load Data --------------------------------------------------------------%

% Steady-State Data
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

% Power Extractio Schedule
load([cd,'\Data\data_Cntrl_PExSch.mat']); %loads dataPEx

% Control Gains
Nom = load([cd,'\Data\data_Cntrl_WfNom_GainsOnly.mat']); %creates Nom.Cntrl
WfLimMax = load([cd,'\Data\data_Cntrl_WfLimMax_GainsOnly.mat']); %creates WfLimMax.Cntrl
WfLimMin = load([cd,'\Data\data_Cntrl_WfLimMin_GainsOnly_Simp.mat']); %creates WfLimMin.Cntrl

% Accel/Decel Schedules
RUSch_STD_a_EPT = load([cd,'\Data\data_Cntrl_RUsched_STD_accel_EPT.mat']); %standard engine accel w/ EPT
RUSch_STD_a_noEPT = load([cd,'\Data\data_Cntrl_RUsched_STD_accel_noEPT.mat']); %standard engine accel w/ EPT
RUSch_STD_d_EPT = load([cd,'\Data\data_Cntrl_RUsched_STD_decel_EPT.mat']); %standard engine decel w/ EPT
RUSch_STD_d_noEPT = load([cd,'\Data\data_Cntrl_RUsched_STD_decel_noEPT.mat']); %standard engine decel w/ EPT
RUSch_Boost_a_EPT = load([cd,'\Data\data_Cntrl_RUsched_Boost_accel_EPT.mat']); %standard engine accel w/ EPT
RUSch_Boost_a_noEPT = load([cd,'\Data\data_Cntrl_RUsched_Boost_accel_noEPT.mat']); %standard engine accel w/ EPT
RUSch_Boost_d_EPT = load([cd,'\Data\data_Cntrl_RUsched_Boost_decel_EPT.mat']); %standard engine decel w/ EPT
RUSch_Boost_d_noEPT = load([cd,'\Data\data_Cntrl_RUsched_Boost_decel_noEPT.mat']); %standard engine decel w/ EPT
RUSch_PEx_a_EPT = load([cd,'\Data\data_Cntrl_RUsched_PEx_accel_EPT.mat']); %standard engine accel w/ EPT
RUSch_PEx_a_noEPT = load([cd,'\Data\data_Cntrl_RUsched_PEx_accel_noEPT.mat']); %standard engine accel w/ EPT
RUSch_PEx_d_EPT = load([cd,'\Data\data_Cntrl_RUsched_PEx_decel_EPT.mat']); %standard engine decel w/ EPT
RUSch_PEx_d_noEPT = load([cd,'\Data\data_Cntrl_RUsched_PEx_decel_noEPT.mat']); %standard engine decel w/ EPT

% Direct Look-up Schedule Parameters -------------------------------------%

MWS.Cntrl.SPSched.Alt_vec = dataTrim.Alt_vec;
MWS.Cntrl.SPSched.MN_vec = dataTrim.MN_vec;
MWS.Cntrl.SPSched.PwrInLP_vec = dataTrim.PwrInLP_vec;
MWS.Cntrl.SPSched.PwrInHP_vec = dataTrim.PwrInHP_vec;
MWS.Cntrl.SPSched.PL_vec = dataTrim.PL_vec;
MWS.Cntrl.SPSched.PLA_vec = [40 80];

% Scheduling Look-ups Arrays ---------------------------------------------%

% Full Sets
% -- Ps3 = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.Ps3.Ps3_array = dataTrim.Ps3;
% -- N2 = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.N2.N2_array = dataTrim.N2;
% -- N3 = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.N3.N3_array = dataTrim.N3;
% -- Fn = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.Fn.Fn_array = dataTrim.Fn;
% -- Wf = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.Wf.Wf_array = dataTrim.Wf;

% Max and Min
% -- Ps3 = f(Alt,MN)
MWS.Cntrl.Sched.Ps3Min.Ps3Min_array = zeros(length(dataTrim.Alt_vec),length(dataTrim.MN_vec));
for i = 1:length(dataTrim.Alt_vec)
    for j = 1:length(dataTrim.MN_vec)
        MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j) = interp2(dataTrim.PwrInHP_vec,dataTrim.PwrInLP_vec,permute(dataTrim.Ps3(1,i,j,:,:),[4 5 1 2 3]),-175+250,-175-250); %minimum based on min power with PEx and EPT, resulting in highest Ps3min (compared to standard and boost)
    end
end
% -- N1c = f(Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.N1cMax.N1cMax_array = permute(dataTrim.N1c(end,:,:,:,:),[2 3 4 5 1]);
MWS.Cntrl.Sched.N1cMin.N1cMin_array = zeros(length(dataTrim.Alt_vec),length(dataTrim.MN_vec),length(dataTrim.PwrInLP_vec),length(dataTrim.PwrInHP_vec));
for i = 1:length(dataTrim.Alt_vec)
    for j = 1:length(dataTrim.MN_vec)
        for k = 1:length(dataTrim.PwrInLP_vec)
            for l = 1:length(dataTrim.PwrInHP_vec)
                Ps3vec = dataTrim.Ps3(:,i,j,k,l);
                N1cvec = dataTrim.N1c(:,i,j,k,l);
                if MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j) >= min(Ps3vec)
                    MWS.Cntrl.Sched.N1cMin.N1cMin_array(i,j,k,l) = interp1(Ps3vec,N1cvec,MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j));
                else
                    MWS.Cntrl.Sched.N1cMin.N1cMin_array(i,j,k,l) = dataTrim.N1c(1,i,j,k,l);
                end
            end
        end
    end
end
% -- Fn = f(Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.FnMax.FnMax_array = permute(dataTrim.Fn(end,:,:,:,:),[2 3 4 5 1]);
MWS.Cntrl.Sched.FnMin.FnMin_array = zeros(length(dataTrim.Alt_vec),length(dataTrim.MN_vec),length(dataTrim.PwrInLP_vec),length(dataTrim.PwrInHP_vec));
for i = 1:length(dataTrim.Alt_vec)
    for j = 1:length(dataTrim.MN_vec)
        for k = 1:length(dataTrim.PwrInLP_vec)
            for l = 1:length(dataTrim.PwrInHP_vec)
                Ps3vec = dataTrim.Ps3(:,i,j,k,l);
                Fnvec = dataTrim.Fn(:,i,j,k,l);
                if MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j) >= min(Ps3vec)
                    MWS.Cntrl.Sched.FnMin.FnMin_array(i,j,k,l) = interp1(Ps3vec,Fnvec,MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j));
                else
                    MWS.Cntrl.Sched.FnMin.FnMin_array(i,j,k,l) = dataTrim.Fn(1,i,j,k,l);
                end
            end
        end
    end
end
% -- Wf = f(Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.Sched.WfMax.WfMax_array = permute(dataTrim.Wf(end,:,:,:,:),[2 3 4 5 1]);
MWS.Cntrl.Sched.WfMin.WfMin_array = zeros(length(dataTrim.Alt_vec),length(dataTrim.MN_vec),length(dataTrim.PwrInLP_vec),length(dataTrim.PwrInHP_vec));
for i = 1:length(dataTrim.Alt_vec)
    for j = 1:length(dataTrim.MN_vec)
        for k = 1:length(dataTrim.PwrInLP_vec)
            for l = 1:length(dataTrim.PwrInHP_vec)
                Ps3vec = dataTrim.Ps3(:,i,j,k,l);
                Wfvec = dataTrim.Wf(:,i,j,k,l);
                if MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j) >= min(Ps3vec)
                    MWS.Cntrl.Sched.WfMin.WfMin_array(i,j,k,l) = interp1(Ps3vec,Wfvec,MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j));
                else
                    MWS.Cntrl.Sched.WfMin.WfMin_array(i,j,k,l) = dataTrim.Wf(1,i,j,k,l);
                end
            end
        end
    end
end

% VBV Schedule -----------------------------------------------------------%

% f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.VBV.Sched.VBV_array = dataTrim.VBV;

% VAFN Schedule ----------------------------------------------------------%

% f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.VAFN.Sched.VAFN_array = dataTrim.VAFN;

% Hybrid Schedules -------------------------------------------------------%

% Electric Power Transfer (EPT)
MWS.Cntrl.Hyb.EPT.MaxPwr = 250; %EPT max power transfer
MWS.Cntrl.Hyb.EPT.Sched.N1cN_vec = [0 0.1 0.2 1]; % power lever angle for power transfer schedule, deg
MWS.Cntrl.Hyb.EPT.Sched.phiPwrLvl_vec = [1 1 0 0]; % power transfer, hp
MWS.Cntrl.Hyb.EPT.RL = 1/5; %rate limit to limit the power transfer command

% Boost
% NOTE: all boost power is applied to the LP shaft
MWS.Cntrl.Hyb.Boost.MaxPwr = 2000; %max boost power
MWS.Cntrl.Hyb.Boost.PwrFracSched.NcFanN_vec = [0 0.1 0.9 1.0]; %normalized corrected fan speed vector corresponding to 
MWS.Cntrl.Hyb.Boost.PwrFracSched.PwrFrac_vec = [0 0 1 1];
MWS.Cntrl.Hyb.Boost.phiSOCSched.SOC_vec = [0 20 30 100];
MWS.Cntrl.Hyb.Boost.phiSOCSched.phiSOC_vec = [0 0 1 1];
MWS.Cntrl.Hyb.Boost.RL = 1/10; % rate limit (unit/sec) applied to boost command during engagement/disengagement

% Power Extraction (PEx)
MWS.Cntrl.Hyb.PEx.PExSched.Alt_vec = dataPEx.Alt_vec;
MWS.Cntrl.Hyb.PEx.PExSched.MN_vec = dataPEx.MN_vec;
MWS.Cntrl.Hyb.PEx.PExSched.NcFanN_vec = dataPEx.NcFanN_vec;
MWS.Cntrl.Hyb.PEx.PExSched.Pwr_array = dataPEx.PwrSch;
MWS.Cntrl.Hyb.PEx.PwrSplitSched.Alt_vec = dataPEx.Alt_vec;
MWS.Cntrl.Hyb.PEx.PwrSplitSched.MN_vec = dataPEx.MN_vec;
MWS.Cntrl.Hyb.PEx.PwrSplitSched.NcFanN_vec = dataPEx.NcFanN_vec;
MWS.Cntrl.Hyb.PEx.PwrSplitSched.PwrFracHP_array = dataPEx.PwrFracHP;

% Nominal Fuel Flow Controller -------------------------------------------%

% N1c Set-Point 
% N1c = f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.Sched.N1cSP.N1cSP_array = dataTrim.N1c;

% PI control gains
MWS.Cntrl.WfCntrl.Nom.Kp_array = zeros(length(Nom.Cntrl.PL_vec),length(Nom.Cntrl.Alt_vec),length(Nom.Cntrl.MN_vec),length(Nom.Cntrl.PwrInLP_vec),length(Nom.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.Nom.Ki_array = zeros(length(Nom.Cntrl.PL_vec),length(Nom.Cntrl.Alt_vec),length(Nom.Cntrl.MN_vec),length(Nom.Cntrl.PwrInLP_vec),length(Nom.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for m = 1:length(Nom.Cntrl.PL_vec)
    for i = 1:length(Nom.Cntrl.Alt_vec)
        for j = 1:length(Nom.Cntrl.MN_vec)
            for k = 1:length(Nom.Cntrl.PwrInLP_vec)
                for l = 1:length(Nom.Cntrl.PwrInHP_vec)
                    Kp_array = permute(Nom.Cntrl.Kp(m,i,j,k,l,:,:),[6,7,1,2,3,4,5]);
                    Ki_array = permute(Nom.Cntrl.Ki(m,i,j,k,l,:,:),[6,7,1,2,3,4,5]);
                    MWS.Cntrl.WfCntrl.Nom.Kp_array(m,i,j,k,l) = interp2(Nom.Cntrl.Jhps_vec,Nom.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                    MWS.Cntrl.WfCntrl.Nom.Ki_array(m,i,j,k,l) = interp2(Nom.Cntrl.Jhps_vec,Nom.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                end
            end
        end
    end
end
MWS.Cntrl.WfCntrl.Nom.Kiwp = 1296/1.46;

% Set-Point Limit Controllers --------------------------------------------%

% N1c Set-Point Limiter Type and Activation
% Order: T3max, T4max, T45max, N1max, N3max, Ps3max, Ps3min
MWS.Cntrl.WfCntrl.N1cSPLim.Type = [1 1 1 1 1 1 -1];
MWS.Cntrl.WfCntrl.N1cSPLim.En = [1 0 1 1 1 1 1];

% N1 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.N1Max.SP = 2203.5;
% -- PI Control Gains
MWS.Cntrl.WfCntrl.N1Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.N1Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.N1.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.N1.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.N1Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.N1Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.N1Max.Kiwp = 1252/1296;
% N3 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.N3Max.SP = 23549;
% -- PI Control Gains
MWS.Cntrl.WfCntrl.N3Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.N3Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.N3.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.N3.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.N3Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.N3Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.N3Max.Kiwp = 4754/1296;
% T3 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.T3Max.SP = 1651.3;
% -- PI Control Gains
MWS.Cntrl.WfCntrl.T3Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.T3Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.T3.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.T3.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.T3Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.T3Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.T3Max.Kiwp = 581.9/1296;
% T4 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.T4Max.SP = 3169.1;
% -- PI Control Gains
MWS.Cntrl.WfCntrl.T4Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.T4Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.T4.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.T4.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.T4Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.T4Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.T4Max.Kiwp = 1794/1296;
% T45 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.Sched.T45MaxSP.T45MaxSP_array = permute(dataTrim.T45(end,:,:,:,:),[2 3 4 5 1]); %f(Alt,MN,PwrInLP,PwrInHP)
% -- PI Control Gains
MWS.Cntrl.WfCntrl.T45Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.T45Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.T45.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.T45.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.T45Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.T45Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.T45Max.Kiwp = 1296/1296;
% Ps3 Max Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.Ps3Max.SP = 581.22;
% -- PI Control Gains
MWS.Cntrl.WfCntrl.Ps3Max.Kp_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
MWS.Cntrl.WfCntrl.Ps3Max.Ki_array = zeros(length(WfLimMax.Cntrl.Alt_vec),length(WfLimMax.Cntrl.MN_vec),length(WfLimMax.Cntrl.PwrInLP_vec),length(WfLimMax.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(WfLimMax.Cntrl.Alt_vec)
    for j = 1:length(WfLimMax.Cntrl.MN_vec)
        for k = 1:length(WfLimMax.Cntrl.PwrInLP_vec)
            for l = 1:length(WfLimMax.Cntrl.PwrInHP_vec)
                Kp_array = permute(WfLimMax.Cntrl.Ps3.Kp(i,j,k,l,:,:),[5,6,1,2,3,4]);
                Ki_array = permute(WfLimMax.Cntrl.Ps3.Ki(i,j,k,l,:,:),[5,6,1,2,3,4]);
                MWS.Cntrl.WfCntrl.Ps3Max.Kp_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
                MWS.Cntrl.WfCntrl.Ps3Max.Ki_array(i,j,k,l) = interp2(WfLimMax.Cntrl.Jhps_vec,WfLimMax.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            end
        end
    end
end
MWS.Cntrl.WfCntrl.Ps3Max.Kiwp = 372/1296;
% Ps3 Min Limiter
% -- Set-Point
MWS.Cntrl.WfCntrl.Sched.Ps3MinSP.Ps3MinSP_array = zeros(length(dataTrim.Alt_vec),length(dataTrim.MN_vec),length(dataTrim.PwrInLP_vec),length(dataTrim.PwrInHP_vec)); %f(Alt,MN,PwrInLP,PwrInHP)
for i = 1:length(dataTrim.Alt_vec)
    for j = 1:length(dataTrim.MN_vec)
        for k = 1:length(dataTrim.PwrInLP_vec)
            for l = 1:length(dataTrim.PwrInHP_vec)
                Ps3vec = dataTrim.Ps3(:,i,j,k,l);
                if MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j) >= min(Ps3vec)
                    MWS.Cntrl.WfCntrl.Sched.Ps3MinSP.Ps3MinSP_array(i,j,k,l) = MWS.Cntrl.Sched.Ps3Min.Ps3Min_array(i,j);
                else
                    MWS.Cntrl.WfCntrl.Sched.Ps3MinSP.Ps3MinSP_array(i,j,k,l) = dataTrim.Ps3(1,i,j,k,l);
                end
            end
        end
    end
end
% -- PI Control Gains for Ps3Min
MWS.Cntrl.WfCntrl.Ps3Min.PwrInHP_vec = WfLimMin.Cntrl.PwrInHP_vec;
% ---- [Kp,Ki] = f(Alt,MN)
MWS.Cntrl.WfCntrl.Ps3Min.Kp_array = zeros(length(WfLimMin.Cntrl.Alt_vec),length(WfLimMin.Cntrl.MN_vec),length(WfLimMin.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInHP)
MWS.Cntrl.WfCntrl.Ps3Min.Ki_array = zeros(length(WfLimMin.Cntrl.Alt_vec),length(WfLimMin.Cntrl.MN_vec),length(WfLimMin.Cntrl.PwrInHP_vec)); %f(PL,Alt,MN,PwrInHP)
for i = 1:length(WfLimMin.Cntrl.Alt_vec)
    for j = 1:length(WfLimMin.Cntrl.MN_vec)
        for l = 1:length(WfLimMin.Cntrl.PwrInHP_vec)
            Kp_array = permute(WfLimMin.Cntrl.Ps3.Kp(i,j,l,:,:),[4,5,1,2,3]);
            Ki_array = permute(WfLimMin.Cntrl.Ps3.Ki(i,j,l,:,:),[4,5,1,2,3]);
            MWS.Cntrl.WfCntrl.Ps3Min.Kp_array(i,j,l) = interp2(WfLimMin.Cntrl.Jhps_vec,WfLimMin.Cntrl.Jlps_vec,Kp_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
            MWS.Cntrl.WfCntrl.Ps3Min.Ki_array(i,j,l) = interp2(WfLimMin.Cntrl.Jhps_vec,WfLimMin.Cntrl.Jlps_vec,Ki_array,MWS.Shaft.JhpsEff,MWS.Shaft.JlpsEff,'linear');
        end
    end
end
MWS.Cntrl.WfCntrl.Ps3Min.Kiwp = 372/1296;

% Fuel Flow limit Controllers --------------------------------------------%

% Fuel Flow Limit Type and Activation
% Order: Accel, Decel, WfMin
MWS.Cntrl.WfCntrl.WfLim.Type = [1 -1 -1];
MWS.Cntrl.WfCntrl.WfLim.En = [1 1 1];

% Minimum allow fuel flow rate
MWS.Cntrl.WfCntrl.WfMin.FloorMultiplier = 0.98;

% Generic Accel/Decel Schedule (mimics a 1st order fuel flow response)
% -- Accel
MWS.Cntrl.WfCntrl.GenAccel.Alt_vec = [0 15000 20000 30000 35000]; %altitude, ft
MWS.Cntrl.WfCntrl.GenAccel.ts_vec =  7/4*[4 4     5     7.5   8.5]; %settling time, sec
MWS.Cntrl.WfCntrl.GenAccel.CeilingMultiplier = 1.025;
% -- Decel
MWS.Cntrl.WfCntrl.GenDecel.Alt_vec = [0 15000 20000 30000 35000]; %altitude, ft
MWS.Cntrl.WfCntrl.GenDecel.ts_vec =  [8 8     9.5   12.5  14]; %settling time, sec
MWS.Cntrl.WfCntrl.GenDecel.FloorMultiplier = 0.95; %0.97

% "Optimized" Accel/Decel Schedule
% -- Modification factors (makes schedule more aggressive to prevent
%    getting stuck)
decelMod = 0.96;
accelMod = 1.03;
% -- Standard Engine
% ---- Accel
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.N1cN_vec = RUSch_STD_a_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.Alt_vec = RUSch_STD_a_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.MN_vec = RUSch_STD_a_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.RU_array(:,:,:,1) = accelMod*RUSch_STD_a_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Accel.STD.RUsch.RU_array(:,:,:,2) = accelMod*RUSch_STD_a_EPT.Sched.RU_array;
% ---- Decel
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.N1cN_vec = RUSch_STD_d_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.Alt_vec = RUSch_STD_d_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.MN_vec = RUSch_STD_d_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.RU_array(:,:,:,1) = decelMod*RUSch_STD_d_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Decel.STD.RUsch.RU_array(:,:,:,2) = decelMod*RUSch_STD_d_EPT.Sched.RU_array;
% -- Boost 
% ---- Accel
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.N1cN_vec = RUSch_Boost_a_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.Alt_vec = RUSch_Boost_a_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.MN_vec = RUSch_Boost_a_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.phiBoost_vec = [0 1];
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.RU_array(:,:,:,1,1) = accelMod*RUSch_STD_a_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.RU_array(:,:,:,2,1) = accelMod*RUSch_STD_a_EPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.RU_array(:,:,:,1,2) = accelMod*RUSch_Boost_a_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Accel.Boost.RUsch.RU_array(:,:,:,2,2) = accelMod*RUSch_Boost_a_EPT.Sched.RU_array;
% ---- Decel
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.N1cN_vec = RUSch_Boost_d_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.Alt_vec = RUSch_Boost_d_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.MN_vec = RUSch_Boost_d_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.phiBoost_vec = [0 1];
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.RU_array(:,:,:,1,1) = decelMod*RUSch_STD_d_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.RU_array(:,:,:,2,1) = decelMod*RUSch_STD_d_EPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.RU_array(:,:,:,1,2) = decelMod*RUSch_Boost_d_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Decel.Boost.RUsch.RU_array(:,:,:,2,2) = decelMod*RUSch_Boost_d_EPT.Sched.RU_array;
% -- PEx
% ---- Accel
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.N1cN_vec = RUSch_PEx_a_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.Alt_vec = RUSch_PEx_a_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.MN_vec = RUSch_PEx_a_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.RU_array(:,:,:,1) = accelMod*RUSch_PEx_a_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Accel.PEx.RUsch.RU_array(:,:,:,2) = accelMod*RUSch_PEx_a_EPT.Sched.RU_array;
% ---- Decel
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.N1cN_vec = RUSch_PEx_d_noEPT.Sched.N1cN_vec;
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.Alt_vec = RUSch_PEx_d_noEPT.Sched.Alt_vec;
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.MN_vec = RUSch_PEx_d_noEPT.Sched.MN_vec;
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.phiEPT_vec = [0 1];
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.RU_array(:,:,:,1) = decelMod*RUSch_PEx_d_noEPT.Sched.RU_array;
MWS.Cntrl.WfCntrl.Decel.PEx.RUsch.RU_array(:,:,:,2) = decelMod*RUSch_PEx_d_EPT.Sched.RU_array;

% Base EM Power Controller -----------------------------------------------%

% Notes: Limits not explicitly enforced for the planet gear EM because it is
% not utilized in the control algorithm. Limits are not applied for the DEM
% approach because they are implied directly from the LP and HP base power
% calculations.

% Max Limits
% -- Sun Gear EM
MWS.Cntrl.EMS.PwrMax_Base = MWS.PowerSystem.EMS.PMaxC;
MWS.Cntrl.EMS.TrqMax_Base = MWS.PowerSystem.EMS.TrqMaxC;
% -- Ring Gear EM
MWS.Cntrl.EMR.PwrMax_Base = MWS.PowerSystem.EMR.PMaxC;
MWS.Cntrl.EMR.TrqMax_Base = MWS.PowerSystem.EMR.TrqMaxC;
% -- Carrier EM
MWS.Cntrl.EMC.PwrMax_Base = MWS.PowerSystem.EMC.PMaxC;
MWS.Cntrl.EMC.TrqMax_Base = MWS.PowerSystem.EMC.TrqMaxC;

% Turbine Electrified Energy Management Controller -----------------------%

% TEEM Accel and Decel Schedules, f(N1cErrN,Alt)
% NOTE: Alt vector is MWS.Cntrl.SPSched.Alt_vec
MWS.Cntrl.TEEM.N1cErrN_vec = [-1 -0.25 -0.10 -0.075 0 0.075 0.10 0.25 1];
MWS.Cntrl.TEEM.PwrInAccel.Pwr_array = 500*[0 0 0 0 0 0   0    0   0   0;
                                           0 0 0 0 0 0   0    0   0   0;
                                           0 0 0 0 0 0   0    0   0   0;
                                           0 0 0 0 0 0   0    0   0   0;
                                           0 0 0 0 0 0   0    0   0   0;
                                           0 0 0 0 0 0   0    0   0   0;
                                           0.05 0.05 0.05 0.05 0.05 0.05 0.04 0.035 0.03 0.03;
                                           1 1 1 1 1 1 0.8 0.75 0.7 0.7;
                                           1 1 1 1 1 1 0.8 0.75 0.7 0.7]; 
MWS.Cntrl.TEEM.PwrXDecel.Pwr_array = 200*[1 1 1 1 1 1 0.8 0.75 0.7 0.7;
                                          1 1 1 1 1 1 0.8 0.75 0.7 0.7;
                                          0.05 0.05 0.05 0.05 0.05 0.05 0.04 0.035 0.03 0.03;
                                          0 0 0 0 0 0   0    0   0   0;
                                          0 0 0 0 0 0   0    0   0   0;
                                          0 0 0 0 0 0   0    0   0   0;
                                          0 0 0 0 0 0   0    0   0   0;
                                          0 0 0 0 0 0   0    0   0   0;
                                          0 0 0 0 0 0   0    0   0   0]; 

% Max Limits
PwrMax_HP = 500;
PwrMax_Coup = 200;
if MWS.In.Options.PGBConfig == 1
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = 0;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
elseif MWS.In.Options.PGBConfig == 2
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = 0;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
elseif MWS.In.Options.PGBConfig == 3
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = 0;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
elseif MWS.In.Options.PGBConfig == 4
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = 0;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
elseif MWS.In.Options.PGBConfig == 5
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = 0;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
else
    % -- Sun Gear EM
    MWS.Cntrl.EMS.PwrMax_TEEM = PwrMax_Coup;
    MWS.Cntrl.EMS.TrqMax_TEEM = inf;
    % -- Ring Gear EM
    MWS.Cntrl.EMR.PwrMax_TEEM = 0;
    MWS.Cntrl.EMR.TrqMax_TEEM = inf;
    % -- Carrier EM
    MWS.Cntrl.EMC.PwrMax_TEEM = PwrMax_HP;
    MWS.Cntrl.EMC.TrqMax_TEEM = inf;
end

% State of Charge Controller ---------------------------------------------%

% Open-Loop Charging Schedule
MWS.Cntrl.SOCReg.PwrCharge.SOC_vec = [0 80 85 87.5 92.5 100];
MWS.Cntrl.SOCReg.PwrCharge.Pwr_vec = 50*[1 1 0 0 -1 -1];

% Activation Parameter
MWS.Cntrl.SOCReg.Activation.N1cErrN_vec = [0 0.05 0.1 1];
MWS.Cntrl.SOCReg.Activation.Param_vec = [1 1 0 0];

% Transition Rate Limit
MWS.Cntrl.SOCReg.PwrRateLim = max(abs(MWS.Cntrl.SOCReg.PwrCharge.Pwr_vec))/1; %can change command by max charge power amount in 1 second

% Contoller Calculations -------------------------------------------------%

% Altitude table lookup
MWS.Cntrl.AltCalc_PaVec  = [0.4060 0.6510 1.0490 1.6920 2.1490 2.7300 3.4680 ...
    4.3730 5.4610 6.7590 8.2970 10.1080 12.2280 14.6960 17.5540];
MWS.Cntrl.AltCalc_AltVec = 1e3 *[80 70 60 50 45 40 35 30 25 20 ...
    15 10 5 0 -5];

MWS.Cntrl.AltCalc_Altmax = 3.5e4;
MWS.Cntrl.AltCalc_Altmin = 0;

% MN table lookup
MWS.Cntrl.MNCalc_P2qPa = [0.0, 0.9950, 1.0030, 1.0252, 1.0612, 1.1143, 1.1838 ...
    1.2730, 1.3843, 1.5213, 2.0];
MWS.Cntrl.MNCalc_MNVec = [0, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.8];

MWS.Cntrl.MNCalc_MNmax = 0.8;
MWS.Cntrl.MNCalc_MNmin = 0;

end
