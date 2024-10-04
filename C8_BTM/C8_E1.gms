$title C8_E1 PV System sizing

Set
   t 'hours'         / t1*t24 /;

Table data(t,*)
    lambda  Plu     Ppvu
 t1 0.11    0.68    0.00
 t2 0.11    0.70    0.00
 t3 0.11    0.68    0.00
 t4 0.11    0.68    0.00
 t5 0.11    0.68    0.00
 t6 0.12    0.72    0.00
 t7 0.15    0.85    0.15
 t8 0.17    0.90    0.35
 t9 0.18    0.97    0.55
t10 0.16    0.97    0.72
t11 0.15    0.98    0.85
t12 0.13    1.00    0.96
t13 0.13    0.99    1.00
t14 0.13    0.92    0.92
t15 0.14    0.90    0.87
t16 0.13    0.95    0.73
t17 0.18    0.94    0.55
t18 0.14    1.00    0.35
t19 0.14    0.96    0.15
t20 0.14    0.94    0.00
t21 0.15    0.82    0.00
t22 0.15    0.77    0.00
t23 0.15    0.76    0.00
t24 0.12    0.72    0.00;  
* -----------------------------------------------------

   Variable
   npv          'Net present value'
   Pb(t)        'Power bought from the public grid kW'
   Ps(t)        'Power sold to the public grid kW'
   Ppv_inst     'installed PV capacity kW'
   DemCharge    'Max Demand payment'
   EnergyCharge 'Energy component payment'
   Ppv(t)       'PV production'
   Pl(t)        'Load';
   
   Binary Variable
   w1(t)       

   Scalar 
   
   Plmax     / 1000 /
   psi       /0.05/
   Pmax      /5000/
   kappa     /36/
   crf       /0.08024258719/
   CAPEXpvu   /1400/;

Ppv_inst.lo = 0;
Pb.lo(t) = 0;
Ps.lo(t) = 0;

Equation Obj, balance,r1,r2, r3,r4, r5, r6;
Obj..         npv =e= (1/crf)*(DemCharge+EnergyCharge)-CAPEXpvu*Ppv_inst;
balance(t)..   Pb(t) + Ppv(t) =e= Ps(t) + Pl(t);
r1..            DemCharge=e=-12*kappa*smax(t,Ps(t)+Pb(t));
r2..            EnergyCharge=e=365*sum((t), (data(t,'lambda')*ps(t)-(data(t,'lambda')+psi)*pb(t)));
r3(t)..         Ppv(t) =e= Ppv_inst*data(t,'Ppvu');  
r4(t)..         Pb(t) =l= Pmax*w1(t);
r5(t)..         Ps(t) =l= Pmax*(1-w1(t));
r6(t)..         Pl(t) =e= Plmax*data(t,'Plu');

Model modelVPNpv / all /;
solve modelVPNpv using MINLP maximizing npv

execute_unload 'C8_E1.gdx';

