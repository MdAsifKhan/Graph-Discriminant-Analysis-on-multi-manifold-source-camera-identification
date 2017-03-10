clc
clear all
close all

im=double(imread('ucid02.tif'));
image=double(im(56:156,56:156,:));

w=input('Enter Value of block size');
num_bins=input('Enter Number of bins');
r1=input('Enter Horizontal distance');
r2=input('Enter Vertical distance');
p=input('Enter p quantile');

Nx=size(image,1);
Ny=size(image,2);
num_blocks=(Nx-w+1)*(Ny-w+1);
num_channels=size(image,3);
for channel=1:num_channels
    k=1;
    for i=1:Nx-w+1
        for j=1:Ny-w+1
            m=image(i:i+w-1,j:j+w-1,channel);
            B(:,:,k)=m;
            tilde_m1=dct2(m);
            tilde_B(:,:,k)=tilde_m1;
            k=k+1;
        end
    end
    cc=1;f=0;
    for i=1:Nx-w+1
        for j=1:Ny-w+1
            tilde_m1=tilde_B(:,:,cc);
            PMSE=9e9;count=1;
            x=i+r1;
            while(x<(i+r2) && x<=(Nx-w+1))
                y=j+r1;
                while(y<(j+r2)&& y<=(Ny-w+1))
                   if max((x-i),(y-j))>=r1 && max((x-i),(y-j))<=r2,
                        m2=image(x:x+w-1,y:y+w-1,channel);
                        tilde_m2=dct2(m2);
                         if(~(sum(sum(tilde_m1==tilde_m2))==w*w))
%                             PMSE=9e9;
%                             continue;
%                         else    
                            PMSE(count)=mean_square_err(tilde_m1,tilde_m2,w);
                            count=count+1;
                         end    
                    end
                    y=y+1;
                end
                x=x+1;
            end   
            L.block(:,:,cc)=tilde_m1;
            L.PMSE(cc)=min(PMSE);
            block_means(cc)=tilde_m1(1,1)/w;
            cc=cc+1;
        end
    end
    samples_per_bin=floor(num_blocks/num_bins);
%     step=(max(block_means)-min(block_means))/num_bins;
%     lim0=min(block_means);lim1=0;num=1;
    [sort_mean,mean_idx]=sort(block_means);
    i1=1;elements_count=0;bin=1;
    for ii=1:num_blocks
        idx=mean_idx(ii);
        if (~(bin == num_bins) && (elements_count >= samples_per_bin)),
            bin=bin+1;
            elements_count=elements_count+1;i1=1;
        else
           bl=L.block(:,:,idx); 
           bin.block(i1,:,bin)=bl(:)';
           bin.PMSE(i1,bin)=L.PMSE(idx);
           i1=i1+1;
        end
     end   
    for kk=1:num
        PMSE_kk=bin.PMSE(:,kk);
        K=length(PMSE_kk)*p;
        elems_bin=size(PMSE_kk,1)
        block_bin_kk=bin.block(:,:,kk);
        [sort_PMSE,idx_PMSE]=sort(PMSE_kk);
        [tilde_sigma(kk,:),bin_intensity(kk,:)]=compute_std(idx_PMSE,K,w,block_bin_kk);
    end    
    save(strcat('Intensity and Variance for channel','_',num2str(channel)),'tilde_sigma','bin_intensity');
end    
            
                 
        


