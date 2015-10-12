figure();
hold on;
k=3;
for i = 1:length(ap{k})
   plot(ap{k}(i).t,ap{k}(i).gate_features(1,:),'color','r')
   plot(ap{k}(i).t,ap{k}(i).gate_features(2,:),'color','g')
   plot(ap{k}(i).t,ap{k}(i).gate_features(3,:),'color','b')
   plot(ap{k}(i).t,ap{k}(i).gate_features(4,:),'color','m')
   plot(ap{k}(i).t,ap{k}(i).gate_features(5,:),'color','y')
   plot(ap{k}(i).t,ap{k}(i).gate_features(6,:)*1000,'color','c')

end