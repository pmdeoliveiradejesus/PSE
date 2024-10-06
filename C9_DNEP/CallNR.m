%% Run A Full NR program
fid=fopen('busdata.m','w+');
fprintf(fid,'ldat=[\n');
j=0;
for i=0:nn/2-1  
    kk=i*2+1;
if X(kk)+X(kk+1)==1 
    j=j+1;
    i;
fprintf(fid,'%i %i %i %8.4f %8.4f 0 0 0;\n',new(i+1,1),new(i+1,2),j, (1/Zbase)*J(3,1)*(new(i+1,3)+new(i+1,4)+new(i+1,5)),(1/Zbase)*J(4,1)*(new(i+1,3)+new(i+1,4)+new(i+1,5)));
end
end
for i=0:nn/2-1 
    kk=nn+i*2+1;
if X(kk)+X(kk+1)==1 
    j=j+1;
    i;
fprintf(fid,'%i %i %i %8.4f %8.4f 0 0 0;\n',new(i+1,1),new(i+1,2),j, J(3,2)*(new(i+1,3)+new(i+1,4)+new(i+1,5)),J(4,2)*(new(i+1,3)+new(i+1,4)+new(i+1,5)));
end
end
for i=1:nv
if old(i,6)==1
fprintf(fid,'%i %i %i %8.4f %8.4f 0 0 0;\n',old(i,1),old(i,2),i+j, (1/Zbase)*J(3,1)*(old(i,3)+old(i,4)+old(i,5)),(1/Zbase)*J(4,1)*(old(i,3)+old(i,4)+old(i,5)));
end
if old(i,6)==2
fprintf(fid,'%i %i %i %8.4f %8.4f 0 0 0;\n',old(i,1),old(i,2),i+j, (1/Zbase)*J(3,2)*(old(i,3)+old(i,4)+old(i,5)),(1/Zbase)*J(4,2)*(old(i,3)+old(i,4)+old(i,5)));
end
if old(i,6)==3
fprintf(fid,'%i %i %i %8.4f %8.4f 0 0 0;\n',old(i,1),old(i,2),i+j, (1/Zbase)*J(3,3)*(old(i,3)+old(i,4)+old(i,5)),(1/Zbase)*J(4,3)*(old(i,3)+old(i,4)+old(i,5)));
end
end
fprintf(fid,'];\n');
fprintf(fid,'bdat=[\n');
for k=1:nnod
   fprintf(fid,'%i 9002 3 0 0 %8.4f %8.4f 1 0 0 0 0 0 0 0 .9 1.1 0 0 0 0 0 0;\n',k,loads(k)*fp/(Sbase),loads(k)*sqrt(1-fp*fp)/(Sbase));
end
   fprintf(fid,'%i 1001 1 0 0 0.0000 0.0000 1 0 0 0 0 0 0 0 1.0 1.0 0 0 0 0 0 0;\n',senode);
fprintf(fid,'];\n');
status=fclose(fid);
busdata;%load LoadFlowCase
econv=0.0001;
itermax=100;
[Plt] = CallFullNewtonRaphson(ldat,bdat,econv,itermax,Sbase,flag);

%%%%Basic Load Flow%%%%%
%n-bus load flow  NEWTON RAPHSON METHOD using Stevenson-Gomez Exposito Scheme May 19 2004
function [Plt] = CallFullNewtonRaphson(ldat,bdat,econv,itermax,Sbase,flag)
if flag==1
disp([' '])
disp([' '])
disp([' ****************************************************************'])
disp([' *  POWER FLOW Version 2.0 (c)2003, 2014                        *'])
disp([' *  NEWTON RHAPSON (Compact formulation)                        *'])
disp([' *                                                              *'])
disp([' *  This program has been developed by Paulo M. De Oliveira     *'])
disp([' *  in MATLAB                                                   *'])
disp([' *                                                              *'])
disp([' *  Modified in 2004/Oct 13,                                    *'])
disp([' *  Modified in 2014/Dic 25,     Taps and Shunts included       *'])
disp([' *  E-mail: pdeoliv@gmail.com                                   *'])
disp([' ****************************************************************'])
disp([' '])
disp([' '])
end
% Options input: convergence;
tic;
%--------------------------------------------------------------------------------------------------
%Number of lines and Buses
nl=length(ldat(:,1));
n=length(bdat(:,1));
%
for i=1:n
   for j=1:n
