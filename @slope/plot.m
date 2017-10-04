function [obj, varargout] = plot(obj,varargin)
%@dirfiles/plot Plot function for dirfiles object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.

Args = struct('GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
    'ReturnVars',{''}, 'ArgsOnly',0);
Args.flags = {'ArgsOnly'};
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
eval(['pst = psthtemp(' char(39) 'auto' char(39)  ')']);


spike_all = pst.data.spike;

binLen = pst.data.Args.binLen;
pre = pst.data.Args.pre;
post = pst.data.Args.post;




spike_n = spike_all(n,:);

spike_n_mean = cellfun(@mean,spike_n,'UniformOutput',0);
ymax = max(cellfun(@max,spike_n_mean));
ymin = min(cellfun(@min,spike_n_mean(1:end-1)));

if ~isempty(spike_n{end})
    location = [1,2,3,4,6,7,8,9];
else
    location = [1,2,3,4,6,7,8];
end



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
    
    slope_n_loc = obj.data.slope_change{n}(i,:);
    slope_n_loc = removeBlacknRed(slope, slope_n_loc,4,2);
    
    hold on;
    s=[];
    c= zeros(length(slope_n_loc),3);
    c(slope_n_loc==1,1) = 1;
    
    scatter(pre+150:binLen:post-150,ones(length(slope_n_loc),1)*ymin,s,c);
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RR = eval('Args.ReturnVars');
for i=1:length(RR)
    RR1{i}=eval(RR{i});
end
varargout = getReturnVal(Args.ReturnVars, RR1);
