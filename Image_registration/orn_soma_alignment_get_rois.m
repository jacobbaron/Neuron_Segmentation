

f_list= uigetfile('*aligned_try1.mat','MultiSelect','on');
if ~iscell(f_list)
    f_list = {f_list};
end
figure;
for ii=1:length(f_list)
    load(f_list{ii},'meanRedImg')
    imshow(meanRedImg,[0,prctile(meanRedImg(:),99.5)]);
    r = round(getrect);
    
    save(f_list{ii},'-append','r')
    
end

%
% logMatFileList = ListMatLogFiles( pwd );
% f_list_log = FindBatchMatLogFile(f_list, logMatFileList);