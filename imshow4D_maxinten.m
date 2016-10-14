function  [ax_xy,ax_xz,ax_yz,shand]=imshow4D_maxinten( Img, f ,S)
%Img=cropZeros(Img);
% f=figure;
% %f.Position(2)=(f.Position(2)-150;
% f.Position(3)=f.Position(3)*2;
% f.Position(4)=f.Position(4)*1.25;
f.Units='pixels';
sno = size(Img,4);  % number of slices
if nargin<3
    S = 1;
end



MinV = 0;
MaxV = max(Img(:));
LevV = (double( MaxV) + double(MinV)) / 2;
Win = double(MaxV) - double(MinV);
WLAdjCoe = (Win + 1)/1024;
FineTuneC = [1 1/16];    % Regular/Fine-tune mode coefficients
%% 

if isa(Img,'uint8')
    MaxV = uint8(Inf);
    MinV = uint8(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'uint16')
    MaxV = uint16(Inf);
    MinV = uint16(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'uint32')
    MaxV = uint32(Inf);
    MinV = uint32(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'uint64')
    MaxV = uint64(Inf);
    MinV = uint64(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'int8')
    MaxV = int8(Inf);
    MinV = int8(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'int16')
    MaxV = int16(Inf);
    MinV = int16(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'int32')
    MaxV = int32(Inf);
    MinV = int32(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'int64')
    MaxV = int64(Inf);
    MinV = int64(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    WLAdjCoe = (Win + 1)/1024;
elseif isa(Img,'logical')
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


fWidth=f.Position(3)/2.5;
fHeight=f.Position(4);
xsize=size(Img,2);
ysize=size(Img,1);
zsize=size(Img,3);
Img_yz=squeeze(max(Img,[],2));
Img_xz=squeeze(max(Img,[],1));
Img_xy=squeeze(max(Img,[],3));
y2x=ysize/xsize;
z2y=zsize/ysize;
z2x=zsize/xsize;

tot_height=.8*fHeight;
img_space=.05*fHeight;
img_height=tot_height-img_space;
img_width=.8*fWidth;

if y2x<=1 %determin width first
    xy_w=xsize/(xsize+zsize)*img_width;
    yz_w=zsize/(xsize+zsize)*img_width;
    xz_w=xy_w;
    
    xy_h=xy_w*y2x;
    yz_h=xy_h;
    xz_h=yz_w;
       
else
    xy_h=ysize/(ysize+zsize)*img_height;
    xz_h=zsize/(ysize+zsize)*img_height;
    yz_h=xy_h;
    
    xy_w=xy_h/y2x;
    yz_w=xz_h;
    xz_w=xy_w;
end

not_buttons_height=xy_h+xz_h+img_space;
not_buttons_width=xy_w+yz_w+img_space;
xmargin=(fWidth-not_buttons_width)/2;
xy_pos=[xmargin,fHeight-not_buttons_height+img_space+xz_h,xy_w,xy_h];
xz_pos=[xmargin,fHeight-not_buttons_height,xz_w,xz_h];
yz_pos=[xy_pos(1)+xy_pos(3)+img_space,...
    xy_pos(2),yz_w,yz_h];
Imin=min(Img(:));
Imax=max(Img(:));
%xz_pos=[0,
ax_xy=axes(f,'units','pixels','position',xy_pos); imshow(Img_xy(:,:,S),[Imin,Imax]);
ax_xy.XTickLabel='';
ax_xy.YTickLabel='';
%x_pos=ax_xy.Position(2)-ax_xy.Position(4)*y2z;
%y_pos=ax_xy.Position(1)+ax_xy.Position(3);
%xz_pos=[
ax_xz=axes(f,'units','pixels','position',xz_pos); imagesc(Img_xz(:,:,S)',[Imin,Imax]);
ax_xz.XTickLabel='';
ax_xz.YTickLabel='';
ax_yz=axes(f,'units','pixels','position',yz_pos); imagesc(Img_yz(:,:,S),[Imin,Imax]);
ax_yz.XTickLabel='';
ax_yz.YTickLabel='';
colormap gray
FigPos=f.Position;
FigPos(3)=fWidth;
S_Pos = [50 45 uint16(FigPos(3)-100)+1 20];
Stxt_Pos = [50 65 uint16(FigPos(3)-100)+1 15];
Wtxt_Pos = [50 20 60 20];
Wval_Pos = [110 20 60 20];
Ltxt_Pos = [175 20 45 20];
Lval_Pos = [220 20 60 20];
BtnStPnt = uint16(FigPos(3)-250)+1;
if BtnStPnt < 300
    BtnStPnt = 300;
end
Btn_Pos = [BtnStPnt 20 100 20];
ChBx_Pos = [BtnStPnt+110 20 100 20];

if sno > 1
    shand = uicontrol('Parent',f,'Style', 'slider','Min',1,'Max',sno,'Value',S,'SliderStep',[1/(sno-1) 10/(sno-1)],'Position', S_Pos,'Callback', {@SliceSlider});
    stxthand = uicontrol('Parent',f,'Style', 'text','Position', Stxt_Pos,'String',sprintf('Slice# %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
else
    stxthand = uicontrol('Parent',f,'Style', 'text','Position', Stxt_Pos,'String','2D image', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
end    
%ltxthand = uicontrol('Style', 'text','Position', Ltxt_Pos,'String','Level: ', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', LFntSz);
%wtxthand = uicontrol('Style', 'text','Position', Wtxt_Pos,'String','Window: ', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', WFntSz);
%lvalhand = uicontrol('Style', 'edit','Position', Lval_Pos,'String',sprintf('%6.0f',LevV), 'BackgroundColor', [1 1 1], 'FontSize', LVFntSz,'Callback', @WinLevChanged);
%wvalhand = uicontrol('Style', 'edit','Position', Wval_Pos,'String',sprintf('%6.0f',Win), 'BackgroundColor', [1 1 1], 'FontSize', WVFntSz,'Callback', @WinLevChanged);
%Btnhand = uicontrol('Style', 'pushbutton','Position', Btn_Pos,'String','Auto W/L', 'FontSize', BtnSz, 'Callback' , @AutoAdjust);
%ChBxhand = uicontrol('Style', 'checkbox','Position', ChBx_Pos,'String','Fine Tune', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', ChBxSz);

%set (gcf, 'WindowScrollWheelFcn', @mouseScroll);
% set (gcf, 'ButtonDownFcn', @mouseClick);
% set(get(ax_xy,'Children'),'ButtonDownFcn', @mouseClick);
% set(get(ax_xz,'Children'),'ButtonDownFcn', @mouseClick);
% set(get(ax_yz,'Children'),'ButtonDownFcn', @mouseClick);





% -=< Slice slider callback function >=-
    function SliceSlider (hObj,event)
        S = round(get(hObj,'Value'));
        set(get(ax_xy,'children'),'cdata',Img_xy(:,:,S))
        set(get(ax_yz,'children'),'cdata',Img_yz(:,:,S))
        set(get(ax_xz,'children'),'cdata',Img_xz(:,:,S)')
        if sno > 1
            set(stxthand, 'String', sprintf('Slice# %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
    end

% -=< Mouse scroll wheel callback function >=-
%     function mouseScroll (object, eventdata)
%         UPDN = eventdata.VerticalScrollCount;
%         S = S + UPDN;
%         if (S < 1)
%             S = 1;
%         elseif (S > sno)
%             S = sno;
%         end
%         if sno > 1
%             set(shand,'Value',S);
%             set(stxthand, 'String', sprintf('Slice# %d / %d',S, sno));
%         else
%             set(stxthand, 'String', '2D image');
%         end
%         set(get(ax_xy,'children'),'cdata',Img_xy(:,:,S))
%         set(get(ax_yz,'children'),'cdata',Img_yz(:,:,S))
%         set(get(ax_xz,'children'),'cdata',Img_xz(:,:,S)')
%     end

end
% -=< Maysam Shahedi (mshahedi@gmail.com), April 19, 2013>=-