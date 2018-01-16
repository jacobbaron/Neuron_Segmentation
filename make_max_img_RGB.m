function [maxImgRGB] = make_max_img_RGB(redImg,greenImg,pixelSize)

    maxProjRed = make_max_proj_img(redImg,pixelSize);
    maxProjGreen = make_max_proj_img(greenImg,pixelSize);
    
    minRed = min(maxProjRed(maxProjRed>0));
    maxRed = max(maxProjRed(:));
    
    minGreen = min(maxProjGreen(maxProjGreen>0));
    maxGreen = max(maxProjGreen(:));
    
    maxImgRGB = cat(3,(maxProjRed-minRed)/(maxRed-minRed),...
       (maxProjGreen-minGreen)/(maxGreen-minGreen),zeros(size(maxProjRed)));