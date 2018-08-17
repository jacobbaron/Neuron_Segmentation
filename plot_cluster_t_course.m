function [f,ax,ax3D]=plot_cluster_t_course(varargin)
tabbed=0;
if isstruct(varargin{1}) %use tsne_data structure to plot
    tsne_data=varargin{1};
    if isfield(tsne_data,'odor_list')
        odor_inf.odor_list=tsne_data.odor_list;
        odor_inf.odor_concentration_list=tsne_data.odor_concentration_list;
    end
    tdata=varargin{1}.t;
    odor_seq=varargin{1}.odor_seq;
    red_img=varargin{1}.aligned_red_img;
    labels=varargin{1}.labels;
    filename=varargin{1}.filenames{1};
    if any(strcmp(varargin,'raw_sig')) %use raw signal instead of normalized signal
        signals=varargin{1}.cluster_signals;
    else
        signals=varargin{1}.nm_signals; %normalized signal
    end
    if any(strcmp(varargin,'labels2plot')) %only plot responses of some neruons
        labels2plot = varargin{find(strcmp(varargin,'labels2plot'))+1}+1;
    else
        labels2plot=unique(labels(labels>1));%otherwise plot all of them
    end
    if nargin==2
        tabbed=1;
        axID=varargin{2}; %if the axis handle is provided, plot in that handle.
    end
elseif nargin==7%if structure datatype not provided, get all variables manually (not recomended)
    [tdata,signals,odor_seq,red_img,labels,filename,labels2plot]=...
        varargin{:}; %plot subset of neurons
    
else
    [tdata,signals,odor_seq,red_img,labels,filename]=...
        varargin{:};
    labels2plot=unique(labels(labels>1)); %plot all neurons
end
        
num_clusters=length(unique(labels(labels>1))); %total number of neurons (labels==1 is considered noise)

cmap=generate_cmap(length(labels2plot)); %make a colormap for the neurons
if ~tabbed %if generating a new figure
    f=figure('units','normalized','outerposition',[0 0 1 1]); 
else
    f=[];
end

[~,name]=fileparts(filename);
name=strrep(name,'_',' ');
ratio=4; %size ratio between image of neuron and time traces
grid = reshape(1:(ratio*length(labels2plot)),ratio,length(labels2plot))'; %create grid of subplots
for ii=1:length(labels2plot)
    if tabbed
        subplot(length(labels2plot),ratio,grid(ii,2:end),axID(ii))
    else
        subplot(length(labels2plot),ratio,grid(ii,2:end))
    end
    
    h(ii)=plot(tdata,signals{labels2plot(ii)-1},'LineWidth',3);
    h(ii).Color=cmap(ii+1,:);
    ax(ii)=gca;
    ax(ii).YLim=[min(signals{labels2plot(ii)-1}) - 0.1 * max(signals{labels2plot(ii)-1}),max(signals{labels2plot(ii)-1}) + 0.1 * max(signals{labels2plot(ii)-1})];
    xlim([0,max(tdata)]);
    if exist('tsne_data','var')
        if isfield(tsne_data,'neuron_fire') %if binary neuron fire information was generated, plot that also
            add_neuron_fire_to_plot(tdata,odor_seq,gca,tsne_data.neuron_fire(labels2plot(ii),:)); 
        end
    end

    
    patches=tsne_data.odor_seq.add_patches(gca); %add patches to indicate when odors were delivered
    
    if ii==1
        
        ylimit=ax(ii).YLim;
        title(gca,name)
        ax(ii).YLim=ylimit;
    end
    if ii==length(labels2plot)
        xlabel('Time(sec)')
    end
    if exist('tsne_data','var')
        if isfield(tsne_data,'neuronID')
            ylab=ylabel(tsne_data.neuronID{labels2plot(ii)-1},'rot',0);
        else
            ylab=ylabel(num2str(labels2plot(ii)),'rot',0);
        end
    end
    ylab.VerticalAlignment='middle';
    ylab.HorizontalAlignment='right';
    ylab.FontWeight='bold';
    
