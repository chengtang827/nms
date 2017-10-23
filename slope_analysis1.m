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
        slope_change{i}(j,:) = removeBlacknRed(slope, slope_change{i}(j,:),4,2);
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
binLen = 50;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
    scatter(pre+150:binLen:post-150,distribution(i,:));
%     plot(pre+150:binLen:post-150,distribution(i,:));
end





