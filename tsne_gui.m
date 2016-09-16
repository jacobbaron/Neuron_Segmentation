function  tsne_gui()
%

%% Initialize a bunch of globals
img_data=[];peak_sig_fig=[];
Img4D=[];
leg=[];
foreground=[];
cmap=[];
C1=[];
img=[];
inten_sld=[];
inten_txt=[];
S=[];
Z=[];
Rmin=[];
Rmax=[];
cmap1=[];
cmap_full=[];
foreground_img=[];
imin=[];
imax=[];
T=[];
dist=[];
min_slider=[];
max_slider=[];
odor_seq=[];
lb=[];
aligned_green_img=[];
aligned_red_img=[];
aligned_green_img_full=[];
aligned_red_img_full=[];
image_times=[];
tsne_data=[];
filename=[];
tsne_title=[];
tcourse_fig=[];
foreground_title=[];
selected_pts=[];
roi=[];
nm_sig={};
nmPeakSig=[];larva_side=[];
%% 

        SFntSz = 9;
        LFntSz = 10;
        WFntSz = 10;
        LVFntSz = 9;
        WVFntSz = 9;
        BtnSz = 10;
        ChBxSz = 10;
%% set up figure and tabs
f=figure('units','normalized','outerposition',[.05 .05 .8 .8],...
    'Name','t-SNE for Neuron Clustering','ToolBar','figure','MenuBar','none');

% tgroup=uitabgroup('Parent',f);
% foreground_tab=uitab('Parent',tgroup,'Title','Determine Foreground');
%tsne_tab=uitab('Parent',tgroup,'Title','t-SNE');
%clustering_tab=uitab('Parent',tgroup,'Title','Clustering and Export');

%% set up axes
tsne_w=.4;
tsne_ax=axes('position',[.95-tsne_w, .2, tsne_w,.65]);
ax_foreground=axes('position',[.05 .2 .4 .65]);
axis('off');
%% Initialize Default paremeters

max_iter=8000;
kmeans_frac=.5;
alpha=.7;
k=70;
tsne_data_no_cluster=[];
%% 
ax_foreground.Units='pixels';
ax_f_Pos=ax_foreground.Position;
foreground_title=title(ax_foreground,'Import a movie to begin');
larva_side_label=uicontrol('Style', 'text',...
    'Position', [ax_f_Pos(1),ax_f_Pos(2)+ax_f_Pos(4)+10,80,20],...
                 'FontSize', 14);
larva_ML_label_left=uicontrol('Style', 'text',...
    'Position', [ax_f_Pos(1)-20,ax_f_Pos(2)+ax_f_Pos(4)/2+40,40,20],...
                 'FontSize', 14);
larva_ML_label_right=uicontrol('Style', 'text',...
    'Position', [ax_f_Pos(1)+ax_f_Pos(3)+20,ax_f_Pos(2)+ax_f_Pos(4)/2+40,40,20],...
                 'FontSize', 14);
f.Units='pixels';
FigPos = f.Position;


S_Pos = [ax_f_Pos(1), ax_f_Pos(2)-50, ax_f_Pos(3), 20];
Z_Pos = [50, 45, uint16(FigPos(3)-100)+1, 20];
Stxt_Pos = [ax_f_Pos(1), S_Pos(2)+35, ax_f_Pos(3)/2, 15];
Ztxt_Pos = [ax_f_Pos(1)+ax_f_Pos(3)/2, S_Pos(2)+35, ax_f_Pos(3)/2, 15];
%Wtxt_Pos = [50 20 60 20];
%Wval_Pos = [110 20 60 20];

%BtnStPnt = uint16(FigPos(3)-250)+1;

t_slider_w=300;
T_slider_pos=[(FigPos(3)/2-t_slider_w)/2, 10,t_slider_w, 40];
t_slider_txt_w=t_slider_w/2;
T_slider_txt_pos=[(FigPos(3)/2-t_slider_txt_w)/2,50,t_slider_txt_w,30];
run_tsne_pos= [T_slider_pos(1)+T_slider_pos(3)+20, T_slider_pos(2) 200 30];
num_iter_txt_pos = [run_tsne_pos(1),run_tsne_pos(2)+45,100,30];
num_iter_box_pos = [num_iter_txt_pos(1)+num_iter_txt_pos(3), run_tsne_pos(2)+45, 60 20];
k_means_txt_pos = [num_iter_txt_pos(1),num_iter_txt_pos(2)+num_iter_txt_pos(4),...
    num_iter_txt_pos(3:4)];
k_means_box_pos = [num_iter_box_pos(1),k_means_txt_pos(2),...
    num_iter_txt_pos(3),num_iter_box_pos(4)];
