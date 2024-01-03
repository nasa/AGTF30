% run_AGTF30e_script.m ===================================================%

% Written by: Jonathan Kratz (NASA GRC - LCC)
% Date: 9/14/2023
% Description: This script is a template for running the AGTF30-e model.
%   This script can be modified to run other simulation scenarios or used a
%   a basis for setting up a seperate script for single or batch
%   simulations. 

clear all
close all
clc

% Initialize the workspace -----------------------------------------------%

disp('Initializing Workspace');

inputMethod = 2; % use excel spreadsheet
In = []; % empty array for now
filename = 'AGTF30e_Inputs.xlsx'; %file to derive inputs from
Mdl = 1; % dynamic model
SSsolverSP = 2; % doesn't matter, not using steady-state model
dem = []; % empty array - use default values
veate = []; % empty array - use default values
MWS = Setup_Simulation(inputMethod,In,filename,Mdl,SSsolverSP,dem,veate);

% Modify the workspace (if desired) --------------------------------------%

% This section of code is unnecessary if AGTF30e_Inputs.xlsx defines the
% simulation scenario you wish to run.

disp('Updating Workspace ...');

% Options
MWS.In.Options.HybridConfig = 2; %1-Standard, 2-Boost, 3-PEx
MWS.In.Options.EngineEMInt = 1; %1-DEM, 2-VEATE-PGB
MWS.In.Options.PGBConfig = 2; %1-HP Sun, LP Ring, 2-HP Sun, LP Carrier
                              %3-HP Ring, LP Sun, 4-HP Ring, LP Carrier
                              %5-HP Carrier, LP Sun, 6-HP Carrier, LP Ring
MWS.In.Options.WfTransientLogic = 2; % 1-General Limiter, 2-Ratio Unit Schedule
MWS.In.Options.TEEM = 0; %0-disable TEEM, 1-Enable TEEM

% Environment Inputs
MWS.In.t_Alt = [0 10];
MWS.In.Alt = [0 0];
MWS.In.t_MN = [0 10];
MWS.In.MN = [0 0];
MWS.In.t_dTamb = [0 10];
MWS.In.dTamb = [0 0];

% Control Inputs
MWS.In.t_PLA = [0 20 20.015 50 50.015 120];
MWS.In.PLA = [40 40 80 80 40 40];
MWS.In.t_Boost = [0 3 3.015 70 70.015 120];
MWS.In.Boost = [0 0 1 1 0 0];
MWS.In.t_Charge = [0 95 95.015 120];
MWS.In.Charge = [0 0 1 1];
MWS.In.t_EPT = [0 65 65.015 95 95.015 120];
MWS.In.EPT = [0 0 1 1 0 0];

% Engine-EM Integration Specification
dem = [];
veate = [];

% Update MWS
inputMethod = 1;
MWS = Setup_Simulation(inputMethod,MWS.In,filename,Mdl,SSsolverSP,dem,veate);

% Run the simulation -----------------------------------------------------%

disp('Running Simulation ...');

sim('AGTF30SysDyn_PExPIn.slx');

disp('Simulation Complete ...');

% Plot some results ------------------------------------------------------%

disp('Plotting Results ...')

