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
%foreground_list=find(foreground);
%groups=tsne_data.precluster_groups;
tsne_preclustered=tsne_data.tsne_result;

%% clustering

%run the clustering (via elki)
clustering_bar=waitbar(0,'Running clustering...');
clusters=lsbdc_elki(tsne_preclustered,k,alpha)+1;
%clusters=group_clusters(groups);


if ~any(clusters>1)
   clusters(clusters==1)=2; 
end

num_clusters=length(unique(clusters));
unique_clusters=unique(clusters);
waitbar(70,clustering_bar,sprintf('Found %d clusters!',num_clusters))

%grey for noise (labels==1), colormap for others
cmap=generate_cmap(length(unique_clusters(unique_clusters>1)));


labels=zeros(size(foreground));
labels(foreground>0)=clusters;
tsne_data.clustering_output=clusters;
tsne_data.cmap=cmap;
tsne_data.labels=labels;
close(clustering_bar);

tsne_data=calculate_cluster_signals(tsne_data,img_stack,odor_sequence);

