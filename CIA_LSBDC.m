function [tsne_data]=CIA_LSBDC(tsne_data,img_stack,odor_sequence,varargin)

%% 
if any(strcmp('alpha',varargin))
    alpha=varargin{find(strcmp('alpha',varargin))+1};
else
    alpha=.7;
end

if any(strcmp('k',varargin))
    k=varargin{find(strcmp('k',varargin))+1};
else
    k=70;
end

%% 
%clustering part of the t-SNE neuron segmentation algorthim

foreground=tsne_data.foreground;
foreground_list=find(foreground);
groups=tsne_data.precluster_groups;
tsne_preclustered=tsne_data.tsne_result;

%% clustering

%run the clustering (via elki)
clustering_bar=waitbar(0,'Running clustering...');
group_clusters=lsbdc_elki(tsne_preclustered,k,alpha)+1;
clusters=group_clusters(groups);

num_clusters=length(unique(clusters));
waitbar(70,clustering_bar,sprintf('Found %d clusters!',num_clusters))


load('neuron_seg_colormap.mat','n_seg_cmap');
cmap_idx=round(linspace(1,size(n_seg_cmap,1),num_clusters-1));
cmap=flipud([n_seg_cmap(cmap_idx,:);.7,.7,.7;1,1,1]);
unique_clusters=unique(clusters);
labels=zeros(size(foreground));
labels(foreground_list)=clusters;

cluster_signals=cell(length(unique_clusters),1);
waitbar(0,clustering_bar,'Calculating signals...')
for ii=1:length(cluster_signals)
    
   cluster_signals{ii}=calculate_label_signal(img_stack,...
       foreground,labels,unique_clusters(ii));
    waitbar(ii/length(cluster_signals),clustering_bar);
end
nm_signals = nm_signal(cluster_signals, odor_sequence );
tsne_data.clustering_output=group_clusters;
tsne_data.cmap=cmap;
tsne_data.labels=labels;
tsne_data.cluster_signals=cluster_signals;
tsne_data.nm_signals=nm_signals;
close(clustering_bar);