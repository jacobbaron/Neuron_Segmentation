function  tsne_gui()
%

%% Initialize a bunch of globals
Img4D=[];
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
forground_title=[];
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
image_times=[];
tsne_data=[];
filename=[];
tcourse_fig=[];
foreground_title=[];
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
    'Name','t-SNE for Neuron Clustering','ToolBar','none','MenuBar','none');

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


import_img_pos=[10,70,200,50];
import_data_pos=[10,10,200,50];
btn_space=10;
run_clustering_pos=[run_tsne_pos(1)+run_tsne_pos(3)+btn_space,...
    run_tsne_pos(2),run_tsne_pos(3:4)];     
run_everything_pos=[run_clustering_pos(1)+run_clustering_pos(3)+btn_space,...
    run_tsne_pos(2),run_tsne_pos(3:4)];
save_export_pos=[run_everything_pos(1)+run_everything_pos(3)+btn_space,...
    run_tsne_pos(2:4)];
import_img_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',import_img_pos,...
    'String',sprintf('Select video data .mat file'),...
    'FontSize', BtnSz, ...
    'Callback' , {@importimg});     
import_data_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',import_data_pos,...
    'String',sprintf('Select t-SNE data .mat file'),...
    'FontSize', BtnSz, ...
    'Callback' , {@importdata});
run_tsne_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',run_tsne_pos,...
    'String',sprintf('Run t-SNE Only!'),...
    'FontSize', BtnSz, ...
    'Callback' , {@run_tsne,tsne_data_no_cluster});
run_clustering_btn=uicontrol(...
    'Style','pushbutton',...
    'Position',run_clustering_pos,...
    'String',sprintf('Run Clustering Only!'),...
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
    'Callback' , {@save_export});

set (gcf, 'WindowScrollWheelFcn', @mouseScroll);
set (gcf, 'ButtonDownFcn', @mouseClick);
set(get(gca,'Children'),'ButtonDownFcn', @mouseClick);
set(gcf,'WindowButtonUpFcn', @mouseRelease)
%set(gcf,'ResizeFcn', @figureResized)

%% t-SNE Tab
    
   % ax_cluster_plots=axes('Parent',tsne_tab,'Units','normalized','position',[.1, .05,.8,.9]);
    

%% functions!

    function filt_inten(hObj,event)
        cmap_full=[cmap1;cmap];
        colormap(ax_foreground,cmap_full)
        T= get(hObj, 'Value');
        foreground_img=dist>T;
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        foreground=foreground_img;
        [~,name,~] = fileparts(filename) ;
        name=strrep(name,'_',' ');
        foreground_title.String=sprintf('%s\nForeground has %d points',...
            name,length(find(foreground)));
    end
