%% Statistical Separability Analysis(Boxplot)
% Compiled by Zephyr Hou on 2019-01-23
%% Load Results
clc;clear;close all;

load('Res_LosAngeles.mat')
% load('Res_CatIsland.mat')
% load('Res_TexasCoast.mat')
% load('Res_PaviaCentra.mat')
% load('Res_Cri.mat')

[rows,cols] = size(hsi_gt);
num_meth = 6;   % The number of all methods
%% Normalized(0-1)
max1 = max(max(R1));min1 = min(min(R1));
R1 = (R1-min1)/(max1-min1);

max2 = max(max(R2));min2 = min(min(R2));
R2 = (R2-min2)/(max2-min2);

max3 = max(max(R3));min3 = min(min(R3));
R3 = (R3-min3)/(max3-min3);

max4 = max(max(R4));min4 = min(min(R4));
R4 = (R4-min4)/(max4-min4);

max5 = max(max(R5));min5 = min(min(R5));
R5 = (R5-min5)/(max5-min5);

max0 = max(max(R0));min0 = min(min(R0));
R0 = (R0-min0)/(max0-min0);

%% Reshape 2D result to vector
label_value = reshape(hsi_gt,1,rows*cols);
R1_value = reshape(R1,1,rows*cols);
R2_value = reshape(R2,1,rows*cols);
R3_value = reshape(R3,1,rows*cols);
R4_value = reshape(R4,1,rows*cols);
R5_value = reshape(R5,1,rows*cols);
R0_value = reshape(R0,1,rows*cols);

%%
ind_tar = find(label_value == 1);
ind_bac = find(label_value == 0);
num_targ = length(ind_tar);
num_back = length(ind_bac);

targ1 = R1_value(ind_tar);
targ2 = R2_value(ind_tar);
targ3 = R3_value(ind_tar);
targ4 = R4_value(ind_tar);
targ5 = R5_value(ind_tar);
targ0 = R0_value(ind_tar);

back1 = R1_value(ind_bac);
back2 = R2_value(ind_bac);
back3 = R3_value(ind_bac);
back4 = R4_value(ind_bac);
back5 = R5_value(ind_bac);
back0 = R0_value(ind_bac);

X_targ = [targ1;targ2;targ3;targ4;targ5;targ0]';
X_back = [back1;back2;back3;back4;back5;back0]';
X = [X_targ(:);X_back(:)];
X = X(:);
g1_targ = [ones(1,num_targ); 2*ones(1, num_targ); 3*ones(1, num_targ);4*ones(1, num_targ);...
    5*ones(1, num_targ);6*ones(1, num_targ)]'; 
g1_back = [ones(1, num_back); 2*ones(1, num_back); 3*ones(1, num_back);4*ones(1, num_back);...
    5*ones(1, num_back);6*ones(1, num_back)]'; 
g1 = [g1_targ(:); g1_back(:)];
g1 = g1(:);
g2 = [ones(num_meth*num_targ,1);2*ones(num_meth*num_back,1)];
g2 = g2(:);
positions = [[1:num_meth],[1:num_meth]+0.3];
%%
figure(2);
% 相关属性['plotstyle','compact']['colorgroup',g2,]['color','rk']
bh=boxplot(X, {g2,g1} ,'whisker',10000,'colorgroup',g2, 'symbol','.','outliersize',4,'widths',0.2,'positions',positions,'color','rb'); 

set(bh,'LineWidth',1.5)
ylabel('Detection test statistic range');

% grid on
% set(gca,'YLim',[0,0.5],'gridLineStyle', '-.');

% ylim([0,0.0065])  % 用于y轴的坐标轴显示范围的控制

Xtick_pos = [1:num_meth]+0.15;% 确定label显示的位置
Xtick_label  ={'GRX','LRX','CRD','RPCA-RX','GTVLRR','2S-GLRT'};
set(gca,'XTickLabel',Xtick_label, 'XTick',Xtick_pos); %可以设置字体属性['fontsize',15]
% xtickangle(15)% 旋转标签角度

%% 
h=findobj(gca,'Tag','Outliers');
delete(h) 
legend(findobj(gca,'Tag','Box'),'Background','Anomaly')

%% 最大值与最小值（箱须至高与至低点：whisker 为0-100%）
p_targ = prctile(X_targ,[0 100]);
p_back = prctile(X_back,[0 100]);
% p_targ = prctile(X_targ,[10 90]);
% p_back = prctile(X_back,[10 90]);
p = [];
for i = 1:num_meth
    p = [p,p_targ(:,i),p_back(:,i)];
end

% 箱子的上边缘与下边缘 (异常、背景区域10% 与 90% 统计)
q_targ = quantile(X_targ,[0.1 0.9]);  
q_back = quantile(X_back,[0.1 0.9]);  
% q_targ = quantile(X_targ,[0.09 0.81]);  
% q_back = quantile(X_back,[0.09 0.81]);  
q = [];
for i = 1:num_meth
    q = [q,q_targ(:,i),q_back(:,i)];
end

h = flipud(findobj(gca,'Tag','Box'));
for j = 1:length(h)
    q10 = q(1,j);
    q90 = q(2,j);
    set(h(j),'YData',[q10 q90 q90 q10 q10]);
end

% Replace upper end y value of whisker
h = flipud(findobj(gca,'Tag','Upper Whisker'));
for j=1:length(h);
%     ydata = get(h(j),'YData');
%     ydata(2) = p(2,j);
%     set(h(j),'YData',ydata);
    set(h(j),'YData',[q(2,j) p(2,j)]);
end

% Replace all y values of adjacent value
h = flipud(findobj(gca,'Tag','Upper Adjacent Value'));
for j=1:length(h);
%     ydata = get(h(j),'YData');
%     ydata(:) = p(2,j);
    set(h(j),'YData',[p(2,j) p(2,j)]);
end

% Replace lower end y value of whisker
h = flipud(findobj(gca,'Tag','Lower Whisker'));
for j=1:length(h);
%     ydata = get(h(j),'YData');
%     ydata(1) = p(1,j);
    set(h(j),'YData',[q(1,j) p(1,j)]);
end

% Replace all y values of adjacent value
h = flipud(findobj(gca,'Tag','Lower Adjacent Value'));
for j=1:length(h);
%     ydata = get(h(j),'YData');
%     ydata(:) = p(1,j);
    set(h(j),'YData',[p(1,j) p(1,j)]);
end