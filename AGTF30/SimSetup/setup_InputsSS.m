function MWS = setup_InputsSS(MWS)
% This function set model IC and Solver inputs. For the Steady-state and dynamic models
% The steady-state point will act as the inputs for the system N3SysSS and
% as the initial conditions (ICs) for the dynamic model, system N3SysDyn
% A Test vector input is then used to set the dynamic system only inputs.

%% Set Model inputs:
%--------------------------------------------------
% Use Predetermined initial condition/steady-state point
% cruise
% takeoff
% none - autogen IC

% Choose steady-state starting conditions
switch(MWS.In.ICPoint)
    case('cruise')
        %% Cruise Steady State point
        % set Engine inputs
        MWS.In.ssNc1 = 1.0 * MWS.FAN.s_Nc; % Corrected FAN speed for solving steady state
        %Environmental inputs
        MWS.In.AltIC = 35000; %ft
        MWS.In.dTambIC = 0.0; % deg F
        MWS.In.MNIC = 0.8;
        % Fuel Flow (pps)
        MWS.In.WfIC = 0.7837;
        % desired  shaft speed and ICs for dynamic operation
        MWS.In.N2IC = 6772.0;
        MWS.In.N3IC = 20796;
        % VBV value ranges from 0 to 1,  0: VBV fully closed, 1: VBV fully open
        MWS.In.VBVIC = 0;
        % Fan nozzle area (in^2)
        MWS.In.VAFNIC = 4775.22;
        
        %set Engine initial conditions
        
        % ICs may be updated for new operating points by running
        % the steady state simulation at alternate operating points and
        % recording the new independents accordingly.
        
        % Independents are broken into two types, for Dyanmic
        % simulation and steady-state simulation. In
        % general, independents in the dynamic simulation are in the
        % steady-state simulation as well, however not all steady-state
        % independents will be in the dynamic simulation.
        
        % Common ICs
        MWS.In.ICcom(1) = 815.48;   % Flow (pps)
        MWS.In.ICcom(2) = 4.0955;   % HPT Pressure Ratio
        MWS.In.ICcom(3) = 1.994;    % HPC Rline
        MWS.In.ICcom(4) = 2.0007;   % Fan_Rline
        MWS.In.ICcom(5) = 23.19937; % Branch Pressure Ratio
        MWS.In.ICcom(6) = 2.19956;  % LPC_Rline
        MWS.In.ICcom(7) = 11.0178;  % LPT Pressure Ratio
        
        % steady state only Independents,  Dynamic ICs
        % Shaft speed independents must be the first two items.
        MWS.In.ICss(1) = MWS.In.N2IC;      % Low Pressure Shaft Speed (rpm)
        MWS.In.ICss(2) = MWS.In.N3IC;      % High Pressure Shaft Speed (rpm)
        MWS.In.ICss(3) = MWS.In.WfIC;      % Fuel Flow (pps)
        MWS.In.ICss(4) = MWS.In.VAFNIC;   % VAFN area (in2)
        MWS.In.ICss(5) = MWS.In.VBVIC + 1; % VBV position plus 1 (1- closed, 2 - open)
        
        MWS = SetSolverVars(MWS);
        
        % Set Sensor ICs
        MWS.In.Sensor.ICN1 = MWS.In.N2IC/3.1;
        MWS.In.Sensor.ICN2 = MWS.In.N2IC;
        MWS.In.Sensor.ICN3 = MWS.In.N3IC;
        
        MWS.In.Sensor.ICPa  = 3.468;
        MWS.In.Sensor.ICP2  = 5.2758;
        MWS.In.Sensor.ICP21 = 6.8616;
        MWS.In.Sensor.ICP25 = 20.1392;
        MWS.In.Sensor.ICPs3 = 270.75;
        MWS.In.Sensor.ICP5  = 5.8981;
        
        MWS.In.Sensor.ICT2  = 444.6128;
        MWS.In.Sensor.ICT25 = 679.6378;
        MWS.In.Sensor.ICT3 = 1531.3;
        MWS.In.Sensor.ICT45  = 2237.2;
        
    case('takeoff')
        %% Takeoff hot day Steady State point
        % set Engine inputs
        MWS.In.ssNc1 = 0.810 * MWS.FAN.s_Nc; % Corrected FAN speed for solving steady state
        %Environmental inputs
        MWS.In.AltIC = 0.0; %ft
        MWS.In.dTambIC = 27.0; % deg F
        MWS.In.MNIC = 0.0;
        % Fuel Flow (pps)
        MWS.In.WfIC = 1.3896;
        % desired  shaft speed and ICs for dynamic operation
        MWS.In.N2IC = 6079.0;
        MWS.In.N3IC = 21583.2;
        % VBV value ranges from 0 to 1,  0: VBV fully closed, 1: VBV fully open
        MWS.In.VBVIC = 0;
        % Fan nozzle area (in^2)
        MWS.In.VAFNIC = 6314.82;
        %set Engine initial conditions
        % Common ICs
        MWS.In.ICcom(1) = 1723.81;  % Flow (pps)
        MWS.In.ICcom(2) = 4.17;     % HPT Pressure Ratio
        MWS.In.ICcom(3) = 2.0325;   % HPC Rline
        MWS.In.ICcom(4) = 1.75;     % Fan_Rline
        MWS.In.ICcom(5) = 27.5078;  % Branch Pressure Ratio
        MWS.In.ICcom(6) = 1.8740;   % LPC_Rline
        MWS.In.ICcom(7) = 7.15;     % LPT Pressure Ratio
        
        % steady state only Independents,  Dynamic ICs
        % Shaft speed independents must be the first two items.
        MWS.In.ICss(1) = MWS.In.N2IC;       % Low Pressure Shaft Speed (rpm)
        MWS.In.ICss(2) = MWS.In.N3IC;       % High Pressure Shaft Speed (rpm)
        MWS.In.ICss(3) = MWS.In.WfIC;       % Fuel Flow (pps)
        MWS.In.ICss(4) = MWS.In.VAFNIC;    %  VAFN area (in2)
        MWS.In.ICss(5) = MWS.In.VBVIC + 1;  % VBVIC (0-closed, 1-open) + 1
        
        MWS = SetSolverVars(MWS);
        
        % Set Sensor ICs
        MWS.In.Sensor.ICN1 = MWS.In.N2IC/3.1;
        MWS.In.Sensor.ICN2 = MWS.In.N2IC;
        MWS.In.Sensor.ICN3 = MWS.In.N3IC;
        
        MWS.In.Sensor.ICPa  = 14.69;
        MWS.In.Sensor.ICP2  = 14.6225;
        MWS.In.Sensor.ICP21 = 17.1725;
        MWS.In.Sensor.ICP25 = 42.2446;
        MWS.In.Sensor.ICPs3 = 524.5709;
        MWS.In.Sensor.ICP5  = 16.7761;
        
        MWS.In.Sensor.ICT2  = 545.67;
        MWS.In.Sensor.ICT25 = 758.4;
        MWS.In.Sensor.ICT3 = 1631.6;
        MWS.In.Sensor.ICT45  = 2258;
        
    otherwise
        %% use the IC generator
        % Gather desired starting point
        MWS.In.AltIC = MWS.In.Alt(1,1);
        MWS.In.MNIC  = MWS.In.MN(1,1);
        MWS.In.dTambIC = MWS.In.dT(1,1);
        
        % gather start points for Alt and MN
        [cond,MWS.In.AltIC,MWS.In.MNIC,MWS.In.dTambIC] = AGTF30.inEnvelope(MWS);
        Alt = MWS.In.AltIC;
        MN  = MWS.In.MNIC;
        dT = MWS.In.dTambIC;
        
        % Get IC points
        load('SS_Mtrx.mat');
        
        % create Alt and MN axis
        AltVec = SS.Alt;
        NcVec  = SS.Nc;
        MNVec  = SS.MN;
        
        % Verify table inputs are within bounds
        Alt    = CheckMnMx(Alt   ,min(AltVec)  , max(AltVec),'Alt');
        MN     = CheckMnMx(MN    ,min(MNVec)   , max(MNVec) ,'MN');
        
        if MWS.In.WfManEn % base input speed request on manual fuel flow request
            % perform backwards table lookup
            Nc_guess = 1500;
            Wfguess = interpn(AltVec,NcVec,MNVec,SS.Ind{10}{1},Alt,Nc_guess,MN);
            Wf_Er = MWS.In.Wfreq(1,1) - Wfguess;
            Nc_guessNew = 1501;
            iter = 1;
            Er_T = 0.001;
            while ((abs(Wf_Er) > Er_T) && (iter < 200))
                % gather Error and iteration info
                Wf_ErOld = Wf_Er;
                Nc_guessOld = Nc_guess;
                Nc_guess = Nc_guessNew;
                % Perform table lookup with new values
                Wfguess = interpn(AltVec,NcVec,MNVec,SS.Ind{10}{1},Alt,Nc_guess,MN);
                Wf_Er = MWS.In.Wfreq(1,1) - Wfguess;
                % if error is large use secant algorithm to guess a new Nc
                % value
                if abs(Wf_Er) > Er_T
                    if abs(Wf_Er - Wf_ErOld) < 0.000001
                        Wf_Er = Wf_Er*1.01;
                    end
                    Nc_guessNew = Nc_guess - Wf_Er * (Nc_guess - Nc_guessOld)/(Wf_Er - Wf_ErOld);
                end
                
                iter = iter + 1;
            end
            
            if iter >= 200
                fprintf(['Can not automatically determine corrected speed that matches with specified fuel flow, Wfref\n']);
            end
            Nc = Nc_guess;
            
        elseif MWS.In.N1ManEn % based on manual N1 request
            Nc = MWS.In.N1creq(1,1);
        else % based on PLA input
            PLA = MWS.In.PLA(1,1);
            % Determine thrust fraction based on PLA max = 80 and min = 40
            TF = (PLA - 40)/(80-40);
            % Look up corrected speed based on PLA, Alt, and MN
            Nc = interp3(MWS.Cntrl.PM_AltVec,MWS.Cntrl.PM_TF,MWS.Cntrl.PM_MNVec,MWS.Cntrl.PM_NcArray,Alt,TF,MN);
        end
        
        % check speed meets vector requirements
        Nc     = CheckMnMx(Nc,min(NcVec), max(NcVec) ,'Nc');
        % check speed meets limiter requirements
        NcMin = interp2(MNVec,AltVec,SS.Ncmin,MN,Alt);
        NcMax = interp2(MNVec,AltVec,SS.Ncmax,MN,Alt);
        Nc     = CheckMnMx(Nc,NcMin, NcMax,'Nc');
        
        % Set final and limited corrected speed value
        MWS.In.ssNc1 = Nc;
        
        % Set VAFN throat area
        if MWS.In.VAFNManEn % if manually set,  set to input value.
            MWS.In.VAFNIC = MWS.In.VAFNreq(1,1);
        else % set based on control system table lookup
            MWS.In.VAFNIC = interp2(MWS.Cntrl.VAFN_MN,MWS.Cntrl.VAFN_Nc1,MWS.Cntrl.VAFN_sch, MN, Nc);
        end
        
        % Set VBV open position
        if MWS.In.VBVManEn % if manually set,  set to input value.
            MWS.In.VBVIC = MWS.In.VBVreq(1,1);
        else % set based on control system table lookup
            MWS.In.VBVIC = interp2(MWS.Cntrl.VBV_MN,MWS.Cntrl.VBV_Nc1,MWS.Cntrl.VBV_sch, MN, Nc);
        end
        
        
        % Read starting points for IC generation
        % dT adjustment
        dT_adj = 1 + dT/1000; % rule of thumb adjustment
        
        MWS.In.ICcom(1) = interpn(AltVec,NcVec,MNVec,SS.Ind{1}{1},Alt,Nc,MN)/ dT_adj;       % Flow (pps)
        MWS.In.ICcom(2) = interpn(AltVec,NcVec,MNVec,SS.Ind{2}{1},Alt,Nc,MN)/ (1 + (dT_adj-1) * MN);               % HPT Pressure Ratio
        MWS.In.ICcom(3) = interpn(AltVec,NcVec,MNVec,SS.Ind{3}{1},Alt,Nc,MN)/ (1 + (dT_adj-1) * MN);               % HPC Rline
        MWS.In.ICcom(4) = interpn(AltVec,NcVec,MNVec,SS.Ind{4}{1},Alt,Nc,MN);               % Fan_Rline
        MWS.In.ICcom(5) = interpn(AltVec,NcVec,MNVec,SS.Ind{5}{1},Alt,Nc,MN);               % Branch Pressure Ratio
        MWS.In.ICcom(6) = interpn(AltVec,NcVec,MNVec,SS.Ind{6}{1},Alt,Nc,MN);               % LPC_Rline
        MWS.In.ICcom(7) = interpn(AltVec,NcVec,MNVec,SS.Ind{7}{1},Alt,Nc,MN);               % LPT Pressure Ratio
        
        MWS.In.ICss(1)  = interpn(AltVec,NcVec,MNVec,SS.Ind{8}{1},Alt,Nc,MN)* dT_adj;       % Low Pressure Shaft Speed (rpm)
        MWS.In.ICss(2)  = interpn(AltVec,NcVec,MNVec,SS.Ind{9}{1},Alt,Nc,MN)* dT_adj;       % High Pressure Shaft Speed (rpm)
        MWS.In.ICss(3)  = interpn(AltVec,NcVec,MNVec,SS.Ind{10}{1},Alt,Nc,MN)* dT_adj;      % Fuel Flow (pps)
        MWS.In.ICss(4)  = interpn(AltVec,NcVec,MNVec,SS.Ind{11}{1},Alt,Nc,MN);              % VAFN area, VAFN (in2)
        MWS.In.ICss(5)  = interpn(AltVec,NcVec,MNVec,SS.Ind{12}{1},Alt,Nc,MN) + 1;          % VBV position plus 1 (1-closed, 2-open)
        
        MWS.In.N2IC = MWS.In.ICss(1);
        MWS.In.N3IC = MWS.In.ICss(2);
        MWS.In.WfIC = MWS.In.ICss(3);
        
        
        MWS = SetSolverVars(MWS);
        
        % run steady state solver to determine final convergence.
        cd(MWS.top_level)
        assignin('base', 'MWS',MWS);
        fprintf(['Generating ICs with steady-state solver...\n']);
        sim('AGTF30SysSS.mdl');
        close_system('AGTF30SysSS.mdl');
        close_system('AGTF30_eng.mdl');
        fprintf(['IC generation complete\n']);
        
        SSconv = out_SS.converged.Data(end);
        
        if SSconv == 0
            fprintf(['Auto initial condition generator failed, please specify ICs via setup_InputsSS\n']);
        else
            try
                MWS.In.ICcom = out_SS.independents.Data(end,1:7);
                MWS.In.ICss  = out_SS.independents.Data(end,8:end);
                MWS.In.N2IC = MWS.In.ICss(1);
                MWS.In.N3IC = MWS.In.ICss(2);
                MWS.In.WfIC = MWS.In.ICss(3);
            catch
                fprintf(['Sensor initial condtions were not fully generated\n']);
            end
        end
            try  
                % Set Sensor ICs
                MWS.In.Sensor.ICN1 = MWS.In.N2IC/3.1;
                MWS.In.Sensor.ICN2 = MWS.In.N2IC;
                MWS.In.Sensor.ICN3 = MWS.In.N3IC;
                
                MWS.In.Sensor.ICPa  = out_SS.Pa.Data(end);
                MWS.In.Sensor.ICP2  = out_SS.S2.Pt.Data(end);
                MWS.In.Sensor.ICP21 = out_SS.S21.Pt.Data(end);
                MWS.In.Sensor.ICP25 = out_SS.S25.Pt.Data(end);
                MWS.In.Sensor.ICPs3 = out_SS.S36.Pt.Data(end);
                MWS.In.Sensor.ICP5  = out_SS.S5.Pt.Data(end);
                
                MWS.In.Sensor.ICT2  = out_SS.S2.Tt.Data(end);
                MWS.In.Sensor.ICT25 = out_SS.S25.Tt.Data(end);
                MWS.In.Sensor.ICT3 = out_SS.S36.Tt.Data(end);
                MWS.In.Sensor.ICT45  = out_SS.S45.Tt.Data(end);
            catch
                fprintf(['Sensor initial condtions were not fully generated\n']);
            end
        cd([MWS.top_level,MWS.POp,'SimSetup']);
        
