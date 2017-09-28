function [obj, varargout] = plot(obj,varargin)
%@dirfiles/plot Plot function for dirfiles object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.

Args = struct('UnequalVar',0,'Analysis',4,'n_resp',20,'l_resp',100,'s_resp',100,'GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
    'ReturnVars',{''}, 'ArgsOnly',0);
Args.flags = {'ArgsOnly','UnequalVar'};
[Args,~] = getOptArgs(varargin,Args);

% if user select 'ArgsOnly', return only Args structure for an empty object
if Args.ArgsOnly
    Args = rmfield (Args, 'ArgsOnly');
    varargout{1} = {'Args',Args};
    return;
end

if(~isempty(Args.NumericArguments))
    % plot one data set at a time
    n = Args.NumericArguments{1};
else
    % plot all data
    n = 1;
end

% add code for plot options here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Args.UnequalVar
    var = 'Unequal';
else
    var = 'equal';
end

delay1 = 700;
delay2 = 1900;

spike_all = obj.data.spike;

binLen = obj.data.Args.binLen;
pre = obj.data.Args.pre;
post = obj.data.Args.post;
bins = obj.data.bins;

n_resp = Args.n_resp;
l_resp = Args.l_resp;
s_resp = Args.s_resp;


spike_n = spike_all(n,:);

spike_n_mean = cellfun(@mean,spike_n,'UniformOutput',0);
ymax = max(cellfun(@max,spike_n_mean));
ymin = min(cellfun(@min,spike_n_mean(1:end-1)));

if ~isempty(spike_n{end})
    location = [1,2,3,4,6,7,8,9];
else
    location = [1,2,3,4,6,7,8];
end

resp1 = cell(length(location),n_resp);
resp2 = cell(length(location),1);

for i = 1: length(location)
    subplot(3,3,location(i));
    plot(pre:binLen:post,spike_n_mean{i});
    xlim([pre,post]);
    ylim([ymin, ymax]);
    
    %draw target and distractor periods
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    
    spike_n_loc = spike_n{i};
    %draw the response lines of stepwise 500 ms
    for j = 1:n_resp
        resp1{i,j} = mean(spike_n_loc(:,find(bins(2,:)==(delay1+(j-1)*s_resp)):find(bins(2,:)==(delay1+l_resp+(j-1)*s_resp))),2);
    end
    resp2{i} = mean(spike_n_loc(:,find(bins(2,:)==delay2):find(bins(2,:)==(delay2+l_resp))),2);
    
end


