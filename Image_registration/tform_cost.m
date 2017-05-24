function [cost]=tform_cost(max_img,frame,x,y)
    T=eye(3);
    T(3,1)=x;
    T(3,2)=y;
    
    tform=affine2d(T);
    frame_trans=imwarp(frame,tform,'OutputView',imref2d(size(max_img)));
    %not_zeros=frame_trans~=0;
    max_trans=max(cat(3,frame_trans,max_img),[],3);
    cost=sum(max_trans(:));
    %cost=var(,frame_trans
    
%      figure(4);imshow(max_trans,[0,max(max_trans(:))]);
%      axis equal;
%      title(cost)
% %     
%     