% if BtnStPnt < 300
%     BtnStPnt = 300;
% end
% Btn_Pos = [BtnStPnt 20 100 20];
% ChBx_Pos = [BtnStPnt+110 20 100 20];
shand=[];
stxthand=[];
zsl=[];
sno=[];
ztxthand=[];

shand = uicontrol('Style', 'slider','Position', S_Pos);
stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,...
    'BackgroundColor', [0.8 0.8 0.8],'FontSize', SFntSz,...
    'String','Load Image First');
ztxthand = uicontrol('Style', 'text','Position', Ztxt_Pos,...
    'BackgroundColor', [0.8 0.8 0.8],...
                 'FontSize', 11);
inten_sld=uicontrol('Style','slider','Position',T_slider_pos);
inten_txt=uicontrol('Style', 'text','Position', T_slider_txt_pos,...
    'BackgroundColor', [0.8 0.8 0.8],...
                 'FontSize', 11);

%Number of iterations box
num_iter_txt = uicontrol('Style', 'text',...
    'Position', num_iter_txt_pos,...
    'String','Number of Iterations: ', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
num_iter_box = uicontrol('Style', 'edit','Position', ...
    num_iter_box_pos,'String',...
    sprintf('%d',max_iter), ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,max_iter});

%box for k means reduction fraction
k_means_red_txt = uicontrol('Style', ...
    'text','Position', k_means_txt_pos,...
    'String','Data reduction fraction:', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
k_means_red_box = uicontrol('Style', 'edit',...
    'Position', k_means_box_pos,...
    'String',sprintf('.5'), ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,kmeans_frac});
    tsne_ax.Units='pixels';
k_txt_pos=[tsne_ax.Position(1), k_means_txt_pos(2:4)];
k_box_pos=[k_txt_pos(1)+k_txt_pos(3),...
    k_means_box_pos(2:4)];
alpha_txt_pos=[k_box_pos(1)+k_box_pos(3)+10,k_txt_pos(2),...
    k_txt_pos(3),k_txt_pos(4)];
alpha_box_pos=[alpha_txt_pos(1)+alpha_txt_pos(3),...
    k_box_pos(2:4)];



%box for k parameter
k_box_txt = uicontrol('Style', ...
    'text','Position', k_txt_pos,...
    'String','Cluster Size:', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
k_box = uicontrol('Style', 'edit',...
    'Position', k_box_pos,...
    'String',k, ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,k});

%box for alpha parameter
alpha_txt = uicontrol('Style', ...
    'text','Position', alpha_txt_pos,...
    'String','Density threshold', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
alpha_box = uicontrol('Style', 'edit',...
    'Position', alpha_box_pos,...
    'String',alpha, ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,alpha});

odor_txt=uicontrol('Style',...
    'text','Position',[S_Pos(1),S_Pos(2)-50,200,50],...
    'String',sprintf('Odor\nt='),...
    'FontSize',LFntSz);

import_img_pos=[10,70,200,50];
import_data_pos=[10,10,200,50];
btn_space=10;
run_clustering_pos=[run_tsne_pos(1)+run_tsne_pos(3)+btn_space,...
    run_tsne_pos(2),run_tsne_pos(3:4)];     
run_everything_pos=[run_clustering_pos(1)+run_clustering_pos(3)+btn_space,...
    run_tsne_pos(2),run_tsne_pos(3:4)];
save_export_pos=[run_everything_pos(1)+run_everything_pos(3)+btn_space,...
    run_tsne_pos(2:4)];
id_neurons_pos=save_export_pos;
id_neurons_pos(2)=id_neurons_pos(2)+id_neurons_pos(4)+btn_space;

start_manual_cluster_btn_pos=[run_clustering_pos(1), ...
    run_clustering_pos(2)+run_clustering_pos(4)+btn_space,...
    run_clustering_pos(3:4)];

% end_manual_cluster_btn_pos=start_manual_cluster_btn_pos;
% end_manual_cluster_btn_pos(1)=start_manual_cluster_btn_pos(1)+btn_space;

% import_img_btn=uicontrol(...
%     'Style','pushbutton',...
%     'Position',import_img_pos,...
%     'String',sprintf('Select .nd2 video file'),...
%     'FontSize', BtnSz, ...
%     'Callback' , {@importimg});   
mh=uimenu(gcf,'Label','File');
importimg_item=uimenu(mh,'Label','Import .nd2 file','Callback',{@importimg},...
    'Accelerator','O');
importtsne_item=uimenu(mh,'Label','Import t-SNE .mat file','Callback',{@importdata});
save_files=uimenu(mh,'Label','Save t-SNE data','Callback',{@save_export},...
    'Accelerator','S');
