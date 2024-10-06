% SingleObjective distribution networks expansion planning program (c) 2005, 2024
% 9 Bus Test System Case 
% Developed by Paulo M. De Oliveira De Jesus
% Maestría en Ingeniería Eléctrica
% Power Systems Planning
% IELE4100 Universidad de los Andes
% pm.deoliveiradejes@uniandes.edu.co
% pdeoliv@gmail.com
clear all
clc
close all
%-----------------------------------------------
DataBase_9nodes;% Call the 9-bus DATABASE
%-----------------------------------------------
nnod=length(loads);%Number of future consumption nodes
nn=2*length(new);%Number of new lines (Type1 and Type 2)
nv=length(old(:,1));%Number of old lines
nt=nnod+1;%Substation node
NPVf=(1/int)-(1/(int*(int+1)^plt)); %net present value coefficient
%Investment Cost, levelized Loss Cost and ENS cost in 
% new lines Type 1 and Type 2 (per line)
for i=1:nn/2 %sweeping new lines
ic1(i)= (cc*new(i,3)+cg*new(i,4)+cs*new(i,5)+J(5,1)*(new(i,3)+new(i,4)+new(i,5)));% Overnight cost coef. Type 1, USD
ic2(i)= (cc*new(i,3)+cg*new(i,4)+cs*new(i,5)+J(5,2)*(new(i,3)+new(i,4)+new(i,5)));% Overnight cost coef. Type 2, USD
loss1(i)=1000*(SysLossFactor*J(1,1)*(new(i,3)+new(i,4)+new(i,5))*ec*NPVf*(8760/1000));%Linearized losses coef. Type 1, USD 
loss2(i)=1000*(SysLossFactor*J(1,2)*(new(i,3)+new(i,4)+new(i,5))*ec*NPVf*(8760/1000));%Linearized losses coef. Type 2, USD 
pns1(i)=1000*(SysLoadFactor*fp*J(6,1)*J(7,1)*ecns*.001*(new(i,3)+new(i,4)+new(i,5)))*NPVf;% ENS cost coef. Type 1, USD 
pns2(i)=1000*(SysLoadFactor*fp*J(6,2)*J(7,2)*ecns*.001*(new(i,3)+new(i,4)+new(i,5)))*NPVf;% ENS cost coef. Type 2, USD 
end
for i=1:nv %sweeping old lines
if old(i,6)==1
icold(i)= 0*(cc*old(i,3)+cg*old(i,4)+cs*old(i,5)+J(5,1)*(old(i,3)+old(i,4)+old(i,5)));% Overnight cost coef. Type 1 USD
lossold(i)=1000*(SysLossFactor*J(1,1)*(old(i,3)+old(i,4)+old(i,5))*ec*NPVf*(8760/1000));%Linearized losses coef. Type 1, USD 
pnsold(i)=1000*(SysLoadFactor*fp*J(6,1)*J(7,1)*ecns*.001*(old(i,3)+old(i,4)+old(i,5)))*NPVf;% ENS cost coef. Type 1, USD 
end
if old(i,6)==2
icold(i)= 0*(cc*old(i,3)+cg*old(i,4)+cs*old(i,5)+J(5,2)*(old(i,3)+old(i,4)+old(i,5)));% Overnight cost coef. Type 2, USD
lossold(i)=1000*(SysLossFactor*J(1,2)*(old(i,3)+old(i,4)+old(i,5))*ec*NPVf*(8760/1000));%Linearized losses coef. Type 2, USD 
pnsold(i)=1000*(SysLoadFactor*fp*J(6,2)*J(7,2)*ecns*.001*(old(i,3)+old(i,4)+old(i,5)))*NPVf;% ENS cost coef. Type 2, USD 
end
if old(i,6)==3
icold(i)= 0*(cc*old(i,3)+cg*old(i,4)+cs*old(i,5)+J(5,3)*(old(i,3)+old(i,4)+old(i,5)));% Overnight cost coef. Type 3, USD
lossold(i)=1000*(SysLossFactor*J(1,3)*(old(i,3)+old(i,4)+old(i,5))*ec*NPVf*(8760/1000));%Linearized losses coef. Type 3, USD
pnsold(i)=1000*(SysLoadFactor*fp*J(6,3)*J(7,3)*ecns*.001*(old(i,3)+old(i,4)+old(i,5)))*NPVf;% ENS cost coef. Type 3, USD
end
end

