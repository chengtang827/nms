%average psth, then compute slope, show in histogram

clear;
load('psthtemp_normal.mat');

spike = pst.data.spike;

spike_mean = cellfun(@mean,spike,'UniformOutput',false);

%compute the slope of mean psth
l_resp = 120;
s_resp = 20;


slope120 = zeros(size(spike,1),size(spike,2),size(spike{1},2)-l_resp/s_resp);

%for each cell
for i = 1:size(slope120,1)
    tic;
    %for each location
    for j = 1:size(slope120,2)
        
        if ~isempty(spike{i,j})
            
            %for each l_resp
            for k = 1:size(slope120,3)
                x = (k-1)*s_resp : s_resp : (k-1)*s_resp+l_resp;
                y = spike_mean{i,j}(k:k+l_resp/s_resp);
                
                if sum(isnan(y))~=0 || sum(y)==0
                    slope120(i,j,k) = NaN;
                    continue;
                end
                
                [f,g] = fit(x',y','poly1');
                
                %first compare confidence interval against zeros
                %if zero is not included
                %run the shuffle test
                
                conf = confint(f);
                if conf(1,1)*conf(2,1)<=0 %interval contains 0
                    slope120(i,j,k) = 0;
                else
                    % 100 shuffle
%                     shuffle = 100;
%                     gd = zeros(shuffle,1);
%                     for l = 1:shuffle
%                         [~,temp] = fit(x',y(randperm(7))','poly1');
%                         gd(l) = temp.rsquare;
%                     end
%                     
%                     if g.rsquare>prctile(gd,95)
%                         slope120(i,j,k) = f.p1*1000;
%                     else
%                         slope120(i,j,k) = NaN;
%                     end
                                        slope120(i,j,k) = f.p1*1000;
                end
                
            end
        else
            slope120(i,j,:) = NaN;
        end
    end
    toc;
    fprintf('cell %d\n',i);but sum up pos and neg, and the 8th location scaled to cell proportion
clear;
end
save('slope120_gf','slope120');

%%
clear;
load('slope120.mat');
load('dataset_overlapbins_fefdl.mat','st_dl');
load('cmap.mat');
colormap(cmap);
ind = st_dl>3;
slope120(slope120==0)=NaN;
slope = slope120;
slope = slope(ind,:,:);
t1 = 9;
t2 = 24;
d1 = 74;
d2 = 89;
%%
clear;
load('slope300.mat');
slope(slope==0)=NaN;
colormap('jet');
t1 = 3;
t2 = 9;
d1 = 29;
d2 = 35;
%%
slope(slope>3) = 2.5;
slope(slope<-3) = -2.5;

NumBins = 6;
location = [1,2,3,4,6,7,8];

ymin = min(min(min(squeeze(slope))));
ymax = max(max(max(squeeze(slope))));
% for each location

range = 3;
ymin = -range;
ymax = range;

%find CLIM
CLOW = 0;
CHIGH = 0;
for i = 1:length(location)
    subplot(3,3,location(i));
    
    hist = [];
    %for each step
    for j = 1:size(slope,3)
        h = histogram(squeeze(slope(:,i,j)),'BinLimits',[ymin ymax],'NumBins',NumBins);
        hist = [hist flipud(h.Values')];
    end
    CLOW = min(CLOW, min(min(hist)));
    CHIGH = max(CHIGH, max(max(hist)));
end

CLOW = 0;
% CLOW = 5;
CHIGH = 25;

for i = 1:length(location)
    subplot(3,3,location(i));
    
    hist = [];
    %for each step
    for j = 1:size(slope,3)
        h = histogram(squeeze(slope(:,i,j)),'BinLimits',[ymin ymax],'NumBins',NumBins);
        hist = [hist flipud(h.Values')];
    end
    imagesc(hist,[CLOW CHIGH]);
    colorbar;
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
    line([t1,t1],[0,NumBins+1],'Color','w','LineWidth',3);
    line([t2,t2],[0,NumBins+1],'Color','w','LineWidth',3);
    line([d1,d1],[0,NumBins+1],'Color','w','LineWidth',3);
    line([d2,d2],[0,NumBins+1],'Color','w','LineWidth',3);
end

