%% Compiled by zephyrhou on 2020.02.07
% 窗口与Lambda参数寻优(2020.01.08)
%% 导入数据
clc;clear;close all;
disp( datestr(now))
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('xx                      自动参数寻优程序：                         xx')
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
addpath('C:\Users\dream\Documents\MATLAB\Functions');
addpath('C:\Users\dream\Documents\MATLAB\Test_Datas\ABU')
%%%选择影像文件

[imgname,pathname]=uigetfile('*.*', 'Select the original image file','C:\Users\dream\Documents\MATLAB\Test_Datas'); 
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
%% 最优参数测试


Win_out=[5,7,9,11,13,15,17,19,21,23,25,7,9,11,13,15,17,19,21,23,25,9,11,13,15,17,19,21,23,25,11,13,15,17,19,21,23,25,13,15,17,19,21,23,25,15,17,19,21,23,25,17,19,21,23,25];
Win_in =[3,3,3, 3, 3, 3, 3, 3, 3, 3, 3,5,5, 5, 5, 5, 5, 5, 5, 5, 5,7, 7, 7, 7, 7, 7, 7, 7, 7, 9, 9, 9, 9, 9, 9, 9, 9,11,11,11,11,11,11,11,13,13,13,13,13,13,15,15,15,15,15];

LambdaMat=[1e-6];
% LambdaMat=[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1];

%%
ParaMat=zeros(length(LambdaMat),length(Win_out));
h=waitbar(0,'please wait......','Name','Optimal Paramaters');
tic;

for Lv=1:length(LambdaMat)
    disp('-----------------------------------------------------')
    Lambda=LambdaMat(Lv);
    for i=1:length(Win_out)
       % 进度条显示
        numP=(i+(Lv-1)*length(Win_out))/(length(Win_out)*length(LambdaMat));
        str=['Running   ',num2str(fix(numP*10000)/100),'%,  Please Wait......'];
        waitbar(numP,h,str)    
        disp('参数显示：')
        win_out=Win_out(i);
        win_in=Win_in(i);
        disp(['lambda=',num2str(Lambda)])
        disp(['win_out=',num2str(win_out)])
        disp(['win_in=',num2str(win_in)])
        disp('Running......')

        %% 探测算法
        result=func_CRD(hsi,win_out, win_in,Lambda);  
%         result=func_LRX(hsi,win_out, win_in);  
        %% AUC值
        R_value =reshape(result,1,rows*cols);
        [FA,PD] = perfcurve(label_value,R_value,'1') ;
        AUC = -sum((FA(1:end-1)-FA(2:end)).*(PD(2:end)+PD(1:end-1))/2);
        disp('AUC Value：')
        disp(vpa(AUC,6))
        ParaMat(Lv,i)=AUC;
    end
end
t=toc;
disp(['运行时间为：',num2str(t)])
delete(h)  % 关闭进度条
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxx The End xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
%%
maxVal=max(ParaMat(:));
[indx,indy]=find(ParaMat==maxVal);
disp(['The Optimal AUC Value is :',num2str(maxVal)])
disp(['The Optimal Window Size is ( lambda = ',num2str(LambdaMat(indx)),' Win_out = ',num2str(Win_out(indy)),' Win_in = ',num2str(Win_in(indy)),' )'])
disp( datestr(now))
%%
figure;
plot(ParaMat','LineWidth',2);
title('AUC Value with different winsize')
legend('\lambda=1e-6','\lambda=1e-5','\lambda=1e-4','\lambda=1e-3','\lambda=1e-2','\lambda=1e-1')
ylabel('AUC Value');
xlabel('Window Size')
%%
% figure;
% X=1:length(Win_out);
% Y=1:length(LambdaMat);
% [X, Y] = meshgrid(X, Y);
% % meshz(X,Y,ParaMat)
% surf(X,Y,ParaMat)

%%
file_name='C:\Users\dream\Desktop\Res_ParaMat.xlsx';
xlswrite(file_name,ParaMat','sheet1','A1')






