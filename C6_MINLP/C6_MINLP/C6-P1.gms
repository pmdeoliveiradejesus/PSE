$title C6_E1 Despacho de una industria

Set
   t 'hours'         / t1*t24 /;

Table data(t,*)
    spotp   load1  load2    sun
 t1 0.11    0.68    0.95    0.00
 t2 0.11    0.70    0.95    0.00
 t3 0.11    0.68    0.93    0.00
 t4 0.11    0.68    0.93    0.00
 t5 0.11    0.68    0.99    0.00
 t6 0.12    0.72    1.00    0.00
 t7 0.15    0.85    1.00    0.15
 t8 0.17    0.90    0.96    0.35
 t9 0.18    0.97    0.91    0.55
t10 0.16    0.97    0.83    0.72
t11 0.15    0.98    0.73    0.85
t12 0.13    1.00    0.63    0.96
t13 0.13    0.99    0.67    1.00
t14 0.13    0.92    0.63    0.92
t15 0.14    0.90    0.60    0.87
t16 0.13    0.95    0.59    0.73
t17 0.18    0.94    0.59    0.55
t18 0.14    1.00    0.60    0.35
t19 0.14    0.96    0.74    0.15
t20 0.14    0.94    0.86    0.00
t21 0.15    0.82    0.95    0.00
t22 0.15    0.77    0.96    0.00
t23 0.15    0.76    0.96    0.00
t24 0.12    0.72    0.95    0.00;    
* -----------------------------------------------------

Variable
   Benefit           'Social Welfare Eur/month'
   SOC1(t)      'State of Charge 1 kWh'
   Pd1(t)       'Power discharge 1 kW'
   Pch1(t)      'Power Charge 1 kW' 
   Pb1(t)       'Power bought from the public grid kW'
   Ps1(t)       'Power sold to the public grid kW'
   AP1(t)       'Benefit industry 1 Eur/month';
      
Binary Variable
   w1(t)     
   w3(t)   

Scalar 
   Ppvmax1     / 500/
   Loadmax1    / 1000 /
   SOCfinal1   / 300  /
   Capacity1   / 3000  /
   eff_c1      / 0.95 /
   eff_d1      / 0.92 /
   CRte_c1     / 0.3 /
   CRte_d1     / 0.2 /
   DoD1        /0.8/
   wheeling    /0.05/
   Pmax1       /5000/
   delta_max       /36/;
   

   
SOC1.up(t)     = ((1-DoD1)/2+DoD1)*Capacity1;
SOC1.lo(t)     = ((1-DoD1)/2)*Capacity1;
SOC1.fx('t24') =     SOCfinal1;
Pch1.lo(t) = 0;
Pd1.lo(t) = 0;
Pb1.lo(t) = 0;
Ps1.lo(t) = 0;


Equation Bcalc, balance1, r1, r2, r3, r4, r5;

Bcalc..       Benefit =e=  -delta_max*smax(t,Ps1(t)+Pb1(t))+30*sum((t), (data(t,'spotp')*ps1(t)-(data(t,'spotp')+wheeling)*pb1(t)));
balance1(t)..  Pd1(t) + Pb1(t) + Ppvmax1*data(t,'sun') =e= Pch1(t) +Ps1(t) + Loadmax1*data(t,'load1');
r1(t)..   SOC1(t) =e= SOCfinal1$(ord(t)=1) + SOC1(t-1)$(ord(t)>1) + Pch1(t)*eff_c1  - Pd1(t)/eff_d1;
r2(t)..  Pch1(t)  =l= Crte_c1*Capacity1*w1(t);
r3(t)..  Pd1(t) =l= Crte_d1*Capacity1*(1-w1(t));
r4(t)..  Pb1(t) =l= Pmax1*w3(t);
r5(t)..  Ps1(t) =l= Pmax1*(1-w3(t));


Model model1 / all /;
solve model1 using MINLP maximizing Benefit

execute_unload 'C6_E1.gdx';
