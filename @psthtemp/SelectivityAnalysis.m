function SelectivityAnalysis(~, info, location )

minLen = 3;
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


figure(2);
clf;
for i = 1:length(location)
    subplot(3,3,location(i));
    
end


end

