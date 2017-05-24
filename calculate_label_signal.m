 function [signal]=calculate_label_signal(img_stack,peak_bkgd,labels,label2ID)

img_size=size(img_stack);

img_list=reshape(img_stack,prod(img_size(1:3)),img_size(4));

label_list=labels(:);



signal=mean(img_list(label_list==label2ID,:),1)-peak_bkgd;

1;