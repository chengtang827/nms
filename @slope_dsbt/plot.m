function [obj, varargout] = plot(obj,varargin)
%@dirfiles/plot Plot function for dirfiles object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.

Args = struct('NumBins',15,'GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
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
NumBins = Args.NumBins;

slope_n = obj.data.slope{n};

if length(slope_n) == 7
    location = [1,2,3,4,6,7,8];
else
    location = [1,2,3,4,6,7,8,9];
end

%identify ymin ymax
% ymin = min(cellfun(@min, ...
%     cellfun(@min,slope_n,'UniformOutput',false)));
% ymax = max(cellfun(@max, ...
%     cellfun(@max,slope_n,'UniformOutput',false)));

%for each location
for i = 1:length(location)
    subplot(3,3,location(i));
    slope_ni = slope_n{i};
    
    ymin = min(min(slope_ni));
    ymax = max(max(slope_ni));
    
    %convert to histogram
    hist = [];
    %for each step
    for j = 1:size(slope_ni,2)
        %TODO really need ymin ymax?
        h = histogram(slope_ni(:,j),'BinLimits',[ymin ymax],'NumBins',NumBins);
        hist = [hist flipud(h.Values')];
    end
    imagesc(hist);
    set(gca, 'ytick',[]);
    set(gca, 'xtick',[]);
    
    %plot min max and 0
    text(0,0,num2str(round(ymax)),...
        'HorizontalAlignment','right','VerticalAlignment','cap');
    text(0,NumBins,num2str(round(ymin)),...
        'HorizontalAlignment','right','VerticalAlignment','cap');
    text(0,ymax/((ymax-ymin)/NumBins),'0',...
        'HorizontalAlignment','right','VerticalAlignment','cap');
    
    %plot target and distractor
    line([3,3],[ymin,ymax],'Color','w');
    line([9,9],[ymin,ymax],'Color','w');
    line([29,29],[ymin,ymax],'Color','w');
    line([35,35],[ymin,ymax],'Color','w');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RR = eval('Args.ReturnVars');
for i=1:length(RR)
    RR1{i}=eval(RR{i});
end
varargout = getReturnVal(Args.ReturnVars, RR1);
