%% Demo for 2S-GLRT
% Paper: Multi-Pixel Anomaly Detection With an Unknown Pattern for Hyperspectral Imagery
% Author: Jun Liu; Zengfu Hou ; Wei Li; Ran Tao;Danilo Orlando; Hongbin Li;
% Compiled by Zengfu Hou
% Time: 2020-06-10
% All Rights Reserved,
% Email: zephyrhours@gmail.com
%%
clc;clear;close all;
%% Add Path 
addpath(genpath('./GTVLRR'));
addpath(genpath('./RPCA'));

%% Load HSI dataset
[imgname,pathname]=uigetfile('*.*', 'Select the original image file','./Datasets');
if imgname == 0
    error("There is no file selected !")
else
    str=strcat(pathname,imgname);
    [pathstr,name,ext]=fileparts(str);
    if ext == '.mat'
        disp('The hyperspectral dataset is :')
        disp(str);
        addpath(pathname);
        load(strcat(pathname,imgname));
%         hsi=data;     % dataset name
%         hsi_gt=map;   % ground truth name
    end
end

% Automatic image name recognition
[pathstr,name,ext]=fileparts(str);
name=strrep(name,'_','\_');

[rows,cols,bands]=size(hsi);
label_value=reshape(hsi_gt,1,rows*cols);

%% Optimal Parameters of Different Methods        
OptPara={   'Methods', '2S-GLRT', 'LRX',      'CRD',   'RPCA-RX',  'GTVLRR';
    'Los Angeles[A2]',  [19,15], [19,15], [17,15,1e-6], [0.01],   [0.5,0.2,0.1];  %lambda,beta,gamma
     'Cat Island[B1]',  [25, 3], [17,13], [25,15,1e-6], [0.01],   [1,0.005,0.005];
    'Texas Coast[U1]',  [ 9, 5], [11, 5], [ 9, 7,1e-6], [0.01],   [0.005,1,0.5];
    'Pavia Centra[B4]',  [21, 5], [25, 5], [ 7, 5,1e-6], [0.01],  [0.7,0.4,0.05];
                'Cir',  [25,15], [19,15], [19, 9,1e-6], [0.001],   [0.005,1,0.5]};
%% Name of Experimental dataset(hsi,hsi_gt)
if strcmp(name,'abu-airport-2')
    ExperimentData='Los Angeles[A2]';   
elseif strcmp(name,'abu-beach-1')
    ExperimentData='Cat Island[B1]';
elseif strcmp(name,'abu-urban-1')
    ExperimentData='Texas Coast[U1]';   
elseif strcmp(name,'abu-beach-4') 
    ExperimentData='Pavia Centra[B4]';
elseif strcmp(name,'Cri') 
    ExperimentData='Cir';   
else
    warning('Unexpected dataset, please reselect the dataset or modify the parameters in different algorithms!')   
end

%%
ImgName=OptPara(:,1);
NameVec=strcmp(ImgName,ExperimentData);
ind_row=find(NameVec==1);

Proposed='2S-GLRT';
CM1='LRX';
CM2='CRD';
CM3='RPCA-RX';
CM4='GTVLRR';

MethodName=OptPara(1,:);

ind_my=find(strcmp(MethodName,Proposed)==1);
ind_cm1=find(strcmp(MethodName,CM1)==1);
ind_cm2=find(strcmp(MethodName,CM2)==1);
ind_cm3=find(strcmp(MethodName,CM3)==1);
ind_cm4=find(strcmp(MethodName,CM4)==1);

para_my=OptPara{ind_row,ind_my};
para_LRX=OptPara{ind_row,ind_cm1};
para_CRD=OptPara{ind_row,ind_cm2};
para_RPCA=OptPara{ind_row,ind_cm3};
para_GTVLRR=OptPara{ind_row,ind_cm4};
  
%% ==========================Contrast Experiment==============================
%%  Proposed 2S-GLRT
disp('Running 2S-GLRT, Please wait...')
tic
R0 = func_2S_GLRT(hsi,para_my(1),para_my(2)); 
t0=toc;
disp(['2S-GLRT Time£º',num2str(t0)])
R0value = reshape(R0,1,rows*cols);
[FA0,PD0] = perfcurve(label_value,R0value,'1') ;
AUC0=-sum((FA0(1:end-1)-FA0(2:end)).*(PD0(2:end)+PD0(1:end-1))/2);

%% 1.GRX Method
disp('Running GRX, Please wait...')
tic
R1 = func_GRX(hsi);
t1=toc;
disp(['GRXD Time£º',num2str(t1)])
R1value = reshape(R1,1,rows*cols);
[FA1,PD1] = perfcurve(label_value,R1value,'1') ;
AUC1=-sum((FA1(1:end-1)-FA1(2:end)).*(PD1(2:end)+PD1(1:end-1))/2);

%% 2.LRX Method
disp('Running LRX, Please wait...')
tic 
R2 = func_LRX(hsi,para_LRX(1),para_LRX(2));   
t2=toc;
disp(['LRXD Time£º',num2str(t2)])
R2value = reshape(R2,1,rows*cols);
[FA2,PD2] = perfcurve(label_value,R2value,'1') ;
AUC2=-sum((FA2(1:end-1)-FA2(2:end)).*(PD2(2:end)+PD2(1:end-1))/2);

