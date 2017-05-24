function [red_stack_aligned,green_stack_aligned]=reg_scale_interp(...
    red_img,green_img,t,scalexy,maxstep,maxiter,minstep)

%% 
red_img_XYT=squeeze(max(red_img,[],3));
scaleview=round(scalexy/2);
%scaleviewz=round(scalez/2);
red_stack_filt=box_filtXYT(red_img_XYT,[scalexy,scalexy]);
red_stack_sub=red_stack_filt(1:scaleview:end,1:scaleview:end,:);


optimizer = registration.optimizer.RegularStepGradientDescent;
[optimizer, metric]  = imregconfig('monomodal');
MaxStepLength_init=maxstep;
optimizer.MaximumIterations=maxiter;
optimizer.MinimumStepLength=minstep;
%% 

%fixed=red_stack_sub(:,:,1);

%red_stack_max=squeeze(max(red_img,[],3));
%fixed_max=red_stack_max(:,:,1);


tform_scaled=cell(size(red_img,4),1);
img_size=size(green_img(:,:,:,1));

green_stack_aligned=zeros(size(green_img),'uint16');
green_stack_aligned(:,:,:,1)=green_img(:,:,:,1);
red_stack_aligned=zeros(size(red_img),'uint16');
red_stack_aligned(:,:,:,1)=red_img(:,:,:,1);

%filter in time
t_box=1; %seconds
fps=mean(diff(t));
t_idx_box=round(t_box/fps);
mvavg=cast(...
    filter(ones(1,t_idx_box)/t_idx_box,1,double(red_stack_sub),[],3),'uint16');


red_stack_sub_t=mvavg(:,:,t_idx_box:t_idx_box:end);
if size(red_stack_sub_t,3)~=length(t(1:t_idx_box:end))    
    red_stack_sub_t(:,:,end+1)=red_stack_sub(:,:,end);
end
fixed=red_stack_sub_t(:,:,1);
%tform2D=cell(size(red_stack_sub_t,3),1);
t_x=zeros(size(red_stack_sub_t,3),1);
t_y=t_x;
tic
hbar=parfor_progressbar(size(red_stack_sub_t,3)-1,'Computing Transformation...');
parfor ii=2:size(red_stack_sub_t,3)
    
    moving=red_stack_sub_t(:,:,ii);
    tform2D = imregtform(moving,fixed,'translation',...
        optimizer,metric,'DisplayOptimization',false,'PyramidLevels',2);
%     [~,lastwarning]=lastwarn;
%     while strcmp(lastwarning,'images:regmex:registrationOutBoundsTermination')
%        lastwarn(''); 
%        optimizer.MaximumStepLength = optimizer.MaximumStepLength/2;
%        tform2D = imregtform(moving,fixed,'translation',...
%         optimizer,metric,'DisplayOptimization',false,'PyramidLevels',1);
%        [~,lastwarning]=lastwarn;
%     end
%     optimizer.MaximumStepLength = MaxStepLength_init;
    t_x(ii)=tform2D.T(3,1);
    t_y(ii)=tform2D.T(3,2);
    if mod(ii,5)==0
        hbar.iterate(5);
    end
end
   close(hbar) 
    t_x_interp=interp1(t(1:t_idx_box:end),t_x,t,'spline','extrap');
    t_y_interp=interp1(t(1:t_idx_box:end),t_y,t,'spline','extrap');
    T3D=cellfun(@(x,y)[1,0,0,0;0,1,0,0;0,0,1,0;x*scaleview,y*scaleview,0,1],...
        num2cell(t_x_interp),num2cell(t_y_interp),'UniformOutput',false);
    tform3D=cellfun(@(x)affine3d(x),T3D,'UniformOutput',false);
    toc
tic    
hbar=parfor_progressbar(size(red_img,4)-1,'Transforming...');
parfor ii=2:size(red_img,4)   
    red_stack_aligned(:,:,:,ii)=imwarp(red_img(:,:,:,ii),tform3D{ii},...
        'OutputView',imref3d(img_size));
    green_stack_aligned(:,:,:,ii)=imwarp(green_img(:,:,:,ii),tform3D{ii},...
        'OutputView',imref3d(img_size));
   % waitbar((ii+size(red_img,4))/(2*size(red_img,4)),...
  %      h,sprintf('Aligning, frame %d',ii));
  if mod(ii,5)==0
        hbar.iterate(5);
    end
end
toc
close(hbar);