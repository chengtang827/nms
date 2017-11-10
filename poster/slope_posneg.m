%look at positive and negative slopes

%slope_pn is calculating the pos/neg based on one-tail t-test across trials
%without goodness of fit
clear;
load('slope_pn.mat');

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
    
    plot(pre+150:binStep:post-150,pos(i,:),'Color','r','LineWidth',2);
    plot(pre+150:binStep:post-150,neg(i,:),'Color','b','LineWidth',2);
    plot(pre+150:binStep:post-150,pos(i,:)+neg(i,:),'Color','k');
    
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
        null_pos(j,:) = arrayfun(@(a) sum(r_pos==a),interval);
        
        r_neg = randi([index, size(neg, 2)],total_neg,1);
        null_neg(j,:) = arrayfun(@(a) sum(r_neg==a),interval);
    end
    subplot(3,3,location(i));
    
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prctile(null_pos,percentile),'Color','r');
    plot(x,prctile(null_neg,percentile),'Color','b');
    
    peak_pos = pos(i,interval)>prctile(null_pos,percentile);
    peak_neg = neg(i,interval)>prctile(null_neg,percentile);
    y_pos = ones(length(x),1)*ymax;
    y_neg = ones(length(x),1)*ymax-3;
    y_pos(peak_pos==0) = NaN;
    y_neg(peak_neg==0) = NaN;
    
    line([x;x+50],[y_neg';y_neg'],'LineWidth',3,'Color','b');
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color','r');
end
%%
clear;
load('slope300_gf.mat');
% 241 cells (filtered out those with st_dl<1)
% slope is calculated based on normalized averaged response accross trials
% considered goodness of fit
pos = zeros(size(slope));
neg = pos;

pos(slope>0) = 1;
neg(slope<0) = 1;

pos = squeeze(sum(pos,1));
neg = squeeze(sum(neg,1));

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
    plot(pre+150:binStep:post-150,pos(i,:),'Color','r','LineWidth',2);
    plot(pre+150:binStep:post-150,neg(i,:),'Color','b','LineWidth',2);
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
        null_pos(j,:) = arrayfun(@(a) sum(r_pos==a),interval);
        
        r_neg = randi([index, size(neg, 2)],total_neg,1);
        null_neg(j,:) = arrayfun(@(a) sum(r_neg==a),interval);
    end
    subplot(3,3,location(i));
    
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prctile(null_pos,percentile),'Color','r');
    plot(x,prctile(null_neg,percentile),'Color','b');
    
    peak_pos = pos(i,interval)>prctile(null_pos,percentile);
    peak_neg = neg(i,interval)>prctile(null_neg,percentile);
    y_pos = ones(length(x),1)*ymax;
    y_neg = ones(length(x),1)*ymax-3;
    y_pos(peak_pos==0) = NaN;
    y_neg(peak_neg==0) = NaN;
    
    line([x;x+50],[y_neg';y_neg'],'LineWidth',3,'Color','b');
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color','r');
end

%% same as the last section, but the null shuffle is across 7 locations and

%divided by 7
clear;
load('slope300_gf.mat');
% 241 cells (filtered out those with st_dl<1)
% slope is calculated based on normalized averaged response accross trials
% considered goodness of fit
pos = zeros(size(slope));
neg = pos;

pos(slope>0) = 1;
neg(slope<0) = 1;

pos = squeeze(sum(pos,1));
neg = squeeze(sum(neg,1));

location = [1,2,3,4,6,7,8];
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
    plot(pre+150:binStep:post-150,pos(i,:),'Color','r','LineWidth',2);
    plot(pre+150:binStep:post-150,neg(i,:),'Color','b','LineWidth',2);
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
shuffle = 10000;
start = 800;
index = length(pre+binLen/2:binStep:start);
interval = index:size(pos,2);
percentile = 100 - 5/length(interval);

total_pos = sum(sum(pos(:,interval)));
total_neg = sum(sum(neg(:,interval)));

null_pos = zeros(shuffle,length(interval));
null_neg = zeros(shuffle,length(interval));

for i = 1:shuffle
    r_pos = randi([index, size(pos, 2)],total_pos,1);
    null_pos(i,:) = arrayfun(@(a) sum(r_pos==a),interval);
    
    r_neg = randi([index, size(neg, 2)],total_neg,1);
    null_neg(i,:) = arrayfun(@(a) sum(r_neg==a),interval);
end

null_pos = null_pos/length(location);
null_neg = null_neg/length(location);
% for each location

