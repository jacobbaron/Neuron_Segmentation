function [neuronsListDay,nmPeakSigDay,...
   nmSigDay,neuronCoMDay,...
   neuronVarDay, neuronFireDay,...
   tCourseNeuron,sig_rgb,sideDay]=load_sig_from_day()

data_files=dir('*_tsne_data.mat');
load odor_inf.mat;
t_expts=cell(length(data_files),1);
sig_expts=cell(size(t_expts));
labels_expts=cell(size(t_expts));
odor_seq=cell(size(t_expts));
[~,date,~]=fileparts(pwd);



neuronsListDay=[];
nmPeakSigDay=[];
neuronCoMDay=[];
neuronVarDay=[];
neuronFireDay=[];
nmSigDay={};
tCourseNeuron.t={};
tCourseNeuron.sig={};
tCourseNeuron.odorSeq={};
tCourseNeuron.odor_conc_inf={};
tCourseNeuron.odor_inf={};
sig_rgb={};
sideDay={};
for ii=1:length(data_files)
    load(data_files(ii).name,'tsne_data');
    
    t_expts{ii}=tsne_data.t;
    sig_expts{ii}=tsne_data.cluster_signals;
    labels_expts{ii}=tsne_data.labels; 
    odor_seq{ii}=tsne_data.odor_seq;
    runidx=strfind(data_files(ii).name,'run')+3;
    dotidx=strfind(data_files(ii).name,'.nd2')-1;
    animal=floor(str2double(data_files(ii).name(runidx:dotidx))/100);
    expt=rem(str2double(data_files(ii).name(runidx:dotidx)),animal*100);
    neurons=[str2double(date)*ones(length(sig_expts{ii}),1),...
        animal*ones(length(sig_expts{ii}),1),expt*ones(length(sig_expts{ii}),1),...
        (1:length(sig_expts{ii}))'];
    
    [~,nm_sig,nm_peak_sig,~,~,~,neuron_fire]=calc_nm_sig(tsne_data.odor_seq,tsne_data.cluster_signals,...
        tsne_data.odor_inf);
        %nm_sig=tsne_data.nmSigMat;
        %nm_peak_sig=tsne_data.nmPeakSigMat;
   tCourseNeuron.t=[tCourseNeuron.t;...
       cellfun(@(x)tsne_data.t,tsne_data.nm_signals,'UniformOutput',false)];
   tCourseNeuron.sig=[tCourseNeuron.sig;tsne_data.nm_signals];
    tCourseNeuron.odorSeq=[tCourseNeuron.odorSeq;...
         cellfun(@(x)tsne_data.odor_seq,tsne_data.nm_signals,'UniformOutput',false)];
     tCourseNeuron.odor_conc_inf=[tCourseNeuron.odor_conc_inf;...
         cellfun(@(x)tsne_data.odor_conc_inf,tsne_data.nm_signals,'UniformOutput',false)];
      tCourseNeuron.odor_inf=[tCourseNeuron.odor_inf;...
          cellfun(@(x)tsne_data.odor_inf,tsne_data.nm_signals,'UniformOutput',false)];
    neuronsListDay=[neuronsListDay;neurons];
    nmPeakSigDay=cat(3,nmPeakSigDay,nm_peak_sig);
    nmSigDay=cat(3,nmSigDay,nm_sig);
    neuronCoMDay=[neuronCoMDay;tsne_data.neuron_CoM];
    neuronVarDay=[neuronVarDay;tsne_data.neuron_var];
    neuronFireDay=cat(3,neuronFireDay,neuron_fire);
    
    max_red_img=max(tsne_data.aligned_red_img,[],4);
    max_green_img=max(tsne_data.aligned_green_img,[],4);
    sideExp=cell(length(tsne_data.nm_signals),1);
    sideExp=cellfun(@(x)tsne_data.which_side,sideExp,'UniformOutput',false);
    sideDay=[sideDay;sideExp];
    side={'Left','Right'};
    
    if strcmp(tsne_data.which_side{1},'Ventral')
       max_red_img=flip(max_red_img,3); 
       max_red_img=flip(max_red_img,2);
       
       max_green_img=flip(max_green_img,3); 
       max_green_img=flip(max_green_img,2);
       which_side=side(~strcmp(side,tsne_data.which_side{2}));
    end
    if strcmp(tsne_data.which_side{2},'Left')
        max_red_img=flip(max_red_img,2);
        max_green_img=flip(max_green_img,2);
    end
    red_sig_proj=gen_max_proj(max_red_img);
    min_red=min(red_sig_proj(red_sig_proj>0));
    max_red=max(red_sig_proj(:));    
    red_sig_proj=(red_sig_proj-min_red)/max_red;
    red_sig_proj(red_sig_proj==min_red)=0;    
    b_sig=zeros(size(red_sig_proj));
    
    for ii=1:length(tsne_data.nm_signals)
       1; 
       green_img_neuron=zeros(size(max_green_img));
       green_img_neuron(tsne_data.labels==ii+1)=...
        max_green_img(tsne_data.labels==ii+1);
       green_sig_proj=gen_max_proj(green_img_neuron);
       min_green=min(green_sig_proj(green_sig_proj>0));
       max_green=max(green_sig_proj(:));
       green_sig_proj=(green_sig_proj)/max_green;
       
       sig_rgb{end+1}=cat(3,red_sig_proj,green_sig_proj,b_sig);
    end
    
        
end

