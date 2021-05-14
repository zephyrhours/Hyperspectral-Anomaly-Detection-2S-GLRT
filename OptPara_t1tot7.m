%% Compiled by zephyrhou on 2020.06.22
% ���ڲ���Ѱ��(2020.06.22)
%% 
clc;clear;close all;
%% ���·��
cname=getenv('username');     % ��ȡ��ǰ���û���
function_path=['C:\Users\',cname,'\Documents\MATLAB\Functions']; % matlab�µĺ���·��
addpath(function_path);
file_name=['C:\Users\',cname,'\Desktop\','Res_ParaMat.xlsx'];    % ���������·��
Img_path=['C:\Users\',cname,'\Documents\MATLAB\Test_Datas\ABU\img']; % matlab�µĺ���·��
addpath(Img_path)

%% �Զ���¼��־��
diary on       %Ĭ���ļ���Ϊdiary.txt
diary 'mylog.txt'    %Ĭ���ļ���Ϊmylog.txt
%%
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('xx                      �����Զ�Ѱ�ų���                           xx')
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp('���ߣ�Zephyr Hou')
disp( datestr(now))
disp('These will be log!')
%% load������������
load('abu-urban-5.mat')
disp(['��Ӱ��Ϊ��','abu-urban-5.mat'])
hsi=data;
hsi_gt=map;

[rows,cols,bands]=size(hsi);
label_value = reshape(hsi_gt,1,rows*cols);
%% GUI����ѡ������
% %%%ѡ��Ӱ���ļ�
% [imgname,pathname]=uigetfile('*.*', 'Select the original image file','E:\�쳣̽��ʵ������\Hyperspectral Anomaly Detection With Attribute and Edge-Preserving Filters\ABU����\img');
% str=strcat(pathname,imgname);
% disp('The Original Image is :')
% disp(str);
% addpath(pathname);
% hdrnam=imgname(1:(strfind(imgname,'.')-1));
% NAME=hdrnam;
% NAME=strrep(NAME,NAME(strfind(NAME,'_')),'-');
% hdrname=strcat(hdrnam,'.hdr');
% hsi=read_ENVIimagefile(hdrname,imgname);
% %%%ѡ����ʵ����Ӱ���ļ�
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
%% ��������
Win_out=[5,7,9,11,13,15,17,19,21,23,25,7,9,11,13,15,17,19,21,23,25,9,11,13,15,17,19,21,23,25,11,13,15,17,19,21,23,25,13,15,17,19,21,23,25,15,17,19,21,23,25,17,19,21,23,25];
Win_in =[3,3,3, 3, 3, 3, 3, 3, 3, 3, 3,5,5, 5, 5, 5, 5, 5, 5, 5, 5,7, 7, 7, 7, 7, 7, 7, 7, 7, 9, 9, 9, 9, 9, 9, 9, 9,11,11,11,11,11,11,11,13,13,13,13,13,13,15,15,15,15,15];

% ̽���㷨[t1-t7]
 LoopNums={'t1','t2','t3','t4','t5','t6','t7'};

%%   ����Ѱ���㷨������
ParaMat=zeros(length(LoopNums),length(Win_out));
h=waitbar(0,'please wait......','Name','Optimal Paramaters');
tic;
for Lv=1:length(LoopNums)
    disp('-----------------------------------------------------')
    disp(['                 ̽���㷨�� ',LoopNums{Lv}])
    disp('-----------------------------------------------------')
    disp( datestr(now))
    tic
    for i=1:length(Win_out)
       %% ��������ʾ
        numP=(i+(Lv-1)*length(Win_out))/(length(Win_out)*length(LoopNums));
        str=['Running   ',num2str(fix(numP*10000)/100),'%,  Please Wait......'];
        waitbar(numP,h,str)    
        disp('������ʾ��')
        win_out=Win_out(i);
        win_in=Win_in(i);
        disp(['win_out=',num2str(win_out)])
        disp(['win_in=',num2str(win_in)])
       %% ̽���㷨
        switch(Lv)  % �˴�Ī��
            case{1}
                disp('��ǰ���г���Ϊ�� t1')
                disp('Running......')
                result=func_1S_GLRT(hsi,win_out, win_in);          
            case{2}
               disp('��ǰ���г���Ϊ�� t2')
               disp('Running......')
               result=func_2S_GLRT(hsi,win_out, win_in); 
            case{3}
               disp('��ǰ���г���Ϊ�� t3')
               disp('Running......')
               result=func_t3(hsi,win_out, win_in); 
            case{4}
               disp('��ǰ���г���Ϊ�� t4')
               disp('Running......')
               result=func_t4(hsi,win_out, win_in); 
            case{5}
               disp('��ǰ���г���Ϊ�� t5')
               disp('Running......')
               result=func_t5(hsi,win_out, win_in);
            case{6}
               disp('��ǰ���г���Ϊ�� t6')
               disp('Running......')
               result=func_t6(hsi,win_out, win_in); 
            case{7}
               disp('��ǰ���г���Ϊ�� t7')
               disp('Running......')
               result=func_t7(hsi,win_out, win_in); 
        end

       %% AUCֵ
        R_value = reshape(result,1,rows*cols);
        [FA,PD] = perfcurve(label_value,R_value,'1') ;
        AUC = -sum((FA(1:end-1)-FA(2:end)).*(PD(2:end)+PD(1:end-1))/2);
        disp('AUC Value��')
        disp(vpa(AUC,6))
        ParaMat(Lv,i)=AUC;
        xlswrite(file_name,AUC','sheet1',strcat(char(64+Lv),num2str(i)))  % char(65)='A'
    end
    %%  ���Ž��
    ParaVec=ParaMat(Lv,:);
    maxVal=max(ParaVec);
    [indx,indy]=find(ParaVec==maxVal);
    disp(['The Optimal AUC Value is :',num2str(maxVal)])
    disp(['The Optimal Window Size is (  Win_out = ',num2str(Win_out(indy)),' Win_in = ',num2str(Win_in(indy)),')'])
    toc
    disp( datestr(now))
end
t=toc;
disp(['������ʱ��Ϊ��',num2str(t)])
delete(h)  % �رս�����
disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxx The End xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
disp( datestr(now))

%%   ���Ų���չʾ
for kk=1:length(LoopNums)
    disp(['�����г��� ',LoopNums{kk},' �е����Ž��Ϊ��'])
    ParaVec=ParaMat(kk,:);
    maxVal=max(ParaVec);
    [indx,indy]=find(ParaVec==maxVal);
    disp(['The Optimal AUC Value is :',num2str(maxVal)])
    disp(['The Optimal Window Size is (  Win_out = ',num2str(Win_out(indy)),' Win_in = ',num2str(Win_in(indy)),')'])
end

%% �Զ��ر���־��¼
disp('log has been colsed!')
diary off   %������¼
%% ̽��������
figure;
plot(ParaMat','LineWidth',2);
title('AUC Value with different winsize')
legend('t1','t2','t3','t4','t5','t6','t7')
ylabel('AUC Value');
xlabel('Window Size')

%%  ������Զ�����
cname=getenv('username'); % ��ȡ��ǰ���û���
file_name=['C:\Users\',cname,'\Desktop\','Res_ParaMat.xlsx']; 
xlswrite(file_name,ParaMat','sheet2','A1')







