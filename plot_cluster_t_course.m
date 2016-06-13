function [f]=plot_cluster_t_course(tdata,signals,odor_seq,red_img,labels,labels2plot)
num_clusters=length(signals);
load('neuron_seg_colormap.mat');
cmap_idx=round(linspace(1,size(n_seg_cmap,1),num_clusters-1));
cmap=flipud([n_seg_cmap(cmap_idx,:);.7,.7,.7;1,1,1]);


f=figure('units','normalized','outerposition',[0 0 1 1]);



if exist('labels2plot','var')==0
    labels2plot=1:num_clusters;
end

ratio=4;
for ii=1:length(labels2plot)
    subplot(length(labels2plot),ratio,ratio*(ii-1)+[2:ratio])
    h(ii)=plot(tdata,signals{labels2plot(ii)},'LineWidth',3);
    h(ii).Color=cmap(labels2plot(ii)+1,:);
    patches=add_patches_to_plot(tdata,odor_seq,gca,ii==1);
    xlim([0,max(tdata)]);
    
end
    
    subplot(1,ratio,1)
    plot_3d_stuff(labels,labels2plot,red_img,cmap(labels2plot+1,:));
    ax=gca;
    ax.Position=[.015,-0.27,.3,1.6];