clc
clear all
close all

tilde_u=double(imread('abc.jpg'));
[W,H,num_channel]=size(tilde_u);
k=4;
Nmin=input('Minimum Number of Similar Patches');
Nmax=input('Maximum No. of Similar Patches');
eta=input('Size of Search Window');

for ch=1:num_channel
    str=strcat('Intensity and Variance for channel','_',num2str(ch));
    D=dctmtx(16);
    for i=1:size(tilde_sigma,1)
        M(:,:,i)=diag(std_1(i,:));
        cov_mat(:,:,i)=D'*M(:,:,i)*D;
    end
    
    
    
end

