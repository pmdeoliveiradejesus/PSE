clear all
Plmax=110;%kW
Lf=0.85;
Wd=Plmax*Lf*8780;%kWh
lambda=89.8/1000;%$/kWh
psi=0.05;%$/kWh
Pbase=Wd*(lambda+psi);%$/año
HPS=24*.25;
Ppvinst=110;%kW
Wpv=Ppvinst*HPS*365;%kWh
Ppv=(Wd-Wpv)*(lambda+psi);%$/año
AvoidedCost=Pbase-Ppv;%$/año
CAPEXpvu=2000;%$/año
Io=-CAPEXpvu*Ppvinst;
Rate=0.05;
life=20;%years
crf=(Rate*(Rate+1)^life)/((Rate+1)^life-1);
%inv(crf)
CashFlow=ones(1,19)*AvoidedCost;
NPV = Io+pvfix(Rate,20,AvoidedCost)
TIR=irr([Io,CashFlow])*100
BCratio=pvfix(Rate,20,AvoidedCost)/-Io
nper=paybackPeriod(Io, CashFlow)


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