for i = 1:length(location)
    subplot(3,3,location(i));
    
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prctile(null_pos,percentile),'Color','r');
    plot(x,prctile(null_neg,percentile),'Color','b');
    
    peak_pos = pos(i,interval)>prctile(null_pos,percentile);
    peak_neg = neg(i,interval)>prctile(null_neg,percentile);
    y_pos = ones(length(x),1)*ymax;
    y_neg = ones(length(x),1)*ymax-3;
    y_pos(peak_pos==0) = NaN;
    y_neg(peak_neg==0) = NaN;
    
    line([x;x+50],[y_neg';y_neg'],'LineWidth',3,'Color','b');
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color','r');
end
%% same as the last section, but sum up pos and neg, and the 8th location scaled to cell proportion
clear;
load('slope300_gf.mat');
% 241 cells (filtered out those with st_dl<1)
% slope is calculated based on normalized averaged response accross trials
% considered goodness of fit
pos = zeros(size(slope));


pos(slope~=0&~isnan(slope)) = 1;
%pos is actually non-zeros

pos = squeeze(sum(pos,1));


location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(pos));
binStep = 50;
binLen = 300;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    ylim([ymin,ymax]);
    
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    hold on;
    
    plot(pre+150:binStep:post-150,pos(i,:),'Color',[0.5, 0, 0.5],'LineWidth',2);
    
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

total_pos = sum(sum(pos(:,interval)));

null_pos = zeros(shuffle,length(interval));

for i = 1:shuffle
    r_pos = randi([index, size(pos, 2)],total_pos,1);
    null_pos(i,:) = arrayfun(@(a) sum(r_pos==a),interval);
end


% for each location

for i = 1:length(location)
    subplot(3,3,location(i));
    
    if i==8
        prc = prctile(null_pos*111/(241*7+111),percentile);
    else
        prc = prctile(null_pos*241/(241*7+111),percentile);
    end
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prc,'Color',[0.5, 0, 0.5]);
    
    peak_pos = pos(i,interval)>prc;
    y_pos = ones(length(x),1)*ymax;
    y_pos(peak_pos==0) = NaN;
    
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color',[0.5, 0, 0.5]);
end
%% same as the last section, but on the 120/20 resolution data
clear;
load('slope120_gf.mat');
load('dataset_overlapbins_fefdl','st_dl');
slope = slope120;
slope = slope(st_dl>3,:,:);
% 241 cells (filtered out those with st_dl<1)
% slope is calculated based on normalized averaged response accross trials
% considered goodness of fit
pos = zeros(size(slope));


pos(slope~=0&~isnan(slope)) = 1;
%pos is actually non-zeros

pos = squeeze(sum(pos,1));


location = [1,2,3,4,6,7,8,9];
binStep = 20;
binLen = 120;
pre = -300 + binLen/2;
post = 2600 - binLen/2;
ymin = 0;
ymax = max(max(pos));


for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    ylim([ymin,ymax]);
    
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    hold on;
    
    plot(pre+binLen/2:binStep:post-binLen/2,pos(i,:),'Color',[0.5, 0, 0.5],'LineWidth',2);
    
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
shuffle = 10000;
start = 800;
index = length(pre+binLen/2:binStep:start);
interval = index:size(pos,2);
percentile = 100 - 5/length(interval);

total_pos = sum(sum(pos(:,interval)));

null_pos = zeros(shuffle,length(interval));

for i = 1:shuffle
    r_pos = randi([index, size(pos, 2)],total_pos,1);
    null_pos(i,:) = arrayfun(@(a) sum(r_pos==a),interval);
end


% for each location

