function [tilde_sigma,bin_intensity]=compute_std(idx_PMSE,K,w,block_bin_kk)

for k=1:K
    block(k,:)=block_bin_kk(idx_PMSE(k),:);
end    
med=median(block);
hat_sigma=median(abs(bsxfun(@minus,block,med)));
tilde_sigma=1.967*hat_sigma-0.2777;
 
bin_intensity=median(block(:,1)/w);
end

