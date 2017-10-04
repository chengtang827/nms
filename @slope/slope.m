function [obj, varargout] = slope(varargin)


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
Args.classname = 'slope';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'sl';

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

eval(['pst = psthtemp(' char(39) 'auto' char(39)  ')']);
slope_change = cell(pst.data.numSets,1);

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
    
    slope_change{n} = zeros(length(location),size(spike_n{1},2)-l_resp/s_resp);
    
    %for each location
    for i = 1:length(location)
        spike_n_loc = spike_n{i};
        
        %spike_n_loc_mean = spike_n_mean{i};
        slope = zeros(size(spike_n_loc,1),size(spike_n_loc,2)-l_resp/s_resp);
        
        %for each single run
        for j = 1:size(slope,1)
            
            %for each l_resp
            for k = 1:size(slope,2)
                x = pre+(k-1)*s_resp : s_resp : pre+(k-1)*s_resp+l_resp;
                y = spike_n_loc(j,k:k+l_resp/s_resp);
                f = fit(x',y','poly1');
                slope(j,k) = f.p1*1000;
            end
        end
        
        slope_change_loc = zeros(size(slope,2),1);
        
        
        %for each l_resp
        for j = 1:size(slope,2)
            slope_change_loc(j) = ttest(slope(:,j));
        end
        slope_change{n}(i,:) = slope_change_loc; 
        fprintf('cell %d loc %d finished\n',n,i);
    end
   
end





% this is a valid object
% these are fields that are useful for most objects
data.numSets = 1;
data.Args = Args;
data.slope_change = slope_change;
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

