function nmImg4D = calc_f0_img(img4D, odor_seq)
    index = find(odor_seq,1);
    f0Img = repmat(mean(img4D(:,:,:,1:index),4),1,1,1,size(img4D,4));
    nmImg4D = (img4D - f0Img)./f0Img;
end