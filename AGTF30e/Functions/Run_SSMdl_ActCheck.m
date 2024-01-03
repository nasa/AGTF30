function [MWS,OutSS,VBVopt,VAFNopt,limit_VBV,limit_VAFN,Err] = Run_SSMdl_ActCheck(MWS,OutSS,iter_Max)

% Run_SSMdl.m
%   Written By: Jonathan Kratz (NASA-GRC)
%   Date: 5/22/2023
%   Description: This function runs the steady-state model of the AGTF30 with
%       power extraction or injection. It is called within the "Run_SSMdl.m
%       function to check if the VBV and VAFN limits have been hit and will
%       switch solver settings to satisfy the constraints. The model must
%       be ran prior to produce the MWS and OutSS inputs. This function
%       could iterate on the model with different solver settings.

% VBV options
% 1 - drive to min LPCSM limit
%   switch to when: (1) VBV is driven with 2 or 3 and LPCSM limit is violated
% 2 - VBV min
%   switch to when: (1) VBV is driven with 1 and LPCSM is not violated
%                   (2) VBV is driven with 1 and VBV Min is violated
% 3 - VBV max
%   switch to when: (1) VBV is driven with 1 and VBV Max is violated 
% VAFN options
% 1 - drive to Fan Opline
%   switch to when: (1) VAFN is driven with 2 or 3 and Fan Opline is not
%                       violated
% 2 - VAFN min
%   switch to when: (1) VAFN is driven with 1 and VAFN Min is violated
% 3 - VAFN max
%   switch to when: (1) VAFN is driven with 1 and VAFN Max is violated
% Combinations & conditions to switch (VBV, VAFN):
%   1: 1, 1 (drive to LPCSM limit, drive to Fan Opline)
%   2: 1, 2 (drive to LPCSM limit, drive to VAFN min)
%   3: 1, 3 (drive to LPCSM limit, drive to VAFN max)
%   4: 2, 1 (drive to VBV min, drive to Fan Opline)
%   5: 2, 2 (drive to VBV min, drive to VAFN min)
%   6: 2, 3 (drive to VBV min, drive to VAFN max)
%   7: 3, 1 (drive to VBV max, drive to Fan Opline)
%   8: 3, 2 (drive to VBV max, drive to VAFN min)
%   9: 3, 3 (drive to VBV max, drive to VAFN max)

% initialize results
VBVopt = MWS.Init.Solver.SS.VBVOpt;
VAFNopt = MWS.Init.Solver.SS.VAFNOpt;
limit_VBV = 0; %0-No limit, 1-LPCSM Min limit, 2-VBV Max
limit_VAFN = 0; %0-No limit, 1-VAFN Min, 2-VAFN Max
Err = 0;

% initialize iteration counter
iter = 1;