%Investment Cost in lines Type 1
c(1)=ic1(1);
c(2)=c(1);
for i=1:nn/2-1
kk=i*2+1;
c(kk)=ic1(i+1);
c(kk+1)=c(kk);
end
%Investment Cost in lines Type 2
c1(1)=ic2(1);
c1(2)=c1(1);
for i=1:nn/2-1
kk=i*2+1;
c1(kk)=ic2(i+1);
c1(kk+1)=c1(kk);
end
%Loss and reliability Cost in lines Type 1 and Type 2
p(1)=loss1(1);
ens(1)=pns1(1);
p(2)=p(1);
ens(2)=ens(1);
p1(1)=loss2(1);
ens1(1)=pns2(1);
p1(2)=p1(1);
ens1(2)=ens1(1);
in(1)=new(1,2);
in(2)=new(1,1);
out(1)=new(1,1);
out(2)=new(1,2);
for i=1:nn/2-1
kk=i*2+1;
p(kk)=loss1(i+1);
ens(kk)=pns1(i+1);
p(kk+1)=p(kk);
ens(kk+1)=ens(kk);
p1(kk)=loss2(i+1);
ens1(kk)=pns2(i+1);
p1(kk+1)=p1(kk);
ens1(kk+1)=ens1(kk);
in(kk)=new(i+1,2);
in(kk+1)=new(i+1,1);
out(kk)=new(i+1,1);
out(kk+1)=new(i+1,2);
end
%Costs in old lines
cost=0;
for i=1:nv
   cost=cost+icold(i);
   p(nn+i)=lossold(i);
   ens(nn+i)=pnsold(i);
   in(nn+i)=old(i,2);
   out(nn+i)=old(i,1);
end
% writting the Lingo Optimization Script (LTF)
% https://www.lindo.com/
fname='modelLP_9.ltf';
fid=fopen(fname,'w+');
fprintf(fid,'set echoin 1\n');
fprintf(fid,'set terseo 1\n');
% General Model
fprintf(fid,'MODEL\n');
fprintf(fid,' MIN = %12.2f * M + %8.4f * W%i\n',cost*0,we1*c(1),1);
for i=2:nn % weighted objective
fprintf(fid,' + %8.4f * W%i\n',we1*c(i),i);
end
fprintf(fid,' + %8.4f * Z%i\n',we1*c1(1),1);
for i=2:nn
fprintf(fid,' + %8.4f * Z%i\n',we1*c1(i),i);
end
for i=1:nn
fprintf(fid,' + %8.4f * P%i\n',we2*p(i),i);
end
for i=nn+1:nv+nn
fprintf(fid,' + %8.4f * P%i\n',we2*p(i),i);
end
for i=1:nn
fprintf(fid,' + %8.4f * R%i\n',we2*p1(i),i);
end
for i=1:nn
fprintf(fid,' + %8.4f * P%i\n',we3*ens(i),i);
end
for i=nn+1:nv+nn
fprintf(fid,' + %8.4f * P%i\n',we3*ens(i),i);
end
for i=1:nn
fprintf(fid,' + %8.4f * R%i\n',we3*ens1(i),i);
end
fprintf(fid,';\n');
fprintf(fid,'M = 0;\n');
for jj=1:nnod%Kirchhof Nodal Balance
yy=0;
for i=1:nn+nv
   if in(i) == jj
      yy=yy+1;
      xi=i;
      if yy == 1
      fprintf(fid,'P%i + R%i ',xi,xi);
      else
      fprintf(fid,'+ P%i + R%i ',xi,xi);   
      end   
   end
end
%      fprintf(fid,'\n');   
for i=1:nn+nv
   if out(i) == jj
      xo=i;
      fprintf(fid,' - P%i - R%i ',xo,xo);
   end
end
fprintf(fid,' = %2.2f;\n',loads(jj));
clear xi
clear xo
end
yy=0;
for i=1:nn+nv%balance at substation
   if out(i) == senode
      yy=yy+1;
      xi=i;
      if yy == 1
      fprintf(fid,'P%i ',xi);
      else
      fprintf(fid,'+ P%i ',xi);   
      end   
   end
end
   fprintf(fid,' - Y11');
   fprintf(fid,' = 0;\n');
for i=1:nn%capacity constraints new lines
   fprintf(fid,'P%i - %6.2f * W%i < 0;\n',i,J(2,1),i);
   fprintf(fid,'R%i - %6.2f * Z%i < 0;\n',i,J(2,2),i);
end
for i=nn+1:nn+nv%capacity constraints existing lines
   if old(i-nn,6)==1
      fprintf(fid,'P%i - %6.2f * W%i < 0;\n',i,J(2,1),i);
   end
   if old(i-nn,6)==2
      fprintf(fid,'P%i - %6.2f * W%i < 0;\n',i,J(2,2),i);
   end
   if old(i-nn,6)==3
      fprintf(fid,'P%i - %6.2f * W%i < 0;\n',i,J(2,3),i);
   end 
end   
for jj=1:nnod%radiallity constraints
zz = 0;   
for i=1:nn+nv
   if in(i) == jj
      zz = zz + 1;
      xi=i;
      if zz == 1
      fprintf(fid,'W%i + Z%i ',xi,xi);
      else
      fprintf(fid,' + W%i + Z%i ',xi,xi);
      end       
   end
end
fprintf(fid,' = 1;\n');
end
for i=nn+1:nn+nv%existing lines
      xi=i;  
      fprintf(fid,'W%i = 1;\n',xi);
   end
for i=nn+1:nn+nv%existing lines
      xi=i;  
      fprintf(fid,'Z%i = 0;\n',xi);
      fprintf(fid,'R%i = 0;\n',xi);    
