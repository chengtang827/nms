function [obj, varargout] = plot(obj,varargin)
%@dirfiles/plot Plot function for dirfiles object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.

Args = struct('LabelsOff',0,'n_resp',13,'l_resp',500,'GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
    'ReturnVars',{''}, 'ArgsOnly',0);
Args.flags = {'LabelsOff','ArgsOnly'};
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
resp = obj.data.resp;
%shift_neurons = obj.data.shift_neurons;
binLen = obj.data.Args.binLen;
pre = obj.data.Args.pre;
post = obj.data.Args.post;
bins = obj.data.bins;

n_resp = Args.n_resp;
l_resp = Args.l_resp;


spike = squeeze(resp(n,:,:));
location = [1,2,3,4,6,7,8,9];
ymax = max(max(resp(n,:,:)));
ymin = min(min(resp(n,:,1:end-1)));

r1 = zeros(length(location),n_resp);
% r2 = zeros(length(location),n_resp);
r2 = zeros(length(location),1);

for i = 1: length(location)
    subplot(3,3,location(i));
    plot(pre:binLen:post,spike(i,1:end-1));
    xlim([pre,post]);
    ylim([ymin, ymax]);
    
    %draw target and distractor periods
    line([0,0],[0,ymax],'Color','b');
    line([300,300],[0,ymax],'Color','b');
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
    
    %draw the response lines of stepwise 500 ms
    for j = 1:n_resp
        r1(i,j) = mean(spike(i,find(bins(2,:)==(750+(j-1)*100)):find(bins(2,:)==(750+l_resp+(j-1)*100))),2);
        %         r2(i,j) = mean(spike(i,find(bins(2,:)==(1950+(j-1)*100)):find(bins(2,:)==(1950+l_resp+(j-1)*100))),2);
    end
    r2(i) = mean(spike(i,find(bins(2,:)==1950):find(bins(2,:)==(1950+l_resp))),2);
    
end

%compare the responses
[~,r2ind] = max(r2);
for i = 1:length(location)
    subplot(3,3,location(i));
    
    if i==r2ind
        line([1950,1950+l_resp],[r2(i),r2(i)],'Color',[1,0,0]);
    else
        line([1950,1950+l_resp],[r2(i),r2(i)],'Color',[0,0,0]);
    end
end



for j = 1:n_resp
    [~,r1ind] = max(r1(:,j));
    %[~,r2ind] = max(r2(:,j));
    
    
    for i = 1:length(location)
        subplot(3,3,location(i));
        
        if i==r1ind
            line([750+(j-1)*100,750+l_resp+(j-1)*100],[r1(i,j),r1(i,j)],'Color',[1,0,0])
        else
            line([750+(j-1)*100,750+l_resp+(j-1)*100],[r1(i,j),r1(i,j)],'Color',[0,0,0])
        end
        
        %         if i==r2ind
        %             line([1950+(j-1)*100,1950+l_resp+(j-1)*100],[r2(i,j),r2(i,j)],'Color',[1,0,0]);
        %         else
        %             line([1950+(j-1)*100,1950+l_resp+(j-1)*100],[r2(i,j),r2(i,j)],'Color',[0,0,0]);
        %         end
    end
end






% @dirfiles/PLOT takes 'LabelsOff' as an example
if(~Args.LabelsOff)
    xlabel('X Axis')
    ylabel('Y Axis')
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RR = eval('Args.ReturnVars');
for i=1:length(RR) RR1{i}=eval(RR{i}); end
varargout = getReturnVal(Args.ReturnVars, RR1);
