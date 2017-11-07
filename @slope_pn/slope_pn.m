function [obj, varargout] = slope_pn(varargin)
%positive and negative slope

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
Args.classname = 'slope_pn';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'slpn';

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

load('slope_dsbt.mat');
% load('psthtemp.mat');
% pst = pste;
slope_pos = cell(sld.data.numSets,1);
slope_neg = cell(sld.data.numSets,1);
% for each cell
for i = 1: sld.data.numSets
    tic;
    slope_pos_i = zeros(length(sld.data.slope{i}),...
        size(sld.data.slope{i}{1},2));
    slope_neg_i = slope_pos_i;
    % for each location
    for j = 1:size(slope_pos_i,1)
        
        % for each step
        for k = 1:size(slope_pos_i,2)
            slope_pos_i(j,k) = ttest(sld.data.slope{i}{j}(:,k),0,'Tail','right','Alpha',0.05);
            slope_neg_i(j,k) = ttest(sld.data.slope{i}{j}(:,k),0,'Tail','left','Alpha',0.05);
        end
    end
    
    slope_pos{i} = slope_pos_i;
    slope_neg{i} = slope_neg_i;
    toc;
    fprintf('Cell %d\n',i);
end
   





% this is a valid object
% these are fields that are useful for most objects
data.numSets = sld.data.numSets;
data.Args = Args;
data.slope_pos = slope_pos;
data.slope_neg = slope_neg;
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

