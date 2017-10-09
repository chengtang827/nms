function slope = removeBlacknRed( ~,slope ,minLenB,minLenR )



%remove black no longer than minLenB
index = find(slope==1);
for i = 2:length(index)
    diff = index(i)-index(i-1);
    if diff<=minLenB+1
        slope(index(i-1):index(i))=1;
    end
end

%remove red no longer than minLenR
index = find(slope==0);
for i = 2:length(index)
    diff = index(i)-index(i-1);
    if diff<=minLenR+1
        slope(index(i-1):index(i))=0;
    end
end

%remove the first and last points of change no longer than minLenR
index = find(slope==0);
if index(1)<=minLenR+1
    slope(1:index(1))=0;
end

if index(end)>=length(slope)-minLenR
    slope(index(end):end) = 0;
end
end



