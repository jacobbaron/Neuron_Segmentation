function  FindBkd4Alignment(Img4D,pca_num)
%IMSHOW3D displays 3D grayscale images in slice by slice fashion with mouse
%based slice browsing and window and level adjustment control.
%
% Usage:
% imshow3D ( Image )
% imshow3D ( Image , [] )
% imshow3D ( Image , [LOW HIGH] )
%   
%    Image:      3D image MxNxK (K slices of MxN images) 
%    [LOW HIGH]: display range that controls the display intensity range of
%                a grayscale image (default: the widest available range)
%
% Use the scroll bar or mouse scroll wheel to switch between slices. To
% adjust window and level values keep the mouse right button pressed and
% drag the mouse up and down (for level adjustment) or right and left (for
% window adjustment). 
% 
% "Auto W/L" button adjust the window and level automatically 
%
% While "Fine Tune" check box is checked the window/level adjustment gets
% 16 times less sensitive to mouse movement, to make it easier to control
% display intensity rang.
%
% Note: The sensitivity of mouse based window and level adjustment is set
% based on the user defined display intensity range; the wider the range
% the more sensitivity to mouse drag.
% 
% 
%   Example
%   --------
%       % Display an image (MRI example)
%       load mri 
%       Image = squeeze(D); 
%       figure, 
%       imshow3D(Image) 
%
%       % Display the image, adjust the display range
%       figure,
%       imshow3D(Image,[20 100]);
%
%   See also IMSHOW.

%
% - Maysam Shahedi (mshahedi@gmail.com)
% - Released: 1.0.0   Date: 2013/04/15
% - Revision: 1.1.0   Date: 2013/04/19
% 

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

SFntSz = 9;
LFntSz = 10;
WFntSz = 10;
LVFntSz = 9;
WVFntSz = 9;
BtnSz = 10;
ChBxSz = 10;

if (nargin < 4)
    [Rmin Rmax] = WL2R(Win, LevV);
elseif numel(disprange) == 0
    [Rmin Rmax] = WL2R(Win, LevV);
else
    LevV = (double(disprange(2)) + double(disprange(1))) / 2;
    Win = double(disprange(2)) - double(disprange(1));
    WLAdjCoe = (Win + 1)/1024;
    [Rmin Rmax] = WL2R(Win, LevV);
end
cmap=[0,0,0;1,1,1];
load('green_colormap.mat','green_colormap')
cmap1=green_colormap;
imin=min(Img4D(Img4D(:,:,:,1)>0));
imax=max(Img4D(:));
C1=(Img4D-imin)*(size(cmap1,1)-1)/(imax-imin)+1;
%% 
if nargin==1
    pca_num=40;
end
Img4D_list=reshape(Img4D,size(Img4D,1)*size(Img4D,2)*size(Img4D,3),size(Img4D,4));
Img4D_list_nonzero=Img4D_list(~any(Img4D_list==0,2),:);
coeffs=zeros(size(Img4D_list,1),pca_num);
coeffs(~any(Img4D_list==0,2),:)=pca(Img4D_list_nonzero',...
    'NumComponents',pca_num);
    dist=reshape(sqrt(sum(coeffs.^2,2)),size(Img4D,1),size(Img4D,2),size(Img4D,3));
    min_slider=min(dist(:));
    max_slider=max(dist(:));
    
f=figure;    
  
%T=determine_background(max(Img4D,[],4));%(max(Img4D(:))-min(Img4D(:)))/2+min(Img4D(:));
T=(max_slider-min_slider)/2+min_slider;

hist=histogram(dist(:),'Normalization','Probability');
[~,max_idx]=max(hist.Values(2:end));
peak_dist=hist.BinEdges(max_idx);
hist_ax=gca;
hist_ax.YScale='log';
hold on;
h_T=plot(ones(10,1)*T,linspace(hist_ax.YLim(1),hist_ax.YLim(2),10));
[nearest_edge, nearest_edge_idx]=min(abs(T-hist.BinEdges));
frac_of_max=hist.Data(nearest_edge_idx)/max(hist.Values);
hist_title=title(sprintf('Threshold = %f, %f of max',T,frac_of_max));
%% 

foreground=dist>T;

figure
ax=axes('position',[0,0.2,1,0.8]);
img=imshow(Img4D(:,:,Z,S), [Rmin Rmax]);
hold on;

img.CDataMapping='direct';
img.CData=C1(:,:,Z,S);

cmap_full=[cmap1;cmap];
colormap(ax,cmap_full)

lb=imshow(foreground(:,:,Z), [Rmin Rmax]);
lb.CDataMapping='direct';
lb.CData=foreground(:,:,Z)+length(cmap1);

lb.AlphaData=.2;
%colormap(lb,cmap);


%% 
FigPos = get(gcf,'Position');
S_Pos = [50 45 uint16(FigPos(3)-100)+1 20];
Z_Pos = [50 45 uint16(FigPos(3)-100)+1 20];
Stxt_Pos = [35 65 (uint16(FigPos(3)-100)+1)/2 15];
Ztxt_Pos = [250 65 (uint16(FigPos(3)-100)+1)/2 15];
Wtxt_Pos = [50 20 60 20];
Wval_Pos = [110 20 60 20];
Ltxt_Pos = [175 20 45 20];
Lval_Pos = [220 20 60 20];
BtnStPnt = uint16(FigPos(3)-250)+1;
savepos= [450 100 100 30];
T_slider_pos=[450 150 20 250];
if BtnStPnt < 300
    BtnStPnt = 300;
