function newPF = recoverPFLocation(PFShift, PF, spaDivNum)

numPC = length(PFShift);
newPF = nan(size(PF));
for i_cell = 1:numPC
    x = PF(i_cell) + PFShift(i_cell);
    if x>spaDivNum
        newPF(i_cell) = mod(x, spaDivNum);
    elseif x<=0
        newPF(i_cell) = spaDivNum+x;
    else
        newPF(i_cell) = x;
    end
end

end