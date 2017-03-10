clc
clear all
close all

C=input('Enter Number of Classes');
 for i=1:C
     N_c(i)=input(strcat('Enter Number of Training Image pairs for class','_',num2str(i)));
 end
N=sum(N_c);
%Read High and low resolution Training Images for each class
Kw=input('Enter Number of Neighbors belonging to same person');
Kb=input('Enter Number of Neighbors belonging to different person');
for i=1:N
%     y=double(rgb2gray(imread('High_resolution.image')));
    y=rand(100,100);
    Y(:,i)=y(:);
%     x=double(rgb2gray(imread('Low_resolution.image')));
    x=rand(12,12);
    X(:,i)=x(:);
end
%To find K nearest neighbors of every yi
Ww=zeros(N,N);Wb=zeros(N,N);
i=1;init=1;Y_diff=[];b=1;
for i=1:C
    for y_i=1:N_c(i)
        Y_s=Y(:,init:N_c(i))';
        [idx]=knnsearch(Y_s,Y(:,y_i)','dist','euclidean','k',Kw);
        Ww(y_i,idx)=1/(Kw+1);
        b=N_c(i)+b;
        if i~=1,
            Y_diff=[Y(:,1:N_c(i-1))';Y(:,b:end)'];
        else
            Y_diff=Y(:,b:end)';
        end    
        [idy]=knnsearch(Y_diff,Y(:,y_i)','dist','euclidean','k',Kb);
        Wb(y_i,idy)=1/Kb;
%         if 
%         Y_diff=[];
    end 
    Y_diff=[];
%    Y_diff=Y(:,1:N_c(i))';
   init=N_c(i)+init;
end
Dw=diag(sum(Ww));
Db=diag(sum(Wb));
Lw=Dw-Ww;
Lb=Db-Wb;
alpha=3;beta=25;
A=(Y*X')/((X*X')+alpha*(X*(Lw-beta*Lb)*X'));


   
   

   

