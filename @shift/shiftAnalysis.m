function shift_info = shiftAnalysis(~,pst)
shift_info = cell(pst.data.numSets,1);
n_resp = 20;
l_resp = 100;
s_resp = 100;
bins = pst.data.bins;
delay1 = 700;


for n = 1:pst.data.numSets
    spike_n = pst.data.spike(n,:);
    if ~isempty(spike_n{end})
        location = [1,2,3,4,6,7,8,9];
    else
        location = [1,2,3,4,6,7,8];
    end
    
    resp = cell(length(location),n_resp);
    for i = 1: length(location)        
        spike_n_loc = spike_n{i};
        for j = 1:n_resp
            resp{i,j} = mean(spike_n_loc(:,find(bins(2,:)==(delay1+(j-1)*s_resp)):find(bins(2,:)==(delay1+l_resp+(j-1)*s_resp))),2);
        end        
    end
    resp_mean =  cellfun(@mean,resp);
    
    
    
    info = cell(n_resp,2);
    %delay1
    for i = 1:n_resp
        [~,r1Ind] = sort(resp_mean(:,i),'descend');
        
        data = [resp{r1Ind(1),i}];
        flag = ones(length(resp{r1Ind(1),i}),1);
        total = length(r1Ind);
        current = 1;
        group = {r1Ind(1)};
        pvalues = {};
        while current~=total
            another = 0;
            for j = current+1:total
                data = [data;resp{r1Ind(j),i}];
                flag = [flag;ones(length(resp{r1Ind(j),i}),1)*j];
                [h, ~] = anova1(data, flag,'off');
                if h>0.05
                    group{end} = [group{end} r1Ind(j)];
                else
                    another = 1;
                    pvalues{end+1} = h;
                    break;
                end
            end
            current = j;
            if another==1
                group{end+1} = r1Ind(current);
                data = [resp{r1Ind(current),i}];
                flag = ones(length(resp{r1Ind(current),i}),1)*j;
            end
        end

        info{i,1} = group;
        info{i,2} = pvalues;
    end
    shift_info{n} = SelectivityAnalysis(shift,info,location,resp);
end

end

