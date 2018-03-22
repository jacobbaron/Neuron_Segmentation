



f_list= uigetfile('*.h5','MultiSelect','on');
if ~iscell(f_list)
    f_list = {f_list};
end

logMatFileList = ListMatLogFiles( pwd );
f_list_log = FindBatchMatLogFile(f_list, logMatFileList);
%%
for f = 1:length(f_list)
    fnamelog=f_list_log{f};
    img_data = import_h5_file(1,f_list{f},fnamelog);    
    side = {'left','right'};
    [d1,d2,d3,T] = size(img_data.img_stacks{1});
    %greenImg = img_data.img_stacks{1}(:,1:round(d2/2),:,:);
    redImgLR{1} = img_data.img_stacks{2}(:,1:round(d2/2),:,:);
    redImgLR{2} = img_data.img_stacks{2}(:,round(d2/2):end,:,:);
    pixelSize = img_data.pixelSize;
    img_data = rmfield(img_data,'img_stacks');

    for s = 1:2



        [tform1,meanRedImg,alignedRedImg] = alignment_box_filt(redImgLR{s},35,5,2,'rigid');
        alignedRedImg = uint16(alignedRedImg);
        save([f_list{f},'_',side{s},'_aligned_try1.mat'],'tform1','meanRedImg','alignedRedImg','pixelSize')
    end
end