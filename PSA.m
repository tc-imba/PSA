err=[1 0.05 0.005];
data=csvread('PSA.csv');
n=length(data);
time=datenum(num2str(data(:,2)),'yyyymmdd');
timestr=datestr(time,'yyyy-mm-dd');
start=time(1);
time=time-start;
figure(1);
set(gcf,'position',[0,0,1440,900]);
plot(time,data(:,3),'.-','MarkerSize',10);
grid on;
title('PSA plot');
legend('PSA');
ylim([0 35]);
set(gca,'YMinorGrid','on')
figure(2);
set(gcf,'position',[0,0,1440,900]);
plot(time,data(:,4),'.-','MarkerSize',10);
grid on;
title('fPSA plot');
legend('fPSA');
ylim([0.4 2.5]);
set(gca,'YMinorGrid','on')
% figure(3)
% plot(time,data(:,5),'.-','MarkerSize',10);
% grid on;
% title('fPSA/tPSA plot');
% legend('fPSA/tPSA');
% ylim([0.05 0.11]);
for i=1:2
    figure(i);
    xlim([0 4000]);
    set(gca,'XTick',365.25:365.25:365.25*10);  
    set(gca,'XTickLabel',{1:10});
    xlabel('year');
    flag=ones(n);
    num=1;
    for j=1:n
        for k=1:j-1
            if(abs(data(k,i+2)-data(j,i+2))<err(i)&&abs(time(k)-time(j))<300&&flag(k)==1)
                flag(j)=0;
                break;
            end
        end
        if(flag(j))
            text(time(j),data(j,i+2)-err(i)/2,[num2str(data(j,i+2)) ' (' timestr(j,:) ')']);
            num=num+1;
        end
    end
end
figure(1);
frame=getframe(gcf);
imwrite(frame.cdata,'PSA.png');
% saveas(gcf,'PSA.png','psc2');
figure(2);
frame=getframe(gcf);
imwrite(frame.cdata,'fPSA.png');
% saveas(gcf,'fPSA.png','psc2');