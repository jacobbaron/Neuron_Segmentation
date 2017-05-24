function [realigned_red_img,realigned_green_img]=fix_poor_alignment(red_img,green_img)

red_img3D=red_img;
red_img=max(red_img,[],3);
h=waitbar(0,'Median Filter');
for ii=1:size(red_img,4)
    
   red_img(:,:,:,ii)=medfilt2(red_img(:,:,:,ii)); 
   waitbar(ii/size(red_img,4),h);
end
close(h);

[~,corr] = mean_squared_diff(red_img);

%% 
    A=[ones(size(corr)),(1:length(corr))'];
    b=A\corr;
    x=1:length(corr);
    corr_lin=b(1)+x*b(2);
    bad_pts=(corr-corr_lin')<=1;%-std(corr-corr_lin')/2;
    best_pts=(corr-corr_lin')>std(corr-corr_lin');
    best_pts_idx=find(best_pts);
    bad_pts_idx=find(bad_pts);
    %% 
     maxstep=.0625;
      minstep=1e-6;
      maxiter=1000;
    optimizer = registration.optimizer.RegularStepGradientDescent;
    [optimizer, metric]  = imregconfig('monomodal');
    %MaxStepLength_init=maxstep;
    optimizer.MaximumIterations=maxiter;
    optimizer.MinimumStepLength=minstep;
    
    
    %max_good_frames=max(img(:,:,:,best_pts),[],3);
      
    %new_alignment=aligned_red_image;
    
    %img=double(tsne_data.img);
    
    
    hbar=parfor_progressbar(length(bad_pts_idx),'Fine Tuning...');
    img_dim=size(red_img(:,:,:,ii));
    aligned_bad_img=red_img(:,:,:,bad_pts);
    aligned_ref_imgs=aligned_bad_img;
    
    
    %new_alignment=aligned_bad_img;
    bad_green_img=green_img(:,:,:,bad_pts);
    new_green_alignment=bad_green_img;
    bad_red_3D = red_img3D(:,:,:,bad_pts);
    new_red_3D = bad_red_3D;
    for ii=1:length(bad_pts_idx)
        [~,nearest_best_pt_idx]=min(abs(best_pts_idx-ii));
        aligned_ref_imgs(:,:,:,ii)=red_img(:,:,:,nearest_best_pt_idx);
    end
    img_dim3D=size(green_img(:,:,:,1));
    update_size=round(length(bad_pts_idx)/100);
    parfor ii=1:length(bad_pts_idx)
        
           
           %find nearest good point
            tform=imregtform(aligned_bad_img(:,:,:,ii),red_img(:,:,:,1),...
                'translation',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',2);
            
            
%             new_alignment(:,:,:,ii)=imwarp(aligned_bad_img(:,:,:,ii),tform,...
%                 'OutputView',imref2d(img_dim));
           T2d=tform.T;
           T3d=eye(4);
           T3d(4,1:2)=T2d(3,1:2);
           tform3d=affine3d(T3d);
            new_green_alignment(:,:,:,ii)=imwarp(bad_green_img(:,:,:,ii),tform3d,...
                'OutputView',imref3d(img_dim3D));
            new_red_3D(:,:,:,ii)=imwarp(bad_red_3D(:,:,:,ii),tform3d,...
                'OutputView',imref3d(img_dim3D));
            if mod(ii,update_size)==0
                hbar.iterate(update_size);
            end
            
           
           
    end
    close(hbar);
    %close(h);
    realigned_red_img=red_img3D;
    realigned_red_img(:,:,:,bad_pts)=new_red_3D;
    realigned_green_img(:,:,:,bad_pts)=new_green_alignment;
    %[~,corr2] = mean_squared_diff(max(realigned_red_img,[],3).^2);
    
    not_zeros=~any(max(realigned_red_img,[],3)==0,4);
    [idy,idx]=ind2sub(size(not_zeros),find(not_zeros));
    
    realigned_red_img=realigned_red_img(min(idy):max(idy),min(idx):max(idx),:,:);
    realigned_green_img=realigned_green_img(min(idy):max(idy),min(idx):max(idx),:,:);
