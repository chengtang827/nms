clear;

load('psthtemp.mat');

n = 226;
binLen = pst.data.Args.binLen;
binStep = pst.data.Args.binStep;
pre = pst.data.Args.pre;
post = pst.data.Args.post;
spike_all = pst.data.spike;

pre = pre + binLen/2;
post = post - binLen/2;

spike_n = spike_all(n,:);

std_err = zeros(sum(~cellfun(@isempty, spike_n)), size(spike_n{1},2));

% for each location
for i = 1:size(std_err,1)
    % for each bin
    for j = 1:size(std_err,2)
        std_err(i,j) = std(spike_n{i}(:,j))/sqrt(size(spike_n{i},1));
    end
end

spike_n_mean = cellfun(@mean,spike_n,'UniformOutput',0);
temp = zeros(size(std_err));
for i = 1:size(temp,1)
    temp(i,:) = spike_n_mean{i};
end
spike_n_mean = temp;

upper = spike_n_mean + std_err;
lower = spike_n_mean - std_err;

ymax = max(max(upper));
ymin = min(min(lower));

if ~isempty(spike_n{end})
    location = [1,2,3,4,6,7,8,9];
else
    location = [1,2,3,4,6,7,8];
end

 

for i = 1: length(location)
    subplot(3,3,location(i));
    rectangle('Position',[0,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    rectangle('Position',[1300,ymin,300,ymax],'FaceColor',[0.8,0.8,0.8],'EdgeColor','none');
    hold on;
    
    xlim([pre,post]);
    ylim([ymin, ymax]);
    
    % plot the standard error range
    
    
    patch([pre:binStep:post post:-binStep:pre],[lower(i,:) fliplr(upper(i,:))],[0.8,0.8,1],'EdgeColor','none');
    plot(pre:binStep:post,spike_n_mean(i,:),'Color','b');
    if i~=6
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
    else
        set(gca,'xtick',[]);
        text(0,ymin,'0','HorizontalAlignment','center','VerticalAlignment','top');
        text(300,ymin,'0.3','HorizontalAlignment','center','VerticalAlignment','top');
        text(1300,ymin,'1.3','HorizontalAlignment','center','VerticalAlignment','top');
        text(1600,ymin,'1.6','HorizontalAlignment','center','VerticalAlignment','top');
    end
    
    if i==4
        ylabel('Firing Rate (Hz)');
    end
    
    if i==7
        xlabel('Time from Target Onset (s)');
    end
end