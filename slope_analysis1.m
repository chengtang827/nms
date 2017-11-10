%slope different from 0

clear;
load('slope.mat');
%
% load('slopee.mat');
% sl = slopee;
%
slope_change = sl.data.slope_change;

distribution = zeros(size(slope_change{1}));


% clean
for i = 1:length(slope_change)
    for j = 1:size(slope_change{i},1)
%         slope_change{i}(j,:) = removeBlacknRed(slope, slope_change{i}(j,:),4,2);
                slope_change{i}(j,(isnan(slope_change{i}(j,:))))= 0;
        
        %now just leave the starting and ending points of a change
        %  slope_change{i}(j,:) = removeMid(slope, slope_change{i}(j,:));
    end
end




%for each location
for i = 1:size(distribution,1)
    for j = 1:length(slope_change)
        slope_n = slope_change{j};
        
        try
            distribution(i,:) = distribution(i,:) + slope_n(i,:);
        catch
        end
    end
end

location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(distribution));
binStep = 50;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
    %     scatter(pre+150:binLen:post-150,distribution(i,:));
    plot(pre+150:binStep:post-150,distribution(i,:));
end

%%
%look at positive and negative slopes


clear;
load('slope_pn.mat');
%
% load('slopee.mat');
% sl = slopee;
%
slope_pos = slpn.data.slope_pos;
slope_neg = slpn.data.slope_neg;

pos = zeros(size(slope_pos{1}));
neg = pos;

% clean
for i = 1:length(slope_pos)
    for j = 1:size(slope_pos{i},1)
        %         slope_pos{i}(j,:) = removeBlacknRed(slope, slope_pos{i}(j,:),4,2);
        %         slope_neg{i}(j,:) = removeBlacknRed(slope, slope_neg{i}(j,:),4,2);
        slope_pos{i}(j,(isnan(slope_pos{i}(j,:))))= 0;
        
        slope_neg{i}(j,(isnan(slope_neg{i}(j,:))))= 0;
        
        %now just leave the starting and ending points of a change
        %  slope_change{i}(j,:) = removeMid(slope, slope_change{i}(j,:));
    end
end




%for each location
for i = 1:size(pos,1)
    for j = 1:length(slope_pos)
        slope_n_pos = slope_pos{j};
        slope_n_neg = slope_neg{j};
        
        try
            pos(i,:) = pos(i,:) + slope_n_pos(i,:);
            neg(i,:) = neg(i,:) + slope_n_neg(i,:);
        catch
        end
    end
end

location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max([pos neg]));
binStep = 50;
binLen = 300;

for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    ylim([ymin,ymax]);
    
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    hold on;
    %     scatter(pre+150:binLen:post-150,distribution(i,:));
    plot(pre+150:binStep:post-150,pos(i,:),'Color','r');
    plot(pre+150:binStep:post-150,neg(i,:),'Color','b');
    %     plot(pre+150:binLen:post-150,pos(i,:)+neg(i,:),'Color','k');
    
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
interval = index:size(pos,2);
percentile = 100 - 5/length(interval);

% for each location
for i = 1:length(location)
    total_pos = sum(pos(i,interval));
    total_neg = sum(neg(i,interval));
    
    %     null_distribution = zeros(shuffle,1);
    null_pos = zeros(shuffle,length(interval));
    null_neg = zeros(shuffle,length(interval));
    % for each shuffle out of the 1000 times
    
    for j = 1:shuffle
        r_pos = randi([index, size(pos, 2)],total_pos,1);
        %         null_distribution(j) = max(arrayfun(@(a) sum(r==a),index:size(distribution,2)));
        null_pos(j,:) = arrayfun(@(a) sum(r_pos==a),interval);
        
        r_neg = randi([index, size(neg, 2)],total_neg,1);
        %         null_distribution(j) = max(arrayfun(@(a) sum(r==a),index:size(distribution,2)));
        null_neg(j,:) = arrayfun(@(a) sum(r_neg==a),interval);
    end
    subplot(3,3,location(i));
    
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prctile(null_pos,percentile),'Color','r');
    plot(x,prctile(null_neg,percentile),'Color','b');
    
    peak_pos = pos(i,interval)>prctile(null_pos,percentile);
    peak_neg = neg(i,interval)>prctile(null_neg,percentile);
    
    c_pos= zeros(length(x),3);
    c_pos(peak_pos,1) = 1;
        c_neg= zeros(length(x),3);
    c_neg(peak_neg,3) = 1;
    scatter(x,ones(1,length(x))*ymax,[],c_pos);
    scatter(x,ones(1,length(x))*ymax-10,[],c_neg);
end