try
    % check for convergence
    if OutSS.converged.Data(end) == 1 %original simulation converged
        % check for violations in actuator limits or intended operation
        if (MWS.Init.Solver.SS.VBVOpt == 2 || MWS.Init.Solver.SS.VBVOpt == 3) && OutSS.SM.SMLPC.Data(end) < MWS.Init.Solver.SS.VBVOpt_LPCSMtarget
            MWS.Init.Solver.SS.VBVOpt = 1; % drive to LPC SM limit
            check_vbv = 0;
            limit_VBV = 1;
        elseif MWS.Init.Solver.SS.VBVOpt == 1 && (OutSS.VBV.Data(end) < MWS.Init.Solver.Limits.VBV_Min+5e-5)
            MWS.Init.Solver.SS.VBVOpt = 2; % drive to min VBV limit
            check_vbv = 0;
            limit_VBV = 0;
        elseif MWS.Init.Solver.SS.VBVOpt == 1 && OutSS.VBV.Data(end) > MWS.Init.Solver.Limits.VBV_Max
            MWS.Init.Solver.SS.VBVOpt = 3; % drive to max VBV limit
            check_vbv = 0;
            limit_VBV = 2;
        else
            check_vbv = 1;
        end
        FanNcMap = OutSS.Data.FAN_Data.NcMap.Data(end);
        FanRL = OutSS.independents.Data(end,4);
        FanOPline_RL = interp1(MWS.Init.Solver.SS.VAFNOpt_NcVec,MWS.Init.Solver.SS.VAFNOpt_RLVec,FanNcMap,'linear');
        if (MWS.Init.Solver.SS.VAFNOpt == 2 && FanRL < FanOPline_RL) || (MWS.Init.Solver.SS.VAFNOpt == 3 && FanRL > FanOPline_RL)
            MWS.Init.Solver.SS.VAFNOpt = 1; % drive to LPC SM limit
            check_vafn = 0;
            limit_VAFN = 0;
        elseif MWS.Init.Solver.SS.VAFNOpt == 1 && (OutSS.VAFN.Data(end) < MWS.Init.Solver.Limits.VAFN_Min)
            MWS.Init.Solver.SS.VAFNOpt = 2; % drive to min VAFN limit
            check_vafn = 0;
            limit_VAFN = 1;
        elseif MWS.Init.Solver.SS.VAFNOpt == 1 && (OutSS.VAFN.Data(end) > MWS.Init.Solver.Limits.VAFN_Max)
            MWS.Init.Solver.SS.VAFNOpt = 3; % drive to max VAFN limit
            check_vafn = 0;
            limit_VAFN = 2;
        else
            check_vafn = 1;
        end
        while (check_vbv == 0 || check_vafn == 0) && iter < iter_Max
            % re-run the model
            assignin('base','MWS',MWS)
            simData = sim('AGTF30SysSS_PExPIn.slx');
            OutSS = simData.Out_SS;
            VBVopt = MWS.Init.Solver.SS.VBVOpt;
            VAFNopt = MWS.Init.Solver.SS.VAFNOpt;
            if OutSS.converged.Data(end) == 1 %converged
                % check for violations in actuator limits or intended operation
                if (MWS.Init.Solver.SS.VBVOpt == 2 || MWS.Init.Solver.SS.VBVOpt == 3) && OutSS.SM.SMLPC.Data(end) < MWS.Init.Solver.SS.VBVOpt_LPCSMtarget
                    MWS.Init.Solver.SS.VBVOpt = 1; % drive to LPC SM limit
                    check_vbv = 0;
                    limit_VBV = 1;
                elseif MWS.Init.Solver.SS.VBVOpt == 1 && (OutSS.VBV.Data(end) < MWS.Init.Solver.Limits.VBV_Min+5e-5)
                    MWS.Init.Solver.SS.VBVOpt = 2; % drive to min VBV limit
                    check_vbv = 0;
                    limit_VBV = 0;
                elseif MWS.Init.Solver.SS.VBVOpt == 1 && OutSS.VBV.Data(end) > MWS.Init.Solver.Limits.VBV_Max
                    MWS.Init.Solver.SS.VBVOpt = 3; % drive to max VBV limit
                    check_vbv = 0;
                    limit_VBV = 2;
                else
                    check_vbv = 1;
                end
                FanNcMap = OutSS.Data.FAN_Data.NcMap.Data(end);
                FanRL = OutSS.independents.Data(end,4);
                FanOPline_RL = interp1(MWS.Init.Solver.SS.VAFNOpt_NcVec,MWS.Init.Solver.SS.VAFNOpt_RLVec,FanNcMap,'linear');
                if (MWS.Init.Solver.SS.VAFNOpt == 2 && FanRL < FanOPline_RL) || (MWS.Init.Solver.SS.VAFNOpt == 3 && FanRL > FanOPline_RL)
                    MWS.Init.Solver.SS.VAFNOpt = 1; % drive to Fan Op-Line
                    check_vafn = 0;
                    limit_VAFN = 0;
                elseif MWS.Init.Solver.SS.VAFNOpt == 1 && (OutSS.VAFN.Data(end) < MWS.Init.Solver.Limits.VAFN_Min)
                    MWS.Init.Solver.SS.VAFNOpt = 2; % drive to min VAFN limit
                    check_vafn = 0;
                    limit_VAFN = 1;
                elseif MWS.Init.Solver.SS.VAFNOpt == 1 && (OutSS.VAFN.Data(end) > MWS.Init.Solver.Limits.VAFN_Max)
                    MWS.Init.Solver.SS.VAFNOpt = 3; % drive to max VAFN limit
                    check_vafn = 0;
                    limit_VAFN = 2;
                else
                    check_vafn = 1;
                end
            else %did not converge
                message = 'Run_SSMdl_ActCheck.m: Error (Err = -2) - did not converge while searching for a solution that satisifies all conditions';
                Err = -2;
                break
            end
            % update iteration count
            iter = iter + 1;
        end
        % collect results
        if iter >= iter_Max
            message = 'Run_SSMdl_ActCheck.m: Warning (Err = -3) - Max iterations hit prior to satisfying all conditions';
            Err = -3;
        end
    else %original simulation did not converge
        message = 'Run_SSMdl_ActCheck.m: Error (Err = -1) - the original simulation did not converge';
    end
catch
    message = 'Run_SSMdl_ActCheck.m: Error (Err = -4) - the simulation failed for unidentified reasons';
end

% display message if applicable
if exist('message','var')
    disp(message)
end