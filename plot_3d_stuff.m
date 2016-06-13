function []=plot_3d_stuff(label,Idx,red_img_stack,col)
red_img_avg=max(red_img_stack,[],4);
red_img_max=squeeze(max(red_img_stack,[],3));
%Idx is list of clusters to plot
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
    %im=imagesc(red_img_avg(:,:,7))
    %
    %legend(mat2cell(num2str(Idx(1:num_disp_clusters)),num_disp_clusters))
    %title('Highest Intensity Clusters')
    
   % subplot(1,2,2)
    im=surf([1 size(red_img_avg,2)],[1 size(red_img_avg,1)],repmat(size(label,3)+1,[2 2]),max(red_img_avg,[],3),'facecolor','texture');
    axis equal;
    x=linspace(0,1,100)';
    colormap([1./(exp(-(x-.4)/.15)+1),linspace(0,0,100)',linspace(0,0,100)'])
    im.CDataMapping='direct';
    min_cdata=min(im.CData(red_img_max(:,:,end)>0));
    max_cdata=max(im.CData(:));
    im.CData=(im.CData-min_cdata)*150/max_cdata;
    alpha(im,.8);
%     figure
%     for  ii=1:num_disp_clusters
%         subplot(num_disp_clusters,1,ii)
%         label_idx=repmat(label==Idx(ii),1,1,1,size(red_img_stack,4));
%         img_label=img_stack.*label_idx;
%         img_label(img_label==0)=NaN;
%         plot(reshape(nanmean(nanmean(nanmean(img_label,1),2),3),[],1),'Color',col(ii,:));
%         
%     end