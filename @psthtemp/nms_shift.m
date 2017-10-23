function [shift_neurons, spike] = nms_shift(~, dataset,trials,session,bins )
%[nms,~,~,~,~,~,~,~,~,~] = TwoWayAnova(dataset,trials,session,bins);

% neurons shifted selectivity are those nms
% selective both in dl_sel and d2_sel
% temp = d1_sel(ismember(d1_sel,d2_sel));
% shift_neurons = nms(ismember(nms, temp));

%shift_neurons = nms;
shift_neurons = 1:size(dataset,1);

%resp of the shifted neurons (neuron x location x bin)
spike = cell(length(shift_neurons),8);
for i = 1:length(shift_neurons)
    index = shift_neurons(i);
    tr1 = session(index,1);
    n_trials = length(trials(tr1).val);
    tmp = squeeze(dataset(index,1:n_trials,:));
    tar = AssignTrialLabel(trials(tr1).val,1);
    for j = 1:length(unique(tar))
        ind_tar = tar==j;
        spike{i,j} = tmp(ind_tar,1:end-1);
    end
end

end

