function [WT, FreqBins, Scales] = CWT_Morlet(Sig, WinLen, nLevel)

%============================================================%
%  Continuous Wavelet Transform using Morlet function               
%            Sig : �ź�                                          
%    WinLen : С�������ڳ߶Ȳ���a=1ʱ�ĳ���   ��Ĭ��Ϊ 10��                 
%      nLevel : Ƶ���Ữ��������   ��Ĭ��Ϊ1024��      
%
%           WT:  ���ص�С���任������
%  FreqBins :  ����Ƶ���Ữ�ֽ������һ��Ƶ�ʣ����Ƶ��Ϊ0.5��
%       Scales:   ������Ƶ���Ữ��ֵ���Ӧ�ĳ߶Ȼ��� ��Ƶ��0.5��Ӧ�ĳ߶�Ϊ1��
%============================================================%

if (nargin == 0),
     error('At least 1 parameter required');
end;

if (nargin < 4),
     iShow = 1;
elseif (nargin < 3),
     nLevel = 1024;
elseif (nargin < 2),
     WinLen = 10;
end;

Sig = hilbert(real(Sig));                     % �����źŵĽ����ź�
SigLen = length(Sig);                        % ��ȡ�źŵĳ���
fmax = 0.5;                                         % ������߷���Ƶ��
fmin = 0.005;                                      % ������ͷ���Ƶ��
FreqBins = logspace(log10(fmin),log10(0.5),nLevel);    % ��Ƶ�����ڷ�����Χ�ڵȶ������껮��
Scales = fmax*ones(size(FreqBins))./ FreqBins;             % ������Ӧ�ĳ߶Ȳ���
omg0 = WinLen / 6;                            % ��������С�����ȼ�����Ӧ��С����������Ƶ��
WT = zeros(nLevel, SigLen);              % ����������Ĵ洢��Ԫ

wait = waitbar(0,'Under calculation, please wait...');
for m = 1:nLevel,
   
    waitbar(m/nLevel,wait);
    a = Scales(m);                                   % ��ȡ�߶Ȳ���                              
    t = -round(a*WinLen):1:round(a*WinLen);   
    Morl = pi^(-1/4)*exp(i*2*pi*0.5*t/a).*exp(-t.^2/2/(2*omg0*a)^2);   % ���㵱ǰ�߶��µ�С������
    temp = conv(Sig,Morl) / sqrt(a);                                                           % �����ź���С�������ľ��  
    WT(m,:) = temp(round(a*WinLen)+1:length(temp)-round(a*WinLen));  
   
end;
close(wait);

WT = WT / WinLen;