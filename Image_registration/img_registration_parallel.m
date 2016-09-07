function [aligned_red_img,aligned_green_img]=img_registration_parallel(img_reg,green_img)



%optimizer.MinimumStepLength=1e-5;
MaxStepLength_init=0.0625;

fixed=img_reg(:,:,:,1);
aligned_red_img = zeros(size(img_reg));
aligned_red_img(:,:,:,1)=fixed;
aligned_green_img= zeros(size(green_img));
aligned_green_img(:,:,:,1)=green_img(:,:,:,1);
fprintf('parallel starting...\n');
pyramidlevel=floor(log2(size(img_reg,3)))-1;
tic
for ii=2:size(img_reg,4)
    optimizer = registration.optimizer.RegularStepGradientDescent; % here you can modify the default properties of the optimizer to suit your need/to adjust the parameters of registration.

    [optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.
    optimizer.RelaxationFactor=0.8;
    optimizer.MinimumStepLength=1e-5;
    optimizer.MaximumStepLength = MaxStepLength_init;
    optimizer.MaximumIterations=1000;
    moving=img_reg(:,:,:,ii);
   lastwarn('');
   
   tform = imregtform(moving,fixed,'translation',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
    [~,lastwarning]=lastwarn;
    while strcmp(lastwarning,'images:regmex:registrationOutBoundsTermination')
       lastwarn(''); 
       optimizer.MaximumStepLength = optimizer.MaximumStepLength/2;
       tform = imregtform(moving,fixed,'translation',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
       [~,lastwarning]=lastwarn;
    end
    optimizer.MaximumStepLength = MaxStepLength_init;
    tform = affine3d(tform.T);
    aligned_red_img(:,:,:,ii) = imwarp(moving,tform,'OutputView',imref3d(size(fixed)));
    
    aligned_green_img(:,:,:,ii) = imwarp(green_img(:,:,:,ii),tform,'OutputView',imref3d(size(fixed)));
    fprintf('%d/%d ',ii,size(img_reg,4));
end
toc
