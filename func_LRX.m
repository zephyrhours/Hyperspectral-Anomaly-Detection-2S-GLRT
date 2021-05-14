function result = func_LRX(Data, win_out, win_in)
%% Hyperspectral Local RX anomaly detector
% Revised by ZephyrHou on 2019-06-10
%
% Usage
%   [result] = hyperRxDetector(Data, window, lambda)
% Inputs
%   Data - 3D data matrix (num_row x num_col x num_dim)
%   win_out - spatial size window of outer(e.g., 3, 5, 7, 9,...)
%   win_in - spatial size window of inner(e.g., 3, 5, 7, 9,...)
%   lambda - regularization parameter
% Outputs
%   result - Detector output (num_row x num_col)  
%% 对整个数据进行归一化
% max_hsi=max(max(max(Data)));
% min_hsi=min(min(min(Data)));
% Data=(Data-min_hsi)/(max_hsi-min_hsi);

%%
[a b c] = size(Data);
result = zeros(a, b);
t = fix(win_out/2);
t1 = fix(win_in/2);
M = win_out^2;

% padding avoid edges (根据窗口尺寸自适应填充边界)
DataTest = zeros(a+2*t,b+2*t, c);
DataTest(t+1:a+t, t+1:b+t, :) = Data;
DataTest(t+1:a+t, 1:t, :) = Data(:, t:-1:1, :);
DataTest(t+1:a+t, t+b+1:b+2*t, :) = Data(:, b:-1:b-t+1, :);
DataTest(1:t, :, :) = DataTest(2*t:-1:(t+1), :, :);
DataTest(t+a+1:a+2*t, :, :) = DataTest(t+a:-1:(a+1), :, :);

for i = t+1:b+t 
    for j = t+1:a+t
        block = DataTest(j-t: j+t, i-t: i+t, :);
        y = squeeze(DataTest(j, i, :));   % num_dim x 1
        block(t-t1+1:t+t1+1, t-t1+1:t+t1+1, :) = NaN;
        block = reshape(block, M, c);
        block(isnan(block(:, 1)), :) = [];
        H = block';  % num_dim x num_sam
		
		CovMat=cov(H',1);   % num_dim x num_dim
		MeanVal=mean(H,2);  % num_dim x 1
		
        result(j-t, i-t) = (y-MeanVal)'*pinv(CovMat)*(y-MeanVal);
    end
end