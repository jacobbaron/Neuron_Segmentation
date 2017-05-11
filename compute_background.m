function [peak_bkgd]=compute_background(foreground,img_stack)

    img_size=size(img_stack);
    img_list=reshape(img_stack,prod(img_size(1:3)),img_size(4));
    bkgd_list=~foreground(:);
    bkgd_pts=img_list(bkgd_list,:);
    [n,binedges]=histcounts(bkgd_pts(bkgd_pts>0));
    peak_bkgd=binedges(n==max(n));
    
end