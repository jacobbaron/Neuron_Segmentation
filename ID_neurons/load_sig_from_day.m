function [neuronsListDay,nmPeakSigDay,nmSigDay,neuronCoMDay,neuronVarDay,...
    tCourseNeuron,neuronFireDay]=load_sig_from_day()

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
    
    [~,nm_sig,nm_peak_sig,~,~,~,neuron_fire]=calc_nm_sig(tsne_data.odor_seq,tsne_data.cluster_signals);
        %nm_sig=tsne_data.nmSigMat;
        %nm_peak_sig=tsne_data.nmPeakSigMat;
   tCourseNeuron.t=[tCourseNeuron.t;...
       cellfun(@(x)tsne_data.t,tsne_data.nm_signals,'UniformOutput',false)];
   tCourseNeuron.sig=[tCourseNeuron.sig;tsne_data.nm_signals];
    tCourseNeuron.odorSeq=[tCourseNeuron.odorSeq;...
         cellfun(@(x)tsne_data.odor_seq,tsne_data.nm_signals,'UniformOutput',false)];
    neuronsListDay=[neuronsListDay;neurons];
    nmPeakSigDay=cat(3,nmPeakSigDay,nm_peak_sig);
    nmSigDay=cat(3,nmSigDay,nm_sig);
    neuronCoMDay=[neuronCoMDay;tsne_data.neuron_CoM];
    neuronVarDay=[neuronVarDay;tsne_data.neuron_var];
    neuronFireDay=cat(3,neuronFireDay,neuron_fire);
end