Z(i,j)=10^20;
	end
end
for k=1:nl
   if ldat(k,1)>=ldat(k,2)
      Z(ldat(k,2),ldat(k,1))=complex(ldat(k,4),ldat(k,5));
      else
      Z(ldat(k,1),ldat(k,2))=complex(ldat(k,4),ldat(k,5));
end
end
for k=1:nl
   if ldat(k,1)>=ldat(k,2)
      su(ldat(k,2),ldat(k,1))=0.5*complex(0,ldat(k,6));
      else
      su(ldat(k,1),ldat(k,2))=0.5*complex(0,ldat(k,6));
   end
end
for i=1:n
   for j=1:n
      if i~=j
      su(j,i)=su(i,j);   
      end
   end
end
for i=1:n
   for j=1:n
      if i~=j
      Z(j,i)=Z(i,j);   
      end
   end
end

%% Transformer Taps acoording Arrillaga Model. PD 26/12/14
for k=1:nl
    if ldat(k,8)>0
      su(ldat(k,1),ldat(k,2))= inv(Z(ldat(k,1),ldat(k,2)))*((1-ldat(k,8))/ldat(k,8)^2);
      su(ldat(k,2),ldat(k,1))= inv(Z(ldat(k,2),ldat(k,1)))*((ldat(k,8)-1)/ldat(k,8));        
      Z(ldat(k,2),ldat(k,1))=ldat(k,8)*complex(ldat(k,4),ldat(k,5));
      Z(ldat(k,1),ldat(k,2))=Z(ldat(k,2),ldat(k,1));    
   end
end
%% Shunts PD 26/12/14
for k=1:n    
sh(k,k)=complex(bdat(k,9),bdat(k,10));%include shunts at each bus% i=sqrt(-1);
end
 %%
for k=1:n
Pesp(k)=bdat(k,4)-bdat(k,6);
Qesp(k)=bdat(k,5)-bdat(k,7);
Pg(k)=bdat(k,4);
Pd(k)=bdat(k,6);
Qg(k)=bdat(k,5);
Qd(k)=bdat(k,7);
end

%create Ybus
for i=1:n
   Y(i,i)=0;
   for j=1:n
      if i~=j
      Y(i,i)=inv(Z(i,j))+Y(i,i)+su(i,j);
      Y(i,j)=-inv(Z(i,j));   
      end
   end
end
Y=Y+sh;%Add (sh) shunt suceptance at buses
%Identify SLACK, PV and PQ buses
nd=0;
ng=0;
pv=0;
for k=1:n
   if bdat(k,3)==1
   	sl=k;   
   end
   if bdat(k,3)==2
      ng=ng+1;   
      pv(ng)=k;
   end
   
   if bdat(k,3)==3
      nd=nd+1;
      pq(nd)=k;
   end
end
%set initial values 
%teta PQ buses
for k=1:nd
   x(k)=0;
end
%teta PV buses
for k=nd+1:nd+ng
   x(k)=0;
end
%Tension PQ buses
for k=nd+ng+1:2*nd+ng
   x(k)=1.0;
end 
%slack bus angle and tension
t(sl)=0;
v(sl)=bdat(sl,8);
for k=1:ng
   v(pv(k))=bdat(pv(k),8);
end
%To entry in a iterative process
for k=1:2*nd+ng
   delta(k) =1;
end
xn=1;
iter=0;
while max(abs(delta))> econv
   %counter   
   iter=iter+1;
   max(abs(delta));
it(iter)=iter;
if iter==itermax
   disp(['No Converge!'])
   disp(['No Converge!'])
   disp(['No Converge!'])
   disp(['No Converge!'])
   break;
end   
%PV tension values 
flag=0;
for k=1:n
   if k~=sl
      flag=flag+1;
      t(k)=x(flag); %pq AND pv buses angles
   end
end
flag=0;
for k=1:n
   if bdat(k,3)==3
      flag=flag+1;
      v(k)=x(flag+ng+nd); %pq AND pv buses angles
   end
end
for i=1:nd
   P(pq(i))=0;
   for j=1:nd+ng+1
   P(pq(i))=v(pq(i))*v(j)*(real(Y(pq(i),j))*cos(t(pq(i))-t(j))+imag(Y(pq(i),j))*sin(t(pq(i))-t(j)))+P(pq(i));
   end
