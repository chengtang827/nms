%only look at start and end points
% %
% clear;
% load('slope.mat');
% slope_change = sl.data.slope_change;
% slope_change1 = sl.data.slope_change;
% slope_change2 = sl.data.slope_change;
%
% distribution1 = zeros(size(slope_change{1}));
% distribution2 = zeros(size(slope_change{1}));
% % clean
% for i = 1:length(slope_change)
%     for j = 1:size(slope_change{i},1)
%         slope_change{i}(j,:) = removeBlacknRed(slope, slope_change{i}(j,:),4,2);
%         %now just leave the starting and ending points of a change
%         temp = removeMid2(slope, slope_change{i}(j,:));
%         slope_change1{i}(j,:) = temp(1,:);
%         slope_change2{i}(j,:) = temp(2,:);
%     end
% end
%
%
%
%
% %for each location
% for i = 1:size(distribution1,1)
%     for j = 1:length(slope_change)
%         slope_n1 = slope_change1{j};
%         slope_n2 = slope_change2{j};
%         try
%             distribution1(i,:) = distribution1(i,:) + slope_n1(i,:);
%             distribution2(i,:) = distribution2(i,:) + slope_n2(i,:);
%         catch
%         end
%     end
% end
%
% location = [1,2,3,4,6,7,8,9];
% pre = -250;
% post = 2650;
% ymax = max(max([distribution1 distribution2]));
% binStep = 50;
% binLen = 300;
% for i = 1: length(location)
%     subplot(3,3,location(i));
%     xlim([pre,post]);
%
%
%     line([0,0],[0,ymax],'Color','b');
%     line([300,300],[0,ymax],'Color','b');
%     line([1300,1300],[0,ymax],'Color','b');
%     line([1600,1600],[0,ymax],'Color','b');
%     hold on;
%
%     plot(pre+150:binStep:post-150,distribution1(i,:),'Color',[1,0,0]);
%     plot(pre+150:binStep:post-150,distribution2(i,:),'Color',[0,0,1]);
% end
%
% pos = distribution1;
% neg = distribution2;
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
%

%% same, but on the 300ms dataset with goodness-of-fit, cleaned, starting and ending

clear;
sl = slope();
load('slope300_gf.mat');

slope(isnan(slope)) = 0;
slope(slope~=0) = 1;


pos = zeros(size(slope,2),size(slope,3));
neg = pos;

% for each cell
for i = 1:size(slope, 1)
    
    % for each location
    for j = 1:size(slope,2)
        slope(i,j,:) = removeBlacknRed(sl, squeeze(slope(i,j,:)),4,2);
        temp = removeMid2(sl, slope(i,j,:));
        
        pos(j,:) = pos(j,:) + temp(1,:);
        neg(j,:) = neg(j,:) + temp(2,:);
    end
end

location = [1,2,3,4,6,7,8,9];
binStep = 50;
binLen = 300;
pre = -250;% + binLen/2;
post = 2650;% - binLen/2;
ymin = 0;
ymax = max(max(pos));
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
    
    plot(pre+binLen/2:binStep:post-binLen/2,pos(i,:),'Color',[1,0,0],'linewidth',2);
    plot(pre+binLen/2:binStep:post-binLen/2,neg(i,:),'Color',[0,0,1],'linewidth',2);
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

% null_pos = null_pos/length(location);
% null_neg = null_neg/length(location);
% for each location

for i = 1:length(location)
    subplot(3,3,location(i));
    
    
    if i==8
        prc_pos = prctile(null_pos*115/(256*7+115),percentile);
        prc_neg = prctile(null_neg*115/(256*7+115),percentile);
        
    else
        prc_pos = prctile(null_pos*256/(256*7+115),percentile);
        prc_neg = prctile(null_neg*256/(256*7+115),percentile);
    end
    
    x = pre+binLen/2+(index-1)*binStep:binStep:post-binLen/2;
    
    plot(x,prc_pos,'Color','r');
    plot(x,prc_neg,'Color','b');
    
    peak_pos = pos(i,interval)>prc_pos;
    peak_neg = neg(i,interval)>prc_neg;
    y_pos = ones(length(x),1)*ymax;
    y_neg = ones(length(x),1)*ymax-3;
    y_pos(peak_pos==0) = NaN;
    y_neg(peak_neg==0) = NaN;
    
    line([x;x+50],[y_neg';y_neg'],'LineWidth',3,'Color','b');
    line([x;x+50],[y_pos';y_pos'],'LineWidth',3,'Color','r');
end
