function [img_stack_box_filt]=box_filt4D(img_stack,filterSize)
img_stack_box_filt=zeros(size(img_stack));    
    h=waitbar(0,'Filtering...');
    for ii=1:size(img_stack,4)
        waitbar(ii/size(img_stack,4),h);
        img_stack_box_filt(:,:,:,ii)=imboxfilt3(img_stack(:,:,:,ii),filterSize);        
    end
    close(h);
end