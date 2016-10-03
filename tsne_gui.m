function  tsne_gui()
%

%% Initialize a bunch of globals
img_data=[];peak_sig_fig=[];log_data=[];
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
tcourse_fig=[];tcourse_ax=[];
foreground_title=[];
selected_pts=[];
roi=[];
nm_sig={};
movie_loaded=0;IDed=0;tsned=0;clustered=0;
nmPeakSig=[];larva_side=[];orns=[];
neuronID=[];neurons2include=[];nmPeakSigTestMat=[];includeInClassifier=[];
ax_NID= gobjects(0);ax3D= gobjects(0);submit_button=[];ORNMenu=[];include_chkbox=[];
confirmed=[];
%% 

        SFntSz = 9;
        LFntSz = 10;
        WFntSz = 10;
        LVFntSz = 9;
        WVFntSz = 9;
        BtnSz = 10;
        ChBxSz = 10;
%% set up figure and tabs
f_tSNE=figure('units','normalized','outerposition',[.05 .05 .8 .8],...
    'Name','t-SNE for Neuron Clustering','ToolBar','figure','MenuBar','none');

tgroup=uitabgroup('Parent',f_tSNE);
% foreground_tab=uitab('Parent',tgroup,'Title','Determine Foreground');
tsne_tab=uitab('Parent',tgroup,'Title','t-SNE');
ID_tab=uitab('Parent',tgroup,'Title','ORN ID');
%clustering_tab=uitab('Parent',tgroup,'Title','Clustering and Export');

%% set up axes
tsne_w=.4;
tsne_ax=axes('Parent',tsne_tab,'position',[.95-tsne_w, .2, tsne_w,.65]);
ax_foreground=axes('Parent',tsne_tab,'position',[.05 .2 .4 .65]);
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
larva_side_label=uicontrol('Parent',tsne_tab,'Style', 'text',...
    'Position', [ax_f_Pos(1),ax_f_Pos(2)+ax_f_Pos(4)+10,80,20],...
                 'FontSize', 14);
larva_ML_label_left=uicontrol('Parent',tsne_tab,'Style', 'text',...
    'Position', [ax_f_Pos(1)-20,ax_f_Pos(2)+ax_f_Pos(4)/2+40,40,20],...
                 'FontSize', 14);
larva_ML_label_right=uicontrol('Parent',tsne_tab,'Style', 'text',...
    'Position', [ax_f_Pos(1)+ax_f_Pos(3)+20,ax_f_Pos(2)+ax_f_Pos(4)/2+40,40,20],...
                 'FontSize', 14);
f_tSNE.Units='pixels';
FigPos = f_tSNE.Position;


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

shand = uicontrol('Parent',tsne_tab,'Style', 'slider','Position', S_Pos);
stxthand = uicontrol('Parent',tsne_tab,'Style', 'text','Position', Stxt_Pos,...
    'BackgroundColor', [0.8 0.8 0.8],'FontSize', SFntSz,...
    'String','Load Image First');
ztxthand = uicontrol('Parent',tsne_tab,'Style', 'text','Position', Ztxt_Pos,...
    'BackgroundColor', [0.8 0.8 0.8],...
                 'FontSize', 11);
inten_sld=uicontrol('Parent',tsne_tab,'Style','slider','Position',T_slider_pos);
inten_txt=uicontrol('Parent',tsne_tab,'Style', 'text','Position', T_slider_txt_pos,...
    'BackgroundColor', [0.8 0.8 0.8],...
                 'FontSize', 11);

%Number of iterations box
num_iter_txt = uicontrol('Parent',tsne_tab,'Style', 'text',...
    'Position', num_iter_txt_pos,...
    'String','Number of Iterations: ', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
num_iter_box = uicontrol('Parent',tsne_tab,'Style', 'edit','Position', ...
    num_iter_box_pos,'String',...
    sprintf('%d',max_iter), ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,max_iter});

