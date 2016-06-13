function [aligned_red_img,aligned_green_img]=img_registration_parallel_2D(img_reg,green_img)



%optimizer.MinimumStepLength=1e-5;
    MaxStepLength_init=0.01;
    
    



aligned_red_img = zeros(size(img_reg));
aligned_red_img(:,:,:,1)=img_reg(:,:,:,1);
aligned_green_img= zeros(size(green_img));
aligned_green_img(:,:,:,1)=green_img(:,:,:,1);
fprintf('parallel starting...\n');

pyramidlevel=4;

img_reg_maxinten=squeeze(max(img_reg,[],3));
fixed=img_reg_maxinten(:,:,1);


tic
parfor ii=2:size(img_reg_maxinten,3)
    optimizer = registration.optimizer.RegularStepGradientDescent; % here you can modify the default properties of the optimizer to suit your need/to adjust the parameters of registration.

    [optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.
   
    optimizer.MaximumStepLength = MaxStepLength_init;

    optimizer.MinimumStepLength=1e-6;
    moving=img_reg_maxinten(:,:,ii);
    lastwarn('');
   
    tform = imregtform(moving,fixed,'rigid',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
    [~,lastwarning]=lastwarn;
    while strcmp(lastwarning,'images:regmex:registrationOutBoundsTermination')
       lastwarn(''); 
       optimizer.MaximumStepLength = optimizer.MaximumStepLength/2;
       tform = imregtform(moving,fixed,'rigid',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
       [~,lastwarning]=lastwarn;
    end
    
    
    tform_mat=tform.T;
    
    tform_mat_3D=eye(4);
    tform_mat_3D([1:2,4],[1:2,4])=tform_mat;
    
    tform3D = affine3d(tform_mat_3D);
    
    aligned_red_img(:,:,:,ii) = imwarp(img_reg(:,:,:,ii),tform3D,'OutputView',imref3d(size(img_reg(:,:,:,1))));
    
    aligned_green_img(:,:,:,ii) = imwarp(green_img(:,:,:,ii),tform3D,'OutputView',imref3d(size(img_reg(:,:,:,1))));
    fprintf('%d/%d\n',ii,size(img_reg,4));
end
toc
