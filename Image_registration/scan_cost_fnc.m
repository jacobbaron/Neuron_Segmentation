function [xmax,ymax,fnc]=scan_cost_fnc(x,y,max_good_frames,current_frame)

    fnc=zeros(length(y),length(x));
    for ii=1:length(x)
        for jj=1:length(y)
            fnc(jj,ii)=tform_cost(max_good_frames,current_frame,x(ii),y(jj));
        end
    end
    %figure;imagesc(fnc)
    %colorbar
    
   [~,idx]=min(fnc(:));
   [i,j]=ind2sub(size(fnc),idx);
   xmax=x(j);ymax=y(i);