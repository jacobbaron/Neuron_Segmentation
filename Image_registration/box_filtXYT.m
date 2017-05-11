function [img_stack_box_filt]=box_filtXYT(img_stack,filterSize)
img_stack_box_filt=zeros(size(img_stack),'uint16');    
    h=waitbar(0,'Filtering...');
    for ii=1:size(img_stack,3)
        waitbar(ii/size(img_stack,3),h);
        img_stack_box_filt(:,:,ii)=imboxfilt(img_stack(:,:,ii),filterSize);        
    end
    close(h);
end