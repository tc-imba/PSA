err=[1 0.05 0.005];
vpoint=[42];
data=csvread('PSA.csv');
n=length(data);
time=datenum(num2str(data(:,2)),'yyyymmdd');
timestr=datestr(time,'yyyy-mm-dd');
start=time(1);
time=time-start;
figure(1);
clf;
set(gcf,'position',[0,0,1440,900]);
plot_main(time, data(:,3), vpoint);
%plot(time,data(:,3),'.-','MarkerSize',10);
grid on;
title('PSA plot');
legend('PSA');
ylim([0 37.5]);
set(gca,'YMinorGrid','on')
figure(2);
clf;
set(gcf,'position',[0,0,1440,900]);
plot_main(time, data(:,4), vpoint);
%plot(time,data(:,4),'.-','MarkerSize',10);
grid on;
title('fPSA plot');
legend('fPSA');
ylim([0 2.5]);
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
    legend(gca,'off');
    flag=ones(n);
    num=1;
    for j=n:-1:1
        for k=n:-1:j+1
            if(abs(data(k,i+2)-data(j,i+2))<err(i)&&abs(time(k)-time(j))<300&&flag(k)==1)
                flag(j)=0;
                break;
            end
        end
        symbol=0;
        if(j==1)
            symbol=-3;
        elseif(j==n-8 && i==1)
            symbol=9;
        elseif(j==n-7)
            symbol=15;
        elseif(j==n-6)
            symbol=13;
        elseif(j==n-5)
            symbol=11;
        elseif(j==n-4)
            symbol=9;
        elseif(j==n-3)
            symbol=7;
        elseif(j==n-2)
            symbol=5;
        elseif(j==n-1)
            symbol=3;
        elseif(j==n)
            symbol=1;
        elseif(data(j,i+2)>data(j+1,i+2)&&flag(j))
            symbol=1;
        elseif(flag(j))
            symbol=-1;
        else
            for k=j+1:n
                if(data(j,i+2)>data(k,i+2))
                    if(abs(time(k)-time(j))>300||k==n)
                        symbol=1;
                    end
                else break;
                end
            end
        end
        if(symbol~=0)    
            line(time(j)+[0,50],data(j,i+2)+[0,symbol*err(i)/2],'LineStyle',':');
            text(time(j)+50,data(j,i+2)+symbol*err(i)/2,[num2str(data(j,i+2)) ' (' timestr(j,:) ')']);
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

function plot_main(time, data, vpoint)
    for i=1:size(time,1)-1
        flag=sum(i+1==vpoint)+sum(i==vpoint);
        if (flag==0)
            linestyle='-';
        else
            linestyle='--';
        end
        line([time(i) time(i+1)],[data(i) data(i+1)],'LineStyle',linestyle);
    end
    hold on;
    plot(time,data,'.','MarkerSize',10);
    hold off;
end
