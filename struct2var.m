
filelist=dir('*nd2.mat');
for ii=1:length(filelist)
    fname=filelist(ii).name;
    img_data=load(fname);
    fields=fieldnames(img_data);
    for jj=1:length(fields)
        eval(sprintf('%s=img_data.%s;',fields{jj},fields{jj}));
    end
    save(fname,fields{:},'-v7.3')
end
