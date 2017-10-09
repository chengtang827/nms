clear;
load('slope.mat');
slope_change = sl.data.slope_change;
slope_change1 = sl.data.slope_change;
slope_change2 = sl.data.slope_change;

distribution = zeros(size(slope_change{1}));
distribution1 = zeros(size(slope_change{1}));
distribution2 = zeros(size(slope_change{1}));
% clean
for i = 1:length(slope_change)
    for j = 1:size(slope_change{i},1)
        slope_change{i}(j,:) = removeBlacknRed(slope, slope_change{i}(j,:),4,2);
        %now just leave the starting and ending points of a change
        temp = removeMid2(slope, slope_change{i}(j,:));   
        slope_change1{i}(j,:) = temp(1,:);
        slope_change2{i}(j,:) = temp(2,:);
    end
end




%for each location
for i = 1:size(distribution,1)
    for j = 1:length(slope_change)
        slope_n1 = slope_change1{j};
        slope_n2 = slope_change2{j};
        try
            distribution1(i,:) = distribution1(i,:) + slope_n1(i,:);
            distribution2(i,:) = distribution2(i,:) + slope_n2(i,:);
        catch
        end
    end
end

location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(distribution));
binLen = 50;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
%     scatter(pre+150:binLen:post-150,distribution1(i,:),[],[1,0,0]);
%     scatter(pre+150:binLen:post-150,distribution2(i,:),[],[0,0,1]);
    plot(pre+150:binLen:post-150,distribution1(i,:),'Color',[1,0,0]);
    plot(pre+150:binLen:post-150,distribution2(i,:),'Color',[0,0,1]);
end





