data_files=dir('OrcoRFP-GH146GCaMP6*_tsne_data.mat');
odor_inf=load('odor_inf.mat');
odor_list=odor_inf.odor_list;
odor_concentration_list=odor_inf.odor_concentration_list;
odor_colormap=odor_inf.odor_colormap;

t_expts=cell(length(data_files),1);
sig_expts=cell(size(t_expts));
labels_expts=cell(size(t_expts));
odor_seq=cell(size(t_expts));
[~,date,~]=fileparts(pwd);

neuronsListDay=[];
nmPeakSigDay=[];
nmSigDay={};
[~,date]=fileparts(pwd);
date=str2num(date);
for ii=1:length(data_files)
    load(data_files(ii).name);
    
    t_expts{ii}=tsne_data.t;
    sig_expts{ii}=tsne_data.cluster_signals;
    labels_expts{ii}=tsne_data.labels; 
    odor_seq{ii}=tsne_data.odor_seq;
    runidx=strfind(data_files(ii).name,'run')+3;
    dotidx=strfind(data_files(ii).name,'.nd2')-1;
    animal=floor(str2double(data_files(ii).name(runidx:dotidx))/100);
    expt=rem(str2double(data_files(ii).name(runidx:dotidx)),animal*100);
    nm_peak_sig=nan(length(odor_concentration_list),length(odor_list),length(sig_expts{ii}));
    nm_sig=cell(length(odor_concentration_list),length(odor_list),length(sig_expts{ii}));
    neurons=[date*ones(length(sig_expts{ii}),1),animal*ones(length(sig_expts{ii}),1),...
        expt*ones(length(sig_expts{ii}),1),(1:length(sig_expts{ii}))'];
    for jj=1:length(sig_expts{ii})
        [~,nm_sig(:,:,jj),nm_peak_sig(:,:,jj)]=calc_nm_sig(odor_seq{ii},sig_expts{ii}(jj),odor_inf);    
    end
    neuronsListDay=[neuronsListDay;neurons];
    nmPeakSigDay=cat(3,nmPeakSigDay,nm_peak_sig);
    nmSigDay=cat(3,nmSigDay,nm_sig);
end

