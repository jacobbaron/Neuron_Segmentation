function [neuron_positions,neuron_variance]=calcNeuronPositions(tsne_data,filename,batch)
    if isfield(tsne_data,'filenames')
        fname=tsne_data.filenames{1};
    elseif isempty(filename)
        fname=filename;
    else
        fname='';
    end
    if isfield(tsne_data,'which_side')
        choice=tsne_data.which_side{2};
        DorV=tsne_data.which_side{1};
    elseif ~batch
    
        choice=questdlg(sprintf('What side is movie %s from?',fname),...
            'Choose Side','Left','Right','Right');
        DorV=questdlg(sprintf('What side from movie %s is closest to objective?',fname),...
            'Choose Side','Dorsal','Ventral','Dorsal');
    else
        choice = 'Left';
        DorV = 'Dorsal';
    end
    
   switch choice
       case 'Left'
           red_img=fliplr(tsne_data.aligned_red_img);
           green_img=fliplr(tsne_data.aligned_green_img);
           labels=fliplr(tsne_data.labels);
       case 'Right'
           red_img=tsne_data.aligned_red_img;
           green_img = tsne_data.aligned_green_img;
           labels = tsne_data.labels;
   end
   switch DorV
       case 'Ventral'
           red_img=flip(red_img,3);
           green_img=flip(green_img,3);
           labels=flip(labels,3);
   end
    if isfield(tsne_data,'pixelSize')
        pixelsize=tsne_data.pixelSize;
    else
        prompt={'Size in X','Size in Y','Size in Z'};
        answer=inputdlg(prompt,'Enter Pixel Sizes',1,{'.2667','.2667','.6'});
        pixelsize=cellfun(@str2num,answer)';
    end
    red_img_max=max(red_img,[],4);
    x=linspace(0,pixelsize(1)*size(green_img,2),size(green_img,2));
    y=linspace(0,pixelsize(2)*size(green_img,1),size(green_img,1));
    if length(pixelsize) == 2
        z= 1;
    else
        z=linspace(0,pixelsize(3)*size(green_img,3),size(green_img,3));
    end
    [X,Y,Z]=meshgrid(x,y,z);
    
    
    if size(red_img,3)==size(green_img,3)
        red_img_lin=double(red_img_max(:));
        CoM=1/sum(red_img_lin)*[sum(red_img_lin.*X(:)),sum(red_img_lin.*Y(:)),sum(red_img_lin.*Z(:))];
    else
        red_img_2d=max(red_img_max,[],3);
        red_img_lin=double(red_img_2d(:));
        [Xlin,Ylin]=meshgrid(x,y);
        CoM=[sum(red_img_lin.*Xlin(:))/sum(red_img_lin),sum(red_img_lin.*Ylin(:))/sum(red_img_lin),...
            round(size(green_img,3)*pixelsize(3)/2)];
    end
    
    X=X-CoM(1);
    Y=Y-CoM(2);
    Z=Z-CoM(3);
    
    unique_neurons=unique(labels(labels>1));
    for ii=1:length(unique_neurons)
       idx=(labels==unique_neurons(ii));
       neuron_positions(ii,:)=[mean(X(idx)),mean(Y(idx)),mean(Z(idx))];
       neuron_variance(ii,:)= [var(X(idx)),var(Y(idx)),var(Z(idx))];
    end
    
end