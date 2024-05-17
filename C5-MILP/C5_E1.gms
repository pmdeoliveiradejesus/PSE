$title Ejemplo C5_E1: Arbitraje con BESS

Set
   t 'horas'         / t1*t24 /;


Table data(t,*)
       PrecioSpot    
   t1   0.03270      
   t2   0.03271      
   t3   0.03272      
   t4   0.03274      
   t5   0.03296       
   t6   0.03493     
   t7   0.0449        
   t8   0.052         
   t9   0.05303       
   t10  0.04726       
   t11  0.04407       
   t12  0.03863       
   t13  0.03991       
   t14  0.03945       
   t15  0.04114      
   t16  0.03923      
   t17  0.05212       
   t18  0.04085       
   t19  0.0412        
   t20  0.04115        
   t21  0.04576        
   t22  0.04559        
   t23  0.04556        
   t24  0.03472;    
* -----------------------------------------------------

Variable
   beneficio    'Beneficio $/dia'
   SOC(t)       'Estado de Carga kWh'
   Pdesc(t)     'Potencia de Descarga kW'
   Pcarg(t)     'Potencia de Carga kW' 
   Pb(t)        'Potencia aquirida kW'
   Ps(t)        'Potencia vendida kW';
      
Binary Variable
   w(t)  
   u(t)   

Scalar
   SOCfinal    / 300  /         
   Capacidad   / 3000  /
   eff_c      / 0.95 /
   eff_d      / 0.92 /
   CRte_carg / 0.3 /
   CRte_desc / 0.2 /
   DoD       /0.8/
   peaje     /0.01/
   Dmax      /5000/;

SOC.up(t)     = ((1-DoD)/2+DoD)*Capacidad; 
SOC.lo(t)     = ((1-DoD)/2)*Capacidad;
SOC.fx('t24') =     SOCfinal;
Pcarg.lo(t) = 0;
Pdesc.lo(t) = 0;
Pb.lo(t) = 0;
Ps.lo(t) = 0;


Equation obj, balance, r1, r2, r3, r4, r5;

obj..       beneficio =e= sum((t), (data(t,'PrecioSpot')*ps(t)-(data(t,'PrecioSpot')+peaje)*pb(t)));
balance(t)..    Pdesc(t) + Pb(t)  =e= Pcarg(t) +Ps(t);
r1(t)..   SOC(t) =e= SOCfinal$(ord(t)=1) + SOC(t-1)$(ord(t)>1) + Pcarg(t)*eff_c  - Pdesc(t)/eff_d;
r2(t)..  Pcarg(t) =l= Crte_carg*Capacidad*w(t);
r3(t)..  Pdesc(t) =l= Crte_desc*Capacidad*(1-w(t));
r4(t)..  Pb(t) =l= Dmax*u(t);
r5(t)..  Ps(t) =l= Dmax*(1-u(t));


Model modelo / all /;
solve modelo using MIP maximizing beneficio

execute_unload 'C5_E1.gdx';

