%figure(1);plot(tsne_result_peaks(:,1),tsne_result_peaks(:,2),'.');drawnow;
function cluster=choose_clusters(tsne_result_peaks,sigs,odors,neuronsListDay,neuron_names,...
    tCourseNeuron)
figure(1);
unique_neurons=unique(neuron_names);
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

drawnow;
%% 
pts=getrect;
pts_list1=tsne_result_peaks(:,1)>pts(1) & tsne_result_peaks(:,1)<pts(1)+pts(3);
pts_list2=tsne_result_peaks(:,2)>pts(2) & tsne_result_peaks(:,2)<pts(2)+pts(4);
cluster=find(pts_list1&pts_list2);
cols=ceil(sqrt(length(cluster)));
rows=ceil(length(cluster)/cols);


%% 
figure(2);
runnums=cellfun(@(x,y)sprintf('%d, #%d',x,y),num2cell(neuronsListDay(:,2)*100+neuronsListDay(:,3)),...
    num2cell(neuronsListDay(:,4)),'UniformOutput',false);
nm_sigs=bsxfun(@rdivide,sigs,max(sigs,[],2));
%for ii=1:length(cluster)
    %subplot(rows,cols,ii)
    h=imagesc(nm_sigs(cluster,:));
    ax=gca;
    ax.XTick=1:size(sigs,2);
    ax.XTickLabel=odors;
    ax.XTickLabelRotation=-90;
    ax.YTick=1:size(sigs,1);
    ax.YTickLabel=runnums(cluster);
    colorbar
    
    
%end
figure(3);
for ii=1:length(cluster)
    
    subplot(length(cluster),1,ii)
    t=tCourseNeuron.t{cluster(ii)};
    sig=tCourseNeuron.sig{cluster(ii)};
    odor_seq=tCourseNeuron.odorSeq{cluster(ii)};
    
    plot(t,sig,'-')
    title(runnums{cluster(ii)})
    patches=add_patches_to_plot(t,odor_seq,gca,ii==1);
    ylim([min(sig)-0.1*max(sig),max(sig)+0.1*max(sig)])
end
