function  tsne_gui()
%

%% Initialize a bunch of globals
peak_sig_fig=[];
Img4D=[];saved=1;
leg=[];scale_factor=[];
foreground=[];
cmap=[];
%C1=[];
img=[];
inten_sld=[];
inten_txt=[];
S=[];
Z=[];
Rmin=[];can_time_slide = 1;
Rmax=[];
cmap1=[];
cmap_full=[];
foreground_img=[];
imin=[];
imax=[];
T=[];
dist=[];
min_slider=[];
max_slider=[];fname=[];fnamelog=[];
lb=[];
aligned_green_img=[];
aligned_red_img=[];
aligned_green_img_full=[];
aligned_red_img_full=[];
tsne_data=[];old_tsne_data=[];
filename=[];old_tsne_alpha=[];ii_glob=0;ii_glob_max=0; f_list_glob=[];
tsne_title=[];
tcourse_fig=[];tcourse_ax=[];batch_fname_idx=[];
foreground_title=[];
selected_pts=[];bkgd_ROI_saving = 0;
batch=0;pca_done=0;max_bkgd_proj=[];bkgd_img=[];mean_green_img_t=[];
roi=[];background_fit=1;
nm_sig={};bkgd_done=[];
movie_loaded=0;IDed=0;tsned=0;clustered=0;
nmPeakSig=[];larva_side=[];orns=[];Img_full=[];Img_max_full=[]; Img_max_xyz=[];
neuronID=[];neurons2include=[];nmPeakSigTestMat=[];includeInClassifier=[];
ax_NID= gobjects(0);ax3D= gobjects(0);submit_button=[];ORNMenu=[];include_chkbox=[];
ax_xyz= gobjects(0);ax_xz= gobjects(0);ax_yz= gobjects(0);tsne_alpha=[];
confirmed=[];maxinten_t_hand=gobjects(0);ax_compare=gobjects(0);white_bkd=gobjects(0);
compare_chkbox=gobjects(0);tline_compare=gobjects(0);maxinten_t_text=gobjects(0);
green_mov=[];
fLeg=gobjects(0);compareable=0;reset_compare_btn=gobjects(0);
Img_yz=[];Img_xz=[];Img_xy=[];Img_yz_full=[];Img_xz_full=[];Img_xy_full=[];

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
compare_tab=uitab('Parent',tgroup,'Title','Compare Neurons');
ID_tab=uitab('Parent',tgroup,'Title','ORN ID');
%clustering_tab=uitab('Parent',tgroup,'Title','Clustering and Export');


%% set up axes
tsne_w=.4;
tsne_ax=axes('Parent',tsne_tab,'position',[.95-tsne_w, .2, tsne_w,.65]);
ax_movie_pos=[.05 .2 .4 .65];
ax_foreground=axes('Parent',tsne_tab,'position',ax_movie_pos);
axis('off');
%% Initialize Default paremeters

max_iter=8000;
kmeans_frac=.5;
Alpha=.7;
k=70;
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
done_btn_pos = [T_slider_pos(1)-215,T_slider_pos(2),200,T_slider_pos(4)];
             
bkgd_done_btn = uicontrol('Parent',tsne_tab,'Style','pushbutton',...
    'Position',done_btn_pos,'String','Done selecting',...
    'BackgroundColor','r','FontSize',15);
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
k_txt_pos=[tsne_ax.Position(1)+200, k_means_txt_pos(2:4)];
k_box_pos=[k_txt_pos(1)+k_txt_pos(3),...
    k_means_box_pos(2:4)];
alpha_txt_pos=[k_box_pos(1)+k_box_pos(3)+10,k_txt_pos(2),...
    k_txt_pos(3),k_txt_pos(4)];
alpha_box_pos=[alpha_txt_pos(1)+alpha_txt_pos(3),...
    k_box_pos(2:4)];

use_spatial_chkbox_pos = [k_txt_pos(1)-90,k_txt_pos(2),30,30];
use_spatial_chkbox_txt_pos = [use_spatial_chkbox_pos(1)-k_means_txt_pos(3)*1.3-10,k_means_txt_pos(2),k_means_txt_pos(3)*1.3,...
    k_means_txt_pos(4)];
use_spatial_chkbox_txt = uicontrol('Parent',tsne_tab,'Style', ...
    'text','Position', use_spatial_chkbox_txt_pos,...
    'String',sprintf('Use Spatial Positions for t-SNE'), ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
use_spatial_chkbox = uicontrol('Parent',tsne_tab,'Style', 'checkbox',...
    'Position', use_spatial_chkbox_pos);

scale_factor_box = uicontrol('Parent',tsne_tab,'Style', 'edit',...
    'Position', [use_spatial_chkbox_pos(1)+30,use_spatial_chkbox_txt_pos(2),...
    k_box_pos(3)/2,k_box_pos(4)],...
    'String','1', ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,k});


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

%box for Alpha parameter
alpha_txt = uicontrol('Parent',tsne_tab,'Style', ...
    'text','Position', alpha_txt_pos,...
    'String','Density threshold', ...
    'BackgroundColor',...
    [0.8 0.8 0.8], ...
    'FontSize', LFntSz);
alpha_box = uicontrol('Parent',tsne_tab,'Style', 'edit',...
    'Position', alpha_box_pos,...
    'String',Alpha, ...
    'BackgroundColor', [1 1 1],...
    'FontSize', LVFntSz,...
    'Callback', {@val_changed,Alpha});

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
run_batch=uimenu(mh,'Label','Run Default Parameters on Batch','Callback',{@run_batch_files});

edit_menu=uimenu(gcf,'Label','Edit');
restore_training_set=uimenu(mh,'Label','Restore Other Training Database','Enable','On',...
    'Callback',{@restore_database});
undo_item=uimenu(edit_menu,'Label','Undo...','Enable','off',...
    'Accelerator','Z','Callback',{@undo_cluster});
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
    'Callback',{@run_everything});
man_cluster_menu=uimenu(run_menu,'Label','Reassign cluster manually',...
    'Callback',{@manual_cluster},'Accelerator','E');
draw_movie_cluster_mn = uimenu(run_menu,'Label','Draw Cluster on Movie','Callback',{@draw_movie_cluster},...
    'Accelerator','R');
disp_menu=uimenu(gcf,'Label','Plot');
plot_sig_button=uimenu(disp_menu,'Label','Plot Signals','Callback',...
    {@plot_signals});
make_movie_button=uimenu(disp_menu,'Label','Make Movie!','Callback',...
    {@makemovie});
disp_red_channel=uimenu(disp_menu,'Label','Show Aligned Red Channel','Callback',...
    {@view_aligned_red_channel});
compare_neuron_btn=uimenu(disp_menu,'Label','Compare Neurons','Callback',...
    {@compare_neuron_sigs},'Accelerator','D');
avg_full_green_menu = uimenu(disp_menu,'Label','Plot full average green signal','Callback',...
    {@plot_avg_full_green});
avg_full_green_menu = uimenu(disp_menu,'Label','Plot full average green signal (pop out)','Callback',...
    {@plot_avg_full_green_pop_out});
batch_menu = uimenu(gcf,'Label','Batch Import');
run_batch_alignment = uimenu(batch_menu ,'Label','Run Batch Alignment','Callback',{@batch_alignment});
batch_ROI_foreground_menu = uimenu(batch_menu ,'Label','Select batch ROIs and Foregrounds',...
    'Callback',{@batch_ROI_foreground});
batch_tsne_menu = uimenu(batch_menu, 'Label','Batch run t-SNE and clustering',...
    'Callback',{@batch_run_tsne});
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
    'Callback' , {@run_tsne});