end
Btn_Pos = [BtnStPnt 20 100 20];
ChBx_Pos = [BtnStPnt+110 20 100 20];

if sno > 1
    shand = uicontrol('Style', 'slider','Min',1,'Max',sno,'Value',S,'SliderStep',[1/(sno-1) 10/(sno-1)],'Position', S_Pos,'Callback', {@SliceSlider, Img4D});
    stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,'String',sprintf('t volume %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
else
    stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,'String','2D image', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
end    
 if zsl>1
%     zhand = uicontrol('Style', 'slider','Min',1,'Max',zsl,'Value',Z,'SliderStep',[1/(zsl-1) 10/(zsl1)],'Position', Z_Pos,'Callback', {@ZSlider, Img4D});
     ztxthand = uicontrol('Style', 'text','Position', Ztxt_Pos,'String',sprintf('Z Slice# %d / %d',Z, zsl), 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
else
     ztxthand = uicontrol('Style', 'text','Position', Ztxt_Pos,'String','2D image', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
 end
ltxthand = uicontrol('Style', 'text','Position', Ltxt_Pos,'String','Level: ', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', LFntSz);
wtxthand = uicontrol('Style', 'text','Position', Wtxt_Pos,'String','Window: ', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', WFntSz);
lvalhand = uicontrol('Style', 'edit','Position', Lval_Pos,'String',sprintf('%6.0f',LevV), 'BackgroundColor', [1 1 1], 'FontSize', LVFntSz,'Callback', @WinLevChanged);
wvalhand = uicontrol('Style', 'edit','Position', Wval_Pos,'String',sprintf('%6.0f',Win), 'BackgroundColor', [1 1 1], 'FontSize', WVFntSz,'Callback', @WinLevChanged);
Btnhand = uicontrol('Style', 'pushbutton','Position', Btn_Pos,'String','Auto W/L', 'FontSize', BtnSz, 'Callback' , @AutoAdjust);
ChBxhand = uicontrol('Style', 'checkbox','Position', ChBx_Pos,'String','Fine Tune', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', ChBxSz);
inten_sld=uicontrol('Style','slider','Min',min_slider,'Max',max_slider,...
    'Value',T,...
    'Position',T_slider_pos,'Callback',@filt_inten);
save_button=uicontrol('Style','pushbutton','Position',savepos,...
    'String',sprintf('Save Foreground\n and run t-SNE!'),'FontSize', BtnSz, 'Callback' , {@save_foreground});

set (gcf, 'WindowScrollWheelFcn', @mouseScroll);
set (gcf, 'ButtonDownFcn', @mouseClick);
set(get(gca,'Children'),'ButtonDownFcn', @mouseClick);
set(gcf,'WindowButtonUpFcn', @mouseRelease)
set(gcf,'ResizeFcn', @figureResized)
    function filt_inten(hObj,event)
        T= get(hObj, 'Value');
        foreground=dist>T;
        lb.CData=foreground(:,:,Z)+length(cmap1);
        h_T.XData=ones(10,1)*T;
        [nearest_edge, nearest_edge_idx]=min(abs(T-hist.BinEdges));
        frac_of_max=hist.Values(nearest_edge_idx)/max(hist.Values);
        hist_title.String=sprintf('Threshold = %f, %f of max',T,frac_of_max);
    end

% -=< Figure resize callback function >=-
    function figureResized(object, eventdata)
        FigPos = get(gcf,'Position');
        S_Pos = [50 45 uint16(FigPos(3)-100)+1 20];
        Stxt_Pos = [50 65 uint16(FigPos(3)-100)+1 15];
        BtnStPnt = uint16(FigPos(3)-250)+1;
        if BtnStPnt < 300
            BtnStPnt = 300;
        end
        Btn_Pos = [BtnStPnt 20 100 20];
        ChBx_Pos = [BtnStPnt+110 20 100 20];
        if sno > 1
            set(shand,'Position', S_Pos);
        end
        set(stxthand,'Position', Stxt_Pos);
        set(ltxthand,'Position', Ltxt_Pos);
        set(wtxthand,'Position', Wtxt_Pos);
        set(lvalhand,'Position', Lval_Pos);
        set(wvalhand,'Position', Wval_Pos);
        set(Btnhand,'Position', Btn_Pos);
        set(ChBxhand,'Position', ChBx_Pos);
    end

% -=< Slice slider callback function >=-
    function SliceSlider (hObj,event, Img4D)
        S = round(get(hObj,'Value'));
        img.CData=C1(:,:,Z,S);
        caxis([Rmin Rmax])
        if sno > 1
            set(stxthand, 'String', sprintf('t volume %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
    end

% % -=< Slice slider callback function >=-
%     function ZSlider (hObj,event, Img4D)
%         Z = round(get(hObj,'Value'));
%         set(get(gca,'children'),'cdata',Img4D(:,:,Z,S))
%         caxis([Rmin Rmax])
%         if sno > 1
%             set(ztxthand, 'String', sprintf('Slice# %d / %d',Z, zsl));
%         else
%             set(ztxthand, 'String', '2D image');
%         end
%     end


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
        lb.CData=foreground(:,:,Z)+length(cmap1);
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
        assignin('base','foreground',foreground);
        close all;
        imshow3D(foreground);
    end



end
% -=< Maysam Shahedi (mshahedi@gmail.com), April 19, 2013>=-