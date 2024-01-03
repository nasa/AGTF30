function [TrqCoeff,JEff] = PGBimpact(rS,rR,nP,mP,JS,JR,JC,JP)

%PGBimpact Summary 
%   This function computs the Torq Coefficients and Effective Inertias of
%   each gearbox component. 

% Inputs:
%   rS: sun gear radius
%   rR: ring gear radius
%   nP: number of planets
%   mP: mass of planet
%   JS: inertia on sun gear
%   JR: inertia on ring gear
%   JC: inertia on carrier
%   JP: inertia on planet gear

% -- Planet Radius
rP = 0.5*(rR-rS);
% -- Tier 1 Simplifiers
lam = 1/(mP*(rS+rP));
zeta = (1/JC)*nP*(rS+rP);
theta = rP^2/JP + nP*rS^2/JS;
xi = rP^2/JP + nP*rR^2/JR;
% -- Tier 2 Simplifiers
phi = -theta - rP^2/JP;
% -- Tier 3 Simplifiers
sig = (1/phi)*(rS*zeta + theta*(1+zeta/lam));
eta = (1/phi)*(1/JC)*(rS+theta/lam);
alpha = -(rS/JS)*(1/phi)*(rP^2/JP+xi);
nu = (rP/JP)*(-(1/phi)*(rP^2/JP)+(-xi/phi-1));
% -- Tier 4 Simplifiers
gam = -(rP^2/JP)*(sig+(1+zeta/lam)) - sig*xi + rR*zeta;
kappa = sig + (1+zeta/lam);
beta = (rP^2/JP)*(eta+(1/lam)*(1/JC)) + eta*xi - rR/JC;
% -- Effective Torque Coefficients
TrqCoeff.CTrqSR = -(nP*rS*(kappa/gam)*rR/JR)/(1-nP*rS*(kappa*alpha/gam-(1/phi)*rS/JS)); % Ring impact on Sun
TrqCoeff.CTrqSC = -(nP*rS*(kappa*beta/gam+eta+(1/lam)*(1/JC)))/(1-nP*rS*(kappa*alpha/gam-(1/phi)*rS/JS)); % Carrier impact on Sun
TrqCoeff.CTrqSP = -(nP*rS*(kappa*nu/gam-(1/phi)*(rP/JP)))/(1-nP*rS*(kappa*alpha/gam-(1/phi)*rS/JS)); % Planet impact on Sun
TrqCoeff.CTrqRS = (nP*rR*(sig*alpha/gam-(1/phi)*rS/JS))/(1+nP*(sig/gam)*(rR^2/JR)); % Sun impact on Ring
TrqCoeff.CTrqRC = (nP*rR*(sig*beta/gam+eta))/(1+nP*(sig/gam)*(rR^2/JR)); % Carrier impact on Ring
TrqCoeff.CTrqRP = (nP*rR*(sig*nu/gam-(1/phi)*(rP/JP)))/(1+nP*(sig/gam)*(rR^2/JR)); % Planet impact of Ring
TrqCoeff.CTrqCS = (nP*(rS+rP)*alpha)/(gam+nP*(rS+rP)*beta); % Sun impact on Carrier
TrqCoeff.CTrqCR = (nP*(rS+rP)*(rR/JR))/(gam+nP*(rS+rP)*beta); % Ring impact on Carrier
TrqCoeff.CTrqCP = (nP*(rS+rP)*nu)/(gam+nP*(rS+rP)*beta); % Planet impact on Carrier
% -- Effective Spool Inertias
JEff.Sun = JS/(1-nP*rS*(kappa*alpha/gam-(1/phi)*rS/JS));
JEff.Ring = JR/(1+nP*(sig/gam)*(rR^2/JR));
JEff.Carrier = JC/(1+nP*(rS+rP)*beta/gam);

end