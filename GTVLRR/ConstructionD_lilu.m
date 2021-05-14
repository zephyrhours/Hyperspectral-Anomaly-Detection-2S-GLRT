function Dict=ConstructionD_lilu(data,K,P)
%% Function Usage
% Input:
%     data --  2ά���ݣ�ÿ��Ϊһ����Ԫ(data��bands x pixels��
%        K --  KΪ������
%        P --  PΪÿ�ౣ����ԭ�Ӹ���
% ����K=15,P=20,��Щֵ���趨�ο�LRASR�㷨
% Output:
%    Dict -- �ֵ䣬ÿһ��Ϊһ��ԭ�ӣ�data��bands x nums
%% Main Function

IDX=kmeans(data',K,'start','plus'); % 'plus'Ĭ�ϳ�ʼ����λ��
Dict=[];
for i=1:K
    pos=find(IDX==i);
    D_temp=data(:,pos);
    if(size(D_temp,2)<P)
        continue; % continue �������ǽ�������ѭ��������continue֮��Ĵ��룬����������һ��ѭ������
    end
    % ������������RX̽��
    mu=mean(D_temp,2); % ���������ľ�ֵ����һ��������
    COV_inv=pinv(cov(D_temp')); % ����һ���Э����
    D_temp_C=D_temp-repmat(mu,[1,size(D_temp,2)]);
    Dis=zeros(1,size(D_temp,2));
    for j=1:size(D_temp,2)
        Dis(j)=D_temp_C(:,j)'*COV_inv*D_temp_C(:,j); % RX̽���㷨
    end
    [~,Ind]=sort(Dis);  % �����Ͼ����С��������
    Dict=[Dict,D_temp(:,Ind(1:P))]; % ȡ������С��P����Ϊ������ֵ�
end
