function [foreground,min_range,max_range]=bkgd_cost_fn(Img4D,T)
    coeffs=pca(reshape(Img4D,size(Img4D,1)*size(Img4D,2)*size(Img4D,3),size(Img4D,4))',...
        'NumComponents',40);
    dist=sqrt(sum(coeffs.^2,2));
    min_range=min(dist);
    max_range=max(dist);
   
    foreground=reshape(dist>T,size(Img4D,1),size(Img4D,2),size(Img4D,3));
   
end