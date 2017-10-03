function [shift_info, fisher] = SelectivityAnalysis(~, info, location,resp,minLen)
%if 3 consecutive windows have the same color, it is recognized as a group


grouping = zeros(length(location),length(info));

% for each time bin
for i = 1:length(info)
    
    %if only one group
    if length(info{i,1}) == 1
        grouping(:,i) = 0;
    else
        %for each group
        for j = 1:length(info{i,1})
            
            %for each location
            for k = 1:length(info{i,1}{j})
                grouping(info{i,1}{j}(k),i) = j;
            end
        end
    end
end

%filter those less than minLen
tgrouping = grouping;
count = ones(length(location),1);
for i = 2:length(info)
    compare = tgrouping(:,i)==tgrouping(:,i-1);
    count = count + compare;
    
    off = compare==0;
    short = count<minLen;
    remove = find(short&off==1);
    
    for j = 1:length(remove)
        grouping(remove(j),i-count(remove(j)):i-1)=-1;
    end
    count(off) = 1;
    
    if i == length(info) %the last one
        remove = count<minLen;
        remove = find(remove==1);
        for j = 1:length(remove)
            grouping(remove(j),i-count(remove(j))+1:i)=-1;
        end
    end
end

%compute the fisher's discriminant over the groups
fisher = zeros(length(info),1);

%for each time bin
for i = 1:length(info)
    group = unique(tgrouping(:,i));
    mean_var = zeros(length(group),2);
    
    %for each group, compute the mean and var
    for j = 1:length(group)
        locs = find(tgrouping(:,i)==j);
        data = [];
        
        %for each location in that group
        for k = 1:length(locs)
            data = [data;resp{locs(k),i}];
        end
        
        mean_var(j,1) = mean(data);%mean
        mean_var(j,2) = var(data);%variance
        
    end
    
    %compute fisher's discriminant
    f = 0;
    
    if length(group)>1
        for j = 1:length(group)
            for k = j+1:length(group)
                multi = sum(tgrouping(:,i)==j)+sum(tgrouping(:,i)==k);
                f = f + multi*(mean_var(j,1)-mean_var(k,1))^2/(mean_var(j,2)+mean_var(k,2));
            end
        end
        
        f = f/(length(group)-1);
    end
    fisher(i) = f;
end


%summarize the grouping of this neuron
group_info = cell(length(location),1);
for i = 1:length(location)
    
    loc_group = grouping(i,:);
    group_info{i} = struct;
    len = 1;
    for j = 2:length(loc_group)
        if loc_group(j)~=loc_group(j-1)
            group_info{i}(end).group = loc_group(j-1);
            group_info{i}(end).length = len;
            
            group_info{i}(end+1).group = [];
            group_info{i}(end).length = [];
            
            len = 1;
        else
            len = len+1;
        end
        if j == length(loc_group)
            group_info{i}(end).group = loc_group(j);
            group_info{i}(end).length = len;
        end
    end
end

%summarize the shift of this neuron
max_shift_len = 3;
shift_info = cell(length(location),1);

for i = 1:length(location)
    shift_info{i} = struct;
    g1 = [];
    g2 = [];
    pos = 0;
    count = 1;
    begi = 0;
    en = 0;
    for j = 1:length(group_info{i})
        pos = pos + group_info{i}(j).length;
        
        if group_info{i}(j).group~=-1
            if isempty(g1)
                g1 = group_info{i}(j).group;
                begi = pos;
            elseif group_info{i}(j).group~=g1
                g2 = group_info{i}(j).group;
                en = pos - group_info{i}(j).length;
            else
                begi = pos;
            end
            
            
        else %the group is -1
            if group_info{i}(j).length>=minLen
                %means the gap is too big
                if isempty(g1)
                    g1 = group_info{i}(j).group;
                    begi = pos;
                elseif group_info{i}(j).group~=g1
                    g2 = group_info{i}(j).group;
                    en = pos - group_info{i}(j).length;
                else
                    begi = pos;
                end
            else
                continue;
            end
        end
        
        %see if there is a shift
        if ~isempty(g1)&&~isempty(g2)
            shift_info{i}(count).g1 = g1;
            shift_info{i}(count).g2 = g2;
            shift_info{i}(count).begin = 650 + begi*100;
            shift_info{i}(count).end = 650 + en*100;
            count = count + 1;
            
            g1 = g2;
            g2 = [];
            begi = pos;
        end
        
    end
end


end

