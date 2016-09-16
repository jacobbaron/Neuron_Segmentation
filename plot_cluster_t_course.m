function [f]=plot_cluster_t_course(varargin)%tdata,signals,odor_seq,red_img,labels,filename,labels2plot)
if isstruct(varargin{1}) %use tsne_data to plot
    tsne_data=varargin{1};
    tdata=varargin{1}.t;
    odor_seq=varargin{1}.odor_seq;
    red_img=varargin{1}.aligned_red_img;
    labels=varargin{1}.labels;
    filename=varargin{1}.filenames{1};
    if any(strcmp(varargin,'raw_sig'))
        signals=varargin{1}.cluster_signals;
    else
        signals=varargin{1}.nm_signals;
    end
    labels2plot=unique(labels(labels>1));
elseif nargin==7
    [tdata,signals,odor_seq,red_img,labels,filename,labels2plot]=...
        varargin{:};
    
else
    [tdata,signals,odor_seq,red_img,labels,filename]=...
        varargin{:};
    labels2plot=unique(labels(labels>1));
end
        
num_clusters=length(unique(labels(labels>1)));

cmap=generate_cmap(num_clusters);

f=figure('units','normalized','outerposition',[0 0 1 1]);


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
    if exist('tsne_data','var')
        if isfield(tsne_data,'neuron_fire')
            add_neuron_fire_to_plot(tdata,odor_seq,gca,tsne_data.neuron_fire(ii,:));
        end
    end
   
    patches=add_patches_to_plot(tdata,odor_seq,gca,ii==1);
    
    if ii==1
        
        ylimit=ax.YLim;
        title(gca,name)
        ax.YLim=ylimit;
    end
    if ii==length(labels2plot)
        xlabel('Time(sec)')
    end
    if isfield(tsne_data,'neuronID')
        ylab=ylabel(tsne_data.neuronID{ii},'rot',0);
    else
        ylab=ylabel(num2str(ii),'rot',0);
    end
    ylab.VerticalAlignment='middle';
    ylab.HorizontalAlignment='right';
    ylab.FontWeight='bold';
    
end
    
    subplot(1,ratio,1)
    plot_3d_stuff(labels,labels2plot,red_img,cmap(labels2plot,:));
    ax=gca;
    ax.Position=[.015,-0.27,.3,1.6];