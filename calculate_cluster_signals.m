function [tsne_data]=calculate_cluster_signals(tsne_data,img_stack,odor_sequence)
    
    unique_clusters=unique(tsne_data.labels(tsne_data.foreground));
    unique_clusters=unique_clusters(unique_clusters>1);
    cluster_signals=cell(length(unique_clusters),1);
    img_size=size(img_stack);
    
    if isfield(tsne_data,'background')
%         roi=tsne_data.roi;
%         bkgd_field = tsne_data.background(roi(1,1):roi(1,2),roi(2,1):roi(2,2),:);
%         bkgd_field = repmat(bkgd_field,1,1,1,img_size(4));
%         img_stack = img_stack-bkgd_field;
        bkgd=0;
    else
        bkgd=tsne_data.background_level;
    end
    clustering_bar=waitbar(0,'Calculating signals...');
    for ii=1:length(cluster_signals)
        
       cluster_signals{ii}=calculate_label_signal(img_stack,...
           bkgd,tsne_data.labels,unique_clusters(ii));
       waitbar(ii/length(cluster_signals),clustering_bar);
    end
    nm_signals = nm_signal(cluster_signals, odor_sequence );
    
    tsne_data.cluster_signals=cluster_signals;
    tsne_data.nm_signals=nm_signals;
    close(clustering_bar)