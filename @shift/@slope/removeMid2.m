function slopee = removeMid( ~, slope )
slopee = zeros(2,length(slope));
%slopee(1,:) is starting points
%slopee(2,:) is ending points
index = find(slope==0);

for i = 2:length(index)
    if index(i)-index(i-1)~=1
        slopee(1,index(i-1)+1) = 1;
        slopee(2,index(i)-1) = 1;
    end
end

if index(1)~=1
    slopee(1,1) = 1;
    slopee(2,index(1)-1) = 1;
end

if index(end)~=length(slope)
    slopee(1,index(end)+1) = 1;
    slopee(2,end) = 1;
end

end