end
fprintf(fid,'W1 + W2 + Z1 + Z2 < 1;\n');
for i=1:nn/2-1%eliminate double flow
kk=i*2+1;
      fprintf(fid,'W%i + W%i + Z%i + Z%i < 1;\n',kk,kk+1,kk,kk+1);
end
for i=1:nn%binary vars
      fprintf(fid,'@BIN( W%i);\n',i);
      fprintf(fid,'@BIN( Z%i);\n',i);    
end
fprintf(fid,'END\n');
fprintf(fid,'go\n');%Execute the Lingo Solver
fprintf(fid,'div results_9.m\n');%Store results
fprintf(fid,'solu\n'); 
fprintf(fid,'rvrt\n');
status=fclose(fid);
%dos('C:\LINGO64_19\Lingo64_19.exe'); %Execute DOS command
% Scanning Results
	fid=fopen('results_9.m','r');
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   for k=1:2*nn%Read decision variables
   X(k) = str2num(A);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   end   
   for kpp=1:2*nn+nv%Read aparent power flows (kVA)
   pi(kpp) = str2num(A);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
   [A,count] = fscanf(fid,'%s',1);
end  
  ST=fclose(fid);  
% Aggreggating the optimal results
CI=ic1;
CI2=ic2;
for k=1:nn/2
CI(nn/2+k)=CI2(k);   
end
CV1=loss1;
ENSV1=pns1;
CV2=loss2;
ENSV2=pns2;
CV3=lossold;
ENSV3=pnsold;
Inv=0;
PV1=0;
PV2=0;
PV3=0;
ENS1=0;
ENS2=0;
ENS3=0;

CII(1)=CI(1);
CII(2)=CII(1);
for i=1:nn-1
kk=i*2+1;
CII(kk)=CI(i+1);
CII(kk+1)=CII(kk);
end
CVV(1)=CV1(1);
CVV(2)=CVV(1);
ENSVV(1)=ENSV1(1);
ENSVV(2)=ENSVV(1);
for i=1:nn/2-1
kk=i*2+1;
CVV(kk)=CV1(i+1);
CVV(kk+1)=CVV(kk);
ENSVV(kk)=ENSV1(i+1);
ENSVV(kk+1)=ENSVV(kk);
end
CVV2(1)=CV2(1);
CVV2(2)=CVV2(1);
ENSVV2(1)=ENSV2(1);
ENSVV2(2)=ENSVV2(1);
for i=1:nn/2-1
kk=i*2+1;
CVV2(kk)=CV2(i+1);
CVV2(kk+1)=CVV2(kk);
ENSVV2(kk)=ENSV2(i+1);
ENSVV2(kk+1)=ENSVV2(kk);
end
for i=1:2*nn
   Inv = CII(i)*X(i)+Inv;
end
for i=1:nn
   PV1 = CVV(i)*pi(i)+PV1;
   ENS1 = ENSVV(i)*pi(i)+ENS1;
end
for i=nn+1:nn+nv
   PV3 = CV3(i-nn)*pi(i)+PV3;
   ENS3 = ENSV3(i-nn)*pi(i)+ENS3;
end
for i=nn+nv+1:2*nn+nv
   PV2 = CVV2(i-nn-nv)*pi(i)+PV2;
   ENS2 = ENSVV2(i-nn-nv)*pi(i)+ENS2;
end
%pcflomodel2%call PCFLO Power Flow program
%dos('pcflo.exe'); %Execute DOS command
InverB=Inv+cost; %USD
LossesB=PV1+PV2+PV3; %USD
ENSB=ENS1+ENS2+ENS3; %USD
EstimLosses=LossesB/(ec*NPVf*8760*SysLossFactor)  %Peak Power Losses in kW
TotalENS=ENSB/(ecns*NPVf); %Total Energy Not Supplied in kWh/yr
iplot=1;
CallNR %Call internal power flow program
ActualLosses=Plt*Sbase*1000; %kW
ShareLosses=ActualLosses/(sum(loads(:,1)*fp)*1000);%percentage
reliability;% Calculate SAIFI, SAIDI; CAIFI, ASAI etc
%% Store the results
Results(1,1)=InverB;%Investment NPV, USD 
Results(2,1)=LossesB;%Losses NPV, USD 
Results(3,1)=ENSB;%ENS NPV, USD
Results(4,1)=InverB+ENSB+LossesB;%Total NPV, USD
Results(5,1)=EstimLosses;%Model (Estimated)Peak Power Losses in kW
Results(6,1)=ActualLosses;%Actual Peak Power Losses in kW
Results(7,1)=ShareLosses;%percentage
Results(8,1)=SAIFI;%system average iterruption frequencyin faults/customer/year
Results(9,1)=SAIDI;%system average iterruption duration hours/customer/year
Results(10,1)=CAIDI;%customer average iterruption duration hours/customer/year
Results(11,1)=TotalENS;%Energy Not Supplied in kWh/yr
Results(12,1)=ASAI;%Average Service Availability Index (%)  
Results(13,1)=we1;%weight investment
Results(14,1)=we2;%weight losses
Results(15,1)=we3;%weight ENS
netplot_9% Plot 9-bus Optimal Topology 





