%% Compiled by zephyrhou on 2020.02.07
% 参数寻优(2021.01.27)
%% 导入数据
clc;clear;close all;
disp( datestr(now))
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('xx                      自动参数寻优程序：                         xx')
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
addpath('C:\Users\hp\Documents\MATLAB\Functions\GTVLRR')
addpath('C:\Users\hp\Documents\MATLAB\Functions\GTVLRR\ConstructW')
addpath('C:\Users\hp\Documents\MATLAB\Functions')
%%%选择影像文件

[imgname,pathname]=uigetfile('*.*', 'Select the original image file','C:\Users\hp\Documents\MATLAB\LiuJun\Datasets'); 
str=strcat(pathname,imgname);
disp('The Original Image is :')
disp(str);
addpath(pathname);
hdrnam=imgname(1:(strfind(imgname,'.')-1));
NAME=hdrnam;
NAME=strrep(NAME,NAME(strfind(NAME,'_')),'-');
hdrname=strcat(hdrnam,'.hdr');
hsi=read_ENVIimagefile(hdrname,imgname);

%%%选择真实地物影像文件
[imgname,pathname]=uigetfile('*.*', 'Select the GT image file',pathname);
str=strcat(pathname,imgname);
disp('The GT Image is :')
disp(str);
addpath(pathname);
hdrnam=imgname(1:(strfind(imgname,'.')-1));
hdrname=strcat(hdrnam,'.hdr');
hsi_gt=read_ENVIimagefile(hdrname,imgname);

[rows,cols,bands]=size(hsi);
label_value = reshape(hsi_gt,1,rows*cols);

file_name='C:\Users\hp\Desktop\Res_ParaMat.xlsx';
%% 字典
Y=reshape(hsi,rows*cols,bands)';  % Y：bands x pixels
Y = Y./max(Y(:));

K=6;
P=20;
Dict=ConstructionD_lilu(Y,K,P);

%% 最优参数测试

% Lambda=[0.005,0.05,0.1,0.3,0.5,0.7,1];
% Beta=[0.2];
% Gamma =[0.05];

% Lambda=[0.005];
% Beta=[0.005,0.05,0.1,0.2,0.4,0.7,1];
% Gamma =[0.05];

Lambda=[0.005];
Beta=[1];
Gamma =[0.005,0.01,0.02,0.05,0.1,0.2,0.5];



% Lambda=[0.005,0.05,0.1,0.3,0.5,0.7,1];
% Beta=[0.005,0.05,0.1,0.2,0.4,0.7,1];
% Gamma =[0.005,0.01,0.02,0.05,0.1,0.2,0.5];

%%
ParaMat=zeros(length(Beta)*length(Lambda),length(Gamma));
h=waitbar(0,'please wait......','Name','Optimal Paramaters');
tic;

for k=1:length(Lambda)
    disp('-----------------------------------------------------')
    lambda=Lambda(k);
    for i=1:length(Beta)
        for j=1:length(Gamma)      
           % 进度条显示
            numP=(((k-1)*length(Beta)*length(Gamma))+(i-1)*length(Gamma)+j)/(length(Lambda)*length(Beta)*length(Gamma));
            str=['Running   ',num2str(fix(numP*10000)/100),'%,  Please Wait......'];
            waitbar(numP,h,str)    
            disp('参数显示：')
            beta=Beta(i);
            gamma=Gamma(j);
            disp(['lambda=',num2str(lambda)])
            disp(['beta=',num2str(beta)])
            disp(['gamma=',num2str(gamma)])
            disp('Running......')

            %% 探测算法
            result=func_GTVLRR(hsi,Dict,lambda,beta,gamma);   
            %% AUC值
            R_value =reshape(result,1,rows*cols);
            [FA,PD] = perfcurve(label_value,R_value,'1') ;
            AUC = -sum((FA(1:end-1)-FA(2:end)).*(PD(2:end)+PD(1:end-1))/2);
            disp('AUC Value：')
            disp(vpa(AUC,6))
            ParaMat((k-1)*length(Beta)+i,j)=AUC;
            xlswrite(file_name,ParaMat,'sheet1','A1')
        end
    end
end
t=toc;
disp(['运行时间为：',num2str(t)])
delete(h)  % 关闭进度条
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxx The End xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
%%
maxVal=max(ParaMat(:));
[indx,indg]=find(ParaMat==maxVal);

if mod(indx,length(Beta)) == 0
    indl= floor(indx/length(Beta));
    indb= indx-(indl-1)*length(Beta);
else
    indl= floor(indx/length(Beta))+1;
    indb= indx-(indl-1)*length(Beta);
end    

disp(['The Optimal AUC Value is :',num2str(maxVal)])
disp(['The Optimal Window Size is ( lambda = ',num2str(Lambda(indl)),' beta = ',num2str(Beta(indb)),' gamma = ',num2str(Gamma(indg)),' )'])
disp( datestr(now))
%%
% figure;
% plot(ParaMat','LineWidth',2);
% title('AUC Value with different winsize')
% legend('\lambda=1e-6','\lambda=1e-5','\lambda=1e-4','\lambda=1e-3','\lambda=1e-2','\lambda=1e-1')
% ylabel('AUC Value');
% xlabel('Window Size')
%%
% figure;
% X=1:length(Win_out);
% Y=1:length(LambdaMat);
% [X, Y] = meshgrid(X, Y);
% % meshz(X,Y,ParaMat)
% surf(X,Y,ParaMat)

%%
xlswrite(file_name,ParaMat','sheet1','A1')






