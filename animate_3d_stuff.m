function []=animate_3d_stuff(label,Idx,col,green_img)

figure
green_img_max=squeeze(max(green_img,[],3));
num_disp_clusters=length(Idx);
for ii=1:num_disp_clusters
    hpatch(ii)=patch(isosurface(label.*(label==Idx(ii)),0));
    isonormals(label.*(label==Idx(ii)),hpatch(ii));
    hpatch(ii).FaceColor = col(ii,:);
    hpatch(ii).EdgeColor = 'none';
    hold on;
    
end
axis off 
    daspect([1,1,1])
    view([0,-90]);
    camlight('right') 
    lighting gouraud
for ii=1:size(green_img_max,3)
    im=surf([1 size(green_img_max,2)],[1 size(green_img_max,1)],repmat(size(label,3)+1,[2 2]),green_img_max(:,:,ii),'facecolor','texture');
    axis equal;
    x=linspace(0,1,100)';
    colormap([1./(exp(-(x-.4)/.15)+1),linspace(0,0,100)',linspace(0,0,100)'])
    im.CDataMapping='direct';
    min_cdata=min(im.CData(green_img_max(:,:,end)>0));
    max_cdata=max(im.CData(:));
    im.CData=(im.CData-min_cdata)*150/max_cdata;
    %alpha(im,.8);
    %hold off;
    drawnow
    F(ii)=getframe;
end