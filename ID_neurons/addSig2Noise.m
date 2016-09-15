%% 



%% 
clearvars
tsnedatafiles=dir('*_tsne_data.mat');
for ii=1:length(tsnedatafiles)
    load(tsnedatafiles(ii).name)
    [~,tsne_data.nmSigMat,tsne_data.nmPeakSigMat,...
            tsne_data.s2nMat,tsne_data.s2nPeakMat,tsne_data.neuron_fire]=...
            calc_nm_sig(tsne_data.odor_seq,tsne_data.cluster_signals);
   f=plot_cluster_t_course(tsne_data);
   savefig(f,strcat(tsne_data.filenames{1},'_tsne_result.fig'));
   save(strcat(tsne_data.filenames{1},'_tsne_data.mat'),'tsne_data');
   close(f)
end