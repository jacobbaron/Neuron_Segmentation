function [tform]=...
    register_two_movies(red_img2register,template)

%all movie inputs (red_img2register, and template)
%should be aligned with respect to the first frame. 


fixed=medfilt3D(max(template,[],4));
moving=medfilt3D(max(red_img2register,[],4));

optimizer = registration.optimizer.RegularStepGradientDescent; % here you can modify the default properties of the optimizer to suit your need/to adjust the parameters of registration.

    [optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.
    optimizer.RelaxationFactor=0.5;
    optimizer.GradientMagnitudeTolerance=1e-5;
    optimizer.MinimumStepLength=1e-7;
    optimizer.MaximumIterations=1000;
    MaxStepLength_init=0.01;
    optimizer.MaximumStepLength = MaxStepLength_init;
    pyramidlevel=floor(log2(size(moving,3)))-1;
    lastwarn('');
    
     tform = imregtform(moving,fixed,'affine',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
    [~,lastwarning]=lastwarn;
    while strcmp(lastwarning,'images:regmex:registrationOutBoundsTermination')
       lastwarn(''); 
       optimizer.MaximumStepLength = optimizer.MaximumStepLength/2;
       tform = imregtform(moving,fixed,'affine',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',pyramidlevel);
       [~,lastwarning]=lastwarn;
    end
    optimizer.MaximumStepLength = MaxStepLength_init;
    tform = affine3d(tform.T);
    
   % reg_labels=imwarp(labels,tform,'OutputView',imref3d(size(moving)));
%     template_sz=size(template);
%     reg_size=size(red_img2register);
%     reg_red_img=zeros([template_sz(1:3),reg_size(4)]);
%     reg_green_img=reg_red_img;
%      for ii=1:size(green_img2register,4)
%  
%          reg_red_img(:,:,:,ii)=imwarp(red_img2register(:,:,:,ii),tform,'OutputView',imref3d(size(fixed)));
%          reg_green_img(:,:,:,ii)=imwarp(green_img2register(:,:,:,ii),tform,'OutputView',imref3d(size(fixed)));
%  
%      end
%     
%     