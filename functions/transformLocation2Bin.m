% transform 1-184cm scale into 50 spatial bins

function y = transformLocation2Bin(x, binNum, locationSize)

index = 1:(locationSize/binNum):184
n = length(x);
y = nan(n,1);
for i = 1:n
    y(i) = find(x(i)>index, 1, 'last');
    
end

figure; 
plot(x,y, 'o')