end
for i=1:ng
   P(pv(i))=0;
   for j=1:nd+ng+1
   P(pv(i))=v(pv(i))*v(j)*(real(Y(pv(i),j))*cos(t(pv(i))-t(j))+imag(Y(pv(i),j))*sin(t(pv(i))-t(j)))+P(pv(i));
   end
end
for i=1:nd
   Q(pq(i))=0;
   for j=1:nd+ng+1
   Q(pq(i))=v(pq(i))*v(j)*(real(Y(pq(i),j))*sin(t(pq(i))-t(j))-imag(Y(pq(i),j))*cos(t(pq(i))-t(j)))+Q(pq(i));
   end
end
for k=1:nd
deltap(pq(k))= Pesp(pq(k))-P(pq(k));
end
for k=1:ng
deltap(pv(k))= Pesp(pv(k))-P(pv(k));
end
for k=1:nd
deltaq(pq(k))= Qesp(pq(k))-Q(pq(k));
end
flag=0;
ndelta=length(deltap(:));
for k=1:ndelta
   if k~=sl
   flag=flag+1;
   delta(flag)=deltap(k);
	end
end
flag=0;
ndelta=length(deltaq(:));
for k=1:ndelta
   if bdat(k,3)==3
      flag=flag+1;
      delta(n-1+flag)=deltaq(k);   
   end
end
%calculate jacobian components H,N,M,L % EXPOSITO FORMULATION
for i=1:nd+ng+1
   Qx(i)=0;
   for j=1:nd+ng+1     
   Qx(i)=v(i)*v(j)*(real(Y(i,j))*sin(t(i)-t(j))-imag(Y(i,j))*cos(t(i)-t(j)))+Qx(i);
	end
end
for i=1:nd+ng+1
   Px(i)=0;
   for j=1:nd+ng+1
   Px(i)=v(i)*v(j)*(real(Y(i,j))*cos(t(i)-t(j))+imag(Y(i,j))*sin(t(i)-t(j)))+Px(i);
   end
end
for i=1:ng+nd+1
   for j=1:ng+nd+1   
    if i==j  
    H(i,i)=-Qx(i)-imag(Y(i,i))*v(i)*v(i);
	 else
    H(i,j)=v(i)*v(j)*(real(Y(i,j))*sin(t(i)-t(j))-imag(Y(i,j))*cos(t(i)-t(j)));
 	 end   
  end
end
for i=1:ng+nd+1
   for j=1:ng+nd+1   
          if i==j 
    L(i,i)=Qx(i)-imag(Y(i,i))*v(i)*v(i);
    else
    L(i,j)=v(i)*v(j)*(real(Y(i,j))*sin(t(i)-t(j))-imag(Y(i,j))*cos(t(i)-t(j)));
 	end
  end   
end
for i=1:ng+nd+1
   for j=1:ng+nd+1   
          if i==j 
             N(i,i)=Px(i)+real(Y(i,i))*v(i)*v(i);
             else
                N(i,j)=v(i)*v(j)*(real(Y(i,j))*cos(t(i)-t(j))+imag(Y(i,j))*sin(t(i)-t(j)));
             end
end   
end
for i=1:ng+nd+1
   for j=1:ng+nd+1   
          if i==j 
             M(i,i)=Px(i)-real(Y(i,i))*v(i)*v(i);
             else
                M(i,j)=-N(i,j);
                end
end   
end
%Fill jacobian
for i=1:nd+ng+1
   for j=1:nd+ng+1
      J(i,j)=H(i,j);
      J(i+nd+ng+1,j)=M(i,j);
      J(i,j+nd+ng+1)=N(i,j);
      J(i+nd+ng+1,j+nd+ng+1)=L(i,j);
   end
end
%Eliminate rows and columns corresponding to slack sl, ans pv's buses 
nn=length(J(:,1));
mm=length(J(1,:));
for j=1:nn
flag(j)=0;
end
for j=1:nn
   for k=1:mm
if ng==0
   if k~=sl & k~=sl+n
   flag(j)=flag(j)+1;
   B(j,flag(j))=J(j,k);
   end
end
c= (k~=sl & k~=sl+n & k~=pv(1)+n); 
for p=1:ng
if ng==p
   if c
   flag(j)=flag(j)+1;
   B(j,flag(j))=J(j,k);      
   end
