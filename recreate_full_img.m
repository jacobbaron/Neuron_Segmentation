function [full_img]=recreate_full_img(foreground,background,image_size,roi)
    %get indicies of background region using image_size and roi
    full_img=zeros(image_size);
    full_img(roi(1,1):roi(1,2),roi(2,1):roi(2,2),:,:) = 1;
    full_img(full_img==0)=background;
    full_img(roi(1,1):roi(1,2),roi(2,1):roi(2,2),:,:) = foreground;
    

end