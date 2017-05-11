function [green_stack_aligned, red_stack_aligned]=...
    imregbox_2D_interp_t(red_img, green_img,t,varargin)
%does a box filter on movie, uses that for registration - reduces file size
if any(strcmp(varargin,'scalexy'))
    scalexy=varargin{find(strcmp(varargin,'scalexy'))+1};
else
    scalexy=29;    
end
if any(strcmp(varargin,'scalez'))
    scalez=varargin{find(strcmp(varargin,'scalez'))+1};
else
    scalez=5;
end
if any(strcmp(varargin,'maxiter'))
    maxiter=varargin{find(strcmp(varargin,'maxiter'))+1};
else
    maxiter=1000;
end
if any(strcmp(varargin,'minstep'))
    minstep=varargin{find(strcmp(varargin,'minstep'))+1};
else
    minstep=1e-6;
end
if any(strcmp(varargin,'maxstep'))
    maxstep=varargin{find(strcmp(varargin,'maxstep'))+1};
else
    maxstep=.0625;
end
if any(strcmp(varargin,'scalexy pass 2'))
    scalexy2=varargin{find(strcmp(varargin,'scalexy pass 2'))+1};
else
    scalexy2=5;
end
if any(strcmp(varargin,'doublepass'))
    doublepass=varargin{find(strcmp(varargin,'doublepass'))+1};
else
    doublepass=2;
end

[red_stack_aligned,green_stack_aligned]=reg_scale_interp(...
    red_img,green_img,t,scalexy,maxstep,maxiter,minstep);

min_green_stack_aligned=min(green_stack_aligned,[],4);
idx=find(min_green_stack_aligned~=0);
[i,j,k]=ind2sub(size(min_green_stack_aligned),idx);
red_stack_aligned=red_stack_aligned(min(i):max(i),min(j):max(j),min(k):max(k),:);
green_stack_aligned=green_stack_aligned(min(i):max(i),min(j):max(j),min(k):max(k),:);
red_stack_cropped_max=squeeze(max(red_stack_aligned,[],3));
fixed_max=red_stack_cropped_max(:,:,1);
% 
    [red_stack_cropped_max,xrange,yrange]=crop_img(max(red_stack_cropped_max,[],3));
    red_stack_aligned=red_stack_aligned(yrange,xrange,:,:);
    green_stack_aligned=green_stack_aligned(yrange,xrange,:,:);
 if doublepass==2
    
     
     [red_stack_aligned,green_stack_aligned]=...
         fix_poor_alignment(red_stack_aligned,green_stack_aligned);
     
 end
green_stack_aligned=gpu_medfilt4(green_stack_aligned,'green',2,0);
%red_stack_aligned=gpu_medfilt4(red_stack_aligned,'red',2);
toc
%close(h)