else
c = c & (k~=pv(p+1)+n);
end
end
end
end
nn=length(B(:,1));
mm=length(B(1,:));
for j=1:nn
flag(j)=0;
end
for j=1:mm
   for k=1:nn
if ng==0
   if k~=sl & k~=sl+n
   flag(j)=flag(j)+1;
   Jrr(flag(j),j)=B(k,j);
   end
end
r = (k~=sl & k~=sl+n & k~=pv(1)+n);
for h=1:ng
if ng==h
   if r
   flag(j)=flag(j)+1;
   Jrr(flag(j),j)=B(k,j);        
   end
else
r = r & (k~=pv(h+1)+n);
end
end
end
end
%system solution
xn=inv(Jrr)*delta';
%for k=ng 
%  xn(nd+ng+k)=xn(nd+ng+k)*v(pv(k));
%end
%actualize values of x
x=x+xn';
dP(iter)=max(delta);
end
for k=1:ng+nd+1
   [vx(k),vy(k)]=pol2cart(t(k),v(k));
   vt(k)=complex(vx(k),vy(k));
end
%end of ierative process---------------------------------
elapsedtime = toc;
%if iter<itermax
It=Y*vt.';
St=diag(vt)*conj(It);
Plt=0;
Qlt=0;
for k=1:nl
P(ldat(k,1),ldat(k,2))=v(ldat(k,1))*v(ldat(k,2))*(real(Y(ldat(k,1),ldat(k,2)))*cos(t(ldat(k,1))-t(ldat(k,2)))+imag(Y(ldat(k,1),ldat(k,2)))*sin(t(ldat(k,1))-t(ldat(k,2))))-real(Y(ldat(k,1),ldat(k,2)))*v(ldat(k,1))*v(ldat(k,1));
Q(ldat(k,1),ldat(k,2))=v(ldat(k,1))*v(ldat(k,2))*(real(Y(ldat(k,1),ldat(k,2)))*sin(t(ldat(k,1))-t(ldat(k,2)))-imag(Y(ldat(k,1),ldat(k,2)))*cos(t(ldat(k,1))-t(ldat(k,2))))+(imag(Y(ldat(k,1),ldat(k,2)))-imag(su(ldat(k,1),ldat(k,2))))*v(ldat(k,1))*v(ldat(k,1));
P(ldat(k,2),ldat(k,1))=v(ldat(k,2))*v(ldat(k,1))*(real(Y(ldat(k,2),ldat(k,1)))*cos(t(ldat(k,2))-t(ldat(k,1)))+imag(Y(ldat(k,2),ldat(k,1)))*sin(t(ldat(k,2))-t(ldat(k,1))))-real(Y(ldat(k,2),ldat(k,1)))*v(ldat(k,2))*v(ldat(k,2));
Q(ldat(k,2),ldat(k,1))=v(ldat(k,2))*v(ldat(k,1))*(real(Y(ldat(k,2),ldat(k,1)))*sin(t(ldat(k,2))-t(ldat(k,1)))-imag(Y(ldat(k,2),ldat(k,1)))*cos(t(ldat(k,2))-t(ldat(k,1))))+(imag(Y(ldat(k,2),ldat(k,1)))-imag(su(ldat(k,2),ldat(k,1))))*v(ldat(k,2))*v(ldat(k,2));
Pl(k) = (P(ldat(k,1),ldat(k,2))-P(ldat(k,2),ldat(k,1)))/2;
Ql(k) = (Q(ldat(k,1),ldat(k,2))-Q(ldat(k,2),ldat(k,1)))/2;
Sl(k)=(Pl(k)^2+Ql(k)^2)^.5;
S1(k)=complex(P(ldat(k,1),ldat(k,2)),Q(ldat(k,1),ldat(k,2)));
[x,y]=pol2cart(t(ldat(k,1)),v(ldat(k,1)));
I1(k)=conj(S1(k)/complex(x,y));
S2(k)=complex(P(ldat(k,2),ldat(k,1)),Q(ldat(k,2),ldat(k,1)));
[x,y]=pol2cart(t(ldat(k,2)),v(ldat(k,2)));
I2(k)=conj(S2(k)/complex(x,y));
I(k)=(I1(k)-I2(k))*.5;
Pli(k)=ldat(k,4)*(real(I(k)))*(real(I(k)));
Ploss(k) = P(ldat(k,1),ldat(k,2))+P(ldat(k,2),ldat(k,1));
Qloss(k) = Q(ldat(k,1),ldat(k,2))+Q(ldat(k,2),ldat(k,1));
Plt=Ploss(k)+Plt;
Qlt=Qloss(k)+Qlt;
error(k)=Pli(k)-Ploss(k);
end
if flag==1
%Output Report
fid=fopen('nrexit.m','w+');
fprintf(fid,'POWER FLOW Version 2.0 (c)2003, 2014                        \n');
fprintf(fid,'---------                                                   \n');
fprintf(fid,'This program has been developed by Paulo M. De Oliveira     \n');
fprintf(fid,'in MATLAB                                                   \n');
fprintf(fid,'E-mail: pdeoliv@GMAIL.COM                                   \n');
fprintf(fid,'NEWTON RAPHSON                               \n');
fprintf(fid,'--------- \n');
fprintf(fid,' \n');
fprintf(fid,'Power flow completed in: %6.3f s\n',elapsedtime);
fprintf(fid,'NUMBER OF BUSES: %3.0f\n',n);
fprintf(fid,'NUMBER OF LINES: %3.0f\n',nl);
fprintf(fid,'NUMBER OF ITERATIONS: %3.0f\n',iter);
fprintf(fid,'CONVERGENCY: %1.16f\n',econv);
fprintf(fid,' \n');
fprintf(fid,'NLines   SBus RBus R(p.u.) X(p.u)  P(i,j)   P(j,i)  Ploss(kW) Q(i,j)   Q(j,i)   Qloss (kVAr) S(i,j)\n');
for k=1:nl
fprintf(fid,'Line%3.0f   %3.0f  %3.0f %1.4f  %1.4f  %1.4f  %1.4f  %1.4f  %1.4f  %1.4f  %1.4f  %1.4f\n',k,ldat(k,1),ldat(k,2),ldat(k,4),ldat(k,5),P(ldat(k,1),ldat(k,2)),P(ldat(k,2),ldat(k,1)),Ploss(k)*Sbase*1000,Q(ldat(k,1),ldat(k,2)),Q(ldat(k,2),ldat(k,1)),Qloss(k)*Sbase*1000,Sl(k)*Sbase);   
end
fprintf(fid,' \n');
fprintf(fid,'                                                     -----                    -----\n',Plt,Qlt);
fprintf(fid,'TOTAL LOSSES in kW and kVAr:                         %1.8f                    %1.4f\n',Plt*Sbase*1000,Qlt*Sbase*1000);
fprintf(fid,' \n');
fprintf(fid,'NBus      P(p.u.)    Q(p.u)    V(p.u.)     Th(rad)\n');
for k=1:n
fprintf(fid,'Bus%3.0f    %1.4f     %1.4f    %1.4f     %1.4f\n',k,real(St(k)),imag(St(k)),v(k),t(k));   
end
fprintf(fid,' \n');
fprintf(fid,'CONTROL VARIABLES\n');
fprintf(fid,'SLACK BUS\n');
fprintf(fid,'Bus%3.0f   Active Generation %1.8f MW \n',sl,real(St(sl)+bdat(sl,6))*Sbase);   
fprintf(fid,'PV BUSES\n');
for k=1:ng
fprintf(fid,'Bus%3.0f   Active Generation %1.8f MW \n',pv(k),bdat(pv(k),4)*Sbase);   
end
fprintf(fid,' \n');

fprintf(fid,'Bus%3.0f   Reactive Generation %1.8f MVAr\n',sl,imag(St(sl)+bdat(sl,6))*Sbase);   
for k=1:ng
   Qgen(k)=(imag(St(pv(k)))+bdat(pv(k),7));
   end
for k=1:ng
   fprintf(fid,'Bus%3.0f   Reactive Generation %1.9f MVAr\n',pv(k),(imag(St(pv(k)))+bdat(pv(k),7))*Sbase);   
end
fprintf(fid,'STATE VARIABLES\n');
fprintf(fid,' \n');
for k=1:n
fprintf(fid,'Bus%3.0f  Tension %1.8f pu  Angle %1.4f DEG\n',k,v(k),t(k)*180/3.1416);   
end
status=fclose(fid);
disp([''])
close
disp([' '])
edit nrexit.m
end
end


