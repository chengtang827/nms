
load('shift.mat');

shift_info = sh.data.shift_info;

total = 0;
after_onset = 0;
during = 0;
% for each cell
for i = 1:length(shift_info)
    shift_n = shift_info{i};
    
    % for each locaion
    for j = 1:length(shift_n)
        shift_n_loc = shift_n{j};
        
        if isfield(shift_n_loc,'g1')
            total = total + length(shift_n_loc);
            
            % for each shift
            for k = 1:length(shift_n_loc)
                
                % a shift after distractor onset
                if shift_n_loc(k).end>=1300
                    after_onset = after_onset + 1;
                    
                    %a shift during distractor present
                    if shift_n_loc(k).begin<=1600
                        during = during + 1;
                    end
                end
            end
        end
    end
end

%% shift of peak
%not a good analysis
peak_shift = cell(length(shift_info),1);

%for each cell
for i = 1:length(shift_info)
    shift_n = shift_info{i};
    
    lose = [];
    get =[];
    
    % for each locaion
    for j = 1:length(shift_n)
        shift_n_loc = shift_n{j};
        
        if isfield(shift_n_loc,'g1')
            % for each shift
            for k = 1:length(shift_n_loc)
                
                
                if shift_n_loc(k).g1 == 1 %lose peak
                    lose = [lose;j shift_n_loc(k).begin, shift_n_loc(k).end];
                elseif shift_n_loc(k).g2 == 1%get peak
                    get = [get;j shift_n_loc(k).begin, shift_n_loc(k).end];
                end
                
            end
        end
    end
    
    %compare the get and lose information
    % for each one in the get
    
    for j = 1:size(get,1)
        
        for k = 1:size(lose,1)
            if abs(get(j,2)-lose(k,3))<=200||abs(get(j,3)-lose(k,2))<=200
                if isempty(peak_shift{i})
                    peak_shift{i} = struct('lose',[],'get',[]);
                end
                peak_shift{i}.lose = [peak_shift{i}.lose   lose(k,1)];
                peak_shift{i}.get = [peak_shift{i}.get   get(j,1)];
                
            end
        end
        
    end
    
    
end
%%
