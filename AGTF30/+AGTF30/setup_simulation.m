function MWS = setup_simulation(varargin)
% void setup_simulation()
% MWS = setup_simulation(Input_structure)
% This function defines all inputs for the AGTF30 engine simulation

% *************************************************************************
% written by Jeffryes Chapman based on work by Ryan May, Jeff Csank, and
% Dean Fredrick
% NASA Glenn Research Center, Cleveland, OH
% Aug 15th, 2016
%
% *************************************************************************

MWS.engName = 'AGTF30';

if(nargin == 0)  % if engName argument is not passed into setup_everything
    inputs = []; % pull inputs from inputs scripted in define inputs
    inputs.LoadBus = 1; % Set to load bus objects.
elseif(nargin == 1)
    inputs = varargin{1};
end

MWS.top_level = pwd;
addpath(MWS.top_level);
MWS.POp = filesep;


%------ run various setup files to get tables & constants ---------
% change directory to SimSetup
cd([MWS.top_level,MWS.POp,'SimSetup']);

MWS = setup_Controller(MWS);   % develops inputs for engine controller
MWS = setup_AllEng(MWS);	   % develops inputs for engine simulation

%load bus objects
if ~isfield(inputs,'LoadBus')
    evalin('base','load(''Eng_Bus.mat'')');
elseif inputs.LoadBus == 1
    evalin('base','load(''Eng_Bus.mat'')');
end

%return to base 
cd([MWS.top_level]);

% gather inputs
MWS = define_inputs(MWS,inputs); % develops simulation inputs

%send inputs to the workspace
if(nargout == 0)
    assignin('base','MWS',MWS);
end

% loading complete
disp('** AGTF30 ready to execute **')