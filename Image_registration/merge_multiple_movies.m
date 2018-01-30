function [tsne_data] = merge_multiple_movies(movs)

%% first make sure movies are same size

imgSizes =cell2mat(cellfun(@size,{movs(:).aligned_red_img}','UniformOutput',false));

imgReSize = max(imgSizes,[],1);
imgReSize(4) = sum(imgSizes(:,4));
for ii=1:length(movs)
    amount2pad = double(imgReSize(1:3) - imgSizes(ii,1:3));
    amount2pad(4) = 0;
    movs(ii).aligned_red_img = padarray(movs(ii).aligned_red_img,amount2pad,'replicate','post');
    movs(ii).aligned_green_img = padarray(movs(ii).aligned_green_img,amount2pad,'replicate','post');
    movs(ii).meanRedChan = padarray(movs(ii).meanRedChan,amount2pad,'replicate','post');
end
%%
   
meanImgs = cell2mat(permute({movs(:).meanRedChan},[1,3,4,2]));
[d1,d2,d3] = size(meanImgs);
%templates = cat(4,meanImg{1},meanImg{2},meanImg{3});
options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'d3',d3,'bin_width',50,'max_shift',[50,50,20],'iter',1,'correct_bidir',false);
iter = 2;
template = meanImgs(:,:,:,1);
for jj=1:iter
    
[M1,shifts,templateNew] = normcorre_batch(meanImgs,options_r,template);

    for ii=2:length(shifts)
        clear shiftsMov;
        shiftsMov(1:size(movs(ii).aligned_red_img,4)) = shifts(ii);
        movs(ii).aligned_red_img = apply_shifts(movs(ii).aligned_red_img,shiftsMov,options_r);
        movs(ii).aligned_green_img = apply_shifts(movs(ii).aligned_green_img,shiftsMov,options_r);
    end
    meanImgs = M1;
end
%% now merge other parts of data file
tsne_data.aligned_red_img = cell2mat(permute({movs(:).aligned_red_img},[1,3,4,2]));
tsne_data.aligned_green_img = cell2mat(permute({movs(:).aligned_green_img},[1,3,4,2]));
tsne_data.meanRedChan = mean(meanImgs,4);
tsne_data.filenames = {movs(:).filenames};
tsne_data.odor_inf = movs(1).odor_inf;
tsne_data.t = cell2mat({movs(:).t}');
tsne_data.pixelSize = movs(1).pixelSize;

tsne_data.odor_seq = movs(1).odor_seq;
for ii=2:length(movs)
    
    
    %because water is first and last. this will enforce order 'water, odor,
    %water, odor,... odor, water' for entire merged movie.
    tsne_data.odor_seq.t(end) = tsne_data.odor_seq.t(end)+movs(ii).odor_seq.t(1); 
    tsne_data.odor_seq.t = [tsne_data.odor_seq.t; movs(ii).odor_seq.t(2:end)];
    
    
    tsne_data.odor_seq.seqArr = [tsne_data.odor_seq.seqArr, movs(ii).odor_seq.seqArr];
    tsne_data.odor_seq.odorSeqStep = [tsne_data.odor_seq.odorSeqStep; movs(ii).odor_seq.odorSeqStep];
    
    
end
1;
