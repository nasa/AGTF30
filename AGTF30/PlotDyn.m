% plot using the TMATS TD plot function
TMATS.TDplot('AGTF30SysDyn')

% ---------------------------------------------------------------
% plot remaining itemts that do not appear with the TDplot command

% save figure settings
Temp.set_old = get(0,'DefaultFigureWindowStyle');
% set figure to place new figures into the same window
set(0,'DefaultFigureWindowStyle','docked');

% plot additional engine items,  thrust and control inputs
Temp.f = figure;
set(Temp.f,'name','Cntrl,Thrst','numbertitle','off');
subplot(4,1,1)
plot(out_Dyn.eng.Perf.Fnet)
ylabel('Fnet, lbf')
subplot(4,1,2)
plot(out_Dyn.cntrl.Wfdmd)
ylabel('Wf, pps')
subplot(4,1,3)
plot(out_Dyn.cntrl.VBVdmd)
ylabel('VBV')
subplot(4,1,4)
plot(out_Dyn.cntrl.VAFNdmd)
ylabel('VAFN, in2')

% plot stall margins
Temp.f = figure;
set(Temp.f,'name','SrgMrgn','numbertitle','off');
subplot(3,1,1)
plot(out_Dyn.eng.SM.SMFan)
ylabel('SM, %')
subplot(3,1,2)
plot(out_Dyn.eng.SM.SMLPC)
ylabel('SM, %')
subplot(3,1,3)
plot(out_Dyn.eng.SM.SMHPC)
ylabel('SM, %')

%return settings
set(0,'DefaultFigureWindowStyle',Temp.set_old);

clear Temp