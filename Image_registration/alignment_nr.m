function [redImg,greenImg,template2,errz] = alignment_nr(redImg,greenImg,numIterR,numIterNR)
[d1,d2,d3, T] = size(redImg);
% Tend = cumsum(imgSizes(4,:));
% Tstart = [1,Tend(1:end-1)+1];
redImg = single(redImg);
greenImg = single(greenImg);
if ~exist('numIterR','var')
    numIterR = 1;
end
if ~exist('numIterNR','var')
    numIterNR = 3;
end
%% do high pass filter of red channel
Y = zeros(size(redImg));
parfor t = 1:T
    filt1 = medfilt3(redImg(:,:,:,t));
    Y(:,:,:,t)  = filt1-imgaussfilt3(filt1,[3,3,2]);
end

%% first register rigidly to align z
options_r = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'d3',size(Y,3),'bin_width',50,'max_shift',[50,50,15],'iter',1,'correct_bidir',false);


 for ii=1:numIterR

    tic; [Y,shiftsR,template1] = normcorre_batch(Y,options_r); toc % register filtered data

    redImg = apply_shifts(redImg,shiftsR,options_r);
    greenImg = apply_shifts(greenImg,shiftsR,options_r);
 end
%% apply nonrigid shifts to each z-plane individually
[d1,d2,d3,T] = size(Y);
gSizes = [126,64,32];
overlaps = [16,16,8];
maxShifts= [20,10,5];
template2 = template1;
for jj=1:numIterNR
options_nr = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',50, ...
        'grid_size',[gSizes(jj),gSizes(jj)],'us_fac',10,'max_dev',[4,4], ...
        'overlap_pre',[overlaps(jj),overlaps(jj)],'overlap_post',[overlaps(jj),overlaps(jj)],'max_shift',maxShifts(jj),'plot_flag',true,...
        'correct_bidir',false);

errz = {};
%shiftsNR = shiftsR;
%shiftsCell = 
%M2 = M1;
%redImgAlignedNR = redImgAligned;
%greenImgAlignedNR = greenImgAligned;

for ii = 1:d3
    try
        tic; [tmp,shiftsNR,template2(:,:,ii)] = normcorre_batch(squeeze(...
            Y(:,:,ii,:)),options_nr,template1(:,:,ii)); toc % register filtered data
        Y(:,:,ii,:) = permute(tmp,[1,2,4,3]);
        redImg(:,:,ii,:) = permute(apply_shifts(squeeze(redImg(:,:,ii,:)),shiftsNR,options_nr),[1,2,4,3]);
        greenImg(:,:,ii,:) = permute(apply_shifts(squeeze(greenImg(:,:,ii,:)),shiftsNR,options_nr),[1,2,4,3]);
        
        
    catch ME
        errz{end+1} = {ii,ME};
        fprintf('%s In %s',ME.message, ME.stack(1).name);
    end
    fprintf('Slice %d of %d, iter %d of %d\n',ii,d3,jj,numIterNR);
end
template1 = template2;
end

