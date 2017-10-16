function slope = removeMid( ~, slope )
index = find(slope==0);

for i = 2:length(index)
    if index(i)-index(i-1)~=1
        slope(index(i-1)+2:index(i)-2) = 0;
    end
end

if index(1)~=1
    slope(2:index(1)-2)=0;
end

if index(end)~=length(slope)
    slope(index(end)+2:end-1)=0;
end

end