% -=< Slice slider callback function >=-
    function SliceSlider (hObj,event, Img4D)
        S = round(get(hObj,'Value'));
        img.CData=C1(:,:,Z,S);
        caxis([Rmin Rmax])
        if sno > 1
            set(stxthand, 'String', sprintf('t step %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
    end

    function Slider3D(hObj,event,txt)
        z = round(get(hObj,'Value'));
        img_foreground.CData=foreground(:,:,z);
        if zsl > 1
            set(txt, 'String', sprintf('z slice %d / %d',z, zsl));
        else
            set(txt, 'String', '2D image');
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
    end

% -=< Mouse button released callback function >=-
    function mouseRelease (object,eventdata)
        set(gcf, 'WindowButtonMotionFcn', '')
    end

% -=< Mouse click callback function >=-
    function mouseClick (object, eventdata)
        MouseStat = get(gcbf, 'SelectionType');
        if (MouseStat(1) == 'a')        %   RIGHT CLICK
            InitialCoord = get(0,'PointerLocation');
            set(gcf, 'WindowButtonMotionFcn', @WinLevAdj);
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

% -=< Window and level text adjustment >=-
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

    function val=val_changed(varargin)
        eventdata=varargin{2};
        val=str2num(eventdata.Source.String);
    end
    function run_tsne(varargin)
        max_iter=str2num(num_iter_box.String);
       tsne_data_no_cluster=CIA_TSNE(aligned_green_img,foreground,...
           odor_seq,'tsne_iter',max_iter);
        plot(tsne_ax,tsne_data_no_cluster.tsne_result(:,1),...
            tsne_data_no_cluster.tsne_result(:,2),'.')
       
       
    end
    function run_clustering(varargin)
        
        if ~isempty(tsne_data_no_cluster)
            if size(tsne_data_no_cluster.foreground)==...
                    size(aligned_green_img(:,:,:,1))
                alpha=str2num(alpha_box.String);
                k=str2num(k_box.String);
                tsne_data=CIA_LSBDC(tsne_data_no_cluster,aligned_green_img,...
                    odor_seq,'alpha',alpha,'k',k);

                cmap_full=[cmap1;tsne_data.cmap];
                colormap(ax_foreground,cmap_full)

                foreground_img=tsne_data.labels+1;
                lb.CData=foreground_img(:,:,Z)+length(cmap1);
                unique_clusters=unique(tsne_data.labels(tsne_data.labels>0));
                tsne_result_full=tsne_data.tsne_result(tsne_data.precluster_groups,:);
                clustering_bar=waitbar(0,'Plotting result...');
                for ii=1:length(unique_clusters)

                    h(ii)=plot(tsne_ax,tsne_result_full(tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),1),...
                        tsne_result_full(tsne_data.labels(tsne_data.labels>0)==unique_clusters(ii),2),'.');
                    hold(tsne_ax, 'on');
                    h(ii).MarkerEdgeColor=tsne_data.cmap(ii+1,:);
                    waitbar(ii/length(unique_clusters),clustering_bar);
                end
                hold(tsne_ax,'off');
                close(clustering_bar);
                tcourse_fig=plot_cluster_t_course(image_times,tsne_data.cluster_signals,...
                    odor_seq,aligned_red_img,tsne_data.labels);
                msgbox('Segmentation Success!');
            else
                warndlg(sprintf('Run t-SNE or import data before running clustering'));
            end
        else
            warndlg(sprintf('Run t-SNE or import data before running clustering'));
        end
    end
    function importdata(varargin)
       
        fname=uigetfile('*tsne_data.mat','Choose t-SNE data .mat file');
        if ~isempty(fname)
           ld=load(fname);
           try
               new_tsne_data=ld.tsne_data;
               if size(new_tsne_data.foreground)==size(aligned_red_img(:,:,:,1))
                   tsne_data_no_cluster=new_tsne_data;
                   plot(tsne_ax,tsne_data_no_cluster.tsne_result(:,1),...
                          tsne_data_no_cluster.tsne_result(:,2),'.')
               else
                   warndlg(sprintf('Looks like data from the wrong movie.\nTry again!'));
               end
           catch
               warndlg(sprintf('No t-SNE data found! \nTry again.'));
           end

        end

    end
    function importimg(varargin)
        fname=uigetfile('*.mat');
        if fname~=0
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

        lb=imshow(foreground_img(:,:,Z), [Rmin Rmax],'Parent',ax_foreground);
        lb.CDataMapping='direct';
        lb.CData=foreground_img(:,:,Z)+length(cmap1);
        [~,name]=fileparts(filename);
        name=strrep(name,'_',' ');
        foreground_title=title(ax_foreground,sprintf('%s\nForeground has %d points',...
            name,length(find(foreground))));
        lb.AlphaData=.2;
        %colormap(lb,cmap);
        hold(ax_foreground,'off');
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
        
        inten_sld.Min=min_slider;
        inten_sld.Max=max_slider;
        inten_sld.Value=T;
        inten_sld.Callback=@filt_inten;
        inten_txt.String='Background Threshold';
    end

    function save_export(varargin)
        
        [fname,pname]=uiputfile('*.fig','Enter figure name',strcat(filename,'_tsne_result.fig'));
        if fname~=0
            savefig(tcourse_fig,fullfile(pname,fname));
            save(strcat(filename,'_tsne_data.mat'),'tsne_data')
            msgbox('Data Saved!');
        end
        
        
    end

end
% -=< Maysam Shahedi (mshahedi@gmail.com), April 19, 2013>=-