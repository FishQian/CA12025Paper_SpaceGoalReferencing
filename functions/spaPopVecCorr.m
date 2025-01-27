function y = spaPopVecCorr(map1, map1_odd, map1_even, map1_idx, map2, map2_idx)
%% first corr matrix is self-cross-validation matrix, second is across condition spa population vector corr matrix
corrMatrix_1 = nan(size(map1,1), size(map1,1));
corrMatrix_2 = nan(size(map1,1), size(map1,1));
if sum(map1_idx)>0 || sum(map2_idx)>0
    corrMatrix_1 = corr(map1_odd(:, logical(map1_idx))', (map1_even(:,logical(map1_idx)))');
    corrMatrix_2 = corr(map1(:, logical(map1_idx))', (map2(:, logical(map2_idx)))');
end
y = nan(size(corrMatrix_1,1), size(corrMatrix_1,2), 2);
y(:,:,1) = corrMatrix_1;
y(:,:,2) = corrMatrix_2;
end