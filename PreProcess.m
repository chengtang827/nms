function [dataset_dl, bins_overlap] = PreProcess(dataset,trials,session)
bins = -300:1:2600;
bin_width = 120;
bin_step = 20;


bins_overlap = -300:bin_step:2600;
bins_overlap(2,:) = bins_overlap(1,:) + bin_width;

dataset_dl = zeros(size(dataset,1), size(dataset,2), size(bins_overlap,2)-bin_width/bin_step);

for i = 1:size(dataset,1)
    for k = 1:(size(bins_overlap,2)-bin_width/bin_step)
        
        ind1 = find(bins==bins_overlap(1,k));
        ind2 = find(bins==bins_overlap(2,k))-1;
        for j = 1:size(dataset,2)
            dataset_dl(i,j,k) = squeeze(sum(dataset(i,j,ind1:ind2)))/(bin_width/1000);
        end
    end
end

% baseline_ind = find(bins_overlap(2,:)==0);
% for i = 1:size(dataset_rate,1)
%     sess = session(i,1);
%     tr = length(trials(sess).val);
%     m(i) = squeeze(mean(mean(dataset_rate(i,1:tr,1:baseline_ind),3),2));
%     st(i) = squeeze(std(mean(dataset_rate(i,1:tr,1:baseline_ind),3),[],2));
% end
% m = m';
% st = st';