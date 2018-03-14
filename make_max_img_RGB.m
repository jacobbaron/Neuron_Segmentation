function [maxImgRGB] = make_max_img_RGB(redImg,greenImg,pixelSize,scale)
    if ~exist('scale','var')
        scale=1;
    end
    maxProjRed = make_max_proj_img(redImg,pixelSize);
    maxProjGreen = make_max_proj_img(greenImg,pixelSize);    
    if scale
        minRed = min(maxProjRed(maxProjRed>0));
        maxRed = max(maxProjRed(:));

        minGreen = min(maxProjGreen(maxProjGreen>0));
        maxGreen = max(maxProjGreen(:));
    else
        maxRed = 1;
        minRed = 0;
        maxGreen = 1;
        minGreen = 0;
    end
    maxImgRGB = cat(3,(maxProjRed-minRed)/(maxRed-minRed),...
       (maxProjGreen-minGreen)/(maxGreen-minGreen),zeros(size(maxProjRed)));