function [y,t] = seismSim(sigma,fn,zeta,f,T90,eps,tn)
% [y,t] = seismSim(sigma,fn,zeta,f,T90,eps,tn) generate one time series
%  corresponding to acceleration record from a seismometer. 
% The function requires 7 inputs, and gives 2 outputs. The time series is 
% generated in two steps: First, a stationary process is created based on 
% the Kanai-Tajimi spectrum, then an envelope function is used to transform
% this stationary time series into a non-stationary record. For more 
% information, see [1-3].
% 
% References
% 
%  [1] Lin, Y. K., & Yong, Y. (1987). Evolutionary Kanai-Tajimi earthquake models. Journal of engineering mechanics, 113(8), 1119-1137.
%  [2] Rofooei, F. R., Mobarake, A., & Ahmadi, G. (2001). 
%  Generation of artificial earthquake records with a nonstationary 
%  Kanai-Tajimi model. Engineering Structures, 23(7), 827-837.
%  [3] Guo, Y., & Kareem, A. (2016). 
%  System identification through nonstationary data using Time-requency Blind
%  Source Separation. Journal of Sound and Vibration, 371, 110-131.
% 
%  
% INPUTS 
% 
% sigma: [1 x 1 ]: standard deviation of the excitation.
% fn: [1 x 1 ]: dominant frequency of the earthquake excitation (Hz).
% zeta: [1 x 1 ]:  bandwidth of the earthquake excitation.
% f: [ 1 x M ]: frequency vector for the Kanai-tajimi spectrum.
% T90: [1 x 1 ]: value at 90 percent of the duration.
% eps: [1 x 1 ]: normalized duration time when ground motion achieves peak.
% tn: [1 x 1 ]: duration of ground motion.
% 
%  
% OUTPUTS 
% 
% y: size: [ 1 x N ] : Simulated aceleration record
% t: size: [ 1 x N ] : time
% 
%  
% EXAMPLE:
%  
% f = linspace(0,40,2048);
% zeta = 0.3;
% sigma = 0.9;
% fn =5;
% T90 = 0.3;
% eps = 0.4;
% tn = 30;
% [y,t] = seismSim(sigma,fn,zeta,f,T90,eps,tn);
% figure
% plot(t,y);axis tight
% xlabel('time(s)');
% ylabel('ground acceleration (m/s^2)')
% 
% see also fitKT.m
% Author: Etienne Cheynet - modified: 23/04/2016

%% Initialisation
w = 2*pi.*f;
fs = f(end); dt = 1/fs;
f0= median(diff(f));
Nfreq = numel(f);
t = 0:dt:dt*(Nfreq-1);

%% Generation of the spectrum S
fn = fn *2*pi; % transformation in rad;
s0 = 2*zeta*sigma.^2./(pi.*fn.*(4*zeta.^2+1));
A = fn.^4+(2*zeta*fn*w).^2;
B = (fn.^2-w.^2).^2+(2*zeta*fn.*w).^2;
S = s0.*A./B; % single sided PSD


%% Time series generation - Monte Carlo simulation
A = sqrt(2.*S.*f0);
B =cos(w'*t + 2*pi.*repmat(rand(Nfreq,1),[1,Nfreq]));
x = A*B; % stationary process

%% Envelop function E
b = -eps.*log(T90)./(1+eps.*(log(T90)-1));
c = b./eps;
a = (exp(1)./eps).^b;
E = a.*(t./tn).^b.*exp(-c.*t./tn);

%% Envelop multiplied with stationary process to get y
y = x.*E;

end