%box for k means reduction fraction
k_means_red_txt = uicontrol('Parent',tsne_tab,'Style', ...
    'text','Position', k_means_txt_pos,...
    'String','Data reduction fraction:', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
k_means_red_box = uicontrol('Parent',tsne_tab,'Style', 'edit',...
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
k_box_txt = uicontrol('Parent',tsne_tab,'Style', ...
    'text','Position', k_txt_pos,...
    'String','Cluster Size:', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
k_box = uicontrol('Parent',tsne_tab,'Style', 'edit',...
    'Position', k_box_pos,...
    'String',k, ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,k});

%box for alpha parameter
alpha_txt = uicontrol('Parent',tsne_tab,'Style', ...
    'text','Position', alpha_txt_pos,...
    'String','Density threshold', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
alpha_box = uicontrol('Parent',tsne_tab,'Style', 'edit',...
    'Position', alpha_box_pos,...
    'String',alpha, ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,alpha});

odor_txt=uicontrol('Parent',tsne_tab,'Style',...
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

% import_img_btn=uicontrol('Parent',tsne_tab,...
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
add2trainset=uimenu(mh,'Label','Add to Training Dataset','Callback',{@add2trainingset});


edit_menu=uimenu(gcf,'Label','Edit');
restore_training_set=uimenu(mh,'Label','Restore Other Training Database','Enable','On',...
    'Callback',{@restore_database});
select_ROI_item=uimenu(edit_menu,'Label','Select ROI','Callback',{@get_ROI});
tsne_parameters=uimenu(edit_menu,'Label','Edit t-SNE paremeters','Callback',{@tsne_parems});
cluster_parameters=uimenu(edit_menu,'Label','Edit clustering paremeters','Callback',{@cluster_parems});
disp_soma=uimenu(edit_menu,'Label','Plot Soma Responses','Callback',{@soma_responses});
run_menu=uimenu(gcf,'Label','Run');
run_alignment_menu=uimenu(run_menu,'Label','Run Alignment',...
    'Callback',{@man_run_alignment});
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
disp_red_channel=uimenu(disp_menu,'Label','Show Aligned Red Channel','Callback',...
    {@view_aligned_red_channel});
% import_data_btn=uicontrol('Parent',tsne_tab,...
%     'Style','pushbutton',...
%     'Position',import_data_pos,...
%     'String',sprintf('Select t-SNE data .mat file'),...
%     'FontSize', BtnSz, ...
%     'Callback' , {@importdata});
run_tsne_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',run_tsne_pos,...
    'String',sprintf('Run t-SNE Only!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_tsne,tsne_data_no_cluster});
run_clustering_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',run_clustering_pos,...
    'String',sprintf('Run Automatic Clustering!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_clustering,tsne_data_no_cluster});
run_everything_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',run_everything_pos,...
    'String',sprintf('Run t-SNE and Clustering!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_everything});
save_export_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',save_export_pos,...
    'String',sprintf('Save to file...'),...
    'FontSize', BtnSz, ...
    'Callback' , {@save_export,tsne_data});
id_neurons_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',id_neurons_pos,...
    'String',sprintf('Identify Neurons!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@idNeurons,tsne_data});

start_manual_cluster_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',start_manual_cluster_btn_pos,...
    'String','Manually cluster points',...
    'FontSize', BtnSz, ...
    'Callback' , {@manual_cluster});

plot_btn_pos=[start_manual_cluster_btn_pos(1)+start_manual_cluster_btn_pos(3)+btn_space,...
    start_manual_cluster_btn_pos(2:4)];
plot_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',plot_btn_pos,...
    'String','Plot Cluster Signals',...
    'FontSize', BtnSz, ...
    'Callback' , {@plot_signals});
ID_tab.Units='pixels';
        fpositionPix=ID_tab.Position;
        ID_tab.Units='normalized';
        fpositionNorm=ID_tab.Position;
        submit_buttonSZ=[150/fpositionPix(3),60/fpositionPix(4)];
        submit_button_pos=[fpositionNorm(3)-submit_buttonSZ(1)-80/fpositionPix(3),...
            submit_buttonSZ(2)+20/fpositionPix(4),submit_buttonSZ];
        cancel_button_pos=[submit_button_pos(1),...
            submit_button_pos(2)-submit_button_pos(4)-btn_space/fpositionPix(3),...
            submit_button_pos(3:4)];
        confirm_button=uicontrol('Parent',ID_tab,'Style','pushbutton',...
            'Units','normalized',...
            'Position',submit_button_pos,...
            'String','Confirm',...
            'FontSize',12,...
            'Callback',{@confirm},...
            'Visible','off');
        cancel_button=uicontrol('Parent',ID_tab,'Style','pushbutton',...
            'Units','normalized',...
            'Position',cancel_button_pos,...
            'String','Cancel',...
            'FontSize',12,...
            'Callback',{@cancel},...
            'Visible','off');
        1;
%set (gcf, 'ButtonDownFcn', @mouseClick);
%set(get(gca,'Children'),'ButtonDownFcn', @mouseClick);
%set(gcf,'WindowButtonUpFcn', @mouseRelease)
%set(gcf,'ResizeFcn', @figureResized)
%set(tsne_ax,'ButtonDownFcn',@draw_rect)
%% functions!

%% importing functions
    %import t-sne data file
    function erase_ID_tab(varargin)
        not_buttons=~ismember(ID_tab.Children,[cancel_button,confirm_button]);
        delete(ID_tab.Children(not_buttons));
    end
    function delete_figs(varagin) %deletes other figures that are not the tsne_gui
        all_figs=get(0,'Children');
        other_figs=all_figs(~(all_figs==f_tSNE));
        close(other_figs);
    end
    function importdata(varargin)
        
        fname=uigetfile('*tsne_data.mat','Choose t-SNE data .mat file');
        
        if ~isempty(fname)
           
           ld=load(fname);
           try
               delete_figs;
               tsne_data=ld.tsne_data;
               movie_loaded=1;tsned=1;clustered=1;
               erase_ID_tab;
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
            IDed=0;
        else %there is a field called neuronID -- this could either be the neuron name, if they ahve been identified, or it could be just a number 1->number of neurons
            %check if they are all numbers
            are_numbers=cellfun(@(x)~isnan(str2double(x)),tsne_data.neuronID);
            if all(~are_numbers)
                plot_signals_w_labels;
                IDed=1;
            end
            
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
        
    end %load existing tsne data file for viewing and editing
    %import nd2 movie file
    function importimg(varargin)
        
    
        
        fname=uigetfile('*.nd2');
        if all(fname~=0)
            
            fnamelog=uigetfile('log_*');
            
            if all(fnamelog ~= 0)
                delete_figs;
                img_data=import_nd2_files(1,fname,fnamelog);
                ld=load(fnamelog);
                log_data=ld.log_data;
                erase_ID_tab;
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
                movie_loaded=1;IDed=0;tsned=0;clustered=0;
            end
        end
    end


%% interactive functions
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
    % -=< Mouse scroll wheel callback function >=-
    function mouseScroll (object, eventdata)
        for ii=1:length(object.Children)
           if strcmp(object.Children(ii).Type,'uitabgroup')
               if strcmp(object.Children(5).SelectedTab.Title,'t-SNE')
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
           end
       end
        
        
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

%% tsne prep functions
    function tsne_parems(varargin)
        parems={sprintf('Fraction to reduce data\nbefore running t-SNE'),...
            'Number of Iterations'};
        
    end
    function cluster_parems(varargin)
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
                
                msg=msgbox('Movie Imported Successfully!');
                uiwait(msg);
            end
        end
    end
    function get_ROI(varargin)
        if isempty(aligned_green_img_full)
            msg=msgbox('Full movie does not exist. Reload to adjust ROI');
            uiwait(msg);
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
            tgroup.SelectedTab=tsne_tab;
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
    function man_run_alignment(varargin)
        run_alignment;
        get_roi;
    end
    function view_aligned_red_channel(varargin)
        figure;
        imshow4D_wheel(aligned_red_img)
    end

%%  preparation figures
    function display_movie(varargin)        
        %neuronID=[];neurons2include=[];nmPeakSigTestMat=[];includeInClassifier=[];
       %ax_NID= gobjects(0);ax3D= gobjects(0);submit_button=[];ORNMenu=[];include_chkbox=[];

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
    

%% t-sne + clustering functions
    function run_tsne(varargin)
        foreground=foreground_img;
        max_iter=str2num(num_iter_box.String);
       tsne_data_no_cluster=CIA_TSNE(aligned_green_img,foreground,...
           odor_seq,'tsne_iter',max_iter);
        plot(tsne_ax,tsne_data_no_cluster.tsne_result(:,1),...
            tsne_data_no_cluster.tsne_result(:,2),'.')
       tsned=1;
       
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
                tsne_data.t=image_times;
                tsne_data.odor_seq=odor_seq;
                tsne_data.aligned_red_img=aligned_red_img;
                tsne_data.aligned_green_img=aligned_green_img;
                tsne_data.filenames={img_data.filename,img_data.filename_log};
                tsne_data.log_data=log_data;
                tsne_data.odor_conc_inf=gen_odor_conc_inf(tsne_data.log_data);
                if ~isfield(tsne_data,'odor_inf')
                    tsne_data.odor_inf=load('odor_inf.mat');
                end
                plot_tsne_clusters;
                [tcourse_fig,tcourse_ax]=plot_cluster_t_course(tsne_data);
                
                msg=msgbox('Segmentation Success!');
                uiwait;
                clustered=1;
            else
                warndlg(sprintf('Run t-SNE or import data before running clustering'));
            end
        else
            warndlg(sprintf('Run t-SNE or import data before running clustering'));
        end
        
    end
    function run_everything(varargin)
        run_tsne;
        run_clustering;
    end
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
        eval=1;
        try
            rect=getrect_JB(tsne_ax);
        catch
            eval=0;
        end
        if eval
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
                clustered=1;
            end
        end            
            
        end
    end

%% plotting and saving
    function plot_tsne_clusters(varargin)
        if tsned
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
            cluster_names=tsne_data.neuronID;
        end
        leg=legend(h,cluster_names);
        leg.Visible='On';
        else
            warndlg('Run t-sne first!');
        end
    end
    function plot_signals(varargin)
        if clustered
            delete_figs;
%             try
%                 close(tcourse_fig);
%                 close(peak_sig_fig);
%             end
            tsne_data=calculate_cluster_signals(tsne_data,aligned_green_img,odor_seq);
            odor_inf.odor_list=tsne_data.odor_list;
            odor_inf.odor_concentration_list=tsne_data.odor_concentration_list;
            [~,nm_sig,nmPeakSig,...
                s2n_mat,s2n_peak_mat,neuron_fire,neuron_fire_mat]=...
                 calc_nm_sig(odor_seq,tsne_data.cluster_signals,tsne_data.odor_inf);

             tsne_data.nmPeakSigMat=nmPeakSig;
             tsne_data.nmSigMat=nm_sig;


            [tcourse_fig,tcourse_ax]=plot_cluster_t_course(tsne_data);         

             [~,name]=fileparts(filename);
             name=strrep(name,'_',' ');
             assignin('base','tsne_data','tsne_data');
             [~,~,fire,peak_sig_fig]=dispNeuronSignals(nmPeakSig,...
                tsne_data.odor_inf,neuron_fire,name,tsne_data.neuronID);
             
        else
            warndlg('Cluster first!')
        end
        
    end
    function makemovie(varargin)
        mov=animate_3d_stuff2(tsne_data);
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
            sv=msgbox('Data Saved!');
            uiwait(sv);
        end
        
        
    end
    function soma_responses(varargin)
        
        disp_soma_response(tsne_data.odor_conc_inf)
    end

%% classifier functions
    function idNeurons(varargin)
        nmPeakSigTestMat=[];
        odors2exclude_idx=fliplr(selectTestOdorSet(odor_seq,tsne_data.odor_inf));
        ORNs2use=selectTestORNbasis;
        tsne_data=calculate_cluster_signals(tsne_data,aligned_green_img,odor_seq);
        [~,tsne_data.nmSigMat,tsne_data.nmPeakSigMat]=...
             calc_nm_sig(odor_seq,tsne_data.cluster_signals,tsne_data.odor_inf);
        
        
        
        %if ~isempty(odors2exclude_idx) && ~isempty(ORNs2use)
            %w=waitbar(0,'Predicting...');
            [prediction,nmPeakSigTestMat]=predictNeurons(...
                tsne_data.nmPeakSigMat,odors2exclude_idx,ORNs2use);
            tsne_data.neuronID=prediction;
            plot_tsne_clusters;
%             try
%                 close(tcourse_fig);
%                 close(peak_sig_fig);
%             end
         

            plot_signals_w_labels;
            

            [~,~,peak_sig_fig]=dispNeuronSignals(tsne_data.nmPeakSigMat,[],tsne_data.filenames{1},tsne_data.neuronID);
          %  close(w);
       % end
       1;
    end
    function plot_signals_w_labels(varargin)
        erase_ID_tab;
        ax_NID= gobjects(0);
        for ii=1:length(tsne_data.cluster_signals)+1
           ax_NID(ii)=axes('Parent',ID_tab); 
        end
        [~,ax_NID,ax3D]=plot_cluster_t_course(tsne_data,ax_NID);
        [ID_tab,ax_NID,...
            ORNMenu, include_chkbox,orns]=editNeurons4Classifier(tsne_data,ID_tab,ax_NID);
        for ii=1:length(ORNMenu)
            ORNMenu(ii).Callback={@change_neuronID,orns,ii};
        end
        IDed=1;
    end
    function change_neuronID(varargin)
        ornz=varargin{3};
        menu=varargin{1};
        ii=varargin{4};
        tsne_data.neuronID{ii}=ornz{menu.Value};
        if any(tsne_data.labels(:)==1)
            cluster_names=['Noise',tsne_data.neuronID];
        else
            cluster_names=tsne_data.neuronID;
        end
        leg.String=cluster_names;
        1;
    end
    function confirm(varargin)
        confirmed=1;
        uiresume;
    end
    function cancel(varargin)
        confirmed=0;
        uiresume;
    end
    function add2trainingset(varargin)
        if IDed
            include=logical([include_chkbox(:).Value]);
            known=~strcmp(tsne_data.neuronID,'Unknown\NaN');
            include=include & known;
            nmPeakSigNew=tsne_data.nmPeakSigMat(:,:,include);
            filenameNew=tsne_data.filenames{1};
            labelsNew=tsne_data.neuronID(include);
            tgroup.SelectedTab=ID_tab;
            confirm_button.Visible='on';
            cancel_button.Visible='on';
            uiwait;
            confirm_button.Visible='off';
            cancel_button.Visible='off';
            add2TrainingDataset(nmPeakSigNew,filenameNew,labelsNew,find(include))
            msg=msgbox('Added to training database!');
            
        else
            warndlg('Neuron IDs not availabel, run identification first!')
        end
        
    end
    function restore_database(varargin)
        compiled_data_folder=fileparts(which('compiled_data.mat'));
        backup_folder=fullfile(compiled_data_folder,'Compiled_data_backup');
        fname=uigetfile(backup_folder,...
            'Select Database To Replace');
        if (~fname==0)
            old=load('compiled_data.mat');
            new=load(fullfile(backup_folder,fname));
            last_animal=sprintf('%0.0f_%0.0f',old.neuronList(end,1),...
            old.neuronList(end,2)*100+old.neuronList(end,3));
            backupfilename=sprintf('compiled_data_backup%s.mat',last_animal);
            save(fullfile(compiled_data_folder,'Compiled_data_backup',backupfilename),...
        '-struct','old');
            save(fullfile(compiled_data_folder,'compiled_data.mat'),'-struct','new');
            
        end
        
    end
end