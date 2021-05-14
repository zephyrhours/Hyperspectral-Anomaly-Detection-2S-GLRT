%% 实验论文中ROC曲线绘制
% Compiled by Zengfu Hou on 2020-07-01
%% 1.Los Angeles
clc;clear;close all
load('Res_LosAngeles.mat')

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
axis([0,0.5,0,1])
%% 2.Cat Island
clc;clear;

load('Res_CatIsland.mat')

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
axis([0,0.1,0.55,1])

%% 3.Texas Coast
clc;clear;

load('Res_TexasCoast.mat')

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
axis([0,0.07,0.6,1])

%% 4.Pavia Centra
clc;clear;
load('Res_PaviaCentra.mat')

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
axis([0,0.95,0.3,1])

%% 5.Cri
clc;clear;

load('Res_Cri.mat')

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
axis([0,1,0,1])













