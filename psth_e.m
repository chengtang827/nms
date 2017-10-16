clear;
load('dataset_overlapbins_fefdl.mat');
load('psthtemp.mat');

shift_neurons = pst.data.shift_neurons;

spike = cell(length(shift_neurons),8);
for i = 1:length(shift_neurons)
    index = shift_neurons(i);
    tr1 = session_dl(index,1);
    n_trials = length(etrials(tr1).val);
    tmp = squeeze(dataset_e_dl(index,1:n_trials,:));
    tar = AssignTrialLabel(etrials(tr1).val,1);
    for j = 1:length(unique(tar))
        ind_tar = tar==j;
        spike{i,j} = tmp(ind_tar,1:end-1);
    end
end

pst.data.spike = spike;
pste = pst;
save('psthtempe.mat','pste');