



f_list= uigetfile('*aligned_try1.mat','MultiSelect','on');
if ~iscell(f_list)
    f_list = {f_list};
end

%% second pass of alignment
for f = 1:length(f_list)
    load(f_list{f},'alignedRedImg','pixelSize','r')
    alignedRedImg = alignedRedImg(r(2):(r(2)+r(4)),r(1):(r(1)+r(3)),:,:);
    [d1,d2,d3,T] = size(alignedRedImg);
    %greenImg = img_data.img_stacks{1}(:,1:round(d2/2),:,:);
    

        [tform2,meanRedImg,alignedRedImg2] = alignment_box_filt(alignedRedImg,5,1,3,'rigid','mean');
        alignedRedImg2 = uint16(alignedRedImg2);
        redImgMaxProj = make_4d_maxinten(single(alignedRedImg2),pixelSize);
        
        save(f_list{f},'-append','tform2','alignedRedImg2','redImgMaxProj','pixelSize')
       
end
%%
for f = 1:length(f_list)
   if ~isempty(strfind(f_list{f},'left'))
        side = 'left';
    else
        side = 'right';
    end
       tail = strfind(f_list{f},['_',side]);
        movFile{f} = f_list{f}(1:(tail-1));
       
end

movFiles = unique(movFile);
clearvars -except movFiles
%% register the green channel with the specified transformations


logMatFileList = ListMatLogFiles( pwd );
f_list_log = FindBatchMatLogFile(movFiles, logMatFileList);

for f=1:length(movFiles)
    
    fnamelog=f_list_log{f};
    img_data = import_h5_file(1,movFiles{f},fnamelog);    
    sides = {'left','right'};
    [d1,d2,d3,T] = size(img_data.img_stacks{1});
    %greenImg = img_data.img_stacks{1}(:,1:round(d2/2),:,:);
    greenImgLR{1} = img_data.img_stacks{1}(:,1:round(d2/2),:,:);
    greenImgLR{2} = img_data.img_stacks{1}(:,round(d2/2):end,:,:);    
    redImgLR{1} = img_data.img_stacks{2}(:,1:round(d2/2),:,:);
    redImgLR{2} = img_data.img_stacks{2}(:,round(d2/2):end,:,:);    
    img_data = rmfield(img_data,'img_stacks');
    pixelSize = img_data.pixelSize;
    for s = 1:2
        
        greenImg = greenImgLR{s};
        redImg = redImgLR{s};
        [d1,d2,d3,T] = size(greenImg);
        load([movFiles{f},'_',sides{s},'_aligned_try1.mat'],'tform1','tform2','r');
        tform1{1} = tform1{2};tform1{1}.T = eye(4);
        
        tform2{1} = tform2{2};tform2{1}.T = eye(4);
     
        Ti = eye(4);Ti(4,1:2) = r(1:2);
        Tf = Ti; Tf(4,1:2) = -Ti(4,1:2);
        tformi = cellfun(@(x)affine3d(Ti),tform2,'UniformOutput',false); %translate so rotations are about correct axis
        tformf = cellfun(@(x)affine3d(Tf),tform2,'UniformOutput',false);%translate back so image isn't cropped
        tformTot = cellfun(@(t1,ti,t2,tf)affine3d(tf.T*t2.T*ti.T*t1.T),tform1,tformi,tform2,tformf,'UniformOutput',false);
        
        alignedGreen= zeros(d1,d2,d3,T,'single');
        alignedRed =  zeros(d1,d2,d3,T,'single');
        parfor_progress(T);
        tic
        figure(1);
        Ref3DBig = imref3d([d1,d2,d3]);
        parfor ii=1:T
           alignedGreen(:,:,:,ii) = imwarp(greenImg(:,:,:,ii),tformTot{ii},...
                'OutputView',Ref3DBig); 
            alignedRed(:,:,:,ii) = imwarp(redImg(:,:,:,ii),tformTot{ii},...
                'OutputView',Ref3DBig); 
            parfor_progress;
        end
        toc
        parfor_progress(0);
        greenMaxProj = make_4d_maxinten(alignedGreen,pixelSize);
        meanRedImg = mean(alignedRed,4);
        save([movFiles{f},'_',sides{s},'_aligned_try1.mat'],'-append',...
            'alignedGreen','alignedRed','meanRedImg','pixelSize','tformTot','greenMaxProj');
    end
end