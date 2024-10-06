% Distribution LP model 					
%% Technical data 9 bus system
flag=0;% flag=1, print power flow results 
kVn=	10	;%nominal voltage (kV);			
senode=	9	;%Substation node
Sbase=100;%MVA
Zbase=kVn*kVn/Sbase;%ohms
fp=0.8;%load power factor (lag)
SysLossFactor=0.5;
SysLoadFactor=0.5;
we1= 1;%weight investment
we2= 1;%weight losses
we3= 1;%weight ENS
%Conductor data		
%  S1 150mm2   S2 1x400mm2  S3 2x400m2					
J=[	0.0242      0.0070    0.0099/6	        %Linearized losses coeficient
	4250     	12250    	24500   		%Capacity (kVA)
	0.000257	0.000102	0.000051		%Resistance (Ohm/m)
	0.000087	0.000095	0.000005		%Reactance (Ohm/m)
	60.8	    245.2   	490.4		    %Conductor Cost (USD/m)
	0.0084096	0.0056064	0.0056064		%frequency (outages/year-km)
	10.000000	8.000000	8.000000	];	%repair time (hours)
%% Economical Data					
ec=		    0.05	;%energy cost (USD/kWh)		
ecns=		1000*ec	;%energy not supplied cost (USD/kWh)		
int=		0.08    ;%discount rate (%)					
plt=		20	    ;%project lifetime (years)					
cc=		    120	;%investment corridor cost (USD/m)					
cg=		    50	;%investment garden cost (USD/m)					
cs=		    100	;%investment street cost (USD/m)		


%% ---------EXISTING LINES----------------
    %in out	cor gar str type
    %       (m) (m) (m)
old=[9  1	150  0   0 3;	%oldline1
	 9	2	150  0   0 3;	%oldline2
    ];						
% -------PROPOSED NEW LINES--------------								
    %in out	cor gar str  
    %       (m) (m) (m)		
new=[
    1	3	100	500	100	%newline1
    1	4	150	750	150	%newline2		
	1	5	225	1000	325	%newline3		
	2	3	225	1000	310	%newline4		
	2	4	150	700	160	%newline5		
	2	5	100	500	150	%newline6
	3	4	100	400	200	%newline7
	3	6	100	300	300	%newline8
	3	7	150	750	0	%newline9
	3	8	225	1100	0	%newline10
    4	5	150	200	500	%newline11
	4	6	150	200	450	%newline12
	4	7	100	300	400	%newline13
	4	8	150	700	150	%newline14
	5	6	225	1000 115	%newline15
	5	7	150	500	200	%newline16
	5	8	100	800	0	%newline17
    6	7	100	0	900	%newline18
	7	8	100	0	1000	%newline19
    ]; 	
%% ---Future Loads (MVA)-----------						
loads=[
    1   %1
    1	%2	
    2	%3
	5	%4
	2	%5
	3	%6
	5   %7
	3	%8 
    ];
for k=1:length(loads) %Number of users per load node (3000kWh/year per user)
loads(k,2)=loads(k,1)*1000*8760*SysLoadFactor/3000; 
end
