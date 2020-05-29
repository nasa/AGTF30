% To create all buses for the model call.
% 1) Enter AGTF30_eng.slx (make sure to create the MWS variable first with
% setup_everything.
% 2) remove bus outport from model (Sys_Out in top level of AGTF30_eng.slx)
% 3) select bus creator you wish to generate the bus objects for (marked as
% BusCreatorHere in AGTF30_eng.slx -> AGT30F_eng/Engine/EngData)
% 4) run the command below
% 5) put outport back into model
% 6) go into model to the bus editor.  Here there will be all the bus
% objects... export the bus objects to a .mat file. Overwrite the current
% mat file located in the SimSetup folder (Eng_Bus.mat).
%------------------------------------------------------------------------
% Automated Version
clear all
cd ..
% Generate MWS variable so system can be run, use the known cruise IC so the
% simulation does not run the SS solver to determine ICs (this is bad 
% because the bus files may not work).
Input.ICPoint = 'cruise';
run('setup_everything.m');
% separate MWS variable from bus objects.
save('MWS.mat','MWS');
% clear bus variables
clear all;
% Load MWS variable back into system
load('MWS.mat');

% Remove Eng_Out outport from AGTF30_eng, for some reason the auto bus
% creation script doesn't work with this block here. Then create bus
% objects and close system w/o saving.
% open system
open_system('AGTF30_eng');
try
    % delete the outport file that uses the buses... auto bus generator
    % doesn't like it.
    Temp.OffendingBlockString=['AGTF30_eng','/','Eng_Out'];
    delete_block(Temp.OffendingBlockString);
    
    % Create bus files based on final mux location within the file.
    Temp.MuxBlockString = ['AGTF30_eng','/','Engine','/','EngData','/','BusCreatorHere'];
    Simulink.Bus.createObject('AGTF30_eng', Temp.MuxBlockString,'AGTF30_Bus');
catch
    % something went wrong
    disp('bus objects not created')
end
% close w/o saving
bdclose('AGTF30_eng');

% Adjust file format to meet current AGTF30 format. A .m was created AGTF30
% needs a .mat file.
% remove all workspace vars
clear all
if exist('AGTF30_Bus.m', 'file') == 2
    % create bus files
    run('AGTF30_Bus.m');
    % save the buf files as a .mat
    save('Eng_Bus.mat','-regexp','^(?!(ans)$).');
    % clean up files MWS and Buf file
    delete('AGTF30_Bus.m');
    if exist('MWS.mat', 'file') == 2
        delete('MWS.mat');
    end
    % move file to proper destination
    Temp.Dest = fullfile(pwd,'SimSetup');
    movefile('Eng_Bus.mat',Temp.Dest);
end
cd SimSetup
clear all;
disp('Bus generation complete, run AGTF30 setup as normal to begin')




