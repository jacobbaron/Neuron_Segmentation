function [aligned_red_img,aligned_green_img]=img_registration(img_reg,green_img)

optimizer = registration.optimizer.RegularStepGradientDescent; % here you can modify the default properties of the optimizer to suit your need/to adjust the parameters of registration.

[optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.


fixed=img_reg(:,:,:,1);
aligned_red_img = zeros(size(img_reg));
aligned_red_img(:,:,:,1)=fixed;
aligned_green_img= zeros(size(green_img));
aligned_green_img(:,:,:,1)=green_img(:,:,:,1);
fprintf('serial starting...\n');
for ii=2:size(img_reg,4)
   moving=img_reg(:,:,:,ii);
   tform = imregtform(moving,fixed,'rigid',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',2);
    tform = affine3d(tform.T);
    aligned_red_img(:,:,:,ii) = imwarp(moving,tform,'OutputView',imref3d(size(fixed)));
    
    aligned_green_img(:,:,:,ii) = imwarp(green_img(:,:,:,ii),tform,'OutputView',imref3d(size(fixed)));
    fprintf('%d/%d ',ii,size(img_reg,4));
end

