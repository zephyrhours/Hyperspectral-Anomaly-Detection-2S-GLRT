function Dict=ConstructionD_lilu(data,K,P)
%% Function Usage
% Input:
%     data --  2维数据，每列为一个像元(data：bands x pixels）
%        K --  K为聚类数
%        P --  P为每类保留的原子个数
% 其中K=15,P=20,这些值的设定参考LRASR算法
% Output:
%    Dict -- 字典，每一列为一个原子，data：bands x nums
%% Main Function

IDX=kmeans(data',K,'start','plus'); % 'plus'默认初始质心位置
Dict=[];
for i=1:K
    pos=find(IDX==i);
    D_temp=data(:,pos);
    if(size(D_temp,2)<P)
        continue; % continue 的作用是结束本次循环，跳过continue之后的代码，继续进行下一次循环操作
    end
    % 下面代码就是求RX探测
    mu=mean(D_temp,2); % 所有向量的均值，是一个列向量
    COV_inv=pinv(cov(D_temp')); % 求这一类的协方差
    D_temp_C=D_temp-repmat(mu,[1,size(D_temp,2)]);
    Dis=zeros(1,size(D_temp,2));
    for j=1:size(D_temp,2)
        Dis(j)=D_temp_C(:,j)'*COV_inv*D_temp_C(:,j); % RX探测算法
    end
    [~,Ind]=sort(Dis);  % 对马氏距离从小到大排序
    Dict=[Dict,D_temp(:,Ind(1:P))]; % 取距离最小的P个作为该类的字典
end
