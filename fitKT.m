function [T90,eps,tn,zeta,sigma,fn] = fitKT(t,y,guessEnvelop,guessKT,varargin)
% [T90,eps,tn,zeta,sigma,fn] = fitKT(t,y,fs,guessEnvelop,guessKT,
% varargin) fit the nonstationary Kanai傍ajimi model to ground acceleration
% records. 
% 
% 
% INPUTS 
% 
% y: size: [ 1 x N ] : aceleration record
% t: size: [ 1 x N ] : time vector
% guessEnvelop: [1 x 3 ]: first guess for envelop function
% guessKT: [1 x 3 ]: first guess for Kanai傍ajimi spectrum
% varargin:
%      'F3DB'        - cut off frequency for the low pass filter
%      'TolFun'      - Termination tolerance on the residual sum of squares.
%                      Defaults to 1e-8.
%      'TolX'        - Termination tolerance on the estimated coefficients
%                      BETA.  Defaults to 1e-8.
%      'dataPlot'        - 'yes': shows the results of the fitting process
% 
% OUTPUTS 
% 
% sigma: [1 x 1 ]: Fitted standard deviation of the excitation.
% fn: [1 x 1 ]:  Fitted dominant frequency of the earthquake excitation (Hz).
% zeta: [1 x 1 ]: Fitted bandwidth of the earthquake excitation.
% f: [ 1 x M ]: Fitted frequency vector for the Kanai-tajimi spectrum.
% T90: [1 x 1 ]: Fitted value at 90 percent of the duration.
% eps: [1 x 1 ]: Fitted normalized duration time when ground motion achieves peak.
% tn: [1 x 1 ]: Fitted duration of ground motion.
% 
% 
% EXAMPLE: this requires the function seismSim.m
% 
% f = linspace(0,40,2048);
% zeta = 0.3;
% sigma = 0.3;
% fn =5;
% eta = 0.3;
% eps = 0.4;
% tn = 30;
% [y,t] = seismSim(sigma,fn,zeta,f,eta,eps,tn);
% guessEnvelop=[0.33,0.43,50];
% guessKT = [1,1,5];
% [eta,eps,tn,zeta,sigma,fn] = fitKT(t,y,guessEnvelop,guessKT,...
% 'dataPlot','yes');
% 
% see also seismSim.m
% Author: Etienne Cheynet - modified: 23/04/2016

%% inputParser
p = inputParser();
p.CaseSensitive = false;
p.addOptional('f3DB',0.05);
p.addOptional('tolX',1e-8);
p.addOptional('tolFun',1e-8);
p.addOptional('dataPlot','no');
p.parse(varargin{:});
tolX = p.Results.tolX ;
tolFun = p.Results.tolFun ;
f3DB = p.Results.f3DB ;
dataPlot = p.Results.dataPlot ;
% check number of input
narginchk(4,8)

%% Get envelop parameters
dt = median(diff(t));

h1=fdesign.lowpass('N,F3dB',8,f3DB,1/dt);
d1 = design(h1,'butter');
Y = filtfilt(d1.sosMatrix,d1.ScaleValues, abs(hilbert(y)));
Y = Y./max(abs(Y));

options=optimset('Display','off','TolX',tolX,'TolFun',tolFun);
coeff1 = lsqcurvefit(@(para,t) Envelop(para,t),guessEnvelop,t,Y,[0.01,0.01,0.1],[3,3,100],options);

eps = coeff1(1);
T90 = coeff1(2);
tn = coeff1(3);





%% Get stationnary perameters for the spectrum
E =Envelop(coeff1,t);
x = y./E; % there may be better solution than this one, but I don't have better idea right now.
x(1)=0;

% calculate the PSD
[PSD,freq]=pmtm(x,7/2,numel(t),1/median(diff(t)));%%
coeff2 = lsqcurvefit(@(para,t) KT(para,freq),guessKT,freq,PSD,[0.01,0.01,1],[5,5,100],options);
zeta = coeff2(1);
sigma = coeff2(2);
fn = coeff2(3);



%% dataPLot (optional)
if strcmpi(dataPlot,'yes'),
    spectra = KT(coeff2,freq);
    
    figure
    subplot(211)
    plot(t,y./max(abs(y)),'k',t,Envelop(coeff1,t),'b',t,Y,'r')
    legend('original data','Fitted envelop','measured envelop')
    title([' T_{90} = ',num2str(coeff1(2),3),'; \epsilon = ',...
        num2str(coeff1(1),3),'; t_{n} = ',num2str(coeff1(3),3)]);
    xlabel('time (s)')
    ylabel('ground acceleration (m/s^2)')
    axis tight
    
    subplot(212)
    plot(freq,PSD,'b',freq,spectra,'r')
    legend('Measured','Fitted envelop')
    legend('original data','Fitted Kanai-Tajimi spectrum')
    title([' \zeta = ',num2str(coeff2(1),3),';  \sigma = ',...
        num2str(coeff2(2),3),';  f_{n} = ',num2str(coeff2(3),3)]);
    xlabel('freq (Hz)')
    ylabel('Acceleration spectrum (m^2/s)')
    axis tight
    set(gcf,'color','w')
end

% 
%% NESTED FUNCTIONS
% 

    function E = Envelop(para,t)
        eps0 = para(1);
        eta0 = para(2);
        tn0 = para(3);
        b = -eps0.*log(eta0)./(1+eps0.*(log(eta0)-1));
        c = b./eps0;
        a = (exp(1)./eps0).^b;
        E = a.*(t./tn0).^b.*exp(-c.*t./tn0);
    end
    function S = KT(para,freq)
        zeta0 = para(1);
        sigma0 = para(2);
        omega0 = 2*pi.*para(3);
        w =2*pi*freq; 
        s0 = 2*zeta0*sigma0.^2./(pi.*omega0.*(4*zeta0.^2+1));
        A = omega0.^4+(2*zeta0*omega0*w).^2;
        B = (omega0.^2-w.^2).^2+(2*zeta0*omega0.*w).^2;
        S = s0.*A./B; % single sided PSD
    end
end

