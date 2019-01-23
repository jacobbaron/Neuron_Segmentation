function [Y,greenImg,template2] = alignment_nr(redImg,greenImg)
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
Y = zeros(size(redImg),'single');
Yblr = Y;
%parfor_progress(T);
parfor t = 1:T
    filt1 = medfilt3(redImg(:,:,:,t));
    Y(:,:,:,t)  = filt1-imgaussfilt3(filt1,[3,3,2]);
    Yblr(:,:,:,t) = imgaussfilt3(filt1,[10,10,5]);
    %parfor_progress;
end
%parfor_progress(0);
%% first register rigidly to align z
options_r = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'d3',size(Y,3),'bin_width',50,'max_shift',[50,50,15],'iter',1,'correct_bidir',false);


 for ii=1:numIterR

    tic; [Yblr,shiftsR,template1] = normcorre_batch(Yblr,options_r, Yblr(:,:,:,1)); toc % register filtered data

    Y = apply_shifts(Y,shiftsR,options_r);
    greenImg = apply_shifts(greenImg,shiftsR,options_r);
 end
 clear Yblr
%% apply nonrigid shifts to each z-plane individually
[d1,d2,d3,T] = size(Y);
gSizes = 64;
overlaps = 16;
maxShifts= 10;

options_nr = NoRMCorreSetParms('d1',d1,'d2',d2,'d3',d3,'bin_width',50, ...
        'grid_size',[round(d1/4),round(d2/4),2],'us_fac',4,'max_dev',[4,4,1], ...
        'overlap_pre',[round(d1/12),round(d2/12),1],'overlap_post',[4,4,1],...
        'max_shift',[maxShifts,maxShifts,3],'plot_flag',true,...
        'correct_bidir',false,'iter',2);

%shiftsNR = shiftsR;
%shiftsCell = 
%M2 = M1;
%redImgAlignedNR = redImgAligned;
%greenImgAlignedNR = greenImgAligned;
    [Y,shiftsNR,template2] = normcorre_batch(Y,options_nr);
    greenImg = apply_shifts(greenImg,shiftsNR,options_nr);

end

