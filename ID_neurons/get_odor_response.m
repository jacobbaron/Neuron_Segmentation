nm_sig_peak=sigs;

tsne_result_peaks=fast_tsne(nm_sig_peak);

%% 

[~,manuel_naming]=xlsread('Glomeruli_Analysis_Fix.xlsx');
neuron_names=manuel_naming(~strcmp(manuel_naming,''));


%% 
unique_neurons=unique(neuron_names);
cmap=generate_cmap(length(unique_neurons));
figure(1)
hold off;

markers={'o','+','*','x','s','d'};
marker_idx=mod(1:length(unique_neurons),length(markers))+1;
for ii=1:length(unique_neurons)
    pts2plot=strcmp(neuron_names,unique_neurons{ii});
    plot(tsne_result_peaks(pts2plot,1),...
        tsne_result_peaks(pts2plot,2),markers{marker_idx(ii)},'MarkerFaceColor',cmap(ii+1,:))
    hold on 
end
legend(unique_neurons)
neuronsListDayCell=num2cell(neuronsListDay);
figure(2)
for ii=1:length(unique_neurons)
    pts2plot=find(strcmp(neuron_names,unique_neurons{ii}));
    subplot(4,5,ii)
    imagesc(nm_sig_peak(pts2plot,:))
    title(sprintf('%s',unique_neurons{ii}))
    ax=gca;
    ax.YTick=1:length(pts2plot);
    ax.YTickLabel=cellfun(@(x,y,z)sprintf('%d, #%d',x*100+y,z),...
        neuronsListDayCell(pts2plot,2),neuronsListDayCell(pts2plot,3),...
        neuronsListDayCell(pts2plot,4),'UniformOutput',false);
    
end
%% 

figure(3)
for ii=1:length(unique_neurons)
    pts2plot=strcmp(neuron_names(neuronsListDay(:,2)==2),unique_neurons{ii});
    scatter3(neuronCoMDay(pts2plot,1),neuronCoMDay(pts2plot,2),neuronCoMDay(pts2plot,3),...
       markers{marker_idx(ii)},'MarkerFaceColor',cmap(ii+1,:))
   xlabel('X')
   ylabel('Y')
   zlabel('Z')
    hold on;
end
hold off
legend(unique_neurons)
% 
% dotSizes=[10,15,20];
% cmapnew=generate_cmap(6);
% for ii=1:length(infoORNList)
%     for jj=1:3
%         h(ii,jj)=plot(tsne_result_peaks(size(nm_sig_peak,1)+length(infoORNList)*(jj-1)+ii,1),...
%             tsne_result_peaks(size(nm_sig_peak,1)+length(infoORNList)*(jj-1)+ii,2),...
%             'MarkerSize',dotSizes(jj));
%         
%         hold all
%     end
% end