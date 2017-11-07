clear;
load('distribution');

location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(distribution));
binStep = 50;
binLen = 300;


for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    ylim([ymin,ymax]);
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    
    hold on;
    %     scatter(pre+binLen/2:binStep:post-binLen/2,distribution(i,:));
    plot(pre+binLen/2:binStep:post-binLen/2,distribution(i,:));
    
    if i~=6
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
    else
        set(gca,'xtick',[]);
        text(0,0,'0','HorizontalAlignment','center','VerticalAlignment','top');
        text(300,0,'0.3','HorizontalAlignment','center','VerticalAlignment','top');
        text(1300,0,'1.3','HorizontalAlignment','center','VerticalAlignment','top');
        text(1600,0,'1.6','HorizontalAlignment','center','VerticalAlignment','top');
    end
    
    if i==4
        ylabel('Number of Cells');
    end
    
    if i==7
        xlabel('Time from Target Onset (s)');
    end
    
end

%shuffle
shuffle = 1000;
start = 800;
index = length(pre+binLen/2:binStep:start);
interval = index:size(distribution,2);
percentile = 100 - 5/length(interval);

% for each location
for i = 1:length(location)
    total = sum(distribution(i,interval));
%     null_distribution = zeros(shuffle,1);
    null_distribution = zeros(shuffle,length(interval));
    
    % for each shuffle out of the 1000 times
    
    for j = 1:shuffle
        r = randi([index, size(distribution, 2)],total,1);
%         null_distribution(j) = max(arrayfun(@(a) sum(r==a),index:size(distribution,2)));
        null_distribution(j,:) = arrayfun(@(a) sum(r==a),interval);
    end
    subplot(3,3,location(i));

    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prctile(null_distribution,percentile));
    
    peak = distribution(i,index:end)>prctile(null_distribution,percentile);
    
    c= zeros(length(x),3);
    c(peak,1) = 1;
    
    scatter(x,zeros(1,length(x)),[],c);
end
