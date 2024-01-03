%		T-MATS -- TMATS_Run_Example.m
% *************************************************************************
% Example_setup_everything.m
% *************************************************************************
% written by Jeffryes Chapman
% NASA Glenn Research Center, Cleveland, OH
% Feb 14th, 2012
%
% This file calls the setup_everything file from the specified example then opens the template model.
% *************************************************************************

% Select which Example setup should be run
TMATS.POp = filesep;
TMATS.P = pwd;
InpMsg{1} = 'Select the enumeration of the T-MATS Example to be setup:';
InpMsg{2} = '1) NewtonRaphson_Equation_Solver';
InpMsg{3} = '2) Steady State GasTurbine';
InpMsg{4} = '3) Dynamic GasTurbine';
InpMsg{5} = '4) Steady State Dual Spool High Bypass Engine JT9D';
InpMsg{6} = '5) Dynamic Dual Spool High Bypass Engine JT9D';
InpMsg{7} = '6) Steady State JT9D, Cantera';
InpMsg{8} = '7) Cycle Model';
InpMsg{9} = '8) Linearization Examples';
InpMsg{10} = '9) Volume Example';
InpMsg{11} = '10) Cancel Setup';
InpMsgFinal = '';

for i = 1: length(InpMsg)
    InpMsgFinal = strcat(InpMsgFinal,InpMsg{i},'\n');
end

%Messages for Cycle Model Selection
InpMsg2{1} = 'Select Cycle Model';
InpMsg2{2} = '1) Brayton Cycle';
InpMsg2{3} = '2) Cancel';
InpMsgFinal2 = '';

for i = 1: length(InpMsg2)
    InpMsgFinal2 = strcat(InpMsgFinal2,InpMsg2{i},'\n');
end

%Messages for Cycle Model Selection
InpMsg3{1} = 'Select Linearization Example';
InpMsg3{2} = '1) Known State Space';
InpMsg3{3} = '2) JT9D single point Linearization';
InpMsg3{4} = '3) JT9D Piece Wise Linearization';
InpMsg3{5} = '4) Cancel';
InpMsgFinal3 = '';

for i = 1: length(InpMsg3)
    InpMsgFinal3 = strcat(InpMsgFinal3,InpMsg3{i},'\n');
end



%Start Menu
TMATS.S = input(InpMsgFinal,'s');

switch TMATS.S
    case '1'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_NewtonRaphson_Equation_Solver'))
        cd Example_NewtonRaphson_Equation_Solver
        
        % open template
        open_system('NewtonRaphson_Equation_Solver.slx');
        
        % loading complete
        disp('** NewtonRaphson_Equation_Solver example ready to execute **')
        cd ..
    case '2'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_GasTurbine_SS'))
        cd Example_GasTurbine_SS
        %------ Performs example setup ---------
        GasTurbine_SS_setup_everything;
        cd ..
        
    case '3'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_GasTurbine_Dyn'))
        cd Example_GasTurbine_Dyn
        %------ Performs example setup ---------
        GasTurbine_Dyn_setup_everything;
        cd ..
        
    case '4'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_JT9D_SS'))
        cd Example_JT9D
        %------ Performs example setup ---------
        JT9D_setup_everything_SS;
        cd ..
        
    case '5'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_JT9D_Dyn'))
        cd Example_JT9D
        %------ Performs example setup ---------
        JT9D_setup_everything_Dyn;
        cd ..
        
    case '6'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_JT9D_SS_Cantera'))
        cd Example_JT9D_SS_Cantera
        %------ Performs example setup ---------
        JT9D_SS_Cantera_setup_everything;
        cd ..
        
    case '7'
        
        TMATS.S2 = input(InpMsgFinal2,'s');
        switch TMATS.S2
            case '1'
                disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Cycles'))
                cd Cycles
                open_system('BraytonCycle.slx');
                cd ..
                
            case '2'
                disp('Example Setup Canceled')
            otherwise,
                disp('Selection Invalid')
        end
        
    case '8'
        
        TMATS.S3 = input(InpMsgFinal3,'s');
        switch TMATS.S3
            case '1'
                disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_Linearization'))
                cd Example_Linearization
                open_system('LinStSpace.slx');
                cd ..
            case '2'
                disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_JT9D'))
                cd Example_JT9D
                open_system('JT9D_Model_Lin.slx');
                cd ..
            case '3'
                disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_JT9D'))
                cd Example_JT9D
                open_system('JT9D_Model_PWLin.slx');
                cd ..
                
            case '4'
                disp('Example Setup Canceled')
            otherwise,
                disp('Selection Invalid')
        end
        
    case '9'
        disp(strcat('Loading Simulation from: ', TMATS.P ,TMATS.POp,'Example_Volumes'))
        cd Example_Volumes
        load('Properties.mat')
        open_system('Dyn_Vol_Line.slx');
        cd ..
        
    case '10'
        disp('Example Setup Canceled');
    otherwise,
        disp('Selection Invalid')
end

clear TMATS;

