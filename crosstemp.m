clear;
load('dataset_overlapbins_fefdl.mat');

performance = cell(10,1);

for i = 1:length(performance)
    tic;
    performance{i} = Decode_final_temporal_v2(dataset_dl, m_dl, st_dl, session_dl,'target' ,trials_dl,bins_overlap, etrials_dl, dataset_e_dl, m_e_dl, st_e_dl, 'Correct' );
    toc;
end

ave = zeros(size(performance{1}));

for i = 1:length(performance)
    ave = ave + performance{i};
end
ave = ave./length(performance);