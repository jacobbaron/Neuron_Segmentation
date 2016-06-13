function [signal]=calculate_label_signal(img_stack,foreground,labels,label2ID)

img_size=size(img_stack);
img_list=reshape(img_stack,prod(img_size(1:3)),img_size(4));
label_list=labels(:);

bkgd_list=~foreground(:);
bkgd_pts=img_list(bkgd_list,:);
[n,binedges]=histcounts(bkgd_pts(bkgd_pts>0));
peak_bkgd=binedges(find(n==max(n)));

signal=mean(img_list(label_list==label2ID,:),1)-peak_bkgd;
