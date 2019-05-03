err=[1 0.05 0.005];
vpoint=[42];
fid=fopen('PSA.csv');
csv_data=textscan(fid, '%f,%f,%f,%f,%f,%s');
data=cell2mat(csv_data(1:5));
str_data=csv_data(6);
str_data=str_data{1};
fclose(fid);
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
title('PSA plot (共计11年)');
legend('PSA');
ylim([0 37.5]);
set(gca,'YMinorGrid','on')
figure(2);
clf;
set(gcf,'position',[0,0,1440,900]);
plot_main(time, data(:,4), vpoint);
%plot(time,data(:,4),'.-','MarkerSize',10);
grid on;
title('fPSA plot (共计11年)');
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
    xlim([0 4500]);
    set(gca,'XTick',365.25:365.25:365.25*11);  
    set(gca,'XTickLabel',{1:11});
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
        elseif(j==n)
            symbol=1;
        elseif(j>=1&&data(j,i+2)==data(j-1,i+2))
            symbol=0;
        elseif(j==n-18 && i==1)
            symbol=9;
        elseif(j==n-17)
            symbol=13;
        elseif(j==n-16)
            symbol=11;
        elseif(j==n-15)
            symbol=9;
        elseif(j==n-14)
            symbol=7;
        elseif(j==n-13)
            symbol=5;
        elseif(j==n-12)
            symbol=3;
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
            normal_data=str_data{j};
            extra_data='';
            max_len=9;
            if length(str_data{j})>max_len
                extra_data=normal_data(max_len+1:end);
                normal_data=normal_data(1:max_len);
            end
            text_str={[num2str(data(j,i+2)) ' (' timestr(j,:) ') ' normal_data], extra_data};
            text(time(j)+50,data(j,i+2)+symbol*err(i)/2,text_str);
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
