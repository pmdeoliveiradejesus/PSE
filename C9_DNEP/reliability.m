% Reliability indexes calculation

% new lines Type 1 and Type 2 (per line)
for i=1:nn/2 %sweeping new lines
ic1(i)= (cc*new(i,3)+cg*new(i,4)+cs*new(i,5)+J(5,1)*(new(i,3)+new(i,4)+new(i,5)));% Overnight cost coef. Type 1, USD
lambdanew1(i)=J(6,1)*.001*(new(i,3)+new(i,4)+new(i,5));
lambdanew2(i)=J(6,2)*.001*(new(i,3)+new(i,4)+new(i,5));
repairnew1(i)=J(7,1);
repairnew2(i)=J(7,2);
end
for i=1:nv %sweeping old lines
if old(i,6)==1
lambdaold(i)=J(6,1)*.001*(old(i,3)+old(i,4)+old(i,5));
repairold(i)=J(7,1);
end
if old(i,6)==2
lambdaold(i)=J(6,2)*.001*(old(i,3)+old(i,4)+old(i,5));
repairold(i)=J(7,2);
end
if old(i,6)==3
lambdaold(i)=J(6,3)*.001*(old(i,3)+old(i,4)+old(i,5));
repairold(i)=J(7,3);
end
end
lambdaB=[lambdanew1,lambdanew2];
repairB=[repairnew1,repairnew2];
for i=0:nn-1
kk=i*2+1;
lambdaA(kk)=lambdaB(i+1);
lambdaA(kk+1)=lambdaB(i+1);
repairA(kk)=repairB(i+1);
repairA(kk+1)=repairB(i+1);
end

for i=0:nn/2-1
kk=i*2+1;
newA(kk,1)=new(i+1,2);
newA(kk+1,1)=new(i+1,2);
newB(kk,1)=new(i+1,1);
newB(kk+1,1)=new(i+1,1);
end
for i=0:nn/2-1
kk=i*2+1;
newA(kk+nn,1)=new(i+1,2);
newA(kk+1+nn,1)=new(i+1,2);
newB(kk+nn,1)=new(i+1,1);
newB(kk+1+nn,1)=new(i+1,1);
end
k=0;
for i=1:nv
    k=k+1;
lambdaC(k)=lambdaold(i);
repairC(k)=repairold(i);
end
for i=1:nv
SendingNode(i)=old(i,1);
RecieveNode(i)=old(i,2);
end
for i=1:2*nn
if X(i)==1
k=k+1; 
i;
SendingNode(k)=newB(i,1);
RecieveNode(k)=newA(i,1); 
lambdaC(k)=lambdaA(i).*X(i);
repairC(k)=repairA(i).*X(i);
end
end

%Ax=zeros(length(SendingNode),length(loads(:,1)));
%for i=1:length(SendingNode) 
%Ax(i,RecieveNode(i))=1;
%Find all nodes thar connect with  RecieveNode(i)
% for k=1:length(SendingNode) 
%     if SendingNode(k)==RecieveNode(i)
%     Ax(i,RecieveNode(k))=1;
%         for j=1:length(SendingNode)
%         if SendingNode(j)==RecieveNode(k)
%         Ax(i,RecieveNode(j))=1;
%             for jj=1:length(SendingNode)
%             if SendingNode(jj)==RecieveNode(j)
%             Ax(i,RecieveNode(jj))=1;
%             end
%         end
%         end
%         end
%     end
% end
% end
%for i=1:length(loads(:,1))
%Pload(i,1)=loads(i,1);
%end
%pflow2=IncidenceMatrix*Pload;

pflow=zeros(1,length(loads(:,1)));
k=0;
for i=1:nv
    k=k+1;
        pflow(k)=pi(nn+i);
end
for i=1:nn
    if pi(i) > 0
    k=k+1;
        pflow(k)=pi(i);
    end
end
for i=1:nn
    if pi(nn+nv+i) > 0
    k=k+1;
        pflow(k)=pi(nn+nv+i);
    end
end
EnergyNotSupplied=sum(lambdaC.*repairC.*pflow*1000*SysLoadFactor*fp);%kWh/year
Usys=EnergyNotSupplied/(sum(loads(:,1)*1000*SysLoadFactor*fp));%hours/year
lambdaSys=sum(lambdaC); %fault/yr
repairtimeSys=Usys/lambdaSys; %hours
ASAI=100*(8760-Usys)/8760; % percentage
SAIFI=sum(lambdaC.*pflow)/sum(loads(:,1));% interruptions per customer
SAIDI=sum(lambdaC.*repairC.*pflow)/sum(loads(:,1));% hours per customer
CAIDI=sum(lambdaC.*repairC.*pflow)/sum(lambdaC.*pflow);% hours per customer


