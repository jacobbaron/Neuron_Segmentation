
max_t_pts=max(cellfun(@length,t_expts));
min_t=max(cellfun(@(x)x(1),t_expts));
max_t=min(cellfun(@(x)x(end),t_expts));
t=linspace(min_t,max_t,max_t_pts);
nm_sig_expt_interp=cell(size(nm_sig_expts));
neuron_num=cell(size(nm_sig_expts));
odor_seq_interp=interp1(t_expts{1},odor_seq{1},t,'nearest');
for ii=1:length(t_expts)
   nm_sig_expt_interp{ii}=cellfun(@(x)interp1(t_expts{ii},x,t),nm_sig_expts{ii},'UniformOutput',false);
   neuron_num{ii}=[ii*ones(length(nm_sig_expts{ii}),1),(1:length(nm_sig_expts{ii}))'];
   
end


neuron_numList=cell2mat(neuron_num);
nm_sigs_interp=cell2mat(cat(1,nm_sig_expt_interp{:}));
%tsne_result=fast_tsne(nm_sigs_interp);
%nm_sig_pca=pca(nm_sigs_interp');
%=cellfun(@(x)interp1(t,
    