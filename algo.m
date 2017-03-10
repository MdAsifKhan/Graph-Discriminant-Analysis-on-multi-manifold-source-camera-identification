clc
clear all
close all

image=double(imread('ucid02.tif'));
% image=image(56:156,56:156,:);
w=input('Enter Value of block size');
num_bins=input('Enter Number of bins');
r1=input('Enter Horizontal distance');
r2=input('Enter Vertical distance');
p=input('Enter p quantile');

[Nx,Ny,num_channels]=size(image);
num_blocks=(Nx-w+1)*(Ny-w+1);
for channel=1:1  %num_channels
    k=1;
    for i=1:Nx-w+1
        for j=1:Ny-w+1
            B(:,:,k)=image(i:i+w-1,j:j+w-1,channel);
            tilde_B(:,:,k)=dct2(B(:,:,k));
            k=k+1;
        end
    end
    ccc=1;cc=1;
    for i=1:Nx-w+1
        for j=1:Ny-w+1
            tilde_m1=tilde_B(:,:,cc);
            PMSE=[];count=1;
            x=i+r1;
            while(x<(i+r2) && x<=(Nx-w+1))
                 y=j+r1;
                 while(y<(j+r2)&& y<=(Ny-w+1))
                   if max((x-i),(y-j))>=r1 && max((x-i),(y-j))<=r2,
                            tilde_m2=tilde_B(:,:,(x-1)*(Nx-w+1)+y);
                            PMSE(count)=mean_square_err(tilde_m1,tilde_m2,w);
                            count=count+1;
                    end
                     y=y+1;
                 end
                 x=x+1;
            end   
             if min(PMSE)>0,
                L.block(:,:,ccc)=tilde_m1;
                L.PMSE(ccc)=min(PMSE);
                block_means(ccc)=tilde_m1(1,1)/w;
                ccc=ccc+1;
             end   
             cc=cc+1;
         end
    end
    num_blocks_hist=ccc-1;
    samples_per_bin=floor(num_blocks_hist/num_bins);
    [sort_mean,mean_idx]=sort(block_means);
    elements_count=0;binn=1;i1=1;
       % Dividing elements of L into disjoint bins according to mean intensity
    for ii=1:num_blocks_hist
        idx=mean_idx(ii);
        if (~(binn == num_bins) && (elements_count >= samples_per_bin)),
            binn=binn+1;i1=1;
            elements_count=0;
        else
           bl=L.block(:,:,idx); 
           bin.block(i1,:,binn)=reshape(bl',1,16);
           bin.PMSE(i1,binn)=L.PMSE(idx);i1=i1+1;
           elements_count=elements_count+1;
        end
    end
    % For each bin consider those blocks whose PMSE is below p-quantile
    for kk=1:binn
        PMSE_kk=bin.PMSE(:,kk);
        block_bin_kk=bin.block(:,:,kk);
       if kk==binn, %final bin will have less number of block so some zeros were added to avoid size discrepancy while creating a bin,
                    %the following statement discards such zeros 
             PMSE_kk=PMSE_kk(PMSE_kk~=0);
             block_bin_kk=block_bin_kk(1:length(PMSE_kk),:);
       end
        K=length(PMSE_kk)*p;
        elems_bin=size(PMSE_kk,1)
        [sort_PMSE,idx_PMSE]=sort(PMSE_kk);
        [tilde_sigma(kk,:),bin_intensity(kk,:)]=compute_std(idx_PMSE,K,w,block_bin_kk);
    end    
    save(strcat('Intensity and Variance for channel','_',num2str(channel)),'tilde_sigma','bin_intensity');
end    
            
                 
        


