function GTVLRR_out = func_GTVLRR(hsi,Dict,lambda,beta,gamma)
%% Compiled by Zephyr Hou on 2021-01-27
% Input:
%     hsi -- 3D dataset with the size of rows x cols x bands
%     Dict-- the dictionary 
%     beta,lamda-- the parameters
% Output
%    LRRASR -- 2D result with the size of rows x cols
% Reference:
% 1.
%% Main Function
[rows,cols,bands]=size(hsi);
Y=reshape(hsi,rows*cols,bands)';  % Y：bands x pixels
Y = Y./max(Y(:));


im_size = [rows,cols]; 
display = true;

% if nargin<4
%     disp('Insufficient input parameters, set by default')
%     Dict=ConstructionD_lilu(Y,15,20); % Y：bands x pixels, 每列是一个像元，（其中K=15,P=20,这些值的设定参考LRASR算法）
%     beta=0.1;%[1000,100,10,1,0.1,0.01,0.001];%[0.07, 0.08, 0.09];
%     lamda=0.1;%[1000,100,10,1,0.1,0.01,0.001];%[0.07, 0.08, 0.09];
% end

tic;
[X,S] = lrr_tv_manifold(Y,Dict,lambda,beta,gamma,im_size,display);
toc

E_norm = zeros(rows*cols,1);
for i = 1:rows*cols
    E_norm(i) = norm(S(:,i));
end
GTVLRR_out=reshape(E_norm,[rows,cols]);
end

