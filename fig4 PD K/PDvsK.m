clear all;
% close all;
clc
alpha0 = 1 ;
L = 15 ;  %%%% training data size
N = 10 ;     %%%% data dimension
pfa = 1e-3 ;  %%%  虚警概率
for m =1 : N    %%%%%%  clutter convariance matrix
    for n = 1 : N
        R(n,m) = 0.95^(abs(n-m));
    end
end
R12 = chol(R,'lower') ;
R11 = pinv(R) ;
load endnumber
% % a = ones(N, 1);
% a = rand(N,1) ;
% a = a/sqrt(a'*a) ;
SNR = 10 ;   sigma_t = 10^(SNR/10);
%%
SNRstart = 0;  SNRinterval = 1  ; SNRpoint = 15;
for ii = 1 : SNRpoint
    ii
    K = SNRstart + ii* SNRinterval;  %%%%  pixel number
    b1 = ones(K,1) ;
    b = zeros(K,1);
    for jj = 1:K
        if mod(jj, 2) == 0
            b(jj) = 1;
        else
            b(jj) = 0.5;
        end
    end
    
    %     for jj = 1:K
    %        b(jj) = jj;
    %     end
    %     b = b/sqrt(b'*b) ;
    
    %     b = rand(K,1) ;
    %     b = b/sqrt(b'*b) ;
    %%%%%%%%%%%%%%%%%%%  threshold  %%%%%%%%%%%%%%%%%
    latter_num = 100;
    runs_pfa = latter_num/pfa;
    X = zeros(N,K);
    Y = zeros(N,L);
    I_K = eye(K) ;
    for nn = 1:runs_pfa
        X = sqrt(alpha0) * R12 * randn(N,K) ;
        Y = R12 * randn(N,L) ;
        R_inv = pinv(Y*Y.');
        X1 = (sqrtm(R_inv)) * X  ;
        %%  2S-GLRT
        BB = X1.'*X1 ;
        [x2,y2] = eig(BB);%求矩阵的特征值和特征向量，x为特征向量矩阵，y为特征值矩阵。
        eigenvalue2 = diag(y2);%求对角线向量
        GLRT_2S(nn) = max(eigenvalue2) ;
        %%  known pattern
        GLRT_p(nn) = b'*X'*pinv(X*X'+Y*Y')*X*b/(b'*b) ;
        %%  mismatch in pattern
        MF(nn) =  b1'*X'*pinv(X*X'+Y*Y')*X*b1/(b1'*b1) ;
    end
    order_position = latter_num/pfa - latter_num;
    ascend_element_RPGLRT = sort(GLRT_2S);
    threshold_GLRT_2S = ( ascend_element_RPGLRT(order_position));
    %%  known pattern
    ascend_element_GLRT_p = sort(GLRT_p);
    threshold_GLRT_p =  ascend_element_GLRT_p(order_position);
    
    ascend_element_AMFAMF = sort(MF);
    threshold_MF = abs( ascend_element_AMFAMF(order_position));
    %%%%%%%%%%%%%%%%%%%%%  PD
    runs = 10000;
    DD1 = 0;    DD2 = 0;  DD3 = 0;  DD4 = 0;   DD5 = 0;
    for n = 1 : runs
        X = sqrt(sigma_t)* a*b.'+ sqrt(alpha0) * R12 * randn(N,K) ;
        Y =  R12 * randn(N,L) ;
        R_inv = pinv(Y*Y.');
        X1 = (sqrtm(R_inv)) * X ;
        %%  2S-GLRT
        BB = X1.'*X1 ;
        [x2,y2] = eig(BB);%求矩阵的特征值和特征向量，x为特征向量矩阵，y为特征值矩阵。
        eigenvalue2 = diag(y2);%求对角线向量
        GLRT_2S_test = max(eigenvalue2) ;
        if GLRT_2S_test > threshold_GLRT_2S
            DD2 = DD2 + 1;
        end
        %%  known pattern
        GLRT_p_test = b'*X'*pinv(X*X'+Y*Y')*X*b/(b'*b)  ;
        if GLRT_p_test > threshold_GLRT_p
            DD4 = DD4 + 1;
        end
        %%  mismatch in pattern
        MF_test = b1'*X'*pinv(X*X'+Y*Y')*X*b1/(b1'*b1) ;
        if MF_test > threshold_MF
            DD5 = DD5 + 1;
        end
    end
    PD_GLRT2S(ii) = DD2/runs;
    PD_known_pattern(ii) = DD4/runs;
    PD_mismatch_pattern (ii) = DD5/runs ;
end
figure
SNR = SNRstart + (1:SNRpoint)*SNRinterval;
plot(SNR,PD_GLRT2S,'b-o','linewidth',1.5);  hold on;
plot(SNR,PD_known_pattern,'r--+','linewidth',1.5);  hold on;
% plot(SNR,PD_mismatch_pattern,'k-^','linewidth',1.5);  hold on;
grid on;
xlabel('Pixel Number \it K'); ylabel('Probability of Detection');
legend('Proposed, unknown pattern','Known pattern')

save SNR10L15
