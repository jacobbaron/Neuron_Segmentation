function [alignedRed,AlignedGreen] = merge_multiple_movies(movs)

%% first make sure movies are same size

imgSizes = cellfun(@size,{movs(:).aligned_red_img});


%%
   
meanImgs = cell2mat(permute({movs(:).meanRedChan},[1,3,4,2]));

%templates = cat(4,meanImg{1},meanImg{2},meanImg{3});
options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'d3',d3,'bin_width',50,'max_shift',[50,50,20],'iter',1,'correct_bidir',false);

[M1,shifts,template] = normcorre_batch(meanImgs,options_r,templates(:,:,:,1));

for ii=1:length(shifts)
    shiftsMov = shifts;
    shiftsMov(1:size(movs.aligned_red_img,4)) = shifts;
    redImg = apply_shifts(redImg(:,:,:,Tstart(ii):Tend(ii)),shiftsMov,options_r);
    greenImg = apply_shifts(greenImg(:,:,:,Tstart(ii):Tend(ii)),shiftsMov,options_r);
end
[M2,shiftsF,templateF] = normcorre_batch(M1,options_r,templates(:,:,:,1));
%
