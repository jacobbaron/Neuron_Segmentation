function [f]=plot_cluster_t_course(tdata,signals,odor_seq,red_img,labels,filename,labels2plot)
num_clusters=length(unique(labels(labels>1)));

cmap=generate_cmap(num_clusters);

f=figure('units','normalized','outerposition',[0 0 1 1]);



if exist('labels2plot','var')==0
    labels2plot=1:num_clusters;
end
[~,name]=fileparts(filename);
name=strrep(name,'_',' ');
ratio=4;
for ii=1:length(labels2plot)
    subplot(length(labels2plot),ratio,ratio*(ii-1)+[2:ratio])
    
    h(ii)=plot(tdata,signals{ii},'LineWidth',3);
    h(ii).Color=cmap(ii+1,:);
    ax=gca;
    ax.YLim=[min(signals{ii}) - 0.1 * max(signals{ii}),max(signals{ii}) + 0.1 * max(signals{ii})];
    xlim([0,max(tdata)]);
    patches=add_patches_to_plot(tdata,odor_seq,gca,ii==1);
    
    if ii==1
        
        ylimit=ax.YLim;
        title(gca,name)
        ax.YLim=ylimit;
    end
    if ii==length(labels2plot)
        xlabel('Time(sec)')
    end
    ylab=ylabel(num2str(ii),'rot',0);
    ylab.VerticalAlignment='middle';
    ylab.HorizontalAlignment='right';
    ylab.FontWeight='bold';
    
end
    
    subplot(1,ratio,1)
    plot_3d_stuff(labels,labels2plot,red_img,cmap(labels2plot,:));
    ax=gca;
    ax.Position=[.015,-0.27,.3,1.6];