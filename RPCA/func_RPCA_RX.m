function [ RPCA_RX_out ] = func_RPCA_RX( hsi,lambda )

[N,NN,M]=size(hsi);
hsi = reshape(hsi,N*NN,M);

% % % ���������ݽ��й�һ��
% max_y = max(max(hsi));
% min_x = min(min(hsi));
% hsi = (hsi-min_x)/(max_y-min_x);
% 
% % �������ι�һ��0-1
% hsi = scale_new(hsi);  % �й�һ��


% RPCA_MC�ļ��� m x n matrix of observations/data�� ��Ϊά�Ȼ����������� ̽������һ��
% hsi = hsi';
% [A_low E_spare ] = inexact_alm_rpca_mc(hsi, lambda);    % �ٶ�̫��
% E_spare = E_spare';

% % ALM Method�ļ��У�m x n matrix of observations/data  nΪ��С�ģ�����Ϊά��
[A_low,E_spare,iter] = inexact_alm_rpca(hsi, lambda);

%% ��̽���㷨 : ��ϡ������ϵ�RX̽��(�������ʽ��RPCA_RX)
cov_matrix = cov(E_spare,1);  % ����N�����ǣ�N-1��
inv_cov=inv(cov_matrix);
xmean = mean(E_spare,1);
% E_spare_img = reshape(E_spare,N,NN,M);
RPCA_RX_out = zeros(N*NN,1);

for i = 1:N*NN
    value_test = E_spare(i,:);
    RPCA_RX_out(i,:)=(value_test-xmean)*inv_cov*(value_test-xmean)';
end
RPCA_RX_out = reshape(RPCA_RX_out,N,NN);

% ��̽���㷨 �� �е�L2����  (RPCA_L2,��HYDICEЧ����RPCA_RX��)
% E_spare = E_spare';
% RPCA_AD = zeros(1,N*NN);
% for i = 1: N*NN
%    RPCA_AD(:,i) = norm(E_spare(:,i));    
% end
% RPCA_AD = RPCA_AD';
% RPCA_RX_out = reshape(RPCA_AD,N,NN);
% 
% % ALM����RPCA����

end

