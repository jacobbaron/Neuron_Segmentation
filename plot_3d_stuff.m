function []=plot_3d_stuff(label,Idx,red_img_stack,col,imgSize,pixelSize)

%red_img_avg=max(red_img_stack,[],4);
%red_img_max=squeeze(max(red_img_stack,[],3));


x2z = pixelSize(3)/pixelSize(2);
imgSizeInterp = imgSize;
imgSizeInterp(3) = round(imgSize(3)*x2z);
zIdx = linspace(1,imgSizeInterp(3),imgSize(3));
[xMesh,yMesh,zMesh] = meshgrid(1:imgSize(1),1:imgSize(2),zIdx);
red_img_avg = red_img_stack;
red_img_max = red_img_stack;
%Idx is list of clusters to plot
num_disp_clusters=length(Idx);
if ~exist('col','var')
    col=generate_cmap(length(unique(label(:)>1)));
end


[labelProj,xMesh,yMesh,zMesh] = make_max_label_proj(label,pixelSize);
maxZ = max(cellfun(@(x)max(x(:)),zMesh));
for ii=1:num_disp_clusters
    for jj=1:3
        hpatch(ii,jj)=patch(isosurface(xMesh{jj},yMesh{jj},maxZ-zMesh{jj},...
            labelProj{jj}.*(labelProj{jj}==Idx(ii)),0));
        isonormals(label.*(label==Idx(ii)),hpatch(ii,jj));
        hpatch(ii,jj).FaceColor = col(ii,:);
        hpatch(ii,jj).EdgeColor = 'none';
        
        hold on;
    end
end
    
    axis off 
    daspect([1,1,1])
    view([0,-90]);
    camlight('left') 
    camlight('right') 
    material shiny
    %im=imagesc(red_img_avg(:,:,7))
    %
    %legend(mat2cell(num2str(Idx(1:num_disp_clusters)),num_disp_clusters))
    %title('Highest Intensity Clusters')
    
   % subplot(1,2,2)
    redMax = max(red_img_avg,[],3);
    redMax = (redMax-min(redMax(redMax>0)))/(max(redMax(:))-min(redMax(redMax>0)));
    redMax(redMax<0)= 0;
    im=surf([1 size(red_img_avg,2)],[1 size(red_img_avg,1)],ones(2)*maxZ+1,max(redMax,[],3),'facecolor','texture');
    axis equal;
    x=linspace(0,1,100)';
    %colormap([1./(exp(-(x-.4)/.15)+1),linspace(0,0,100)',linspace(0,0,100)']);
    colormap([linspace(0,1,100)',linspace(0,1,100)',linspace(0,1,100)'])
%     im.CDataMapping='direct';
%     min_cdata=min(im.CData(red_img_max(:,:,end)>0));
%     max_cdata=max(im.CData(:));
%     oldCdata = im.CData;
%     im.CData=(oldCdata-min_cdata)*100/max_cdata;
    alpha(im,.8);
    hold off;
%     figure
%     for  ii=1:num_disp_clusters
%         subplot(num_disp_clusters,1,ii)
%         label_idx=repmat(label==Idx(ii),1,1,1,size(red_img_stack,4));
%         img_label=img_stack.*label_idx;
%         img_label(img_label==0)=NaN;
%         plot(reshape(nanmean(nanmean(nanmean(img_label,1),2),3),[],1),'Color',col(ii,:));
%         
%     end