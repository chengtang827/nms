function [obj, varargout] = slope_dsbt(varargin)


Args = struct('RedoLevels',0, 'SaveLevels',0, 'Auto',1, 'ArgsOnly',0);
Args.flags = {'Auto','ArgsOnly'};
% The arguments which can be neglected during arguments checking
Args.DataCheckArgs = {};

[Args,modvarargin] = getOptArgs(varargin,Args, ...
    'subtract',{'RedoLevels','SaveLevels'}, ...
    'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
    'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'slope_dsbt';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'sld';

% To decide the method to create or load the object
command = checkObjCreate('ArgsC',Args,'narginC',nargin,'firstVarargin',varargin);

if(strcmp(command,'createEmptyObjArgs'))
    varargout{1} = {'Args',Args};
    obj = createEmptyObject(Args);
elseif(strcmp(command,'createEmptyObj'))
    obj = createEmptyObject(Args);
elseif(strcmp(command,'passedObj'))
    obj = varargin{1};
elseif(strcmp(command,'loadObj'))
    l = load(Args.matname);
    obj = eval(['l.' Args.matvarname]);
elseif(strcmp(command,'createObj'))
    % IMPORTANT NOTICE!!!
    % If there is additional requirements for creating the object, add
    % whatever needed here
    obj = createObject(Args,varargin{:});
end

function obj = createObject(Args,varargin)

pst = psthtemp('auto');
% load('psthtemp.mat');
% pst = pste;
slope = cell(pst.data.numSets,1); %each cell is location * 53 * runs(cell)

l_resp = 300;
s_resp = 50;
pre = -250;


% for each cell
for n = 1:pst.data.numSets
    spike_n = pst.data.spike(n,:);    
    
    
    if ~isempty(spike_n{end})
        location = [1,2,3,4,6,7,8,9];
    else
        location = [1,2,3,4,6,7,8];
    end
    
    slope{n} = cell(length(location),1);
    %size(spike_n{1},2)-l_resp/s_resp
    %for each location
    for i = 1:length(location)
        tic;
        spike_n_loc = spike_n{i};
        
        %spike_n_loc_mean = spike_n_mean{i};
        slope_ni = zeros(size(spike_n_loc,1),size(spike_n_loc,2)-l_resp/s_resp);
        
        %for each single run
        for j = 1:size(slope_ni,1)
            
            %for each l_resp
            for k = 1:size(slope_ni,2)
                x = pre+(k-1)*s_resp : s_resp : pre+(k-1)*s_resp+l_resp;
                y = spike_n_loc(j,k:k+l_resp/s_resp);
                f = fit(x',y','poly1');
                slope_ni(j,k) = f.p1*1000;
            end
        end        
        slope{n}{i} = slope_ni; 
        fprintf('cell %d loc %d finished\n',n,i);
        toc;
    end
   
end




% this is a valid object
% these are fields that are useful for most objects
data.numSets = pst.data.numSets;
data.Args = Args;
data.slope = slope;
% create nptdata so we can inherit from it

n = nptdata(data.numSets,0,pwd);
d.data = data;
obj = class(d,Args.classname,n);

saveObject(obj,'ArgsC',Args);


function obj = createEmptyObject(Args)

% useful fields for most objects
data.numSets = 0;
data.setNames = '';

% these are object specific fields
data.dlist = [];
data.setIndex = [];

% create nptdata so we can inherit from it
data.Args = Args;
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);

