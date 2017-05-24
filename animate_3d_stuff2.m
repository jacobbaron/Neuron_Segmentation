function [F]=animate_3d_stuff2(tsne_data)

label=tsne_data.labels;
Idx=2:max(tsne_data.labels(:));
col=tsne_data.cmap(2:end,:);
green_img=tsne_data.aligned_green_img;
red_img=tsne_data.aligned_red_img;
signals=tsne_data.cluster_signals;
fname=tsne_data.filenames{1};
t=tsne_data.t;
odor_conc_inf=tsne_data.odor_conc_inf;

[~,name,~] = fileparts(fname) ;
        name=strrep(name,'_',' ');
maxsig=max(cellfun(@max,signals));
minsig=min(cellfun(@min,signals));
nm_sig=cellfun(@(x)(x-minsig)/(maxsig-minsig),signals,'UniformOutput',false);

framerate=8;

f=figure;
f.Position(3:4)=f.Position(3:4)*2;
f.Position(2)=f.Position(2)/4;
green_img_max=squeeze(max(green_img,[],3));
red_img_max=squeeze(max(red_img,[],3));
num_disp_clusters=length(Idx);
green_img_flat=reshape(green_img_max,size(green_img_max,1)*size(green_img_max,2),[]);
red_img_flat=reshape(red_img_max,size(red_img_max,1)*size(red_img_max,2),[]);
green_img_interp_flat=interp1(t,green_img_flat',t(1):1/framerate:t(end))';
red_img_interp_flat=interp1(t,red_img_flat',t(1):1/framerate:t(end))';
green_stack_interp=reshape(green_img_interp_flat,size(green_img_max,1),size(green_img_max,2),[]);
red_stack_interp=reshape(red_img_interp_flat,size(red_img_max,1),size(red_img_max,2),[]);
nm_sig_interp=cellfun(@(x)interp1(t,x,t(1):1/framerate:t(end)),nm_sig,'UniformOutput',false);
t_interp=t(1):1/framerate:t(end);
subplot(4,2,[1,3,5])
ax1=gca;
%ax1.Position(3:4)=ax1.Position(3:4)*1.1;

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
    
    min_cdata=min(green_img_max(green_img_max>0));
    max_cdata=max(green_img_max(:));
    min_rdata=min(red_img_max(red_img_max>0));
    max_rdata=max(red_img_max(:));
    x=linspace(0,1,100)';
    cmap=[x*0,x,x*0];
    cmapred=[x,x*0,x*0];
    colormap(ax1,cmapred)
    im=surf([1 size(green_img_max,2)],[1 size(green_img_max,1)],repmat(size(label,3)+1,[2 2]),'facecolor','texture');
    im.CDataMapping='direct';
    subplot(4,2,[2,4,6])
    ax2=gca;
    colormap(ax2,cmap)
    im2=surf([1 size(green_img_max,2)],[1 size(green_img_max,1)],repmat(size(label,3)+1,[2 2]),'facecolor','texture');
    daspect([1,1,1])
    view([0,-90]);
    axis off 
    im2.CDataMapping='direct';
    subplot(4,1,4)
    ax_plot=gca;
    patches=add_patches_to_plot(odor_conc_inf,ax_plot,1,tsne_data.odor_inf);
    xlabel('Time (s)')
    hold(ax_plot,'on');
    ax_plot.YAxis.Visible='off';
    xpos=ones(1,10);
    min_plot=ax_plot.YLim(1);
    max_plot=ax_plot.YLim(2);
    l=plot(xpos*0,linspace(min_plot,max_plot,10),'k');
    ax_plot.YLim=[min_plot,max_plot];
    ax_plot.XLim=[t(1),t(end)];
    supertitle(name);
for ii=1:size(green_stack_interp,3)    
    
    
    
    im2.CData=(green_stack_interp(:,:,ii)-min_cdata)*150/max_cdata;
    im.CData=(red_stack_interp(:,:,ii)-min_rdata)*150/max_rdata;
    %alpha(im,.8);
    %hold off;
    l.XData=xpos*t_interp(ii);
    for jj=1:num_disp_clusters
        try
            hpatch(jj).FaceAlpha=nm_sig_interp{jj}(ii);
        catch
            1;
        end
    end
    drawnow
    
    F(ii)=getframe(f);
    
end


 if exist('fname','var')
        h=waitbar(0,'Saving Video...');
         filename=strcat(fname,'_movie.avi');
         v = VideoWriter(filename);
         v.FrameRate=framerate*4;
         open(v)
         writeVideo(v,F);
         close(h);
         msgbox('Movie Saved!');
%         im = frame2im(F(ii));
%         [imind,cm] = rgb2ind(im,256);
%         if ii == 1;
%             imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%         else
%             imwrite(imind,cm,filename,'gif','WriteMode','append');
%         end
end
