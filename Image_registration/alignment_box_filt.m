function [tformUS,meanImg,alignedUS,idxInterp] = alignment_box_filt(img,scalexy,scalez,dim,regType,template)


%
%scalexy = 29;
%scalez = 5;
scaleview=round(scalexy/2);
scaleviewz=round(scalez/2);
red_stack_filt=box_filt4D(img,[scalexy,scalexy,scalez]);
[d1,d2,d3,T] = size(red_stack_filt);

red_stack_sub=red_stack_filt(1:scaleview:end,1:scaleview:end,1:scaleviewz:end,:);

idxInterp{1} = 1:scaleview:d1;
idxInterp{2} = 1:scaleview:d2;
idxInterp{3} = 1:scaleviewz:d3;
optimizer = registration.optimizer.RegularStepGradientDescent;
[optimizer, metric]  = imregconfig('monomodal');
[d1,d2,d3,T] = size(red_stack_sub);
maxstep=.0625;
maxiter=1000;
minstep=1e-6;
pixelSize = [0.27,0.27,1.5];
optimizer = registration.optimizer.RegularStepGradientDescent;
[optimizer, metric]  = imregconfig('monomodal');
MaxStepLength_init=maxstep;
optimizer.MaximumIterations=maxiter;
optimizer.MinimumStepLength=minstep;
if dim==2
    red_stack_sub = max(red_stack_sub,[],3);
end
if ~exist('template','var')
    fixed = red_stack_sub(:,:,:,1);
elseif strcmp(template,'mean')
    fixed = mean(red_stack_sub,4);
end

figure;
%aligned = red_stack_sub;
parfor_progress(T-1)
parfor ii=2:T    
    moving = red_stack_sub(:,:,:,ii);
    
    tform{ii} = imregtform(moving,fixed,regType,...
            optimizer,metric,'DisplayOptimization',false,'PyramidLevels',2);
    
%     aligned(:,:,:,ii) = imwarp(moving,tform{ii},'OutputView',imref3d([d1,d2,d3]));
%     imshow(cat(2,make_4d_maxinten(aligned(:,:,:,ii),[1,1,1]),make_4d_maxinten(moving,[1,1,1])),[0,2000],'InitialMagnification','fit')
    parfor_progress;
end
parfor_progress(0);
%%

[d1,d2,d3,T] = size(img);
alignedUS = zeros(d1,d2,d3,T);
tformUS = cell(T,1);
h=waitbar(0);
close all
figure;
for ii=2:T
    tform{ii}.T;
    tform3D = eye(4);
    tform3D(1:dim,1:dim) = tform{ii}.T(1:dim,1:dim);
    if dim==3
        eul = rotm2eul(tform3D(1:dim,1:dim));%convert rotations to euler angle
        eul(2:3) = atan(tan(eul(2:3))/scaleview); %scale rotations about xz and yz    
        tform3D(1:dim,1:dim) = eul2rotm(eul);
    end
    tform3D(4,1:2) = tform{ii}.T(dim+1,1:2)*scaleview;
    if dim==3
       tform3D(4,3) =  tform{ii}.T(dim+1,3)*scaleviewz;
    end
   tformUS{ii} = affine3d(tform3D);
   
   %tformUS{ii}.T(3,1:2) = tformUS{ii}.T(3,1:2)
   alignedUS(:,:,:,ii) = imwarp(img(:,:,:,ii),tformUS{ii},'OutputView',imref3d([d1,d2,d3]));
   waitbar(ii/T,h,sprintf('frame %d of %d',ii,T));
   imshow(make_4d_maxinten(alignedUS(:,:,:,ii),pixelSize),[0,2000])
end
close(h)
meanImg = max(mean(alignedUS,4),[],3);