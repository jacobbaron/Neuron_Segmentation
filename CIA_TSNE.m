function [groups,tsne_preclustered]=CIA_TSNE(img_stack,foreground,odor_sequence,...
    varargin)
%required arguments are img_stack, foreground, and odor_sequence
%options are 'tsne_data','tsne_iter','alpha', 'k'
%options are called as CIA_TSNE(img_stack,foreground,odor_sequence,...
                             %'option',value);


%tsne_iter is number of iterations to use for tsne (Default=8000)

%k and alpha are parameters in the DBSCAN clustering algorthim
%k, number of points in cluster (default 70)
%alpha, density drop threshold (default .7)

%if you include tsne_data struct, function will only perform
%DBSCAN clustering, and will not run TSNE.

if any(strcmp('tsne_data',varargin))
    tsne_data=varargin{find(strcmp('tsne_data',varargin))+1};
else
    tsne_data=[];
end

if any(strcmp('tsne_iter',varargin))
    tsne_iter=varargin{find(strcmp('tsne_iter',varargin))+1};
else
    tsne_iter=8000;
end
if any(strcmp('use_space',varargin))
    use_space=varargin{find(strcmp('use_space',varargin))+1};
else
    use_space=0;
end
if use_space
   scale_factor = varargin{find(strcmp('scale_factor',varargin))+1};
else
    scale_factor=1;
end
%% reshape image stacks

if any(foreground(:)>1)
    foreground(foreground==1)=0;
    foreground(foreground>1)=1;
end
    
tsne_bar=waitbar(0,'Starting t-SNE...');
foreground_stack=repmat(foreground,1,1,1,size(img_stack,4));
%img_stack_foreground=img_stack;
%img_stack_foreground(~foreground_stack)=0;
foreground_list=find(foreground);
img_list=reshape(img_stack,size(img_stack,1)*size(img_stack,2)*size(img_stack,3),size(img_stack,4));
img_list_foreground=img_list(foreground_list,:);
clear img_list;
if use_space
    max_img = max(img_list_foreground(:));
    min_img = min(img_list_foreground(:));
    idx=find(foreground);
    [i,j,k] = ind2sub(size(foreground),idx);
    i = i*max_img*scale_factor/max(i);
    j = j*max_img*scale_factor/max(j);
    k = k*max_img*scale_factor/max(k);
    img_list_foreground = [img_list_foreground,i,j,k];
end
%% preliminary kmeans to reduce number of points to run tsne on
if isempty(tsne_data)
    waitbar(.05,tsne_bar,'Running k-means to reduce computation size!');
    fprintf('Running k-means to reduce computation size!\n');
    num_groups=round(size(img_list_foreground,1)/2);
    [groups,group_center]=kmeans(double(img_list_foreground),num_groups);
    img_list_preclustered=img_list_foreground;  
    for ii=1:num_groups
       img_list_preclustered(groups==ii,:)=repmat(group_center(ii,:),length(find(groups==ii)),1); 
    end
%     img_stack_preclustered=img_stack_foreground;
%     img_stack_preclustered(foreground_stack)=img_list_preclustered(:);

    %% run t_sne
    fprintf('Starting t-SNE!\n');
    waitbar(.1,tsne_bar,'Starting t-SNE!');
    tsne_preclustered=fast_tsne(group_center,2,[],[],.5,[],tsne_iter);
else
    fprintf('Data provided, so not running t-SNE\n');
    tsne_preclustered=tsne_data.tsne_result;
    groups=tsne_data.precluster_groups;
end





%% save relevant variables in a struct

% tsne_data=struct;
% tsne_data.foreground=foreground;
% tsne_data.precluster_groups=groups;
% tsne_data.tsne_result=tsne_preclustered;
close(tsne_bar);