%% 3.CRD Method
disp('Running CRD, Please wait...')
tic 
R3 = func_CRD(hsi,para_CRD(1),para_CRD(2),para_CRD(3));   
t3=toc;
disp(['CRD Time£º',num2str(t3)])
R3value = reshape(R3,1,rows*cols);
[FA3,PD3] = perfcurve(label_value,R3value,'1') ;
AUC3=-sum((FA3(1:end-1)-FA3(2:end)).*(PD3(2:end)+PD3(1:end-1))/2);

%% 4.RPCA Method
disp('Running RPCA, Please wait...')
tic 
R4 =  func_RPCA_RX( hsi,para_RPCA);     % Cri(0.001),other(0.01)
t4=toc;
disp(['RPCA Time£º',num2str(t4)])
R4value = reshape(R4,1,rows*cols);
[FA4,PD4] = perfcurve(label_value,R4value,'1') ;
AUC4=-sum((FA4(1:end-1)-FA4(2:end)).*(PD4(2:end)+PD4(1:end-1))/2);

%% 5.GTVLRR Method
disp('Running GTVLRR, Please wait...')
Y=reshape(hsi,rows*cols,bands)';  % Y£ºbands x pixels
Y = Y./max(Y(:));
K=6;
P=20;
Dict=ConstructionD_lilu(Y,K,P);

tic 
R5 = func_GTVLRR(hsi,Dict,para_GTVLRR(1),para_GTVLRR(2),para_GTVLRR(3));     
t5=toc;
disp(['GTVLRR Time£º',num2str(t5)])
R5value = reshape(R5,1,rows*cols);
[FA5,PD5] = perfcurve(label_value,R5value,'1') ;
AUC5=-sum((FA5(1:end-1)-FA5(2:end)).*(PD5(2:end)+PD5(1:end-1))/2);

%% Optimal Parameters and AUC Value Display
clc;
disp(date)
disp('Author: Zengfu Hou')
disp('---------------------------------------------------------------------')
disp('Optimal Parameters£º')
disp(['    Methods ','         ',CM1,'             ', CM2,'         '...
    , CM3,'        ',CM4,'         ',Proposed])
disp([ExperimentData,...
    '    (',num2str(para_LRX(1)),', ',num2str(para_LRX(2)),')',...
    '    (',num2str(para_CRD(1)),', ',num2str(para_CRD(2)),', ',num2str(para_CRD(3)),')',...
    '    (',num2str(para_RPCA),')' ,...
    '    (',num2str(para_GTVLRR(1)),', ',num2str(para_GTVLRR(2)),', ',num2str(para_GTVLRR(3)),')',...
    '    (',num2str(para_my(1)),', ',num2str( para_my(2)),')']);
disp('---------------------------------------------------------------------')
disp('AUC Values and Execution Time£º')
disp('GRX')
disp(['AUC:     ',num2str(AUC1),'          Time:     ',num2str(t1)])
disp('LRX')
disp(['AUC:     ',num2str(AUC2),'          Time:     ',num2str(t2)])
disp('CRD')
disp(['AUC:     ',num2str(AUC3),'          Time:     ',num2str(t3)])
disp('RPCA-RX')
disp(['AUC:     ',num2str(AUC4),'          Time:     ',num2str(t4)])
disp('GTVLRR')
disp(['AUC:     ',num2str(AUC5),'          Time:     ',num2str(t5)])
disp('2S-GLRT')
disp(['AUC:     ',num2str(AUC0),'          Time:     ',num2str(t0)])
disp('-------------------------------------------------------------------')
%% ROC Curves Display
% figure;
% subplot(2,4,1);imshow(hsi_gt,[]);title('GT')
% subplot(2,4,2);imshow(R1,[]);title('RX')
% subplot(2,4,3);imshow(R2,[]);title('LRX')
% subplot(2,4,4);imshow(R3,[]);title('CRD')
% subplot(2,4,5);imshow(R4,[]);title('RPCA')
% subplot(2,4,6);imshow(R5,[]);title('GTVLRR')
% subplot(2,4,7);imshow(R0,[]);title('2S-GLRT')

figure;
semilogx(FA1, PD1, 'LineWidth', 2);  hold on
semilogx(FA2, PD2, 'LineWidth', 2);  hold on
semilogx(FA3, PD3, 'LineWidth', 2);  hold on
semilogx(FA4, PD4, 'LineWidth', 2);  hold on
semilogx(FA5, PD5, 'LineWidth', 2);  hold on
semilogx(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
% title(name)

figure;
plot(FA1, PD1, 'LineWidth', 2);  hold on
plot(FA2, PD2, 'LineWidth', 2);  hold on
plot(FA3, PD3, 'LineWidth', 2);  hold on
plot(FA4, PD4, 'LineWidth', 2);  hold on
plot(FA5, PD5, 'LineWidth', 2);  hold on
plot(FA0, PD0, 'k-', 'LineWidth', 2);  hold on
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT','location','southeast')
% title(name)

% save Res_LosAngeles.mat    % A2
save Res_CatIsland.mat       % B1
% save Res_TexasCoast.mat    % U1
% save Res_PaviaCentra.mat   % B4
% save Res_Cri.mat           % Cri