end
    if tabbed
        subplot(2,ratio,1,axID(end))
    else
        subplot(2,ratio,1)
    end
    
    if isfield(tsne_data,'cropped_red_img')
        label_bkd = zeros(prod(tsne_data.full_img_size(1:3))-prod(size(labels)),1);
        full_labels = recreate_full_img(labels,label_bkd,tsne_data.full_img_size(1:3),tsne_data.roi);
        full_red_img = recreate_full_img(tsne_data.aligned_red_img,...
            tsne_data.cropped_red_img,tsne_data.full_img_size,tsne_data.roi);
        
    else
        full_labels = labels;
        full_red_img = red_img;
        
    end
    red_img_proj = make_max_proj_img(full_red_img,tsne_data.pixelSize);
    plot_3d_stuff(full_labels,labels2plot,red_img_proj,cmap(2:end,:),size(full_red_img),tsne_data.pixelSize);
    axis equal
    ax3D=gca;
    ax3D.Position=[.01,.5,.3,.5];
    firstOdorIdx = find(tsne_data.t>tsne_data.odor_seq.time_first_odor,1);
    if isfield(tsne_data,'full_max_projs')
        imgProj = tsne_data.full_max_projs;
        
    elseif isfield(tsne_data,'cropped_img')
        fullImg4D = recreate_full_img(tsne_data.aligned_green_img,...
            tsne_data.cropped_img,tsne_data.full_img_size,tsne_data.roi);
        
        nmMaxProj = make_max_proj_img(fullImg4D(:,:,:,1:firstOdorIdx),tsne_data.pixelSize);
        maxProj = max(nmMaxProj(:));
        minProj = min(nmMaxProj(nmMaxProj>0));
        nmMaxProjScaled = (nmMaxProj-minProj)/(maxProj-minProj);
        
        if isfield(tsne_data,'cropped_red_img')
            fullRedImg4D = recreate_full_img(tsne_data.aligned_red_img,...
                tsne_data.cropped_red_img,tsne_data.full_img_size,tsne_data.roi);
            nmMaxProjRed = make_max_proj_img(fullRedImg4D(:,:,:,:),tsne_data.pixelSize);
            maxProj = max(nmMaxProjRed(:));
            minProj = min(nmMaxProjRed(nmMaxProjRed>0));
            nmMaxProjRedScaled = (nmMaxProjRed-minProj)/(maxProj-minProj);
            imgProj = cat(3,nmMaxProjRedScaled,nmMaxProjScaled,zeros(size(nmMaxProj)));
        else
            imgProj = cat(3,zeros(size(nmMaxProj)),nmMaxProjScaled,zeros(size(nmMaxProj)));
        end      
    else
        nmMaxProj = make_max_proj_img(tsne_data.aligned_green_img(:,:,:,1:firstOdorIdx),tsne_data.pixelSize);        
        maxProj = max(nmMaxProj(:));
        minProj = min(nmMaxProj(nmMaxProj>0));
        nmMaxProjScaledGr = (nmMaxProj-minProj)/(maxProj-minProj);
        nmMaxProj = make_max_proj_img(tsne_data.aligned_red_img(:,:,:,1:firstOdorIdx),tsne_data.pixelSize);        
        maxProj = max(nmMaxProj(:));
        minProj = min(nmMaxProj(nmMaxProj>0));
        nmMaxProjScaledRd = (nmMaxProj-minProj)/(maxProj-minProj);
        imgProj = cat(3,nmMaxProjScaledRd,nmMaxProjScaledGr,zeros(size(nmMaxProj)));
        
     end   
        subplot(2,ratio,ratio+1)
        imshow(imgProj)
        axis equal
        axProj = gca;

        axProj.Position = [0.01,.0,0.3,0.5];
        %t=title('f_0');
        t.Units = 'normalized';
        t.Color = [1,1,1];   
        t.Position(2) = .85;
    
    
    
    if exist('axID','var')
        ax=axID;
    end