end
end

function MWS = SetSolverVars(MWS)
%% Solver Input Settings (for SS and dyn)
%---------------------------------
%Solver inputs
ICnumCom = length(MWS.In.ICcom);
ICnumTot = ICnumCom +  length(MWS.In.ICss);
%set solver perturbation sizes
MWS.In.JPerSS = [0.001*ones(ICnumTot,1) -0.001*ones(ICnumTot,1)]';
MWS.In.JPerDyn = [0.001*ones(ICnumCom,1) -0.001*ones(ICnumCom,1)]';
%set Condition limit
MWS.In.Lim = 1e-5;
%set max number of solver iterations
%for run (steady-state) or per time step (dyn)
MWS.In.Max_IterDyn = numel(MWS.In.JPerDyn) + 50;
MWS.In.Max_IterSS = 2*(numel(MWS.In.JPerSS) + 40);
% set number of consecuative time steps for determining a dynamic run is
% failing to converge.  Once limit is reached the dynamic simulation will
% stop
MWS.In.DynRunNonConv = 400;
%set number of solver attempts before Jacobian re-calc.
MWS.In.NRADyn = 25;
MWS.In.NRASS = MWS.In.Max_IterSS/2;
%set max % step change for solver
MWS.In.dX = 1;
%set Perturbation values for X in the linear solver
FracStep = [0.01; 0.005;-0.005;-0.01];
MWS.In.XPerLin = [MWS.In.N2IC*FracStep,MWS.In.N3IC*FracStep];
% Set Perturabation steps for u in the linear solver
MWS.In.UPerLin = MWS.In.WfIC * FracStep;
end

function Vf = CheckMnMx(Vo, Mn, Mx,VarName)
%% Check input value by min and max values producing an error message and
% limiting the value if it fails the check
%-------------------------------------------------------------------------
if Vo < Mn
    Vf = Mn;
    fprintf(['Initial condition ',VarName,' too low, updating to %d \n'],Mn)
elseif Vo > Mx
    Vf = Mx;
    fprintf(['Initial condition ',VarName,' too high, updating to %d \n'],Mx)
else
    Vf = Vo;
end

end

