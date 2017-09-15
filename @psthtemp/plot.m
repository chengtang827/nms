function [obj, varargout] = plot(obj,varargin)
%@dirfiles/plot Plot function for dirfiles object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.

Args = struct('LabelsOff',0,'AverageRuns',0,'SessionNumber',1,'GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
    'ReturnVars',{''}, 'ArgsOnly',0);
Args.flags = {'LabelsOff','ArgsOnly','AverageRuns'};
[Args,varargin2] = getOptArgs(varargin,Args);

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
shift_neurons = obj.data.resp;

spike = squeeze(resp(n,:,:));
location = [1,2,3,4,6,7,8,9];
ymax = max(max(resp(n,:,:)));
ymin = min(min(resp(n,:,1:end-1)));

for i = 1: length(location)
    subplot(3,3,location(i));
    plot(-300:50:2600,spike(i,1:end-1));
    xlim([-300,2600]);
    ylim([ymin, ymax]);
    
    %draw target and distractor periods
    line([0,0],[0,ymax],'Color','r');
    line([300,300],[0,ymax],'Color','r');
    
    line([1300,1300],[0,ymax],'Color','b');
    line([1600,1600],[0,ymax],'Color','b');
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
