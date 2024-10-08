close all
figure(iplot)
%set(iplot,'position',pos1)
set(iplot,'MenuBar','none')
      aa=num2str(we1);   
      bb=num2str(we2);
      cc=num2str(we3);
      invt=num2str(Inv+cost);
      enst=num2str(TotalENS);
      lossest=num2str(ActualLosses);
 
      titlename=strcat('Case:',aa,'-',bb,'-',cc,': Io=',invt,' USD,',' ENS = ',enst,' kWh/yr,','Peak Losses = ',lossest,' kW');
title(titlename)
hold on
plot(10,20,'ks');%9
plot(20,30,'k.');%1
plot(20,10,'k.');%2
plot(30,30,'k.');%3
plot(30,20,'k.');%4
plot(30,10,'k.');%5
plot(40,10,'k.');%6
plot(40,20,'k.');%7
plot(40,30,'k.');%8
% New lines
if X(1)==1   
   plot([20 30], [30 30],'b') 
end
if X(2)==1   
   plot([20 30], [30 30],'b') 
end
 if X(3)==1   
    plot([20 30], [30 20],'b') 
 end
 if X(4)==1   
    plot([20 30], [30 20],'b') 
 end
 if X(5)==1   
    plot([20 30], [30 10],'b') 
 end
 if X(6)==1   
    plot([20 30], [30 10],'b') 
 end
 if X(7)==1   
     plot([20 30], [10 30],'b') 
 end
  if X(8)==1   
     plot([20 30], [10 30],'b') 
  end
 if X(9)==1   
    plot([20 30], [10 20],'b') 
 end
 if X(10)==1   
    plot([20 30], [10 20],'b') 
 end
 if X(11)==1   
    plot([20 30], [10 10],'b') 
 end
 if X(12)==1   
    plot([20 30], [10 30],'b') 
 end
 if X(13)==1   
    plot([30 30], [30 20],'b') 
 end
 if X(14)==1   
    plot([30 30], [30 20],'b') 
 end
  if X(15)==1   
     plot([30 40], [30 30],'b') 
  end
  if X(16)==1   
     plot([30 40], [30 30],'b') 
  end
  if X(17)==1   
     plot([30 40], [30 20],'b') 
  end
  if X(18)==1   
     plot([30 40], [30 20],'b') 
  end
 if X(19)==1   
    plot([30 40], [30 10],'b') 
 end
 if X(20)==1   
    plot([30 40], [30 10],'b') 
 end
 if X(21)==1   
    plot([30 30], [20 10],'b') 
 end
 if X(22)==1   
    plot([30 30], [20 10],'b') 
 end
 if X(23)==1   
    plot([30 40], [20 30],'b') 
 end
 if X(24)==1   
    plot([30 40], [20 30],'b') 
 end
 if X(25)==1   
    plot([30 40 ], [20 20],'b') 
 end
 if X(26)==1   
    plot([30 40 ], [20 20],'b') 
 end
 if X(27)==1   
    plot([30 40], [20 10],'b') 
 end
 if X(28)==1   
    plot([30 40], [20 10],'b') 
 end
 if X(29)==1   
    plot([30 40], [10 30],'b') 
 end
 if X(30)==1   
    plot([30 40], [10 30],'b') 
 end
if X(31)==1   
   plot([30 40], [10 20],'b') 
end
if X(32)==1   
   plot([30 40], [10 20],'b') 
end
 if X(33)==1   
    plot([30 40], [10 10],'b') 
 end
 if X(34)==1   
    plot([30 40], [10 10],'b')  
 end
if X(35)==1   
   plot([40 40], [30 20],'b') 
end
if X(36)==1   
   plot([40 40], [30 20],'b') 
end
if X(37)==1   
   plot([40 40], [20 10],'b') 
end
if X(38)==1   
   plot([40 40], [20 10],'b') 
end
     if X(1+38)==1   
       plot([20 30], [30 30],'r') 
    end
    if X(2+38)==1   
       plot([20 30], [30 30],'r') 
    end
 if X(3+38)==1   
    plot([20 30], [30 20],'r') 
 end
 if X(4+38)==1   
    plot([20 30], [30 20],'r') 
 end
 if X(5+38)==1   
    plot([20 30], [30 10],'r') 
 end
 if X(6+38)==1   
    plot([20 30], [30 10],'r') 
 end
 if X(7+38)==1   
     plot([20 30], [10 30],'r') 
 end
  if X(8+38)==1   
     plot([20 30], [10 30],'r') 
  end
 if X(9+38)==1   
    plot([20 30], [10 20],'r') 
 end
 if X(10+38)==1   
    plot([20 30], [10 20],'r') 
 end
 if X(11+38)==1   
    plot([20 30], [10 10],'r') 
 end
 if X(12+38)==1   
    plot([20 30], [10 30],'r') 
 end
 if X(13+38)==1   
    plot([30 30], [30 20],'r') 
 end
 if X(14+38)==1   
    plot([30 30], [30 20],'r') 
 end
  if X(15+38)==1   
     plot([30 40], [30 30],'r') 
  end
  if X(16+38)==1   
     plot([30 40], [30 30],'r') 
  end
  if X(17+38)==1   
     plot([30 40], [30 20],'r') 
  end
  if X(18+38)==1   
     plot([30 40], [30 20],'r') 
  end
 if X(19+38)==1   
    plot([30 40], [30 10],'r') 
 end
 if X(20+38)==1   
    plot([30 40], [30 10],'r') 
 end
 if X(21+38)==1   
    plot([30 30], [20 10],'r') 
 end
 if X(22+38)==1   
    plot([30 30], [20 10],'r') 
 end
 if X(23+38)==1   
    plot([30 40], [20 30],'r') 
 end
 if X(24+38)==1   
    plot([30 40], [20 30],'r') 
 end
 if X(25+38)==1   
    plot([30 40 ], [20 20],'r') 
 end
 if X(26+38)==1   
    plot([30 40 ], [20 20],'r') 
 end
 if X(27+38)==1   
    plot([30 40], [20 10],'r') 
 end
 if X(28+38)==1   
    plot([30 40], [20 10],'r') 
 end
 if X(29+38)==1   
    plot([30 40], [10 30],'r') 
 end
 if X(30+38)==1   
    plot([30 40], [10 30],'r') 
 end
if X(31+38)==1   
   plot([30 40], [10 20],'r') 
end
if X(32+38)==1   
   plot([30 40], [10 20],'r') 
end
 if X(33+38)==1   
    plot([30 40], [10 10],'r') 
 end
 if X(34+38)==1   
    plot([30 40], [10 10],'r') 
 end
if X(35+38)==1   
   plot([40 40], [30 20],'r') 
end
if X(36+38)==1   
   plot([40 40], [30 20],'r') 
end
if X(37+38)==1   
   plot([40 40], [20 10],'r') 
end
if X(38+38)==1   
   plot([40 40], [20 10],'r') 
end

%Existing lines
   plot([10 20], [20 30],'k') 
   plot([10 20], [20 10],'k') 
 
   
hold off
axis([0 50 0 40]);


