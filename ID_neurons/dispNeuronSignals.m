function [sigs,odors,f]=dispNeuronSignals(nmPeakSig,thetitle)
    load odor_inf.mat
    idx_1d=~all(isnan(nmPeakSig),3);
    [i,j]=find(idx_1d);
    idx=find(repmat(idx_1d,1,1,size(nmPeakSig,3)));
    idx_stack=reshape(idx,length(find(idx_1d)),[]);
    
    sigs=nmPeakSig(idx_stack)';
    
    
    odors=cellfun(@(x,y)sprintf('%s %s',x,y),odor_concentration_list(i),odor_list(j),...
        'UniformOutput',false);
    
    f=figure;
    
    h=imagesc(sigs);
    ax=gca;
    ax.XTick=1:size(sigs,2);
    ax.XTickLabel=odors;
    ax.XTickLabelRotation=-90;
    ax.YTick=1:size(sigs,1);
    colorbar
    title(thetitle)
    
    
    