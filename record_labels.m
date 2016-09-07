function [neuron_names]=record_labels(idx,neuron_names,tsne_result_peaks)
load('AveDataMatrix_FromFinalVersionRawData.mat','infoORNList')
ornList=[infoORNList,'Unknown'];
[s,v]=listdlg('PromptString','Which ORN did you find?',...
    'SelectionMode','single',...
    'ListString',ornList);
if v
   neuron_names(idx)=cellfun(@(x)ornList{s},neuron_names(idx),...
       'UniformOutput',false);
    figure(1);
    
    
    markers={'o','+','*','x','s','d'};
    unique_neurons=unique(neuron_names);
    marker_idx=mod(1:length(unique_neurons),length(markers))+1;
    cmap=generate_cmap(length(unique_neurons));
    hold off;
    for ii=1:length(unique_neurons)
        pts2plot=strcmp(neuron_names,unique_neurons{ii});
        plot(tsne_result_peaks(pts2plot,1),...
            tsne_result_peaks(pts2plot,2),markers{marker_idx(ii)},'MarkerFaceColor',cmap(ii+1,:))
        hold on 
    end
    legend(unique_neurons)
    hold off;
end