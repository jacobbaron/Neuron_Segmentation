function [f,ax,...
    ORNMenu, include_chkbox,orns]=editNeurons4Classifier(tsne_data,f,ax)
    orns={'33b','45a','83a','35a','42a','59a','1a','45b','24a','67b','85c','13a','30a','82a','22c','42b','74a','94a','Unknown\NaN'};
    
    if ~exist('f','var')
        [f,ax]=plot_cluster_t_course(tsne_data);    
    else
        if ~isvalid(f)
            [f,ax]=plot_cluster_t_course(tsne_data);
        end
    end
    
    
    fPositionNorm=f.Position;
    
    f.Units='pixels';
mWidth=50/f.Position(3);
mHeight=20/f.Position(4);
menu_space=20/f.Position(4);
if isfield(tsne_data,'neuronID')
    neuronID=tsne_data.neuronID;
    [~,ia]=intersect(orns,neuronID,'stable');
    neuronIDnum=flipud(ia);
else
    neuronIDnum=ones(length(tsne_data.cluster_signals),1);
end


for ii=1:length(tsne_data.cluster_signals)
    
    ax(ii).Position(1)=ax(ii).Position(1)+mWidth+menu_space;
    axpos=ax(ii).Position;
    MenuPos=[axpos(1)-mWidth-30/f.Position(3),...
                    axpos(2)-mHeight/2+axpos(4)/2,...
                    mWidth,...
                    mHeight];
    ax(ii).YLabel.Visible='off';
   
    neuronIDnum(ii)=find(strcmp(orns,neuronID(ii)));
    ORNlistii=orns;
    ORNlistii{neuronIDnum(ii)}=sprintf('<HTML><BODY bgcolor="#d3d3d3">%s</BODY>',...
        orns{neuronIDnum(ii)});
   ORNMenu(ii)=uicontrol('Parent',f,'Style','popupmenu',...
       'String',ORNlistii,...
       'Units','normalized',...
       'Position',MenuPos,...
        'Value',neuronIDnum(ii));
       chkbox_sz=menu_space;
    chkbox_pos=[MenuPos(1)-chkbox_sz,...
                MenuPos(2), chkbox_sz,chkbox_sz];
                
    include_chkbox(ii)=uicontrol('Parent',f,'Style','checkbox',...
       'Units','normalized',...
       'Position',chkbox_pos,...
       'Value',1);
   
end

    function submit(varargin)
        include=logical([include_chkbox(:).Value])';
        labels=orns([ORNMenu(:).Value]);
        assignin('caller','neuronID',labels);
        assignin('caller','neurons2include',include);
    end
end