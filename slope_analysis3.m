%separate for monkeys

clear;
load('slope.mat');
load('dataset_overlapbins_fefdl.mat');
load('psthtemp.mat');

group = pst.data.shift_neurons;
group1 = group(group<116);
group2 = group(group>=116);

% load('slopee.mat');
% sl = slopee;
%
slope_change = sl.data.slope_change;




% clean
for i = 1:length(slope_change)
    for j = 1:size(slope_change{i},1)
        slope_change{i}(j,:) = removeBlacknRed(slope, slope_change{i}(j,:),4,2);
        %now just leave the starting and ending points of a change
      %  slope_change{i}(j,:) = removeMid(slope, slope_change{i}(j,:));        
    end
end

distribution1 = zeros(8,size(slope_change{1},2));
distribution2 = zeros(7,size(slope_change{1},2));


%for the first monkey
%for each location
for i = 1:size(distribution1,1)
    
    %for each cell in group1
    for j = 1:length(group1)
        slope_n = slope_change{j};
        
        try
            distribution1(i,:) = distribution1(i,:) + slope_n(i,:);
        catch
        end
    end
    
end

%for the second monkey
%for each location
for i = 1:size(distribution2,1)
    
    %for each cell in group1
    for j = length(group1)+1:length(slope_change)
        slope_n = slope_change{j};
        
        try
            distribution2(i,:) = distribution2(i,:) + slope_n(i,:);
        catch
        end
    end
    
end

figure(1);
location = [1,2,3,4,6,7,8,9];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(distribution1));
binLen = 50;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
    scatter(pre+150:binLen:post-150,distribution1(i,:));
%     plot(pre+150:binLen:post-150,distribution(i,:));
end

figure(2);
location = [1,2,3,4,6,7,8];
pre = -250;
post = 2650;
ymin = 0;
ymax = max(max(distribution2));
binLen = 50;
for i = 1: length(location)
    subplot(3,3,location(i));
    xlim([pre,post]);
    
    
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    hold on;
    scatter(pre+150:binLen:post-150,distribution2(i,:));
%     plot(pre+150:binLen:post-150,distribution(i,:));
end




