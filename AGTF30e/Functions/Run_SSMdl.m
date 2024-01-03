function [MWS,OutSS,VBVopt,VAFNopt,limit_Prim,limit_VBV,limit_VAFN,Err] = Run_SSMdl(MWS)

% Run_SSMdl.m
%   Written By: Jonathan Kratz (NASA-GRC)
%   Date: 5/22/2023
%   Description: This function runs the steady-state model of the AGTF30 with
%       power extraction or injection. The workspace must be setup prior to
%       running this function.

% initialize results
OutSS = [];
VBVopt = MWS.Init.Solver.SS.VBVOpt;
VAFNopt = MWS.Init.Solver.SS.VAFNOpt;
limit_Prim = 0;
limit_VBV = 0;
limit_VAFN = 0;
Err = 0;

iter_Max = 20; %max iterations in sims to check actuator limits and operation

try
    % run simulation
    simData = sim('AGTF30SysSS_PExPIn.slx');
    OutSS = simData.Out_SS;
    if OutSS.converged.Data(end) == 1 %converged
        % check for actuator constraints
        [MWS,OutSS,VBVopt,VAFNopt,limit_VBV,limit_VAFN,Err_act] = Run_SSMdl_ActCheck(MWS,OutSS,iter_Max);
        if Err_act == 0 % no error encountered with actuator check
            % check for limit violations
            if sum(OutSS.LV_Prim.Data(end,:)) > 0 || (sum(OutSS.LV_Prim.Data(end,:)) == 0 && MWS.Init.Solver.Targets.Opt > 4)% at least 1 limit violation exists
                % Save OutSS incase the limit violation search fails
                OutSS_backup = OutSS;
                VBVopt_backup = VBVopt;
                VAFNopt_backup = VAFNopt;
                limit_VBV_backup = limit_VBV;
                limit_VAFN_backup = limit_VAFN;
                T4_backup = OutSS.S4.Tt.Data(end);
                % identify all limiter that were violated
                if MWS.Init.Solver.Targets.Opt > 4
                    ind_LV = MWS.Init.Solver.Targets.Opt-4;
                else
                    ind_LV = [];
                end
                for k = 1:length(OutSS.LV_Prim.Data(end,:))
                    if OutSS.LV_Prim.Data(end,k) == 1
                        ind_LV = [ind_LV k];
                    end
                end
                limit_Prim_backup = ind_LV(1);
                % identify the most limiting violation
                for k = 1:length(ind_LV)
                    % update limit driver
                    MWS.Init.Solver.Targets.Opt = 4 + ind_LV(k);
                    assignin('base','MWS',MWS)
                     % run simulation
                    simData = sim('AGTF30SysSS_PExPIn.slx');
                    OutSS = simData.Out_SS;
                    if OutSS.converged.Data(end) == 1 %converged
                        % check for actuator constraints
                        [MWS,OutSS,VBVopt,VAFNopt,limit_VBV,limit_VAFN,Err_act] = Run_SSMdl_ActCheck(MWS,OutSS,iter_Max);
                        if Err_act == 0  % no error encountered with actuator check
                            OutSS_backup = OutSS;
                            VBVopt_backup = VBVopt;
                            VAFNopt_backup = VAFNopt;
                            limit_VBV_backup = limit_VBV;
                            limit_VAFN_backup = limit_VAFN;
                            limit_Prim_backup = ind_LV(k);
                            T4_backup = OutSS.S4.Tt.Data(end);
                            if sum(OutSS.LV_Prim.Data(end,:)) == 0
                                limit_Prim = MWS.Init.Solver.Targets.Opt - 4;
                                Err = 0;
                                break;
                            end
                        else
                            OutSS = OutSS_backup;
                            VBVopt = VBVopt_backup;
                            VAFNopt = VAFNopt_backup;
                            limit_Prim = limit_Prim_backup;
                            limit_VBV = limit_VBV_backup;
                            limit_VAFN = limit_VAFN_backup;
                            message = ['Run_SSMdl.m: Error (-4) - an error with the actuator limit check was encountered while searching for the primary limit violation (Run_SSMdl_ActCheck.m Error Code = ',num2str(Err_act),'). Converged data is assigned but limits could be violated.'];
                            Err = -4;
                        end
                    else %did not converge
                        % switch to T4 solver mode and reduce the target
                        % until no limits are hit
                        psuedoLimit = 0;
                        for m = 1:10
                            MWS.Init.Solver.Targets.Opt = 2;
                            MWS.Init.Solver.Targets.T4 = T4_backup - 10*m;
                            assignin('base','MWS',MWS)
                            simData = sim('AGTF30SysSS_PExPIn.slx');
                            OutSS = simData.Out_SS;
                            if OutSS.converged.Data(end) == 1 %converged
                                % check for actuator constraints
                                [MWS,OutSS,VBVopt,VAFNopt,limit_VBV,limit_VAFN,Err_act] = Run_SSMdl_ActCheck(MWS,OutSS,iter_Max);
                                if Err_act == 0 % no error encountered with actuator check
                                    OutSS_backup = OutSS;
                                    VBVopt_backup = VBVopt;
                                    VAFNopt_backup = VAFNopt;
                                    limit_VBV_backup = limit_VBV;
                                    limit_VAFN_backup = limit_VAFN;
                                    T4_backup = OutSS.S4.Tt.Data(end);
                                    if sum(OutSS.LV_Prim.Data(end,:)) == 0
                                        psuedoLimit = 1;
                                        break;
                                    end
                                end
                            end
                        end
                        OutSS = OutSS_backup;
                        VBVopt = VBVopt_backup;
                        VAFNopt = VAFNopt_backup;
                        limit_Prim = limit_Prim_backup;
                        limit_VBV = limit_VBV_backup;
                        limit_VAFN = limit_VAFN_backup;
                        if psuedoLimit == 0
                            message = ['Run_SSMdl.m: Error (-3) - the simulation was not able to converge while searching for a limiting conditions (Limit_Prim = ',num2str(MWS.Init.Solver.Targets.Opt-4),' Limit_VBV = ',num2str(MWS.Init.Solver.SS.VBVOpt),' Limit_VAFN = ',num2str(MWS.Init.Solver.SS.VAFNOpt),'). Converged data is assigned but limits could be violated.'];
                            Err = -3;
                        else
                            message = ['Run_SSMdl.m: Warning (1) -  a limit was not perfectly found and a psuedo limit is being used in its place'];
                            Err = 1;
                        end
                    end
                end
            else % no limits hit
                VBVopt = MWS.Init.Solver.SS.VBVOpt;
                VAFNopt = MWS.Init.Solver.SS.VAFNOpt;
                limit_Prim = 0;
                if MWS.Init.Solver.SS.VBVOpt == 1 % drive to LPC SM limit
                    limit_VBV = 1;
                elseif MWS.Init.Solver.SS.VBVOpt == 2 % drive to min VBV limit
                    limit_VBV = 0;
                elseif MWS.Init.Solver.SS.VBVOpt == 3 % drive to max VBV limit
                    limit_VBV = 2;
                end
                if MWS.Init.Solver.SS.VAFNOpt == 1 % drive to LPC SM limit
                    limit_VAFN = 0;
                elseif MWS.Init.Solver.SS.VAFNOpt == 2 % drive to min VAFN limit
                    limit_VAFN = 1;
                elseif MWS.Init.Solver.SS.VAFNOpt == 3 % drive to max VAFN limit
                    limit_VAFN = 2;
                end    
            end
        else % an error was encountered with the actuator check
            message = ['Run_SSMdl.m: Error (-2) - an error with the actuator limit check was encountered without a primary limit violation (Run_SSMdl_ActCheck.m Error Code = ',num2str(Err_act),')'];
            Err = -2;
        end
    else % did not converge
        message = 'Run_SSMdl.m: Error (-1) - the original simulation did not converge';
        Err = -1;
    end
catch
    message = 'Run_SSMdl.m: Error (-5) - the simulation failed for unidentified reasons';
    Err = -5;
end

% display error message if applicable
if exist('message','var')
    disp(message)
end