edit_menu=uimenu(gcf,'Label','Edit');
select_ROI_item=uimenu(edit_menu,'Label','Select ROI','Callback',{@get_ROI});

run_menu=uimenu(gcf,'Label','Run');
run_alignment_menu=uimenu(run_menu,'Label','Run Alignment',...
    'Callback',{@run_alignment});
run_tsne_menu=uimenu(run_menu,'Label','Run t-SNE',...
    'Callback',{@run_tsne});
run_clustering_menu=uimenu(run_menu,'Label','Run Clustering',...
    'Callback',{@run_clustering});
run_everything_menu=uimenu(run_menu,'Label','Run t-SNE and Clustering',...
    'Callback',{@run_everything},'Accelerator','R');
man_cluster_menu=uimenu(run_menu,'Label','Reassign cluster manually',...
    'Callback',{@manual_cluster},'Accelerator','M');

disp_menu=uimenu(gcf,'Label','Plot');
plot_sig_button=uimenu(disp_menu,'Label','Plot Signals','Callback',...
    {@plot_signals});
make_movie_button=uimenu(disp_menu,'Label','Make Movie!','Callback',...
    {@makemovie});

% import_data_btn=uicontrol(...
%     'Style','pushbutton',...
%     'Position',import_data_pos,...
%     'String',sprintf('Select t-SNE data .mat file'),...
%     'FontSize', BtnSz, ...
%     'Callback' , {@importdata});
run_tsne_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',run_tsne_pos,...
    'String',sprintf('Run t-SNE Only!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_tsne,tsne_data_no_cluster});
run_clustering_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',run_clustering_pos,...
    'String',sprintf('Run Automatic Clustering!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_clustering,tsne_data_no_cluster});
run_everything_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',run_everything_pos,...
    'String',sprintf('Run t-SNE and Clustering!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_everything});
save_export_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',save_export_pos,...
    'String',sprintf('Save to file...'),...
    'FontSize', BtnSz, ...
    'Callback' , {@save_export,tsne_data});
id_neurons_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',id_neurons_pos,...
    'String',sprintf('Identify Neurons!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@idNeurons,tsne_data});

start_manual_cluster_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',start_manual_cluster_btn_pos,...
    'String','Manually cluster points',...
    'FontSize', BtnSz, ...
    'Callback' , {@manual_cluster});

plot_btn_pos=[start_manual_cluster_btn_pos(1)+start_manual_cluster_btn_pos(3)+btn_space,...
    start_manual_cluster_btn_pos(2:4)];
plot_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',plot_btn_pos,...
    'String','Plot Cluster Signals',...
    'FontSize', BtnSz, ...
    'Callback' , {@plot_signals});

%set (gcf, 'ButtonDownFcn', @mouseClick);
%set(get(gca,'Children'),'ButtonDownFcn', @mouseClick);
%set(gcf,'WindowButtonUpFcn', @mouseRelease)
%set(gcf,'ResizeFcn', @figureResized)
%set(tsne_ax,'ButtonDownFcn',@draw_rect)

%% functions!

    function manual_cluster(hObj,event)
        if isempty(tsne_data)&&isempty(tsne_data_no_cluster)
            warndlg('Run t-SNE or import t-SNE data first');
        else
            if isempty(tsne_data) %no clustering has happened yet
                tsne_data=tsne_data_no_cluster;
                tsne_data.labels=double(foreground);
            end
        unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
        num_clusters=length(unique_clusters);
%         load('neuron_seg_colormap.mat','n_seg_cmap');
%         cmap_idx=round(linspace(1,size(n_seg_cmap,1),num_clusters-1));
%         cmap_selection=flipud([n_seg_cmap(cmap_idx,:);.7,.7,.7]);

        tsne_result_full=tsne_data.tsne_result(tsne_data.precluster_groups,:);
        title(tsne_ax,'Select points to assign to cluster')
        rect=getrect(tsne_ax);
        title(tsne_ax,'t-SNE Result')
        if num_clusters>1
            asgn=choose_cluster(unique_clusters,tsne_data.cmap);
        else
            asgn=max(unique_clusters)+1;
        end
        if ~isempty(asgn)
            if strcmp(asgn,'New cluster')
                asgn=max(unique_clusters)+1;
            end
            if strcmp(asgn,'Noise')
                asgn=1;
            end
            selected_pts_x=(tsne_result_full(:,1)>rect(1)) & ...
                (tsne_result_full(:,1)<rect(1)+rect(3));
            selected_pts_y=(tsne_result_full(:,2)>rect(2)) & ...
                (tsne_result_full(:,2)<rect(2)+rect(4));
            foreground_labels=double(tsne_data.labels(foreground));
            foreground_labels(selected_pts_x & selected_pts_y)=asgn;
            tsne_data.labels(foreground)=foreground_labels;
            
            unique_no_noise_clusters=unique(tsne_data.labels(tsne_data.labels>1));
            
            for ii=1:length(unique_no_noise_clusters)
                tsne_data.labels(tsne_data.labels==unique_no_noise_clusters(ii))=...
                    ii+1;
            end
            unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
            tsne_data.neuronID=cellfun(@num2str,...
                    num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
            tsne_data.cmap=generate_cmap(length(unique_clusters(unique_clusters>1)));
            plot_tsne_clusters;
            end
            
            
        end
    end
    function filt_inten(hObj,event)
        cmap_full=[cmap1;cmap];
        colormap(ax_foreground,cmap_full)
        T=hObj.Value;
        foreground_img=dist>T;
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        
        [~,name,~] = fileparts(filename) ;
        name=strrep(name,'_',' ');
        foreground_title.String=sprintf('%s\nForeground has %d points',...
            name,length(find(foreground_img)));
    end
% -=< Slice slider callback function >=-
    function SliceSlider (hObj,event, Img4D)
        S = round(get(hObj,'Value'));
        img.CData=C1(:,:,Z,S);
        %caxis([Rmin Rmax])
        if sno > 1
            set(stxthand, 'String', sprintf('t step %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
        [odor,conc]=compute_odor_conc(odor_seq(S));
        if isfield(img_data,'t')
            t=img_data.t;
        else
            t=tsne_data.t;
        end
        odor_txt.String=sprintf('%s %s\nt = %0.3f sec',conc,odor,t(S));
        
        
        
        
    end

    function Slider3D(hObj,event,txt)
        z = round(get(hObj,'Value'));
        img_foreground.CData=foreground(:,:,z);
        if zsl > 1
            set(txt, 'String', sprintf('z slice %d / %d',z, zsl));
        else
            set(txt, 'String', '2D image');
        end
        if z==1
           larva_side_label.String=larva_side(1);
        elseif z==zsl
            if strcmp(larva_side(1),'Dorsal')
                larva_side_label.String='Ventral';
            else
                larva_side_label.String='Dorsal';
            end
        else
            larva_side_label.String=' ';
        end
       
    end

% -=< Mouse scroll wheel callback function >=-
    function mouseScroll (object, eventdata)
        UPDN = eventdata.VerticalScrollCount;
        Z = Z - UPDN;
        if (Z < 1)
            Z = 1;
        elseif (Z > zsl)
            Z = zsl;
        end
         if zsl > 1
%             set(shand,'Value',Z);
             set(ztxthand, 'String', sprintf('Z Slice# %d / %d',Z, zsl));
         else
             set(ztxthand, 'String', '2D image');
         end
        img.CData=C1(:,:,Z,S);
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        if Z==1
           larva_side_label.String=larva_side(1);
        elseif Z==zsl
            if strcmp(larva_side(1),'Dorsal')
                larva_side_label.String='Ventral';
            else
                larva_side_label.String='Dorsal';
            end
        else
            larva_side_label.String=' ';
        end
    end
% -=< Window and level mouse adjustment >=-
    function WinLevAdj(varargin)
        PosDiff = get(0,'PointerLocation') - InitialCoord;

        Win = Win + PosDiff(1) * WLAdjCoe * FineTuneC(get(ChBxhand,'Value')+1);
        LevV = LevV - PosDiff(2) * WLAdjCoe * FineTuneC(get(ChBxhand,'Value')+1);
        if (Win < 1)
            Win = 1;
        end

        [Rmin, Rmax] = WL2R(Win,LevV);
        caxis([Rmin, Rmax])
        set(lvalhand, 'String', sprintf('%6.0f',LevV));
        set(wvalhand, 'String', sprintf('%6.0f',Win));
        InitialCoord = get(0,'PointerLocation');
    end
%-=< Window and level text adjustment >=-
    function WinLevChanged(varargin)

        LevV = str2double(get(lvalhand, 'string'));
        Win = str2double(get(wvalhand, 'string'));
        if (Win < 1)
            Win = 1;
        end

        [Rmin, Rmax] = WL2R(Win,LevV);
        caxis([Rmin, Rmax])
    end
% -=< Window and level to range conversion >=-
    function [Rmn Rmx] = WL2R(W,L)
        Rmn = L - (W/2);
        Rmx = L + (W/2);
        if (Rmn >= Rmx)
            Rmx = Rmn + 1;
        end
    end
% -=< Window and level auto adjustment callback function >=-
    function AutoAdjust(object,eventdata)
        Win = double(max(Img4D(:))-min(Img4D(:)));
        Win (Win < 1) = 1;
        LevV = double(min(Img4D(:)) + (Win/2));
        [Rmin, Rmax] = WL2R(Win,LevV);
        caxis([Rmin, Rmax])
        set(lvalhand, 'String', sprintf('%6.0f',LevV));
        set(wvalhand, 'String', sprintf('%6.0f',Win));
    end
    function save_foreground(object,eventdata)
        foreground=foreground_img;
        assignin('base','foreground',foreground);
        img_foreground.CData=foreground(:,:,z_tsne);
    end
    function run_tsne(varargin)
        foreground=foreground_img;
        max_iter=str2num(num_iter_box.String);
       tsne_data_no_cluster=CIA_TSNE(aligned_green_img,foreground,...
           odor_seq,'tsne_iter',max_iter);
        plot(tsne_ax,tsne_data_no_cluster.tsne_result(:,1),...
            tsne_data_no_cluster.tsne_result(:,2),'.')
       
       
    end
    function run_clustering(varargin)
        try
            close(tcourse_fig)
        end
        if ~isempty(tsne_data_no_cluster)
            if size(tsne_data_no_cluster.foreground)==...
                    size(aligned_green_img(:,:,:,1))
                alpha=str2num(alpha_box.String);
                k=str2num(k_box.String);
                tsne_data=CIA_LSBDC(tsne_data_no_cluster,aligned_green_img,...
                    odor_seq,'alpha',alpha,'k',k);
                
                tsne_data.neuronID=cellfun(@num2str,...
                    num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
                
                plot_tsne_clusters;
                tcourse_fig=plot_cluster_t_course(image_times,tsne_data.cluster_signals,...
                    odor_seq,aligned_red_img,tsne_data.labels,filename,...
                   tsne_data.neuronID);
                
                msgbox('Segmentation Success!');
            else
                warndlg(sprintf('Run t-SNE or import data before running clustering'));
            end
        else
            warndlg(sprintf('Run t-SNE or import data before running clustering'));
        end
    end

    function plot_tsne_clusters(varargin)
        unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
        tsne_result_full=tsne_data.tsne_result(tsne_data.precluster_groups,:);
        cmap_full=[cmap1;1,1,1;tsne_data.cmap];
        colormap(ax_foreground,cmap_full)

        foreground_img=tsne_data.labels+1;
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        for ii=1:length(unique_clusters)

            h(ii)=plot(tsne_ax,tsne_result_full(tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),1),...
                tsne_result_full(tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),2),'.');
            hold(tsne_ax, 'on');
            if unique_clusters(ii)==1
                h(ii).MarkerEdgeColor=tsne_data.cmap(1,:);
            else
                h(ii).MarkerEdgeColor=tsne_data.cmap(unique_clusters(ii),:);
            end
            
        end
        hold(tsne_ax,'off');
        
        if unique_clusters(1)==1
            cluster_names=['Noise',tsne_data.neuronID];
        else
            cluster_names=tsne_data.neruonID;
        end
        leg=legend(h,cluster_names);
        leg.Visible='On';
    end

    function importdata(varargin)
       
        fname=uigetfile('*tsne_data.mat','Choose t-SNE data .mat file');
        
        if ~isempty(fname)
           ld=load(fname);
           try
               tsne_data=ld.tsne_data;
           catch
               warndlg(sprintf('No t-SNE data found! \nTry again.'));
           end

        end
        if ~isfield(tsne_data,'filenames')
            img_data.filename=uigetfile('*.nd2',sprintf('Choose nd2 filename for %s',fname));
            img_data.filename_log=uigetfile('log_*.txt',sprintf('Choose log filename for %s',fname));
        else
            img_data.filename=tsne_data.filenames{1};
            img_data.filename_log=tsne_data.filenames{2};
        end
        filename=img_data.filename;
        setup_figures;
        Img4D=tsne_data.aligned_green_img;
        if isfield(tsne_data,'which_side')
            larva_side=tsne_data.which_side;
        end
        Z=round(size(Img4D,3)/2);
        S=1;
        aligned_green_img=tsne_data.aligned_green_img;
        aligned_red_img=tsne_data.aligned_red_img;
        odor_seq=tsne_data.odor_seq;
        if isfield(tsne_data,'roi')
            roi=tsne_data.roi;
        end
        if ~isfield(tsne_data,'neuronID')
            tsne_data.neuronID=cellfun(@num2str,...
                    num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
        end
        image_times=tsne_data.t;
        display_movie;
        
        aligned_green_img_full=[];
        aligned_red_img_full=[];
        run_pca;
        foreground=tsne_data.labels>0;
        foreground_img=tsne_data.labels;
        
        display_foreground;
        plot_tsne_clusters;
    end
    function importimg(varargin)
        fname=uigetfile('*.nd2');
        fnamelog=uigetfile('log_*');
        
        if all(fname~=0) && all(fnamelog ~= 0)
            img_data=import_nd2_files(1,fname,fnamelog);
            odor_seq=img_data.odor_seq;
            if isfield(img_data,'which_side')
                larva_side=img_data.which_side;
            end
            if any(strcmp(varargin,'preloaded'))
                run_alignment('preloaded');
                get_ROI('preloaded');
                
            else
                run_alignment;
                get_ROI;
                
            end
        end
    end
    function run_alignment(varargin)
        parems=inputdlg({'xy Filter Size','z Filter Size',...
            'Number of Passes (enter 1 or 2)','xy Filter Size (2nd pass)',...            
            'Max Iterations','Convergance Size','Maximum Step'},...
            'Alignment Parameters',1,{'29','5','2','5','1000','1e-6','0.625'});
        if ~isempty(parems)
            parems=cellfun(@str2num,parems);
            
            
            err=0;
            try
                odor_seq=img_data.odor_seq;
                image_times=img_data.t;
                filename=img_data.filename; 
                [aligned_green_img, aligned_red_img]=...
                     imregbox(img_data.img_stacks{2}, img_data.img_stacks{1},...
                     'scalexy',parems(1),'scalez',parems(2),'maxiter',parems(5),...
                     'minstep',parems(6),'maxstep',parems(7),'scalexy pass 2',parems(4),...
                     'doublepass',parems(3));
                 aligned_green_img_full=aligned_green_img;
                 aligned_red_img_full=aligned_red_img;
            catch
                err=1; 
                warndlg(sprintf('Error loading data,\nplease check and try again!'));
            end
            if err==0
                if ~any(strcmp(varargin,'preloaded'))
                    tsne_data=[];
                end
                tsne_data_no_cluster=[];
                plot(tsne_ax,1,1,'Visible','Off')
                setup_figures;
                
                msgbox('Movie Imported Successfully!');
            end
        end
    end
    function importMatImg(varargin)
        fname=uigetfile('*.mat');
        if fname~=0
            try
                close(tcourse_fig);
            end
            waiting=waitbar(0,'Loading Data...');
            img_data_matfile=matfile(fname);
            err=0;
            try 
                aligned_green_img=img_data_matfile.aligned_green_img;
                aligned_red_img=img_data_matfile.aligned_red_img;
                odor_seq=img_data_matfile.odor_seq;
                image_times=img_data_matfile.t;
                filename=img_data_matfile.filename;
            catch
               err=1; 
               close(waiting);
               warndlg(sprintf('Error loading data,\nplease check and try again!'));
            end
            if err==0;
                tsne_data=[];
                tsne_data_no_cluster=[];
                plot(tsne_ax,1,1,'Visible','Off')
                setup_figures;
                waitbar(.5,waiting,'Running PCA...');
                run_pca;
                display_movie;
                close(waiting);
                msgbox('Movie Imported Successfully!');
            end
        end
    end

    function run_everything(varargin)
        run_tsne;
        run_clustering;
        
        
    end

    function setup_figures(varargin)
        Img4D=aligned_green_img;
        sno = size(Img4D,4);  % number of slices
        S = round(sno/2);
        zsl = size(Img4D,3);
        Z = round(zsl/2);
        global InitialCoord;

        MinV = 0;
        MaxV = max(Img4D(:));
        LevV = (double( MaxV) + double(MinV)) / 2;
        Win = double(MaxV) - double(MinV);
        WLAdjCoe = (Win + 1)/1024;
        FineTuneC = [1 1/16];    % Regular/Fine-tune mode coefficients

        if isa(Img4D,'uint8')
            MaxV = uint8(Inf);
            MinV = uint8(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'uint16')
            MaxV = uint16(Inf);
            MinV = uint16(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'uint32')
            MaxV = uint32(Inf);
            MinV = uint32(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'uint64')
            MaxV = uint64(Inf);
            MinV = uint64(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'int8')
            MaxV = int8(Inf);
            MinV = int8(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'int16')
            MaxV = int16(Inf);
            MinV = int16(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'int32')
            MaxV = int32(Inf);
            MinV = int32(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'int64')
            MaxV = int64(Inf);
            MinV = int64(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(Img4D,'logical')
            MaxV = 0;
            MinV = 1;
            LevV =0.5;
            Win = 1;
            WLAdjCoe = 0.1;
        end    


        if (nargin < 4)
            [Rmin, Rmax] = WL2R(Win, LevV);
        elseif numel(disprange) == 0
            [Rmin, Rmax] = WL2R(Win, LevV);
        else
            LevV = (double(disprange(2)) + double(disprange(1))) / 2;
            Win = double(disprange(2)) - double(disprange(1));
            WLAdjCoe = (Win + 1)/1024;
            [Rmin, Rmax] = WL2R(Win, LevV);
        end        
    end
    function run_pca(varargin)
        
        pca_num=40;
        
        Img4D_list=reshape(Img4D,size(Img4D,1)*size(Img4D,2)*size(Img4D,3),size(Img4D,4));
        Img4D_list_nonzero=Img4D_list(~any(Img4D_list==0,2),:);
        coeffs=zeros(size(Img4D_list,1),pca_num);
        coeffs(~any(Img4D_list==0,2),:)=pca(Img4D_list_nonzero',...
            'NumComponents',pca_num);
            dist=reshape(sqrt(sum(coeffs.^2,2)),size(Img4D,1),size(Img4D,2),size(Img4D,3));
            min_slider=min(dist(:));
            max_slider=max(dist(:));
        T=(max_slider-min_slider)/2+min_slider;  
        foreground_img=dist>T;
        foreground=foreground_img;
        
    end
    function display_movie(varargin)
        %% load background and green channel image
        %% load colormap
        
       

        img=imshow(Img4D(:,:,Z,S), [Rmin Rmax],'Parent',ax_foreground);
        cmap=[0,0,0;1,1,1];
        cmap1=colormap(ax_foreground,gray(100));
        imin=min(Img4D(Img4D(:,:,:,1)>0));
        imax=max(Img4D(:));
        C1=(Img4D-imin)*(size(cmap1,1)-1)/(imax-imin)+1;
        hold(ax_foreground,'on');

        img.CDataMapping='direct';
        img.CData=C1(:,:,Z,S);

        cmap_full=[cmap1;cmap];
        colormap(ax_foreground,cmap_full)
        set (gcf, 'WindowScrollWheelFcn', @mouseScroll);
        
        sno=size(Img4D,4);
        zsl=size(Img4D,3);
        %colormap(lb,cmap);
       
        if sno > 1 %if number of frames>1
            shand.Visible='on';
            shand.Min=1;
            shand.Max=sno;
            shand.Value=1;
            shand.SliderStep=[1/(sno-1) 10/(sno-1)];
            shand.Callback={@SliceSlider, Img4D};
            
            stxthand.String=sprintf('t step %d / %d',S, sno);
            
        else
            shand.Visible='off';
            stxthand.String='2D image';
           
        end    
        if zsl>1 %if number of z slices>1 
            ztxthand.String=sprintf('Z Slice# %d / %d',Z, zsl);
        else
             ztxthand.String='2D image';
        end
        if ~isempty(larva_side)
           if strcmp(larva_side(2),'Left')
               larva_ML_label_left.String='L';
               larva_ML_label_right.String='M';
           else
               larva_ML_label_left.String='M';
               larva_ML_label_right.String='L';
           end
        end
    end
    function get_ROI(varargin)
        if isempty(aligned_green_img_full)
            msgbox('Full movie does not exist. Reload to adjust ROI');
        else
        if ~any(strcmp(varargin,'preloaded'))
            img=imshow(max(max(aligned_green_img_full,[],3),[],4), [Rmin Rmax],'Parent',ax_foreground);
            title(ax_foreground,'Select entire ROI')
            rect=round(getrect(ax_foreground));
            %keep in boundss
            rect=rect([2,1,4,3]);
            for ii=1:2
                if rect(ii)<1
                    rect(ii)=1;
                end
                if rect(ii)+rect(ii+2)>size(aligned_green_img_full,ii)
                    rngend=size(aligned_green_img_full,ii);
                else
                    rngend=rect(ii)+rect(ii+2);
                end
                rng(ii,:)=[rect(ii),rngend];
            end


            roi=rng;
            img=imshow(max(max(...
                aligned_green_img_full(rng(1,1):rng(1,2),rng(2,1):rng(2,2),...
                :,:),[],3),[],4),...
                [Rmin Rmax],'Parent',ax_foreground);                                     
            choice=questdlg('Use this ROI?','Confirm','Yes','Cancel','Cancel');
        else
            choice='Yes';
            rng=tsne_data.roi;
        end
        switch choice
            case 'Yes'             
            aligned_green_img=aligned_green_img_full(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:,:);
            aligned_red_img=aligned_red_img_full(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:,:);
            Img4D=aligned_green_img;
            tsne_data.aligned_red_img=aligned_red_img;
            tsne_data.aligned_green_img=aligned_green_img;
            tsne_data.t=image_times;
            tsne_data.roi=roi;
            display_movie;
            waiting=waitbar(.5,'Running PCA...');
            run_pca;
            display_foreground;
            close(waiting);
        end
        end
    end
    function display_foreground(varargin)
        lb=imshow(foreground_img(:,:,Z), [Rmin Rmax],'Parent',ax_foreground);
        lb.CDataMapping='direct';
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        [~,name]=fileparts(filename);
        name=strrep(name,'_',' ');
        foreground_title=title(ax_foreground,sprintf('%s\nForeground has %d points',...
            name,length(find(foreground))));
        lb.AlphaData=.2;
        hold(ax_foreground,'off');
        
        
        
        inten_sld.Min=min_slider;
        inten_sld.Max=max_slider;
        inten_sld.Value=T;
        inten_sld.Callback=@filt_inten;
        inten_txt.String='Background Threshold';
    end
    function plot_signals(varargin)
        try
            close(tcourse_fig);
            close(peak_sig_fig);
        end
        tsne_data=calculate_cluster_signals(tsne_data,aligned_green_img,odor_seq);
        [~,nm_sig,nmPeakSig]=...
             calc_nm_sig(odor_seq,tsne_data.cluster_signals);
         
         tsne_data.nmPeakSigMat=nmPeakSig;
         tsne_data.nmSigMat=nm_sig;
         
         
        tcourse_fig=plot_cluster_t_course(tsne_data);         
         
         [~,name]=fileparts(filename);
         name=strrep(name,'_',' ');
         [~,~,~,peak_sig_fig]=dispNeuronSignals(nmPeakSig,[],name,tsne_data.neuronID);
         
    end
    function makemovie(varargin)
        mov=animate_3d_stuff2(tsne_data.labels,2:max(tsne_data.labels(:)),...
            tsne_data.cmap(2:end,:),aligned_green_img,aligned_red_img,tsne_data.cluster_signals,...
            filename,image_times,odor_seq);
    end
    function save_export(varargin)
        tsne_data.aligned_red_img=aligned_red_img;
        tsne_data.aligned_green_img=aligned_green_img;
        tsne_data.odor_seq=odor_seq;
        tsne_data.nmPeakSigMat=nmPeakSig;
        tsne_data.nmSigMat=nm_sig;
        if ~isempty(roi)
            tsne_data.roi=roi;
        end
        tsne_data.t=image_times;
        if isfield(img_data,'pixelSize')
            tsne_data.pixelSize=img_data.pixelSize;
        end
        if isfield(img_data,'which_side')
            tsne_data.which_side=img_data.which_side;
        end
        tsne_data.filenames={img_data.filename,img_data.filename_log};
        [tsne_data.neuron_CoM,tsne_data.neuron_var]=calcNeuronPositions(tsne_data);
        [fname,pname]=uiputfile('*.fig','Enter figure 1 name',strcat(filename,'_tsne_result.fig'));
        [fname2,pname]=uiputfile('*.fig','Enter figure 2 name',strcat(filename,'_nm_sigs.fig'));
        if fname~=0
            savefig(tcourse_fig,fullfile(pname,fname));
            savefig(peak_sig_fig,fullfile(pname,fname2));
            save(strcat(filename,'_tsne_data.mat'),'tsne_data')
            msgbox('Data Saved!');
        end
        
        
    end
    function idNeurons(varargin)
        
        odors2exclude_idx=selectTestOdorSet(odor_seq);
        ORNs2use=selectTestORNbasis;
        tsne_data=calculate_cluster_signals(tsne_data,aligned_green_img,odor_seq);
        [~,tsne_data.nmSigMat,tsne_data.nmPeakSigMat]=...
             calc_nm_sig(odor_seq,tsne_data.cluster_signals);
        
        
        
        %if ~isempty(odors2exclude_idx) && ~isempty(ORNs2use)
            %w=waitbar(0,'Predicting...');
            prediction=predictNeurons(tsne_data.nmPeakSigMat,odors2exclude_idx,...
                ORNs2use);
            tsne_data.neuronID=prediction;
            plot_tsne_clusters;
            try
                close(tcourse_fig);
                close(peak_sig_fig);
            end
            tcourse_fig=plot_cluster_t_course(tsne_data);
            [~,~,peak_sig_fig]=dispNeuronSignals(tsne_data.nmPeakSigMat,[],tsne_data.filenames{1},tsne_data.neuronID);
          %  close(w);
       % end
    end
        
        
end