for i = 1:length(location)
    subplot(3,3,location(i));
    
    if i==8
        prc = prctile(null_pos*102/(217*7+102),percentile);
    else
        prc = prctile(null_pos*217/(217*7+102),percentile);
    end
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prc,'Color',[0.5, 0, 0.5]);
    
    peak_pos = pos(i,interval)>prc;
    y_pos = ones(length(x),1)*ymax;
    y_pos(peak_pos==0) = NaN;
    
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color',[0.5, 0, 0.5]);
end
% %% save as last, but split pos and neg
% clear;
% load('slope120_gf.mat');
% slope = slope120;
% % 241 cells (filtered out those with st_dl<1)
% % slope is calculated based on normalized averaged response accross trials
% % considered goodness of fit
% pos = zeros(size(slope));
% neg = pos;
% 
% pos(slope>0) = 1;
% neg(slope<0) = 1;
% 
% pos = squeeze(sum(pos,1));
% neg = squeeze(sum(neg,1));
% 
% location = [1,2,3,4,6,7,8,9];
% binStep = 20;
% binLen = 120;
% pre = -300 + binLen/2;
% post = 2600 - binLen/2;
% ymin = 0;
% ymax = max(max([pos neg]));
% 
% for i = 1: length(location)
%     subplot(3,3,location(i));
%     xlim([pre,post]);
%     ylim([ymin,ymax]);
%     
%     rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
%     rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
%     hold on;
%     %     scatter(pre+150:binLen:post-150,distribution(i,:));
%     plot(pre+binLen/2:binStep:post-binLen/2,pos(i,:),'Color','r','LineWidth',2);
%     plot(pre+binLen/2:binStep:post-binLen/2,neg(i,:),'Color','b','LineWidth',2);
%     %     plot(pre+150:binLen:post-150,pos(i,:)+neg(i,:),'Color','k');
%     
%     if i~=6
%         set(gca,'xtick',[]);
%         set(gca,'ytick',[]);
%     else
%         set(gca,'xtick',[]);
%         text(0,0,'0','HorizontalAlignment','center','VerticalAlignment','top');
%         text(300,0,'0.3','HorizontalAlignment','center','VerticalAlignment','top');
%         text(1300,0,'1.3','HorizontalAlignment','center','VerticalAlignment','top');
%         text(1600,0,'1.6','HorizontalAlignment','center','VerticalAlignment','top');
%     end
%     
%     if i==4
%         ylabel('Number of Cells');
%     end
%     
%     if i==7
%         xlabel('Time from Target Onset (s)');
%     end
% end
% 
% %shuffle
% shuffle = 1000;
% start = 800;
% index = length(pre+binLen/2:binStep:start);
% interval = index:size(pos,2);
% percentile = 100 - 5/length(interval);
% 
% total_pos = sum(sum(pos(:,interval)));
% total_neg = sum(sum(neg(:,interval)));
% 
% null_pos = zeros(shuffle,length(interval));
% null_neg = zeros(shuffle,length(interval));
% 
% for i = 1:shuffle
%     r_pos = randi([index, size(pos, 2)],total_pos,1);
%     null_pos(i,:) = arrayfun(@(a) sum(r_pos==a),interval);
%     
%     r_neg = randi([index, size(neg, 2)],total_neg,1);
%     null_neg(i,:) = arrayfun(@(a) sum(r_neg==a),interval);
% end
% 
% % null_pos = null_pos/length(location);
% % null_neg = null_neg/length(location);
% % for each location
% 
% for i = 1:length(location)
%     subplot(3,3,location(i));
%     
%     
%     if i==8
%         prc_pos = prctile(null_pos*115/(256*7+115),percentile);
%                 prc_neg = prctile(null_neg*115/(256*7+115),percentile);
% 
%     else
%         prc_pos = prctile(null_pos*256/(256*7+115),percentile);
%         prc_neg = prctile(null_neg*256/(256*7+115),percentile);
%     end
%     
%     x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
%     
%     plot(x,prc_pos,'Color','r');
%     plot(x,prc_neg,'Color','b');
%     
%     peak_pos = pos(i,interval)>prc_pos;
%     peak_neg = neg(i,interval)>prc_neg;
%     y_pos = ones(length(x),1)*ymax;
%     y_neg = ones(length(x),1)*ymax-3;
%     y_pos(peak_pos==0) = NaN;
%     y_neg(peak_neg==0) = NaN;
%     
%     line([x;x+50],[y_neg';y_neg'],'LineWidth',3,'Color','b');
%     line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color','r');
% end
%% points cleaning, look at starting and ending points
clear;
sl = slope();
load('slope300_gf.mat');
% 241 cells (filtered out those with st_dl<1)
% slope is calculated based on normalized averaged response accross trials
% considered goodness of fit
slope(isnan(slope)) = 0;
slope(slope~=0) = 1;

for i = 1:size(slope,1)
    for j = 1:size(slope,2)
        slope(i,j,:) = removeBlacknRed(sl, slope(i,j,:),4,2);
        
        %now just leave the starting and ending points of a change
        %  slope_change{i}(j,:) = removeMid(slope, slope_change{i}(j,:));
    end
end

%pos is changing point
pos = zeros(size(slope));


pos(slope~=0&~isnan(slope)) = 1;
%pos is actually non-zeros

pos = squeeze(sum(pos,1));


location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(pos));
binStep = 50;
binLen = 300;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    ylim([ymin,ymax]);
    
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    hold on;
    
    plot(pre+150:binStep:post-150,pos(i,:),'Color',[0.5, 0, 0.5],'LineWidth',2);
    
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
shuffle = 10000;
start = 800;
index = length(pre+binLen/2:binStep:start);
interval = index:size(pos,2);
percentile = 100 - 5/length(interval);

total_pos = sum(sum(pos(:,interval)));

null_pos = zeros(shuffle,length(interval));

for i = 1:shuffle
    r_pos = randi([index, size(pos, 2)],total_pos,1);
    null_pos(i,:) = arrayfun(@(a) sum(r_pos==a),interval);
end


% for each location

for i = 1:length(location)
    subplot(3,3,location(i));
    
    if i==8
        prc = prctile(null_pos*111/(241*7+111),percentile);
    else
        prc = prctile(null_pos*241/(241*7+111),percentile);
    end
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    
    plot(x,prc,'Color',[0.5, 0, 0.5]);
    
    peak_pos = pos(i,interval)>prc;
    y_pos = ones(length(x),1)*ymax;
    y_pos(peak_pos==0) = NaN;
    
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color',[0.5, 0, 0.5]);
end