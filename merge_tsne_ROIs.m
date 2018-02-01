function [tsneF, foregroundF] = merge_tsne_ROIs(groups, tsne_precluster, foreground)
%%
start = 1;
tsneImg = zeros(size(foreground{1}));
previousMax = 0;
dim = 0;
for ii=1:length(groups)
    tsne{ii} = tsne_precluster{ii}(groups{ii},:);
    if ii>1
        tsne{ii}(:,dim+1) = tsne{ii}(:,dim+1)+(2*dim-1)*(previousMax-min(tsne{ii}(:,dim+1)));
    end
    dim = ~dim;
    previousMax = max(tsne{ii}(:,dim+1));
    tsneIdx = start:start+length(tsne{ii})-1;
    tsneImg(foreground{ii}) = tsneIdx;
    start = length(tsne{ii})+1;
end
tsneF = cell2mat(tsne');
tsneF = tsneF(tsneImg(tsneImg>0),:);
for ii=1:size(tsneF,2)
    tsneF(:,ii) = tsneF(:,ii)-mean(tsneF(:,ii));
end
foregroundF = zeros(size(tsneImg));
foregroundF(tsneImg>0) = 1;
foregroundF = foregroundF>0;
1;