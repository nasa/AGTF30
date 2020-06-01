function MWS = define_inputs(MWS,inputs)
%		 define_inputs.m
% *************************************************************************
% written by Jeff Chapman
% NASA Glenn Research Center, Cleveland, OH
% Aug 15th, 2016
%
% This file contains the user defined inputs for AGTF30 simulation
% *************************************************************************

MWS.In.Ts = 0.015;
%% If UseExel is set to 1, set input vector to coincide with data
% within "define_inputs.slx", note if any other inputs are being set by
% inputing to define_inputs.m, they will not be changed. Note: using Excel inputs
% will greatly increase the run time of this script. When running this
% script many times it is recommended to turn this feature off.
if isfield(inputs,'UseExcel')
    if inputs.UseExcel == 1
        inputs = AGTF30.InputsFromXLSX('define_inputs.xlsx', inputs);
        fprintf('Inputs gathered from define_inputs.xlsx\n')
    else
        inputs.UseExcel = 0;
    end
end

cd([MWS.top_level,MWS.POp,'SimSetup'])
%% Set default time vector name
DefTVNm = 't';
% Set default time vector values
MWS = SetInput(MWS,DefTVNm, [0 10 300 600],inputs);

%% Environmental Inputs (t , Alt, MN, dT, PLA)
% altitude (0 to 40,000 ft)
MWS = SetTVec(MWS, 'Alt',0,DefTVNm,inputs);                                 
 % Mach Number (0 to 0.8)
MWS = SetTVec(MWS, 'MN',0,DefTVNm,inputs);                                 
% Delta Temperature (-30 to +50)
MWS = SetTVec(MWS, 'dT',0,DefTVNm,inputs);                                  
% PLA or Power Code (40 to 80.5), not used if N1ManEn == 1 or WfManEn == 1
MWS = SetTVec(MWS, 'PLA',[40 40 80 80],DefTVNm,inputs); 

%% Corrected N1 manual request ( N1creq, N1ManEn)
% Corrected N1 request (rpm)
MWS = SetTVec(MWS, 'N1creq',6079,DefTVNm,inputs);
% Enable N1 cntrl (1 enabled, 0 disabled)
MWS = SetInput(MWS,'N1ManEn', 0,inputs);     

%% Wf manual request (Wf, WfManEn)
% Wf request (pps)
MWS = SetTVec(MWS, 'Wfreq',0.78110,DefTVNm,inputs);     
% Enable Wf cntrl (1 enabled, 0 disabled), this will over ride manual N1 cntrl
MWS = SetInput(MWS,'WfManEn', 0,inputs); 

%% VBV manual request (VBVreq, VBVManEn)
% VBV request (closed(1) - open(2))
MWS = SetTVec(MWS, 'VBVreq',1,DefTVNm,inputs);
% Enable VBV cntrl (1 enabled, 0 disabled)
MWS = SetInput(MWS,'VBVManEn', 0,inputs); 

%% VAFN manual request (VAFNreq, VAFNManEn)
% bypass nozzle area (in2)
MWS = SetTVec(MWS, 'VAFNreq',6314,DefTVNm, inputs);  
% Enable VAFN cntrl (1 enabled, 0 disabled)
MWS = SetInput(MWS,'VAFNManEn', 0,inputs); 

%% Generate Values for Initial Conditions or Steady State simulation.
% by default this script will generate ICs/SS position based on first point
% of test vector above.
MWS = SetInput(MWS,'ICPoint', 'cruise',inputs);
MWS = setup_InputsSS(MWS);

%% end
cd(MWS.top_level)
end

function MWS = SetInput(MWS,name,Value, inputs)
% Set to default if inputs does not contain value
if isfield(inputs,name)
    Value = inputs.(name);
end

MWS.In.(name) = Value;
end

function MWS = SetTVec(MWS, name, Values , tname, inputs)
% Ensure all data is properly formatted
% If Values input is a single number, value will be expanded to the size of
% the defined default time vector MWS.In.t
% If Values is a single row the time vector will then be added to the
% second row of the matrix.
% MWS    - Engine Input structure
% name   - name of engine input, Will be set to MWS.In.name
% Values - values to be set to name
% tname  - time vector associated with name, must already be located at
%         MWS.In.tname
% InVec  - inputs vector, these will overwrite the input if they exist.
%
% example usage:
% if t = [0 10 20]
% Values = 1
% return: MWS.In.Name = [1 1 1; 0 10 20]
% Values = [1 2 3]
% return: MWS.In.Name = [1 2 3; 0 10 20]
% Values = [1 2 3;0 100 200]
% return: MWS.In.Name = [1 2 3;0 100 200]

% If the input vector is defined use it instead of the value defined in
% Values
if isfield(inputs,name)
    Values = inputs.(name);
end

% format Values
if size(Values,1) == 1 && size(Values,2) == 1   % if only 1 element, then assume that value is valid for all time steps
    MWS.In.(name) = Values *ones(1,length(MWS.In.(tname))); %create a vector of appropriate length with the specified value at every element
    MWS.In.(name)(2,:) = MWS.In.(tname);
elseif size(Values,2) == length(MWS.In.(tname)) && size(Values,1) == 1 % number of entries is the same as time, but there is no specific time associated with it.
    MWS.In.(name)(1,:) = Values;
    MWS.In.(name)(2,:) = MWS.In.(tname);
elseif size(Values,2) > 1 && size(Values,1) == 2 %Use defined parameter and time vector
    MWS.In.(name) = Values;
else
    fprintf('Error writing inputs, check MWS.In for size of input vectors to match appropriate time vectors')
    
end
end