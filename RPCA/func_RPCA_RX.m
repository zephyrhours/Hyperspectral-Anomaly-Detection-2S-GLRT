function [ RPCA_RX_out ] = func_RPCA_RX( hsi,lambda )

[N,NN,M]=size(hsi);
hsi = reshape(hsi,N*NN,M);

% % % 对整个数据进行归一化
% max_y = max(max(hsi));
% min_x = min(min(hsi));
% hsi = (hsi-min_x)/(max_y-min_x);
% 
% % 各个波段归一化0-1
% hsi = scale_new(hsi);  % 列归一化


% RPCA_MC文件夹 m x n matrix of observations/data， 行为维度或样本个数， 探测结果都一样
% hsi = hsi';
% [A_low E_spare ] = inexact_alm_rpca_mc(hsi, lambda);    % 速度太慢
% E_spare = E_spare';

% % ALM Method文件夹，m x n matrix of observations/data  n为最小的，即列为维度
[A_low,E_spare,iter] = inexact_alm_rpca(hsi, lambda);

%% 后探测算法 : 在稀疏矩阵上的RX探测(经典后处理方式：RPCA_RX)
cov_matrix = cov(E_spare,1);  % 除以N，不是（N-1）
inv_cov=inv(cov_matrix);
xmean = mean(E_spare,1);
% E_spare_img = reshape(E_spare,N,NN,M);
RPCA_RX_out = zeros(N*NN,1);

for i = 1:N*NN
    value_test = E_spare(i,:);
    RPCA_RX_out(i,:)=(value_test-xmean)*inv_cov*(value_test-xmean)';
end
RPCA_RX_out = reshape(RPCA_RX_out,N,NN);

% 后探测算法 ： 列的L2范数  (RPCA_L2,在HYDICE效果比RPCA_RX好)
% E_spare = E_spare';
% RPCA_AD = zeros(1,N*NN);
% for i = 1: N*NN
%    RPCA_AD(:,i) = norm(E_spare(:,i));    
% end
% RPCA_AD = RPCA_AD';
% RPCA_RX_out = reshape(RPCA_AD,N,NN);
% 
% % ALM进行RPCA计算

end