% Envrionment
figure();
subplot(1,3,1)
plot(out_Dyn.in.Alt.Time,out_Dyn.in.Alt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('Altitude, ft')
grid on;
subplot(1,3,2)
plot(out_Dyn.in.MN.Time,out_Dyn.in.MN.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('Mach Number')
grid on;
subplot(1,3,3)
plot(out_Dyn.in.dT.Time,out_Dyn.in.dT.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('\DeltaT, ^oR')
grid on;

% Control Inputs
figure();
subplot(4,1,1)
plot(out_Dyn.in.PLA.Time,out_Dyn.in.PLA.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('PLA, ^o')
grid on;
subplot(4,1,2)
plot(out_Dyn.in.BoostToggle.Time,out_Dyn.in.BoostToggle.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('Boost Toggle')
grid on;
subplot(4,1,3)
plot(out_Dyn.in.ChargingToggle.Time,out_Dyn.in.ChargingToggle.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('Charge Toggle')
grid on;
subplot(4,1,4)
plot(out_Dyn.in.EPTToggle.Time,out_Dyn.in.EPTToggle.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('EPT Toggle')
grid on;

% Wf, VBV, VAFN
figure();
subplot(3,1,1);
plot(out_Dyn.act.Wfact.Time,out_Dyn.act.Wfact.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('W_f, lb_m/s')
grid on;
subplot(3,1,2);
plot(out_Dyn.act.VBVact.Time,out_Dyn.act.VBVact.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('VBV, frac. open')
grid on;
subplot(3,1,3);
plot(out_Dyn.act.VAFNact.Time,out_Dyn.act.VAFNact.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('VAFN area, in^2')
grid on;

% Control Regulators
figure();
subplot(2,1,1);
plot(out_Dyn.cntrl.Data.WfRegNum.N1cSP.Time,out_Dyn.cntrl.Data.WfRegNum.N1cSP.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('N_{1c} Set-Point Regulator')
grid on;
subplot(2,1,2);
plot(out_Dyn.cntrl.Data.WfRegNum.Wf.Time,out_Dyn.cntrl.Data.WfRegNum.Wf.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('W_f Set-Point Regulator')
grid on;

% EMs
figure();
if MWS.In.Options.EngineEMInt == 1
    subplot(2,2,1);
    plot(out_Dyn.act.TrqEML.Time,out_Dyn.act.TrqEML.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_L, ft-lb_f')
    grid on;
    subplot(2,2,2);
    plot(out_Dyn.act.TrqEML.Time,out_Dyn.act.TrqEML.Data.*out_Dyn.eng.GBData.DEM.Nem.Data(:,1)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_L, hp')
    grid on;
    subplot(2,2,3);
    plot(out_Dyn.act.TrqEMH.Time,out_Dyn.act.TrqEMH.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_H, ft-lb_f')
    grid on;
    subplot(2,2,4);
    plot(out_Dyn.act.TrqEMH.Time,out_Dyn.act.TrqEMH.Data.*out_Dyn.eng.GBData.DEM.Nem.Data(:,2)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_H, hp')
    grid on;
else
    subplot(4,2,1);
    plot(out_Dyn.act.TrqEMS.Time,out_Dyn.act.TrqEMS.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_S, ft-lb_f')
    grid on;
    subplot(4,2,2);
    plot(out_Dyn.act.TrqEMS.Time,out_Dyn.act.TrqEMS.Data.*out_Dyn.eng.GBData.PGB.Nem.Data(:,1)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_S, hp')
    grid on;
    subplot(4,2,3);
    plot(out_Dyn.act.TrqEMR.Time,out_Dyn.act.TrqEMR.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_R, ft-lb_f')
    grid on;
    subplot(4,2,4);
    plot(out_Dyn.act.TrqEMR.Time,out_Dyn.act.TrqEMR.Data.*out_Dyn.eng.GBData.PGB.Nem.Data(:,2)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_R, hp')
    grid on;
    subplot(4,2,5);
    plot(out_Dyn.act.TrqEMC.Time,out_Dyn.act.TrqEMC.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_C, ft-lb_f')
    grid on;
    subplot(4,2,6);
    plot(out_Dyn.act.TrqEMC.Time,out_Dyn.act.TrqEMC.Data.*out_Dyn.eng.GBData.PGB.Nem.Data(:,3)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_C, hp')
    grid on;
    subplot(4,2,7);
    plot(out_Dyn.act.TrqEMP.Time,out_Dyn.act.TrqEMP.Data,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('\tau_P, ft-lb_f')
    grid on;
    subplot(4,2,8);
    plot(out_Dyn.act.TrqEMP.Time,out_Dyn.act.TrqEMP.Data.*out_Dyn.eng.GBData.PGB.Nem.Data(:,4)./5252.113,'-k','LineWidth',2)
    xlabel('Time, s')
    ylabel('P_P, hp')
    grid on;
end

% SOC
figure();
plot(out_Dyn.sen.SOC.Time,out_Dyn.sen.SOC.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('SOC, %')
grid on;

% N1c, Thrust, TSFC
figure();
subplot(3,1,1);
plot(out_Dyn.eng.Data.FAN_Data.Nc.Time,out_Dyn.eng.Data.FAN_Data.Nc.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('N_{1c}, rpm')
grid on;
subplot(3,1,2);
plot(out_Dyn.eng.Perf.Fnet.Time,out_Dyn.eng.Perf.Fnet.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('F_n, lb_f')
grid on;
subplot(3,1,3);
plot(out_Dyn.eng.Perf.Fnet.Time,(out_Dyn.act.Wfact.Data*3600)./out_Dyn.eng.Perf.Fnet.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('TSFC, (lb_m/hr)/lb_f')
grid on;

% Shaft Speeds
figure();
subplot(3,1,1);
plot(out_Dyn.eng.Shaft.N_Fan.Time,out_Dyn.eng.Shaft.N_Fan.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('N_1, rpm')
grid on;
subplot(3,1,2);
plot(out_Dyn.eng.Shaft.N_LPC.Time,out_Dyn.eng.Shaft.N_LPC.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('N_2, rpm')
grid on;
subplot(3,1,3);
plot(out_Dyn.eng.Shaft.N_HPC.Time,out_Dyn.eng.Shaft.N_HPC.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('N_3, rpm')
grid on;

% Station Temperatures (T2, T25, T3, T4, T45, T5)
figure();
subplot(6,1,1);
plot(out_Dyn.eng.S2.Tt.Time,out_Dyn.eng.S2.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_2, ^oR')
grid on;
subplot(6,1,2);
plot(out_Dyn.eng.S25.Tt.Time,out_Dyn.eng.S25.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_{25}, ^oR')
grid on;
subplot(6,1,3);
plot(out_Dyn.eng.S36.Tt.Time,out_Dyn.eng.S36.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_3, ^oR')
grid on;
subplot(6,1,4);
plot(out_Dyn.eng.S4.Tt.Time,out_Dyn.eng.S4.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_4, ^oR')
grid on;
subplot(6,1,5);
plot(out_Dyn.eng.S45.Tt.Time,out_Dyn.eng.S45.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_{45}, ^oR')
grid on;
subplot(6,1,6);
plot(out_Dyn.eng.S5.Tt.Time,out_Dyn.eng.S5.Tt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('T_5, ^oR')
grid on;

% Station Pressures (P2, P25, P3, Ps3, P45, P5)
figure();
subplot(6,1,1);
plot(out_Dyn.eng.S2.Pt.Time,out_Dyn.eng.S2.Pt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_2, ^oR')
grid on;
subplot(6,1,2);
plot(out_Dyn.eng.S25.Pt.Time,out_Dyn.eng.S25.Pt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_{25}, ^oR')
grid on;
subplot(6,1,3);
plot(out_Dyn.eng.S36.Pt.Time,out_Dyn.eng.S36.Pt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_3, ^oR')
grid on;
subplot(6,1,4);
plot(out_Dyn.eng.S36.Ps.Time,out_Dyn.eng.S36.Ps.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_s3, ^oR')
grid on;
subplot(6,1,5);
plot(out_Dyn.eng.S45.Pt.Time,out_Dyn.eng.S45.Pt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_{45}, ^oR')
grid on;
subplot(6,1,6);
plot(out_Dyn.eng.S5.Pt.Time,out_Dyn.eng.S5.Pt.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('p_5, ^oR')
grid on;

% Stall Margins
figure();
subplot(3,1,1);
plot(out_Dyn.eng.SM.SMFan.Time,out_Dyn.eng.SM.SMFan.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('Fan SM, %')
grid on;
subplot(3,1,2);
plot(out_Dyn.eng.SM.SMLPC.Time,out_Dyn.eng.SM.SMLPC.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('LPC SM, %')
grid on;
subplot(3,1,3);
plot(out_Dyn.eng.SM.SMHPC.Time,out_Dyn.eng.SM.SMHPC.Data,'-k','LineWidth',2)
xlabel('Time, s')
ylabel('HPC SM, %')
grid on;

% Maps
figure();
subplot(2,3,1)
PlotCMap(MWS.FAN.NcVec,MWS.FAN.WcArray,MWS.FAN.PRArray,MWS.FAN.EffArray)
hold on;
plot(out_Dyn.eng.Data.FAN_Data.WcMap.Data,out_Dyn.eng.Data.FAN_Data.PRMap.Data,'-k','LineWidth',2)
xlabel('W_{c,Map}, lb_m/s')
ylabel('PR_{Map}')
title('Fan Map')
grid on
subplot(2,3,2)
PlotCMap(MWS.LPC.NcVec,MWS.LPC.WcArray,MWS.LPC.PRArray,MWS.LPC.EffArray)
hold on;
plot(out_Dyn.eng.Data.LPC_Data.WcMap.Data,out_Dyn.eng.Data.LPC_Data.PRMap.Data,'-k','LineWidth',2)
xlabel('W_{c,Map}, lb_m/s')
ylabel('PR_{Map}')
title('LPC Map')
grid on
subplot(2,3,3)
PlotCMap(MWS.HPC.NcVec,MWS.HPC.WcArray,MWS.HPC.PRArray,MWS.HPC.EffArray)
hold on;
plot(out_Dyn.eng.Data.HPC_Data.WcMap.Data,out_Dyn.eng.Data.HPC_Data.PRMap.Data,'-k','LineWidth',2)
xlabel('W_{c,Map}, lb_m/s')
ylabel('PR_{Map}')
title('HPC Map')
grid on
subplot(2,2,3)
PlotTMap(MWS.HPT.NcVec,MWS.HPT.PRVec,MWS.HPT.WcArray,MWS.HPT.effArray)
hold on;
plot(out_Dyn.eng.Data.HPT_Data.WcMap.Data,out_Dyn.eng.Data.HPT_Data.PRMap.Data,'-k','LineWidth',2)
xlabel('W_{c,Map}, lb_m/s')
ylabel('PR_{Map}')
title('HPT Map')
grid on
subplot(2,2,4)
PlotTMap(MWS.LPT.NcVec,MWS.LPT.PRVec,MWS.LPT.WcArray,MWS.LPT.effArray)
hold on;
plot(out_Dyn.eng.Data.LPT_Data.WcMap.Data,out_Dyn.eng.Data.LPT_Data.PRMap.Data,'-k','LineWidth',2)
xlabel('W_{c,Map}, lb_m/s')
ylabel('PR_{Map}')
title('LPT Map')
grid on

disp('Script is Complete')