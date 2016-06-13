function []=make_movie_from_single_label(img_stack,labels,label)
figure;
img_stack_subset=img_stack;
[i,j,k]=ind2sub(size(labels),find(~(labels==label)));
t=sort(repmat(1:size(img_stack,4),[length(i),1]));
t=sort(repmat(1:size(img_stack,4)',[length(i),1]));
t=sort(repmat((1:size(img_stack,4))',[length(i),1]));
i_t=repmat(i,[size(img_stack,4),1]);
j_t=repmat(j,[size(img_stack,4),1]);
k_t=repmat(k,[size(img_stack,4),1]);
t_ind=sub2ind(size(img_stack),i_t,j_t,k_t,t);
img_stack_subset(t_ind)=zeros(size(t));
imshow4D_wheel(img_stack_subset);
