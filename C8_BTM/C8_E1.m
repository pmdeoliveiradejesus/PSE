% C8 BTM - Sizing a PV module
clear all
close all
clc
A=[	0.11	0.68	0.00	;
	0.11	0.70	0.00	;
	0.11	0.68	0.00	;
	0.11	0.68	0.00	;
	0.11	0.68	0.00	;
	0.12	0.72	0.00	;
	0.15	0.85	0.15	;
	0.17	0.90	0.35	;
	0.18	0.97	0.55	;
	0.16	0.97	0.72	;
	0.15	0.98	0.85	;
	0.13	1.00	0.96	;
	0.13	0.99	1.00	;
	0.13	0.92	0.92	;
	0.14	0.90	0.87	;
	0.13	0.95	0.73	;
	0.18	0.94	0.55	;
	0.14	1.00	0.35	;
	0.14	0.96	0.15	;
	0.14	0.94	0.00	;
	0.15	0.82	0.00	;
	0.15	0.77	0.00	;
	0.15	0.76	0.00	;
	0.12	0.72	0.00	];
   Pfixed=110;%kW
   psi =0.050;%Eur/kWh

   kappa=50;%Eur/kW
Plu=A(:,2);% Load, kW
Ppvu=A(:,3);% PV, kW
CAPEXpvu=2000;%Eur/kW
lambda=A(:,1)*0.64;%spot prices eur/kWh
Pl=Plu* Pfixed;
EnergyLoad=365*sum(Pl);
for i=1:1:Pfixed*2
%i=1;
Ppvmax=i;%kW
Ppv=Ppvu*Ppvmax;
EnergyPV=365*sum(Ppv);
Pb_payment_base=-365*sum((lambda+psi).*Pl)-kappa*Pfixed;
for t=1:24
    if Ppv(t) <= Pl(t) 
       Pb_payment_pvt(t,1)= -(lambda(t)+1*psi)*(Pl(t)-Ppv(t));
    else
       Pb_payment_pvt(t,1)= -lambda(t)*(Pl(t)-Ppv(t));
    end
end
Pb_payment_pv(i)=365*sum(Pb_payment_pvt)-kappa*Pfixed;
AvoidedCost(i)=-Pb_payment_base+Pb_payment_pv(i);
Io=-CAPEXpvu*Ppvmax;
Rate=0.05;
life=20;%years
crf=(Rate*(Rate+1)^life)/((Rate+1)^life-1);
%inv(crf)
CashFlow=ones(1,19)*AvoidedCost(i);
NPV(i) = Io+pvfix(Rate,20,AvoidedCost(i));
TIR(i)=irr([Io,CashFlow])*100;
BCratio(i)=pvfix(Rate,20,AvoidedCost(i))/-Io;
nper(i)=paybackPeriod(Io, CashFlow);
if abs(TIR(i)) > 100
TIR(i)=0;
end
if abs(nper(i)) > 10
nper(i)=0;
end
if abs(BCratio(i)) > 10
BCratio(i)=0;
end

end
figure
plot(nper)
figure
plot(BCratio)
figure
plot(NPV)
figure
plot(TIR)
i=find(NPV==max(NPV))
TasaInterna=TIR(i)
VPN=NPV(i)
Benef_costo=BCratio(i)
nper(i)

fcl=mean(A(:,2))/max(A(:,2));
fcpv=mean(A(:,3))/max(A(:,3));

Wpv=i*8760*fcpv/1000;
W6=1000*8760*fcl/1000;

function pbp = paybackPeriod(initialInvestment, cashFlows)
    % PAYBACKPERIOD calculates the payback period of an investment
    %   pbp = PAYBACKPERIOD(initialInvestment, cashFlows)
    %   initialInvestment: The initial cost of the investment (negative value)
    %   cashFlows: A vector of cash flows for each period (positive values)

    % Initialize cumulative cash flow
    cumulativeCashFlow = -initialInvestment;
    
    % Loop through each period to calculate cumulative cash flow
    for t = 1:length(cashFlows)
        cumulativeCashFlow = cumulativeCashFlow + cashFlows(t);
        
        % Check if the initial investment is recovered
        if cumulativeCashFlow >= 0
            % Interpolate if needed for fractional period calculation
            if cumulativeCashFlow == 0
                pbp = t;
            else
                pbp = t - 1 + (cumulativeCashFlow - cashFlows(t)) / cashFlows(t);
            end
            return;
        end
    end
    
    % If the loop completes without returning, the investment is never recovered
    pbp = Inf;
    warning('The initial investment is not recovered within the given periods.');
end