resp1_mean =  cellfun(@mean,resp1);
resp2_mean = cellfun(@mean,resp2);
switch Args.Analysis
    case 0 % show all responses and highlight the peak
        %compare the responses
        
        [~,r2Ind] = max(resp2_mean);
        for i = 1:length(location)
            subplot(3,3,location(i));
            
            if i==r2Ind
                line([delay2-50,delay2+l_resp-50],[resp2_mean(i),resp2_mean(i)],'Color',[1,0,0]);
            else
                line([delay2-50,delay2+l_resp-50],[resp2_mean(i),resp2_mean(i)],'Color',[0,0,0]);
            end
        end
        
        for j = 1:n_resp
            [~,r1Ind] = max(resp1_mean(:,j));
            
            for i = 1:length(location)
                subplot(3,3,location(i));
                
                if i==r1Ind
                    line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(i,j),resp1_mean(i,j)],'Color',[1,0,0])
                else
                    line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(i,j),resp1_mean(i,j)],'Color',[0,0,0])
                end
            end
        end
        
        
    case 1 % show only the peak responses
        % and highlight the peaks significantly different from the second highest peak
        [~,r2Ind] = sort(resp2_mean,'descend');
        
        %peform t-test with the second highest peak
        sig_diff = ttest2(resp2{r2Ind(1)},resp2{r2Ind(2)},'vartype',var);
        
        subplot(3,3,location(r2Ind(1)));
        if sig_diff
            line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(1)),resp2_mean(r2Ind(1))],'Color',[1,0,0]);
        else
            line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(1)),resp2_mean(r2Ind(1))],'Color',[0,0,0]);
        end
        
        
        
        for j = 1:n_resp
            [~,r1Ind] = sort(resp1_mean(:,j),'descend');
            
            %peform t-test with the second highest peak
            [sig_diff,p] = ttest2(resp1{r1Ind(1),j},resp1{r1Ind(2),j},'vartype',var);
            subplot(3,3,location(r1Ind(1)));
            
            if sig_diff
                line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(1),j),resp1_mean(r1Ind(1),j)],'Color',[1,0,0]);
            else
                line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(1),j),resp1_mean(r1Ind(1),j)],'Color',[0,0,0]);
            end
            
            
        end
        
    case 2
        %plot the most 3 in red, least 3 in green
        [~,r2Ind] = sort(resp2_mean,'descend');
        for i = 1:3
            subplot(3,3,location(r2Ind(i)));
            line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(i)),resp2_mean(r2Ind(i))],'Color',[1-0.2*i,0,0]);
            subplot(3,3,location(r2Ind(end+1-i)));
            line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(end+1-i)),resp2_mean(r2Ind(end+1-i))],'Color',[0,1-0.2*i,0]);
            
            
        end
        
        for j = 1:n_resp
            [~,r1Ind] = sort(resp1_mean(:,j),'descend');
            for i = 1:3
                subplot(3,3,location(r1Ind(i)));
                line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(i),j),resp1_mean(r1Ind(i),j)],'Color',[1-0.2*i,0,0]);
                subplot(3,3,location(r1Ind(end+1-i)));
                line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(end+1-i),j),resp1_mean(r1Ind(end+1-i),j)],'Color',[0,1-0.2*i,0]);
                
            end
        end
        
    case 3
        %compare the most/least locations
        [~,r2Ind] = sort(resp2_mean,'descend');
        
        diff = resp2_mean(r2Ind(1))-resp2_mean(r2Ind(end));
        
        subplot(3,3,location(r2Ind(1)));
        line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(1)),resp2_mean(r2Ind(1))],'Color',[1,0,0]);
        line([delay2,delay2],[resp2_mean(r2Ind(1)),resp2_mean(r2Ind(1))-diff],'Color',[1,0,0]);
        
        subplot(3,3,location(r2Ind(end)));
        line([delay2-50,delay2+l_resp-50],[resp2_mean(r2Ind(end)),resp2_mean(r2Ind(end))],'Color',[0,1,0]);
        
        for j = 1:n_resp
            [~,r1Ind] = sort(resp1_mean(:,j),'descend');
            
            diff = resp1_mean(r1Ind(1),j) - resp1_mean(r1Ind(end),j);
            
            subplot(3,3,location(r1Ind(1)));
            line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(1),j),resp1_mean(r1Ind(1),j)],'Color',[1,0,0]);
            line([delay1+(j-1)*s_resp,delay1+(j-1)*s_resp],[resp1_mean(r1Ind(1),j),resp1_mean(r1Ind(1),j)-diff],'Color',[1,0,0]);
            
            
            subplot(3,3,location(r1Ind(end)));
            line([delay1+(j-1)*s_resp-50,delay1+l_resp+(j-1)*s_resp-50],[resp1_mean(r1Ind(end),j),resp1_mean(r1Ind(end),j)],'Color',[0,1,0]);
        end
        
    case 4
        %iterative anova1 test to group locations
        %if there is only one group, line is black
        
        
        info = cell(n_resp,2);
        %delay1
        for i = 1:n_resp
            [~,r1Ind] = sort(resp1_mean(:,i),'descend');
            
            data = [resp1{r1Ind(1),i}];
            flag = ones(length(resp1{r1Ind(1),i}),1);
            total = length(r1Ind);
            current = 1;
            group = {r1Ind(1)};
            pvalues = {};
            while current~=total
                another = 0;
                for j = current+1:total
                    data = [data;resp1{r1Ind(j),i}];
                    flag = [flag;ones(length(resp1{r1Ind(j),i}),1)*j];
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
                    data = [resp1{r1Ind(current),i}];
                    flag = ones(length(resp1{r1Ind(current),i}),1)*j;
                end
            end
            
            for j = 1:length(group)
                g = group{j};
                for k = 1:length(g)
                    subplot(3,3,location(g(k)));
                    c = [0,0,0];
                    try
                        thickness = 3+2^((0.05-pvalues{j})*80);
                    catch
                        if length(group)~=1
                            thickness = 3+2^((0.05-pvalues{end})*80);
                        else
                            thickness = 3;
                        end
                    end
                    
                    if length(group)~=1
                        bc= de2bi(j);
                        c(1:length(bc)) = bc;
                        
                    end
                    line([delay1+(i-1)*s_resp-50,delay1+l_resp+(i-1)*s_resp-50],[resp1_mean(g(k),i),resp1_mean(g(k),i)],'Color',c,'Linewidth',thickness);
                end
            end
            info{i,1} = group;
            info{i,2} = pvalues;
        end
        SelectivityAnalysis(psthtemp,info,location);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RR = eval('Args.ReturnVars');
for i=1:length(RR) RR1{i}=eval(RR{i}); end
varargout = getReturnVal(Args.ReturnVars, RR1);
