function [tsne_data]=calculate_cluster_signals(tsne_data,img_stack,odor_sequence)
    unique_clusters=unique(tsne_data.labels(tsne_data.foreground));
    unique_clusters=unique_clusters(unique_clusters>1);
    cluster_signals=cell(length(unique_clusters),1);
    clustering_bar=waitbar(0,'Calculating signals...');
    for ii=1:length(cluster_signals)
        
       cluster_signals{ii}=calculate_label_signal(img_stack,...
           tsne_data.foreground,tsne_data.labels,unique_clusters(ii));
        waitbar(ii/length(cluster_signals),clustering_bar);
    end
    nm_signals = nm_signal(cluster_signals, odor_sequence );
    
    tsne_data.cluster_signals=cluster_signals;
    tsne_data.nm_signals=nm_signals;
    close(clustering_bar)