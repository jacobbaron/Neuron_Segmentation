function [labelProj,xMesh,yMesh,zMesh] =make_max_label_proj(labels,pixelSize)

    imgSize = size(labels);
    x2z = pixelSize(3)/pixelSize(2);
    imgSizeInterpZ = round(imgSize(3)*x2z);
    %labelProj = zeros(imgSize(1)+imgSize(3), imgSize(2)+imgSize(3),max(imgSize));
    zIdx = linspace(1,imgSizeInterpZ,imgSize(3));
%     [xmesh,ymesh,zmesh]=ndgrid(1:imgSize(1),1:imgSize(2),1:size(labels,3));
%     [xmeshInterp,ymeshInterp,zmeshInterp]=ndgrid(1:imgSize(1),1:imgSize(2),zIdx);
%     labelInterp = interpn(xmesh,ymesh,zmesh,labels,xmeshInterp,ymeshInterp,zmeshInterp,'nearest');
%     
    labelProj{1} = labels;
    labelProj{2} = permute(labels,[3,2,1]);
    labelProj{3} = permute(labels,[1,3,2]);
  
    [xMesh{1},yMesh{1},zMesh{1}] = meshgrid(1:imgSize(2),1:imgSize(1),zIdx);
    [xMesh{2},yMesh{2},zMesh{2}] = meshgrid(1:imgSize(2),...
                                    imgSize(1)+zIdx,1:imgSize(1));
    [xMesh{3},yMesh{3},zMesh{3}] = meshgrid(imgSize(2)+zIdx,1:imgSize(1),...
                                    1:imgSize(2));
    
    

end