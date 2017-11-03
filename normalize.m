clear;
load('psthtemp.mat');
spike = pst.data.spike;

% for each cell
for i = 1:size(spike,1)
    
    %for each location
    baseline = 0;
    if isempty(spike{i,8})
        location = 7;
    else
        location = 8;
    end
    for j = 1:location
        spike_ij = spike{i,j};
        baseline = baseline + mean(mean(spike_ij(:,1:5)));
    end
    baseline = baseline/location;
    
    for j = 1:location
        spike{i,j} = spike{i,j}/baseline;
        pst.data.spike{i,j} = spike{i,j};
    end
    
    
end
