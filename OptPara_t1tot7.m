%% Compiled by zephyrhou on 2020.06.22
% 窗口参数寻优(2020.06.22)
%% 
clc;clear;close all;
%% 添加路径
cname=getenv('username');     % 获取当前的用户名
function_path=['C:\Users\',cname,'\Documents\MATLAB\Functions']; % matlab下的函数路径
addpath(function_path);
file_name=['C:\Users\',cname,'\Desktop\','Res_ParaMat.xlsx'];    % 最后结果保存路径
Img_path=['C:\Users\',cname,'\Documents\MATLAB\Test_Datas\ABU\img']; % matlab下的函数路径
addpath(Img_path)

%% 自动记录日志打开
diary on       %默认文件名为diary.txt
diary 'mylog.txt'    %默认文件名为mylog.txt
%%
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('xx                      参数自动寻优程序                           xx')
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('作者：Zephyr Hou')
disp( datestr(now))
disp('These will be log!')
%% load函数导入数据
load('abu-urban-5.mat')
disp(['打开影像为：','abu-urban-5.mat'])
hsi=data;
hsi_gt=map;

[rows,cols,bands]=size(hsi);
label_value = reshape(hsi_gt,1,rows*cols);
%% GUI窗口选择数据
% %%%选择影像文件
% [imgname,pathname]=uigetfile('*.*', 'Select the original image file','E:\异常探测实验数据\Hyperspectral Anomaly Detection With Attribute and Edge-Preserving Filters\ABU数据\img');
% str=strcat(pathname,imgname);
% disp('The Original Image is :')
% disp(str);
% addpath(pathname);
% hdrnam=imgname(1:(strfind(imgname,'.')-1));
% NAME=hdrnam;
% NAME=strrep(NAME,NAME(strfind(NAME,'_')),'-');
% hdrname=strcat(hdrnam,'.hdr');
% hsi=read_ENVIimagefile(hdrname,imgname);
% %%%选择真实地物影像文件
% [imgname,pathname]=uigetfile('*.*', 'Select the GT image file',pathname);
% str=strcat(pathname,imgname);
% disp('The GT Image is :')
% disp(str);
% addpath(pathname);
% hdrnam=imgname(1:(strfind(imgname,'.')-1));
% hdrname=strcat(hdrnam,'.hdr');
% hsi_gt=read_ENVIimagefile(hdrname,imgname);
% 
% [rows,cols,bands]=size(hsi);
% label_value = reshape(hsi_gt,1,rows*cols);
%% 参数设置
Win_out=[5,7,9,11,13,15,17,19,21,23,25,7,9,11,13,15,17,19,21,23,25,9,11,13,15,17,19,21,23,25,11,13,15,17,19,21,23,25,13,15,17,19,21,23,25,15,17,19,21,23,25,17,19,21,23,25];
Win_in =[3,3,3, 3, 3, 3, 3, 3, 3, 3, 3,5,5, 5, 5, 5, 5, 5, 5, 5, 5,7, 7, 7, 7, 7, 7, 7, 7, 7, 9, 9, 9, 9, 9, 9, 9, 9,11,11,11,11,11,11,11,13,13,13,13,13,13,15,15,15,15,15];

% 探测算法[t1-t7]
 LoopNums={'t1','t2','t3','t4','t5','t6','t7'};

%%   参数寻优算法主程序
ParaMat=zeros(length(LoopNums),length(Win_out));
h=waitbar(0,'please wait......','Name','Optimal Paramaters');
tic;
for Lv=1:length(LoopNums)
    disp('-----------------------------------------------------')
    disp(['                 探测算法： ',LoopNums{Lv}])
    disp('-----------------------------------------------------')
    disp( datestr(now))
    tic
    for i=1:length(Win_out)
       %% 进度条显示
        numP=(i+(Lv-1)*length(Win_out))/(length(Win_out)*length(LoopNums));
        str=['Running   ',num2str(fix(numP*10000)/100),'%,  Please Wait......'];
        waitbar(numP,h,str)    
        disp('参数显示：')
        win_out=Win_out(i);
        win_in=Win_in(i);
        disp(['win_out=',num2str(win_out)])
        disp(['win_in=',num2str(win_in)])
       %% 探测算法
        switch(Lv)  % 此处莫错
            case{1}
                disp('当前运行程序为： t1')
                disp('Running......')
                result=func_1S_GLRT(hsi,win_out, win_in);          
            case{2}
               disp('当前运行程序为： t2')
               disp('Running......')
               result=func_2S_GLRT(hsi,win_out, win_in); 
            case{3}
               disp('当前运行程序为： t3')
               disp('Running......')
               result=func_t3(hsi,win_out, win_in); 
            case{4}
               disp('当前运行程序为： t4')
               disp('Running......')
               result=func_t4(hsi,win_out, win_in); 
            case{5}
               disp('当前运行程序为： t5')
               disp('Running......')
               result=func_t5(hsi,win_out, win_in);
            case{6}
               disp('当前运行程序为： t6')
               disp('Running......')
               result=func_t6(hsi,win_out, win_in); 
            case{7}
               disp('当前运行程序为： t7')
               disp('Running......')
               result=func_t7(hsi,win_out, win_in); 
        end

       %% AUC值
        R_value = reshape(result,1,rows*cols);
        [FA,PD] = perfcurve(label_value,R_value,'1') ;
        AUC = -sum((FA(1:end-1)-FA(2:end)).*(PD(2:end)+PD(1:end-1))/2);
        disp('AUC Value：')
        disp(vpa(AUC,6))
        ParaMat(Lv,i)=AUC;
        xlswrite(file_name,AUC','sheet1',strcat(char(64+Lv),num2str(i)))  % char(65)='A'
    end
    %%  最优结果
    ParaVec=ParaMat(Lv,:);
    maxVal=max(ParaVec);
    [indx,indy]=find(ParaVec==maxVal);
    disp(['The Optimal AUC Value is :',num2str(maxVal)])
    disp(['The Optimal Window Size is (  Win_out = ',num2str(Win_out(indy)),' Win_in = ',num2str(Win_in(indy)),')'])
    toc
    disp( datestr(now))
end
t=toc;
disp(['总运行时间为：',num2str(t)])
delete(h)  % 关闭进度条
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxx The End xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp( datestr(now))

%%   最优参数展示
for kk=1:length(LoopNums)
    disp(['在运行程序 ',LoopNums{kk},' 中的最优结果为：'])
    ParaVec=ParaMat(kk,:);
    maxVal=max(ParaVec);
    [indx,indy]=find(ParaVec==maxVal);
    disp(['The Optimal AUC Value is :',num2str(maxVal)])
    disp(['The Optimal Window Size is (  Win_out = ',num2str(Win_out(indy)),' Win_in = ',num2str(Win_in(indy)),')'])
end

%% 自动关闭日志记录
disp('log has been colsed!')
diary off   %结束记录
%% 探测结果绘制
figure;
plot(ParaMat','LineWidth',2);
title('AUC Value with different winsize')
legend('t1','t2','t3','t4','t5','t6','t7')
ylabel('AUC Value');
xlabel('Window Size')

%%  最后结果自动保存
cname=getenv('username'); % 获取当前的用户名
file_name=['C:\Users\',cname,'\Desktop\','Res_ParaMat.xlsx']; 
xlswrite(file_name,ParaMat','sheet2','A1')







