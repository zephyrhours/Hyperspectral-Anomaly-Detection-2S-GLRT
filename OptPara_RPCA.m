% Compiled by zephyrhou on 2020.06.27

%% ��������
clc;clear;close all;
addpath('C:\Users\dream\Documents\MATLAB\Functions')
addpath('C:\Users\dream\Documents\MATLAB\Functions\RPCA')
addpath('C:\Users\dream\Documents\MATLAB\Functions\RPCA\inexact_alm_rpca')
addpath('C:\Users\dream\Documents\MATLAB\Functions\RPCA\inexact_alm_rpca\PROPACK')

disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('xx                    Lambda ����Ѱ�ų���                        xx')
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')

%%%ѡ��Ӱ���ļ�
[imgname,pathname]=uigetfile('*.*', 'Select the original image file','C:\Users\dream\Documents\MATLAB\Test_Datas\ABU\img');
str=strcat(pathname,imgname);
disp('The Original Image is :')
disp(str);
addpath(pathname);
hdrnam=imgname(1:(strfind(imgname,'.')-1));
NAME=hdrnam;
NAME=strrep(NAME,NAME(strfind(NAME,'_')),'-');
hdrname=strcat(hdrnam,'.hdr');
hsi=read_ENVIimagefile(hdrname,imgname);
[rows,cols,bands]=size(hsi);
%%%ѡ����ʵ����Ӱ���ļ�
[imgname,pathname]=uigetfile('*.*', 'Select the GT image file',pathname);
str=strcat(pathname,imgname);
disp('The GT Image is :')
disp(str);
addpath(pathname);
hdrnam=imgname(1:(strfind(imgname,'.')-1));
hdrname=strcat(hdrnam,'.hdr');
hsi_gt=read_ENVIimagefile(hdrname,imgname);
label_value = reshape(hsi_gt,1,rows*cols);
%% ���ݴ���
% hsi = reshape(hsi,rows*cols,bands);
% label_value = reshape(hsi_gt,1,rows*cols);
% 
% % ���������ݽ��й�һ��
% hsi = hsi';
% max_y = max(max(hsi));
% min_x = min(min(hsi));
% hsi = (hsi-min_x)/(max_y-min_x);
% hsi =hsi';

%% RPCA ���Ų�������
Lambda=[1e-4,1e-3,0.01,0.1,1,10,100,1000,10000];
ParaMat=zeros(1,length(Lambda));

disp('-----------------------------------------------------')
disp('������ʾ��')
h=waitbar(0,'please wait......','Name','Optimal Paramaters');

tic;
for kii=1:length(Lambda)
        
        % ��������ʾ
        numP=kii/length(Lambda);
        str=['Running   ',num2str(fix(numP*10000)/100),'%,  Please Wait......'];
        waitbar(numP,h,str)
         
        lambda1=Lambda(kii);
        disp(['lambda=',num2str(lambda1)])
        disp('Running......')
                
%======================̽���㷨=====================================
        result=func_RPCA_RX(hsi,lambda1);   
% =================================================================
                
        % AUCֵ
        R_value =reshape(result,1,rows*cols);
        [FA,PD] = perfcurve(label_value,R_value,'1') ;
        AUC = -sum((FA(1:end-1)-FA(2:end)).*(PD(2:end)+PD(1:end-1))/2);
        disp('AUC Value��')
        disp(AUC)
        ParaMat(1,kii)=AUC;      
end
delete(h)  % �رս�����
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxx The End xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
% 
maxVal=max(ParaMat);
indW=find(ParaMat==maxVal);

maxW=Lambda(indW);

disp(['The Optimal AUC Value is :',num2str(maxVal)])
disp(['The Optimal lambda is ( lambda = ',num2str(maxW),' )'])
% ����ʱ��
t2=toc;
disp(['����ʱ��Ϊ��',num2str(t2)])




