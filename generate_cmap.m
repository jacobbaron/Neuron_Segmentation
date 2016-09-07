function [cmap]=generate_cmap(num_clusters)
    load('neuron_seg_colormap.mat','n_seg_cmap');
    cmap_idx=round(linspace(1,size(n_seg_cmap,1),num_clusters));
    cmap=[.7, .7, .7 ; n_seg_cmap(cmap_idx,:)];