run_clustering_btn=uicontrol('Parent',tsne_tab,...
    'Style','pushbutton',...
    'Position',run_clustering_pos,...
    'String',sprintf('Run Automatic Clustering!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_clustering});
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
    function erase_compare_tab(varargin)
        stuff2delete=~ismember(compare_tab.Children,[reset_compare_btn]);
        delete(compare_tab.Children);
    end
    function delete_figs(varagin) %deletes other figures that are not the tsne_gui
        all_figs=get(0,'Children');
        other_figs=all_figs(~(all_figs==f_tSNE));
        close(other_figs);
    end
    function importdata(varargin)
        batch=0;
        if saved==0
            choice = questdlg('Unsaved changes detected!',...
                'Save Changes?',...
                'Save Changes','Abandon Changes','Cancel','Save Changes');
            switch choice
                case 'Save Changes'
                    save_export;
                    cont=1;
                case 'Abandon Changes'
                    cont=1;
                    saved=1;
                case 'Cancel'
                    cont=0;                  
            end                    
        else
            cont=1;
        end
        if cont==1
            fname=uigetfile('*tsne_data.mat','Choose t-SNE data .mat file');

            if ~isempty(fname)

               ld=load(fname);
               
               try
                   %delete_figs;
                   if isfield(ld,'tsne_data')
                        tsne_data=ld.tsne_data;
                   else
                       tsne_data=ld;
                   end
                   movie_loaded=1;tsned=1;clustered=1;
                   erase_ID_tab;
               catch
                   warndlg(sprintf('No t-SNE data found! \nTry again.'));
               end

            end
             if ~isfield(tsne_data,'filenames')
                 filename=uigetfile('*.nd2',sprintf('Choose nd2 filename for %s',fname));
                 filename_log=uigetfile('log_*.txt',sprintf('Choose log filename for %s',fname));
                 tsne_data.filenames={filename,filename_log};
             else
%                 img_data.filename=tsne_data.filenames{1};
%                 img_data.filename_log=tsne_data.filenames{2};
            filename=tsne_data.filenames{1};
             end
             if isa(tsne_data.aligned_green_img,'uint16')
                tsne_data.aligned_green_img = cast(tsne_data.aligned_green_img,'double')/...
                    tsne_data.scale_factor_green;
                 tsne_data.aligned_red_img = cast(tsne_data.aligned_red_img,'double')/...
                    tsne_data.scale_factor_red;
                tsne_data.cropped_img = cast(tsne_data.cropped_img,'double')/...
                    tsne_data.scale_factor_green;
             end
             
            %filename=img_data.filename;
            setup_figures;
            %aligned_green_img=tsne_data.aligned_green_img;
            if isfield(tsne_data,'which_side')
                larva_side=tsne_data.which_side;
            end
            Z=round(size(tsne_data.aligned_green_img,3)/2);
            S=1;
            %aligned_green_img=tsne_data.aligned_green_img;
            %aligned_red_img=tsne_data.aligned_red_img;
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
            tsne_alpha=ones(length(tsne_data.cluster_signals),1);
            display_movie;

            aligned_green_img_full=[];
            aligned_red_img_full=[];
            %run_pca;

            foreground=tsne_data.labels>0;
            foreground_img=tsne_data.labels+1;
            if isfield(tsne_data,'dist')
                pca_done = 1;
                min_slider=min(tsne_data.dist(:));
                max_slider=max(tsne_data.dist(:));
                inten_sld.Min = min_slider;
                inten_sld.Max = max_slider;
            end
            undo_item.Enable='Off';
            display_foreground;
            plot_tsne_clusters;
            %if ~isfield(tsne_data,'background_level')
            %    tsne_data.background_level=compute_background(foreground,tsne_data.aligned_green_img);
            %end
            try
                close(fLeg);
            end
            compare_neuron_sigs;
        end
    end %load existing tsne data file for viewing and editing
    %import nd2 movie file
    function importimg(varargin)
        if nargin>0
            batch=0;
        end
                if saved==0
            choice = questdlg('Unsaved changes detected!',...
                'Save Changes?',...
                'Save Changes','Abandon Changes','Cancel');
            switch choice
                case 'Save Changes'
                    save_export;
                    cont=1;
                case 'Abandon Changes'
                    cont=1;
                    saved=1;
                case 'Cancel'
                    cont=0;                  
            end                    
        else
            cont=1;
        end
        if cont==1
            if batch==0
                fname=[];
                fnamelog=[];
                fname=uigetfile('*.nd2;*.h5');
            end
            if all(fname~=0)
                if batch==0
                    fnamelog=uigetfile('log_*');
                end

                if all(fnamelog ~= 0)
                    delete_figs;
                    
                    if ~isempty(strfind(fname,'.nd2'))
                        
                        img_data=import_nd2_files(1,fname,fnamelog);
                    elseif ~isempty(strfind(fname,'.h5'))
                        img_data=import_h5_file(1,fname,fnamelog);
                    end
                    if strfind(fnamelog,'.mat')>0
                        ld=load(fnamelog);
                        tsne_data.log_data=ld.log_data;
                    end
                    tsne_data=struct;
                    tsne_data.odor_inf=load('odor_inf.mat');
                    erase_ID_tab;
                    tsne_data.odor_seq=img_data.odor_seq;
                    tsne_data.t=img_data.t;
                     if isfield(img_data,'pixelSize')
                        tsne_data.pixelSize=img_data.pixelSize;
                    end
                    if isfield(img_data,'which_side')
                        tsne_data.which_side=img_data.which_side;
                    end
                    
                    if isfield(img_data,'which_side')
                        larva_side=img_data.which_side;
                    end
                    tsne_data.filenames={img_data.filename,img_data.filename_log};
                    if any(strcmp(varargin,'preloaded'))
                        run_alignment('preloaded',img_data);
                    %    get_ROI('preloaded');

                    else
                        run_alignment('',img_data);
                        tsne_data.full_img_size = size(tsne_data.aligned_green_img);
                        if ~batch
                            get_ROI;
                        end
                    end
                    movie_loaded=1;IDed=0;tsned=0;clustered=0;pca_done=0;
                    undo_item.Enable='Off';
                    erase_compare_tab;
                    try
                        close(fLeg);
                    end
                end 
            end
        end
    end


%% interactive functions
    function filt_inten(hObj,event)
        if ~isfield(tsne_data,'dist')
            run_pca;
        end
        cmap_full=[cmap1;cmap];
        colormap(ax_foreground,cmap_full)
        T=hObj.Value;
        foreground_img=tsne_data.dist>T;
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        
        [~,name,~] = fileparts(tsne_data.filenames{1}) ;
        name=strrep(name,'_',' ');
        foreground_title.String=sprintf('%s\nForeground has %d points',...
            name,length(find(foreground_img)));
    end
    % -=< Slice slider callback function >=-
    function compareSlider(hObj,event)
         t=round(hObj.Value);
         S=t;
         if ~isempty(event) && can_time_slide
             shand.Value = S;
             SliceSlider(shand,[]);
         end
         for ii=1:length(ax_compare)
             if isvalid(tline_compare(ii))
                delete(tline_compare(ii));
             end
             yrange=ax_compare(ii).YLim;
             y=linspace(min(yrange),max(yrange),10);
             x=tsne_data.t(t)*ones(10,1);
             tline_compare(ii)=plot(ax_compare(ii),x,y,'k');                                                 
         end
        
        [current_odor,current_conc]=compute_odor_conc(tsne_data.odor_seq(t),tsne_data.odor_inf);
        
        maxinten_t_text.String=sprintf('Frame %d / %d, t = %0.1f sec\n%s %s',...
            t,length(tsne_data.t),tsne_data.t(t),current_conc, current_odor);
        ax_xyz.Children.CData=Img_max_xyz(:,:,t);
        %ax_xz.Children.CData=Img_xz(:,:,t)';
        %ax_yz.Children.CData=Img_yz(:,:,t);
        
%         
    end
    function SliceSlider (hObj,event)
        S = round(get(hObj,'Value'));
        img.CData=(green_mov(:,:,Z,S)-imin)*scale_factor+1;
        %caxis([Rmin Rmax])
        if sno > 1
            set(stxthand, 'String', sprintf('t step %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
        [odor,conc]=compute_odor_conc(tsne_data.odor_seq(S),tsne_data.odor_inf);
        
            t=tsne_data.t;
        
        odor_txt.String=sprintf('%s %s\nt = %0.3f sec',conc,odor,t(S));
        
        if ~isempty(event) && isvalid(maxinten_t_hand)
            maxinten_t_hand.Value = S;
            compareSlider(maxinten_t_hand,[]);
        end
        
        
    end
    % -=< Mouse scroll wheel callback function >=-
    function mouseScroll (object, eventdata)
        for ii=1:length(object.Children)
           if strcmp(object.Children(ii).Type,'uitabgroup')
               if strcmp(object.Children(ii).SelectedTab.Title,'t-SNE')
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
                    img.CData=(green_mov(:,:,Z,S)-imin)*scale_factor+1;
                    lb.CData=foreground_img(:,:,Z)+length(cmap1);
                    if Z==1
                       larva_side_label.String=tsne_data.which_side{1};
                    elseif Z==zsl
                        if strcmp(tsne_data.which_side{1},'Dorsal')
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
        %Img4D=tsne_data.aligned_green_img;
        sno = size(tsne_data.aligned_green_img,4);  % number of slices
        S = round(sno/2);
        zsl = size(tsne_data.aligned_green_img,3);
        Z = round(zsl/2);
        global InitialCoord;

        MinV = 0;
        MaxV = max(tsne_data.aligned_green_img(:));
        LevV = (double( MaxV) + double(MinV)) / 2;
        Win = double(MaxV) - double(MinV);
        WLAdjCoe = (Win + 1)/1024;
        FineTuneC = [1 1/16];    % Regular/Fine-tune mode coefficients

        if isa(tsne_data.aligned_green_img,'uint8')
            MaxV = uint8(Inf);
            MinV = uint8(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'uint16')
            MaxV = uint16(Inf);
            MinV = uint16(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'uint32')
            MaxV = uint32(Inf);
            MinV = uint32(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'uint64')
            MaxV = uint64(Inf);
            MinV = uint64(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'int8')
            MaxV = int8(Inf);
            MinV = int8(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'int16')
            MaxV = int16(Inf);
            MinV = int16(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'int32')
            MaxV = int32(Inf);
            MinV = int32(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'int64')
            MaxV = int64(Inf);
            MinV = int64(-Inf);
            LevV = (double( MaxV) + double(MinV)) / 2;
            Win = double(MaxV) - double(MinV);
            WLAdjCoe = (Win + 1)/1024;
        elseif isa(tsne_data.aligned_green_img,'logical')
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
        if batch
            parems={'29','5','2','5','1000','1e-6','0.625'};
            crop=0;
        else
            crop=1;
            parems=inputdlg({'xy Filter Size','z Filter Size',...
                'Number of Passes (enter 1 or 2)','xy Filter Size (2nd pass)',...            
                'Max Iterations','Convergance Size','Maximum Step'},...
                'Alignment Parameters',1,{'29','5','2','5','1000','1e-6','0.625'});
        end
        if ~isempty(parems)
            parems=cellfun(@str2num,parems);
            img_data=varargin{2};
            
            err=0;
            %try
                
                tsne_data.odor_seq=img_data.odor_seq;
                tsne_data.t=img_data.t;
                filename=img_data.filename; 
                %red_img=img_data.img_stacks{2};
                r_idx=find(~squeeze(all(all(all(img_data.img_stacks{2}==0,4),2),1)));
                if length(r_idx)<size(img_data.img_stacks{2},3)
                    [tsne_data.aligned_green_img, tsne_data.aligned_red_img]=...
                         imregbox_2D_interp_t(img_data.img_stacks{2}, img_data.img_stacks{1},...
                         img_data.t,'scalexy',parems(1),'scalez',parems(2),'maxiter',parems(5),...
                         'minstep',parems(6),'maxstep',parems(7),'scalexy pass 2',parems(4),...
                         'doublepass',parems(3));
                else
                    [tsne_data.aligned_green_img, tsne_data.aligned_red_img]=...
                         imregbox(img_data.img_stacks{2}, img_data.img_stacks{1},...
                         'scalexy',parems(1),'scalez',parems(2),'maxiter',parems(5),...
                         'minstep',parems(6),'maxstep',parems(7),'scalexy pass 2',parems(4),...
                         'doublepass',parems(3),'crop',crop);
                end
                 aligned_green_img_full=tsne_data.aligned_green_img;
                 
                 nonzero_slice=squeeze(~all(all(all(tsne_data.aligned_red_img==0,1),2),4));
                 tsne_data.aligned_red_img=tsne_data.aligned_red_img(:,:,nonzero_slice,:);
                 aligned_red_img_full=tsne_data.aligned_red_img;
%                  if length(find(squeeze(any(~all(all(aligned_red_img==0,1),2),4))))==1
%                      aligned_red_img=sparse(aligned_red_img);
%                      aligned_red_img_full=sparse(aligned_red_img);
%                  end
            %catch
            %    err=1; 
            %    warndlg(sprintf('Error loading data,\nplease check and try again!'));
            %end
            if err==0
                
                tsne_data_no_cluster=[];
                plot(tsne_ax,1,1,'Visible','Off')
                setup_figures;
                if ~batch
                    msg=msgbox('Movie Imported Successfully!');
                    uiwait(msg);
                    delete('img_data');
                else
                    disp('Movie Imported Successfully!');
                end
                
            end
        end
    end
    function get_ROI(varargin)
        if isempty(aligned_green_img_full) && ~isfield(tsne_data,'cropped_img') && ~batch
            msg=msgbox('Full movie does not exist. Reload to adjust ROI');
            uiwait(msg);
        else 
            if ~batch
                try
                    delete(img)
                end
                if isempty(aligned_green_img_full)
                    tsne_data.aligned_green_img=tsne_data.aligned_green_img+tsne_data.background;
                    aligned_green_img_full = recreate_full_img(tsne_data.aligned_green_img,...
                        tsne_data.cropped_img,tsne_data.full_img_size,tsne_data.roi);                                       
                end
                bkgd_img= mean(aligned_green_img_full,4);
                if ~isempty(foreground)
                        bkgd_img(~foreground) = NaN;
                end
                max_bkgd_proj=max(bkgd_img,[],3);
                mean_green_img_t = max(mean(aligned_green_img_full,4),[],3);
            end
                
                img=imshow(max_bkgd_proj, [min(max_bkgd_proj(max_bkgd_proj>0)) max(max_bkgd_proj(:))],'Parent',ax_foreground);
                %img.CDataMapping='direct';
                %cmapsz=size(colormap,1);
                %max_bkgd_proj=max(mean(bkgd_img,4),[],3);
                %img.CData=(max_bkgd_proj-min(max_bkgd_proj(max_bkgd_proj>0)))/...
                 %   (max(max_bkgd_proj(:))-min(max_bkgd_proj(max_bkgd_proj>0)));
                %img.CData(max_bkgd_proj==0)=0;
                ax_foreground.XLim=[0,size(max_bkgd_proj,2)];
                ax_foreground.YLim=[0,size(max_bkgd_proj,1)];
                mbox=msgbox('Select regions to exclude from background');
                waitfor(mbox);
                bkgd_done=0;

                while ~bkgd_done
                    rect=keep_in_bounds(round(getrect(ax_foreground)),size(bkgd_img));
                    
                    bkgd_img(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:)=NaN;
                    
                    max_bkgd_proj=max(bkgd_img,[],3);
                    delete(img)
                    
                    img=imshow(max_bkgd_proj, [min(max_bkgd_proj(max_bkgd_proj>0)) max(max_bkgd_proj(:))],'Parent',ax_foreground);
                    ax_foreground.XLim=[0,size(max_bkgd_proj,2)];
                    ax_foreground.YLim=[0,size(max_bkgd_proj,1)];
                    
                    done=questdlg('Are there more regions to exclude from background?',...
                        'Define Background','Add more','Done','Add more');
                    switch done
                        case 'Done'
                            bkgd_done=1;                                
                    end                
                    
                end
                img_size=size(bkgd_img);
                bkgd_img_mean = bkgd_img;
                [Xmesh,Ymesh,Zmesh]=meshgrid(1:img_size(2),1:img_size(1),1:img_size(3));
                notnan=~isnan(bkgd_img_mean);
                Xflat=Xmesh(notnan);
                Yflat=Ymesh(notnan);
                Zflat=Zmesh(notnan);
                bkgd_img_mean_flat=bkgd_img_mean(notnan);

                A=[ones(size(Xflat)),Xflat,Yflat,Zflat];
                [b,std_b] = lscov(A,bkgd_img_mean_flat);
                roi_size=size(bkgd_img);
                fit=zeros(roi_size);

                Afit=[ones(size(Xmesh(:))),Xmesh(:),Ymesh(:),Zmesh(:)];
                fit(:)=Afit*b;
                err_fit=ones(size(fit));
                err_fit = sqrt(std_b(1).^2 + (Xmesh.*std_b(2)).^2 + (Ymesh.*std_b(3)).^2 ...
                    + (Zmesh.*std_b(4)).^2);
                tsne_data.background = fit;
                tsne_data.background_err = err_fit;
            
            

        
        
%         if ~any(strcmp(varargin,'preloaded'))
                choice='';
             while ~strcmp(choice,'Yes')
                max_proj=max(mean_green_img_t,[],3);
                delete(img)                
                img=imshow(max_proj,[min(max_proj(max_proj>0)), max(max_proj(:))],'Parent',ax_foreground);
                ax_foreground.XLim=[0,size(max_proj,2)];
                ax_foreground.YLim=[0,size(max_proj,1)];
                title(ax_foreground,'Select entire ROI')
                %img.CData=(max_proj-min(max_proj(max_proj>0)))*cmapsz/...
%                     (max(max_proj(:))-min(max_proj(max_proj>0)));
                rect=keep_in_bounds(round(getrect(ax_foreground)),size(max_proj));
                
                %keep in boundss
                rect=rect([2,1,4,3]);
                for ii=1:2
                    if rect(ii)<1
                        rect(ii)=1;
                    end
                    if rect(ii)+rect(ii+2)>size(max_proj,ii)
                        rngend=size(max_proj,ii);
                    else
                        rngend=rect(ii)+rect(ii+2);
                    end
                    rng(ii,:)=[rect(ii),rngend];
                end

    
                roi=rng;
                delete(img);
                cropped_img=max_proj(rng(1,1):rng(1,2),rng(2,1):rng(2,2));
                img=imshow(cropped_img,...
                    [min(cropped_img(:)) max(cropped_img(:))],'Parent',ax_foreground);   
                ax_foreground.XLim=[0,size(cropped_img,2)];
                ax_foreground.YLim=[0,size(cropped_img,1)];
                tgroup.SelectedTab=tsne_tab;
                choice=questdlg('Use this ROI?','Confirm','Yes','Cancel','Cancel');
             end
%                 choice='Yes';
%                 rng=[1,size(aligned_green_img_full,1);...
%                     1,size(aligned_green_img_full,2)];
%                 roi=rng;
            
%         else
%             choice='Yes';
%             rng=tsne_data.roi;
%         end
                  
             
            %get indicies of full image, then get indicies of cropped
            %image, to keep track of which pixels are cropped regions, save
            %those in a different array. 
            
            cropped_max_proj = max_proj(rng(1,1):rng(1,2),rng(2,1):rng(2,2));
            tsne_data.roi=roi;
            
            if ~batch
            
                crop_green_img;
                %Img4D=tsne_data.aligned_green_img;
                %tsne_data.tsne_data.aligned_red_img=tsne_data.aligned_red_img;
               % tsne_data.aligned_green_img=aligned_green_img;

                ax_foreground.XLim=[0,size(tsne_data.aligned_green_img,2)];
                ax_foreground.YLim=[0,size(tsne_data.aligned_green_img,1)];
            
                display_movie;
                waiting=waitbar(.5,'Running PCA...');
                run_pca;
                display_foreground;
                close(waiting);
            else
                1;
                if all(size(dist)==size(tsne_data.mean_green_img_t))
                    tsne_data.dist = dist(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:);
                else
                    h = waitbar(.25,'PCA not correct, re-running -- loading file...');
                    ld = load(fullfile('.\aligned\',f_list_glob{ii_glob}),'aligned_green_img');
                    waitbar(.5,h,'PCA not correct, re-running -- running PCA');
                    
                    tsne_data.aligned_green_img = ld.aligned_green_img;
                    run_pca_batch;
                    close(h);
                    dist = tsne_data.dist;
                    tsne_data.dist = tsne_data.dist(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:);
                end
                tsne_data.aligned_green_img = mean_green_img_t(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:);
                prepare_foreground;
                S=1;
                display_movie;
                display_foreground;
                save_export_btn.String = 'Save Background and ROI';
                save_export_btn.BackgroundColor = 'r';
                bkgd_ROI_saving = 1;
                soma = questdlg('Use spatial positions when running t-SNE?','Spatial Positions','Yes','No','No');
                switch soma
                    case 'Yes'
                        tsne_data.use_space = 1;
                    case 'No'
                        tsne_data.use_space = 0;
                end
                
                msgbox('Select appropriate background threshold for movie');
                
            end
            
        
        end
    end
    function crop_green_img(varargin)
        rng=tsne_data.roi;
        cropped_idx=true(tsne_data.full_img_size);
        cropped_idx(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:,:) = false;

        tsne_data.aligned_green_img=tsne_data.aligned_green_img-repmat(tsne_data.background,1,1,1,...
            size(tsne_data.aligned_green_img,4));
        
        tsne_data.cropped_img = tsne_data.aligned_green_img(cropped_idx);
        tsne_data.aligned_green_img=tsne_data.aligned_green_img(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:,:);
        tsne_data.aligned_red_img=tsne_data.aligned_red_img(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:,:);
        tsne_data.background = tsne_data.background(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:);
        tsne_data.background_err = tsne_data.background_err(rng(1,1):rng(1,2),rng(2,1):rng(2,2),:);
            
    end
    function run_pca(varargin)
        
        pca_num=40;
        
        Img4D_list=reshape(tsne_data.aligned_green_img,...
            size(tsne_data.aligned_green_img,1)*...
            size(tsne_data.aligned_green_img,2)*...
            size(tsne_data.aligned_green_img,3),...
            size(tsne_data.aligned_green_img,4));
        nonzeros=~any(Img4D_list==0,2);
        Img4D_list_nonzero=Img4D_list(nonzeros,:);
        coeffs=zeros(size(Img4D_list,1),pca_num);
        coeffs(nonzeros,:)=pca(double(Img4D_list_nonzero)',...
            'NumComponents',pca_num);
            tsne_data.dist=reshape(sqrt(sum(coeffs.^2,2)),...
                size(tsne_data.aligned_green_img,1),...
                size(tsne_data.aligned_green_img,2),...
                size(tsne_data.aligned_green_img,3));
            min_slider=min(tsne_data.dist(:));
            max_slider=max(tsne_data.dist(:));
        inten_sld.Min = min_slider;
        inten_sld.Max = max_slider;
        
        T=min(tsne_data.dist(:));  
         foreground_img=tsne_data.dist>T;
        step=(max_slider-min_slider)/1000;
        while length(find(foreground_img))>=2000
            T=T+step;
            foreground_img=tsne_data.dist>T;
        end
        
        foreground=foreground_img;
        pca_done=1;
        
    end
    function run_pca_batch(varargin)
        pca_num=40;
        
        Img4D_list=reshape(tsne_data.aligned_green_img,...
            size(tsne_data.aligned_green_img,1)*...
            size(tsne_data.aligned_green_img,2)*...
            size(tsne_data.aligned_green_img,3),...
            size(tsne_data.aligned_green_img,4));
        nonzeros=~any(Img4D_list==0,2);
        Img4D_list_nonzero=Img4D_list(nonzeros,:);
        coeffs=zeros(size(Img4D_list,1),pca_num);
        coeffs(nonzeros,:)=pca(double(Img4D_list_nonzero)',...
            'NumComponents',pca_num);
            tsne_data.dist=reshape(sqrt(sum(coeffs.^2,2)),...
                size(tsne_data.aligned_green_img,1),...
                size(tsne_data.aligned_green_img,2),...
                size(tsne_data.aligned_green_img,3));
    end
    function prepare_foreground(varargin)
        min_slider=min(tsne_data.dist(:));
        max_slider=max(tsne_data.dist(:));
        inten_sld.Min=min_slider;
        inten_sld.Max=max_slider;
        T=min(tsne_data.dist(:));  
        foreground_img=tsne_data.dist>T;
        step=(max_slider-min_slider)/1000;
        while length(find(foreground_img))>=2000
            T=T+step;
            foreground_img=tsne_data.dist>T;
        end
        inten_sld.Value=T;
        foreground=foreground_img;
        pca_done=1;
    end
    function man_run_alignment(varargin)
        run_alignment;
        get_ROI;
    end
    function view_aligned_red_channel(varargin)
        figure;
        imshow4D_wheel(tsne_data.aligned_red_img)
    end
    function run_batch_files(varargin)
        f_list=uigetfile('*.nd2;*.h5','MultiSelect','on');         
            if iscell(f_list)
                f_list_log=uigetfile('log_*','MultiSelect','on');
                if length(f_list_log)~=length(f_list)
                    warndlg('Check Log files and Movie files!')
                else
                    for ii=1:length(f_list)
                        fname=f_list{ii};
                        fnamelog=f_list_log{ii};
                        batch=1;
                        run_everything_default;
                        batch=0;
                    end
                end
            end
              
    end

%new batch importing functions 20170524
    function batch_alignment(varargin)
         f_list=uigetfile('*.nd2;*.h5','MultiSelect','on');   
         
         %get all the log mat files in current folder
         logMatFileList = ListMatLogFiles( pwd );
         if ischar(f_list)
            f_list={f_list};
        end
         if iscell(f_list)
                %f_list_log=dir('log_*.mat');
                %f_list_log=uigetfile('log_*','MultiSelect','on');
                f_list_log = FindBatchMatLogFile(f_list, logMatFileList);
                    for ii=1:length(f_list)
                        try
                            fname=f_list{ii};
                            fnamelog=f_list_log{ii};
                            batch=1;
                            tsne_data=struct;
                            importimg;
                            display_movie;
                            run_pca_batch;
                            tsne_data.mean_green_img_t = mean(tsne_data.aligned_green_img,4);
%%
                            max_red = max(tsne_data.aligned_red_img(:));
                            min_red = min(tsne_data.aligned_red_img(:));
                            scaled_red = cast((tsne_data.aligned_red_img-min_red)*(2^16-1)/...
                                (max_red-min_red),'uint16');
                            tsne_data.scale_factor_red = (2^16-1)/(max_red-min_red);
                            tsne_data.aligned_red_img = scaled_red;
                            max_green = max(tsne_data.aligned_green_img(:));
                            min_green = min(tsne_data.aligned_green_img(:));
                            scaled_green = cast((tsne_data.aligned_green_img-min_green)*(2^16-1)/...
                                (max_green-min_green),'uint16');
                            tsne_data.scale_factor_green = (2^16-1)/(max_green-min_green);
                            tsne_data.aligned_green_img = scaled_green;
  %%                                                                                                              
                            mkdir('aligned');
                            aligned_file = fullfile('aligned',strcat(fname,'_aligned.mat'))
                            save(aligned_file,'-struct','tsne_data');
                            batch = 0;
                        catch
                            fprintf('Movie %s failed to load for some reason, check!\n',fname);
                        end
                    end
         end
    end
    function batch_ROI_foreground(varargin)
        f_list_glob = uigetfile('.\aligned\*_aligned.mat','MultiSelect','on');  
        if ischar(f_list_glob)
            f_list_glob={f_list_glob};
        end
        if iscell(f_list_glob)
            ii_glob = 1;
            ii_glob_max = length(f_list_glob);
            batch=1;
            
            increment_ii_glob;

            
        end
    end
    function increment_ii_glob(varargin)
        if ii_glob<=ii_glob_max
            fnamez = fullfile('.\aligned\',f_list_glob{ii_glob});
            tsne_data=load(fnamez,'mean_green_img_t','dist','filenames','which_side');                
            mean_green_img_t = tsne_data.mean_green_img_t;
            dist=tsne_data.dist;
            max_bkgd_proj=max(tsne_data.mean_green_img_t,[],3);
            bkgd_img = mean_green_img_t;
            Z = round(size(mean_green_img_t,3)/2); 
            get_ROI;
            
        else
            batch=0;
            msgbox('Done with backgrounds!');
        end
            
    end
    function batch_run_tsne(varargin)
        f_list = uigetfile('.\prepared\*_prepared*.mat','MultiSelect','on');  
        if ischar(f_list)
            f_list={f_list};
        end
        for ii=1:length(f_list)
            file2load = fullfile('prepared',f_list{ii});
            tsne_data=load(file2load);
            [~,fnm] = fileparts(file2load);
            prep_spot = strfind(fnm,'prepared_');
            if ~isempty(prep_spot)
                idx = fnm(prep_spot + length('prepared_'):end);
                [pth,nme] = fileparts(tsne_data.filenames{1});
                tsne_data.filenames{1} = fullfile(pth,[nme,'_',idx]);
                
                
                
            end
            
            if isa(tsne_data.aligned_green_img,'uint16')
                tsne_data.aligned_green_img = cast(tsne_data.aligned_green_img,'double')/...
                    tsne_data.scale_factor_green;
                tsne_data.aligned_red_img = cast(tsne_data.aligned_red_img,'double')/...
                    tsne_data.scale_factor_red;
               % tsne_data.cropped_img = cast(tsne_data.cropped_img,'double')/...
               %     tsne_data.scale_factor_cropped;
            end
            
            
            
            
            aligned_green_img_full = tsne_data.aligned_green_img;
            aligned_red_img_full = tsne_data.aligned_red_img;
            foreground = tsne_data.foreground;
            foreground_img = foreground;
            crop_green_img;
            Z = round(size(tsne_data.aligned_green_img,3)/2);
            S=1;
            display_movie;
            display_foreground;
            
            
            batch=1;
            if isfield(tsne_data,'use_space')
                if tsne_data.use_space
                    use_spatial_chkbox.Value = 1;
                    scale_factor_box.String = 3;
                else
                    use_spatial_chkbox.Value = 0;
                end
            %else
                %use_spatial_chkbox.Value = 0;
            end
                   
            
            
            run_everything;
            
            save_export;
        
        
            fprintf('Completed t-SNE for %s\n',tsne_data.filenames{1});
            batch=0;
        
        end 
        msgbox('Done with t-SNE and clustering!')
        
        
        
        
    end
    function run_everything_default(varargin)
        importimg;
        display_movie;
        waiting=waitbar(.5,'Running PCA...');
        run_pca;
        display_foreground;
        run_everything;
        save_export;
        
        
    end

%%  preparation figures
    function display_movie(varargin)        
        %neuronID=[];neurons2include=[];nmPeakSigTestMat=[];includeInClassifier=[];
       %ax_NID= gobjects(0);ax3D= gobjects(0);submit_button=[];ORNMenu=[];include_chkbox=[];
        delete(ax_foreground.Children)
        green_mov = tsne_data.aligned_green_img;
        Rmin = min(tsne_data.aligned_green_img(:));
        Rmax = max(tsne_data.aligned_green_img(:));
        img=imshow(tsne_data.aligned_green_img(:,:,Z,S), [Rmin Rmax],'Parent',ax_foreground);
        cmap=[0,0,0;1,1,1];
        cmap1=colormap(ax_foreground,gray(100));
        imin=double(min(green_mov(green_mov(:,:,:,1)>0)));
        imax=double(max(green_mov(:)));
        scale_factor=(size(cmap1,1)-1)/(imax-imin);
        %C1=(tsne_data.aligned_green_img-imin)
        hold(ax_foreground,'on');

        img.CDataMapping='direct';
        %img.CData=tsne_data.aligned_green_img(:,:,Z,S)*scale_factor;
        img.CData=(green_mov(:,:,Z,S)-imin)*scale_factor+1;

        cmap_full=[cmap1;cmap];
        colormap(ax_foreground,cmap_full)
        set(f_tSNE, 'WindowScrollWheelFcn', @mouseScroll);
        
        sno=size(tsne_data.aligned_green_img,4);
        zsl=size(tsne_data.aligned_green_img,3);
        %colormap(lb,cmap);
       
        if sno > 1 %if number of frames>1
            shand.Visible='on';
            shand.Min=1;
            shand.Max=sno;
            shand.Value=1;
            shand.SliderStep=[1/(sno-1) 10/(sno-1)];
            shand.Callback=@SliceSlider;
            
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
        lb=imshow(foreground(:,:,Z), [Rmin Rmax],'Parent',ax_foreground);
        lb.CDataMapping='direct';
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        [~,name]=fileparts(tsne_data.filenames{1});
        name=strrep(name,'_',' ');
        foreground_title=title(ax_foreground,sprintf('%s\nForeground has %d points',...
            name,length(find(foreground))));
        lb.AlphaData=.2;
        hold(ax_foreground,'off');
        
        
        if pca_done && ~batch
            inten_sld.Min=min_slider;
            inten_sld.Max=max_slider;
            T = min_slider;
            fgimg = tsne_data.dist>T;
            step=(max_slider-min_slider)/1000;
            while length(find(fgimg))>=length(find(tsne_data.foreground))
                T=T+step;
                fgimg=tsne_data.dist>T;
            end
            
            inten_sld.Value=T;
        end
        inten_sld.Callback=@filt_inten;
        inten_txt.String='Background Threshold';
    end
   
    

%% t-sne + clustering functions
    function run_tsne(varargin)
        if ~any(foreground_img(:)>1)
            tsne_data.foreground=foreground_img;
        end
        max_iter=str2num(num_iter_box.String);
        
        
        
       tsne_data_no_cluster=CIA_TSNE(tsne_data.aligned_green_img,tsne_data.foreground,...
           tsne_data.odor_seq,'tsne_iter',max_iter,'use_space',use_spatial_chkbox.Value,...
           'scale_factor',str2double(scale_factor_box.String));
       
       
       tsne_data=catstruct(tsne_data,tsne_data_no_cluster);
        plot(tsne_ax,tsne_data.tsne_result(:,1),...
            tsne_data.tsne_result(:,2),'.')
       tsned=1;
       tsne_data.background_level=compute_background(tsne_data.foreground,tsne_data.aligned_green_img);
    end
    function run_clustering(varargin)
        try
            close(tcourse_fig)
        end
        if tsned
            Alpha=str2num(alpha_box.String);
            k=str2num(k_box.String);
            tsne_data=CIA_LSBDC(tsne_data,tsne_data.aligned_green_img,...
                tsne_data.odor_seq,'alpha',Alpha,'k',k);
            
            tsne_data.neuronID=cellfun(@num2str,...
                num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
            
            %tsne_data.aligned_red_img=aligned_red_img;
           % tsne_data.aligned_green_img=aligned_green_img;

            tsne_data.odor_conc_inf=gen_odor_conc_inf(tsne_data.filenames{2});
%                 if ~isfield(tsne_data,'odor_inf')
%                     tsne_data.odor_inf=load('odor_inf.mat');
%                 end
            
            tsne_alpha=ones(length(unique(tsne_data.labels(tsne_data.labels>1))),1);
            clustered=1;
            update_cluster_signals;
            plot_tsne_clusters;            
            [tcourse_fig,tcourse_ax]=plot_cluster_t_course(tsne_data);
            figure(f_tSNE);
            compare_neuron_sigs;
            if ~batch                   
                msg=msgbox('Segmentation Success!');
                uiwait;
                
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
                tsne_data.labels=double(tsne_data.foreground);
            end
        unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
        num_old_no_noise_clusters=length(unique(tsne_data.labels(tsne_data.labels>1)));
        num_clusters=length(unique_clusters);
%         load('neuron_seg_colormap.mat','n_seg_cmap');
%         cmap_idx=round(linspace(1,size(n_seg_cmap,1),num_clusters-1));
%         cmap_selection=flipud([n_seg_cmap(cmap_idx,:);.7,.7,.7]);

        tsne_result_full=tsne_data.tsne_result(tsne_data.precluster_groups,:);
        title(tsne_ax,'Select points to assign to cluster')
        eval=1;
        try
            %rect=getrect_JB(tsne_ax);
            cl = imfreehand(tsne_ax,'Closed',true);
            msk = cl.getPosition;
            
        catch
            eval=0;
        end
        if eval && ~isempty(cl)
            title(tsne_ax,'t-SNE Result')
            if num_clusters>1
                asgn=choose_cluster(unique_clusters,tsne_data.cmap);
            else
                asgn=max(unique_clusters)+1;
            end
            if ~isempty(asgn)
                old_tsne_data=tsne_data;
                old_tsne_alpha=tsne_alpha;
                if strcmp(asgn,'New cluster')
                    asgn=max(unique_clusters)+1;
                end
                if strcmp(asgn,'Noise')
                    asgn=1;
                end
%                 selected_pts_x=(tsne_result_full(:,1)>rect(1)) & ...
%                     (tsne_result_full(:,1)<rect(1)+rect(3));
%                 selected_pts_y=(tsne_result_full(:,2)>rect(2)) & ...
%                     (tsne_result_full(:,2)<rect(2)+rect(4));
                selected_pts = inpolygon(tsne_result_full(:,1),tsne_result_full(:,2),msk(:,1),msk(:,2));
                foreground_labels=double(tsne_data.labels(tsne_data.foreground));
                %foreground_labels(selected_pts_x & selected_pts_y)=asgn;
                foreground_labels(selected_pts)=asgn;
                tsne_data.labels(tsne_data.foreground)=foreground_labels;
                
                unique_no_noise_clusters=unique(tsne_data.labels(tsne_data.labels>1));
                num_new_no_noise_clusters=length(unique_no_noise_clusters);
                if num_old_no_noise_clusters~=num_new_no_noise_clusters;
                    tsne_alpha=ones(num_new_no_noise_clusters,1);
                end
                for ii=1:length(unique_no_noise_clusters)
                    tsne_data.labels(tsne_data.labels==unique_no_noise_clusters(ii))=...
                        ii+1;
                end
                unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
                tsne_data.neuronID=cellfun(@num2str,...
                        num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
                tsne_data.cmap=generate_cmap(length(unique_clusters(unique_clusters>1)));
                foreground_img=tsne_data.labels+1;
                plot_tsne_clusters;
                clustered=1;
                undo_item.Enable='On';
                saved=0;
                compare_neuron_sigs;
                
            end
            delete(cl);
        end            
            
        end
    end
    function undo_cluster(varargin)
        current_tsne_data=tsne_data;
        current_tsne_alpha=tsne_alpha;
        tsne_data=old_tsne_data;
        foreground_img=tsne_data.labels+1;
        tsne_alpha=old_tsne_alpha;
        old_tsne_data=current_tsne_data;
        old_tsne_alpha=current_tsne_alpha;
        plot_tsne_clusters;
        compare_neuron_sigs;
        saved=0;
        clustered=1;
        
    end
    function draw_movie_cluster(varargin)
         unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
        num_old_no_noise_clusters=length(unique(tsne_data.labels(tsne_data.labels>1)));
        num_clusters=length(unique_clusters);
        
        cl = imfreehand(ax_foreground,'Closed',true);
        %uiwait(cl);
        if ~isempty(cl)
            msk = zeros(size(tsne_data.labels));
            msk(:,:,Z) = createMask(cl,lb);

            if num_clusters>1
                    asgn=choose_cluster(unique_clusters,tsne_data.cmap);
            else
                    asgn=max(unique_clusters)+1;
            end
            if ~isempty(asgn)
                old_tsne_data=tsne_data;
                old_tsne_alpha=tsne_alpha;
                if strcmp(asgn,'New cluster')
                    asgn=max(unique_clusters)+1;
                end
                if strcmp(asgn,'Noise')
                    asgn=1;
                end

                tsne_data.labels(tsne_data.labels>0 & msk) = asgn;
                unique_no_noise_clusters=unique(tsne_data.labels(tsne_data.labels>1));
                num_new_no_noise_clusters=length(unique_no_noise_clusters);
                if num_old_no_noise_clusters~=num_new_no_noise_clusters;
                    tsne_alpha=ones(num_new_no_noise_clusters,1);
                end
                for ii=1:length(unique_no_noise_clusters)
                    tsne_data.labels(tsne_data.labels==unique_no_noise_clusters(ii))=...
                        ii+1;
                end
                unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
                tsne_data.neuronID=cellfun(@num2str,...
                        num2cell([1:max(tsne_data.labels(:))-1]),'UniformOutput',false);
                tsne_data.cmap=generate_cmap(length(unique_clusters(unique_clusters>1)));
                foreground_img=tsne_data.labels+1;
                plot_tsne_clusters;
                clustered=1;
                undo_item.Enable='On';
                saved=0;
                compare_neuron_sigs;
            end
            delete(cl);
        end
            
    end


%% plotting and saving
    function plot_tsne_clusters(varargin)
        if tsned
            
            unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
            tsne_result_full=tsne_data.tsne_result(tsne_data.precluster_groups,:);
            cmap_full=[cmap1;1,1,1;tsne_data.cmap];
            colormap(ax_foreground,cmap_full)
            
            
            lb.CData=foreground_img(:,:,Z)+length(cmap1);
            
            for ii=1:length(unique_clusters)
                
                tsne_label_pts=unique([tsne_result_full(...
                    tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),1),...
                    tsne_result_full(tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),2)],...
                    'rows');
                
                h(ii)=scatter(tsne_ax,tsne_label_pts(:,1),tsne_label_pts(:,2),'.');
                hold(tsne_ax, 'on');
                if unique_clusters(ii)==1
                    h(ii).MarkerEdgeColor=tsne_data.cmap(1,:);
                else
                    h(ii).MarkerEdgeColor=tsne_data.cmap(unique_clusters(ii),:);
                end
                if ~isempty(tsne_alpha) && ii>1
                    h(ii).MarkerEdgeAlpha=tsne_alpha(ii-1);
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
            leg.Location = 'northeastoutside';
            
        else
            warndlg('Run t-sne first!');
        end
    end
    function compare_neuron_sigs(varargin)
            update_cluster_signals;
            erase_compare_tab;
            %compared_img2disp=;
            img_size=size(tsne_data.aligned_green_img);
            Img_yz=squeeze(max(tsne_data.aligned_green_img,[],2));
            Img_yz_full=Img_yz;            
            Img_xz=squeeze(max(tsne_data.aligned_green_img,[],1));
            Img_xz_full=Img_xz;
            Img_xy=squeeze(max(tsne_data.aligned_green_img,[],3));
            Img_xy_full=Img_xy;
            Img_max_full=max(tsne_data.aligned_green_img(:))*...
                ones(img_size(1)+img_size(3)+1,...
                img_size(2)+img_size(3)+1,img_size(4));
            Img_max_full(1:img_size(1),1:img_size(2),:) = Img_xy_full;
            Img_max_full(img_size(1)+2:end, 1:img_size(2),:) = permute(Img_xz_full,[2 1 3]);
            Img_max_full(1:img_size(1), img_size(2)+2:end,:) = Img_yz_full;
            [ax_xyz,maxinten_t_hand,maxinten_t_text]=...
                imshow4D_maxinten(tsne_data.aligned_green_img, compare_tab );
            maxinten_t_hand.Callback={@compareSlider};
            
            %ax_xyz.Children.CData=Img_max_xyz(:,:,1);
            ax_compare=gobjects(0);
            for ii=1:length(tsne_data.cluster_signals)
                ax_compare(ii)=axes('Parent',compare_tab,'Visible','off'); 
            end
            [~,ax_compare,white_bkd]=plot_cluster_t_course_no3D(tsne_data,ax_compare);
            tline_compare=gobjects(length(ax_compare),1);
            ax_compare(1).Units='pixels';
            chkposx=ax_compare(1).Position(1)-80;
            for ii=1:length(ax_compare)
                ax_compare(ii).Units='pixels';
                axpos=ax_compare(ii).Position;
               chkpos=[chkposx,axpos(2)+axpos(4)/2,...
                   20,20];
               compare_chkbox(ii)=uicontrol('Parent',compare_tab,...
                   'Style','checkbox','Units','pixels',...
                   'Position',chkpos,...
                   'Value',0,'Callback',{@change_include});
                
                
            end
            if isempty(fLeg) || ~isvalid(fLeg)                       
                fLeg=legendOnly(tsne_data.odor_conc_inf,tsne_data.odor_inf);
            end
            fLeg.Position(1:2)=[f_tSNE.Position(1)+f_tSNE.Position(3),...
                    f_tSNE.Position(2)+f_tSNE.Position(4)-fLeg.Position(4)];   
            if ~isvalid(reset_compare_btn)
                reset_compare_btn=uicontrol('Parent',compare_tab,'Style','pushbutton','String','Reset',...
                    'Callback',@reset_compare);
                reset_compare_btn.Position(1:2)=[ax_compare(1).Position(1)-60,...
                    ax_compare(1).Position(2)+ax_compare(1).Position(4)+20];
            end  
            change_include;
    end

    function reset_compare(varargin)
        for ii=1:length(ax_compare)
            compare_chkbox(ii).Value=0;
        end
        change_include;
    end

    function change_include(varargin)
        tstart=round(maxinten_t_hand.Value);
        %delete([ax_xyz,ax_xz,ax_yz,maxinten_t_hand,maxinten_t_text]);
        %=gobjects(0)
        %compared_img2disp=tsne_data.aligned_green_img;
        labels2include=find(logical([compare_chkbox(1:length(tsne_data.cluster_signals)).Value]));
        foreground_img=tsne_data.labels+1;
        if ~all(labels2include(:)==0)
            
            pnts2include=ismember(tsne_data.labels,labels2include+1);
            %pnts2include_mat=repmat(pnts2include,1,1,1,size(Img_yz,3));
            pnts2include_t=repmat(pnts2include,1,1,1,size(tsne_data.aligned_green_img,4));
            Img_full=tsne_data.aligned_green_img;
            Img_full(~pnts2include_t)=0;
            pnts2include_yz=any(pnts2include,2);
            
            Img_yz = squeeze(max(Img_full,[],2));
            Img_xz = squeeze(max(Img_full,[],1));
            Img_xy = squeeze(max(Img_full,[],3));
            Img_max_xyz=max(Img_full(:)) * ones(size(Img_full,1)+size(Img_full,3)+1,...
                size(Img_full,2)+size(Img_full,3)+1,size(Img_full,4));
            Img_max_xyz(1:size(Img_full,1),1:size(Img_full,2),:)= Img_xy;
            Img_max_xyz(size(Img_full,1)+2:end, 1:size(Img_full,2),:) = permute(Img_xz,[2 1 3]);
            Img_max_xyz(1:size(Img_full,1), size(Img_full,2)+2:end,:) = Img_yz;
%             pnts2include_mat_yz=repmat(pnts2include_yz,1,1,size(Img_yz,3));
%             pnts2include_xz=any(pnts2include,1);
%             pnts2include_mat_xz=repmat(pnts2include_xz,1,1,size(Img_yz,3));
%             pnts2include_xy=any(pnts2include,3);
%             pnts2include_mat_xy=repmat(pnts2include_xy,1,1,size(Img_yz,3));;
            
            %tic
            %compared_img2disp(~pnts2include_mat)=0;   
            %toc
            
%             Img_yz=Img_yz_full;
%             Img_yz(~pnts2include_mat_yz)=0;
%             Img_xz=Img_xz_full;
%             Img_xz(~pnts2include_mat_xz)=0;
%             Img_xy=Img_xy_full;
%             Img_xy(~pnts2include_mat_xy)=0;
            
            foreground_img(~pnts2include)=0;
            
            for ii=1:length(ax_compare)
               if compare_chkbox(ii).Value==1
                   ax_compare(ii).LineWidth=1.5;
                   tsne_alpha(ii)=1;
                   white_bkd(ii).FaceAlpha=0;
               else
                   ax_compare(ii).LineWidth=0.5;    
                   tsne_alpha(ii)=.1;
                   white_bkd(ii).FaceAlpha=0.5;
               end

            end
            
        else
            for ii=1:length(ax_compare)
                ax_compare(ii).LineWidth=0.5;  
                white_bkd(ii).FaceAlpha=0;
            end
            tsne_alpha=ones(length(ax_compare),1);
            Img_yz=Img_yz_full;
            Img_xz=Img_xz_full;
            Img_xy=Img_xy_full;
            Img_max_xyz=Img_max_full;
        end
        ax_xyz.Children.CData=Img_max_xyz(:,:,tstart);
        %ax_xz.Children.CData=Img_xz(:,:,tstart)';
        %ax_yz.Children.CData=Img_yz(:,:,tstart);
        
%         [ax_xyz,ax_xz,ax_yz,maxinten_t_hand,...
%             maxinten_t_text]=...
%                 imshow4D_maxinten(compared_img2disp, compare_tab ,tstart);
       	%maxinten_t_hand.Callback={@compareSlider};
        
        plot_tsne_clusters;
        
    end
    function update_cluster_signals(varargin)
        if clustered
            %delete_figs;
%             try
%                 close(tcourse_fig);
%                 close(peak_sig_fig);
%             end
            tsne_data=calculate_cluster_signals(tsne_data,tsne_data.aligned_green_img,tsne_data.odor_seq);
%             odor_inf.odor_list=tsne_data.odor_inf.odor_list;
%             odor_inf.odor_concentration_list=tsne_data.odor_inf.odor_concentration_list;
            [~,nm_sig,nmPeakSig,...
                s2n_mat,s2n_peak_mat,neuron_fire,neuron_fire_mat]=...
                 calc_nm_sig(tsne_data.odor_seq,tsne_data.cluster_signals,tsne_data.odor_inf);

             tsne_data.nmPeakSigMat=nmPeakSig;
             tsne_data.nmSigMat=nm_sig;
             compareable=1;
        else
            warndlg('Cluster first!')
        end
             
    end
    function plot_signals(varargin)
            update_cluster_signals;
            try
               close(tcourse_fig); 
            end
            [tcourse_fig,tcourse_ax]=plot_cluster_t_course(tsne_data);         
            
             [~,name]=fileparts(filename);
             name=strrep(name,'_',' ');
             assignin('base','tsne_data','tsne_data');
%              [~,~,fire,peak_sig_fig]=dispNeuronSignals(nmPeakSig,...
%                 tsne_data.odor_inf,neuron_fire_mat,name,tsne_data.neuronID);
       
        
    end
    function makemovie(varargin)
        mov=animate_3d_stuff2(tsne_data);
    end
    function save_export(varargin)
        if ~bkgd_ROI_saving %different mode for saving background only (when doing batch things)
            %tsne_data.aligned_red_img=aligned_red_img;
            %tsne_data.aligned_green_img=aligned_green_img;
            tsne_data.nmPeakSigMat=nmPeakSig;
            tsne_data.nmSigMat=nm_sig;
%             if ~isempty(roi)
%                 tsne_data.roi=roi;
%             end
            

            
            [tsne_data.neuron_CoM,tsne_data.neuron_var]=calcNeuronPositions(tsne_data);
            filename = tsne_data.filenames{1};
            if ~batch
            [fig_name,pname]=uiputfile('*.fig','Enter figure 1 name',strcat(filename,'_tsne_result.fig'));
            %[fig_name2,pname]=uiputfile('*.fig','Enter figure 2 name',strcat(filename,'_nm_sigs.fig'));
            else
                pname=pwd;
                fig_name=strcat(filename,'_tsne_result.fig');
               % fig_name2=strcat(filename,'_nm_sigs.fig');
            end

            if fig_name~=0
                try
                    savefig(tcourse_fig,fullfile(pname,fig_name));
                    %savefig(peak_sig_fig,fullfile(pname,fig_name2));
                catch
                    if ~batch
                        msgbox('Could Not Save Figure Successfully');
                    end
                end
                max_red = max(tsne_data.aligned_red_img(:));
                min_red = min(tsne_data.aligned_red_img(:));
                scaled_red = cast((tsne_data.aligned_red_img-min_red)*(2^16-1)/(max_red-min_red),'uint16');
                tsne_data.scale_factor_red = (2^16-1)/(max_red-min_red);
                tsne_data.aligned_red_img = scaled_red;
                max_green = max([tsne_data.aligned_green_img(:);tsne_data.cropped_img(:)]);
                min_green = min([tsne_data.aligned_green_img(:);tsne_data.cropped_img(:)]);
                tsne_data.scale_factor_green = (2^16-1)/(max_green-min_green);
                scaled_green = cast((tsne_data.aligned_green_img-min_green)*...
                    tsne_data.scale_factor_green,'uint16');
                
                tsne_data.aligned_green_img = scaled_green;
                %min_cropped = min(tsne_data.cropped_img);
                %max_cropped = max(tsne_data.cropped_img);
                %tsne_data.scale_factor_cropped = (2^16-1)/(max_cropped-min_cropped);
                tsne_data.cropped_img = cast((tsne_data.cropped_img-min_green)*...
                    tsne_data.scale_factor_green,'uint16');
                save(strcat(filename,'_tsne_data.mat'),'-struct','tsne_data');
                saved=1;
                tsne_data.aligned_green_img = cast(tsne_data.aligned_green_img,'double')/...
                    tsne_data.scale_factor_green;
                 tsne_data.aligned_red_img = cast(tsne_data.aligned_red_img,'double')/...
                    tsne_data.scale_factor_red;
                tsne_data.cropped_img = cast(tsne_data.cropped_img,'double')/...
                    tsne_data.scale_factor_green;
                if ~batch
                    sv=msgbox('Data Saved!');            
                    uiwait(sv);
                end

            end
        else %means we are in batch mode and saving the ROI and forground pixels.
            more_roi = questdlg('Want to select another ROI?','Save more ROIs','Yes','No','No');
            
            tsne_data.foreground = foreground_img;
            save_export_btn.String = 'Saving...';
            save_export_btn.BackgroundColor = [0.94,0.94,0.94];
            switch more_roi
                case 'Yes'
                if isempty(batch_fname_idx)
                    batch_fname_idx=0;
                end
                batch_fname_idx= batch_fname_idx+1;
                    
                filenamez = strcat(tsne_data.filenames{1},'_prepared_',num2str(batch_fname_idx),'.mat');
                case 'No'
                    if isempty(batch_fname_idx)                        
                        filenamez = strcat(tsne_data.filenames{1},'_prepared.mat');
                    else
                        batch_fname_idx= batch_fname_idx+1;                    
                        filenamez = strcat(tsne_data.filenames{1},'_prepared_',num2str(batch_fname_idx),'.mat');
                        batch_fname_idx=[];
                    end
            end
             mkdir('prepared');
             [filedir,name]= fileparts(strcat(tsne_data.filenames{1},'_aligned.mat'));
            aligned_file = fullfile(filedir,'aligned',[name,'.mat']); 
             [filedir,name]= fileparts(filenamez);
            prepared_file = fullfile(filedir,'prepared',[name,'.mat']);
           switch more_roi
               case 'Yes'
                   copyfile(aligned_file,prepared_file);
               case 'No'
                   movefile(aligned_file,prepared_file);
           end
           
           
           bkgd_ROI_saving = 0;
            save(prepared_file,'-struct','tsne_data',...
                'dist','background','background_err','foreground','roi',...
                'use_space','-append');
            %restore button;
           save_export_btn.String = 'Save to file...'; 
           if strcmp(more_roi,'Yes')     
                get_ROI;
           else
           
            ii_glob = ii_glob+1;
            increment_ii_glob;
           end
            
        end        
    end
    function soma_responses(varargin)
        
        disp_soma_response(tsne_data.odor_conc_inf)
    end
    function plot_avg_full_green(varargin)
       
         if can_time_slide
%              figure;imshow3D(mean(recreate_full_img(tsne_data.aligned_green_img,...
%           tsne_data.cropped_img,tsne_data.full_img_size,tsne_data.roi),4));
            can_time_slide = 0;
            green_mov = mean(tsne_data.aligned_green_img,4);
            
            S = 1;
            imin=double(min(green_mov(green_mov(:,:,:,1)>0)));
            imax=double(max(green_mov(:)));
            scale_factor=(size(cmap1,1)-1)/(imax-imin);
            img.CData=(green_mov(:,:,Z,S)-imin)*scale_factor+1;
            shand.Visible = 'off';
         else
             green_mov = tsne_data.aligned_green_img;
             imin=double(min(green_mov(green_mov(:,:,:,1)>0)));
            imax=double(max(green_mov(:)));
            scale_factor=(size(cmap1,1)-1)/(imax-imin);
             
             shand.Visible = 'on';
             S = round(shand.Value);
             img.CData=(green_mov(:,:,Z,S)-imin)*scale_factor+1;
             can_time_slide = 1;
         end
         
         
    end
    function plot_avg_full_green_pop_out(varargin)
       
         
              figure;imshow3D(mean(recreate_full_img(tsne_data.aligned_green_img,...
           tsne_data.cropped_img,tsne_data.full_img_size,tsne_data.roi),4));
         
         
    end

%% classifier functions
    function idNeurons(varargin)
        nmPeakSigTestMat=[];
        odors2exclude_idx=fliplr(selectTestOdorSet(tsne_data.odor_seq,tsne_data.odor_inf));
        ORNs2use=selectTestORNbasis;
        tsne_data=calculate_cluster_signals(tsne_data,tsne_data.aligned_green_img,tsne_data.odor_seq);
        [~,tsne_data.nmSigMat,tsne_data.nmPeakSigMat]=...
             calc_nm_sig(tsne_data.odor_seq,tsne_data.cluster_signals,tsne_data.odor_inf);
        
        odors2exclude(:,1)=tsne_data.odor_inf.odor_concentration_list...
            (odors2exclude_idx(:,1));
        odors2exclude(:,2)=tsne_data.odor_inf.odor_list(odors2exclude_idx(:,2));
        
        %if ~isempty(odors2exclude_idx) && ~isempty(ORNs2use)
            %w=waitbar(0,'Predicting...');
            [prediction,nmPeakSigTestMat]=predictNeurons(...
                tsne_data.nmPeakSigMat,odors2exclude,ORNs2use,tsne_data.odor_inf);
            tsne_data.neuronID=prediction;
            foreground_img=tsne_data.labels+1;
            plot_tsne_clusters;
%             try
%                 close(tcourse_fig);
%                 close(peak_sig_fig);
%             end
         

            plot_signals_w_labels;
            

            [~,~,peak_sig_fig]=dispNeuronSignals(tsne_data.nmPeakSigMat,...
                tsne_data.odor_inf,[],tsne_data.filenames{1},tsne_data.neuronID);
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
            add2TrainingDataset(nmPeakSigNew,filenameNew,labelsNew,find(include),...
                tsne_data.odor_inf);
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
