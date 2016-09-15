function []=disp_soma_response(odor_seq)

load AveSomaResponses.mat


idx_ORN=[3;6;8;18;15;9;13;10;1;4;7;12;11;14;2;5;16;17];
idx_odor=[15;12;14;7;8;6;19;9;1;10;5;17;4;3;11;2;16;18;13];

dataMean=dataMean(idx_odor,idx_ORN,:);
dataSEM=dataSEM(idx_odor,idx_ORN,:);
odorList=odorList(idx_odor);
infoORNList=infoORNList(idx_ORN);

unique_odors=unique(odor_seq(odor_seq>0));
for ii=1:length(unique_odors)
    [odor{ii},conc{ii}]=compute_odor_conc(unique_odors(ii));
    inds(ii,1)=find(strcmp(odorList,odor{ii}));
    
    inds(ii,2)=find(log10(str2num(conc{ii}))==log10(concList));
    
    response_mat(ii,:)=dataMean(inds(ii,1),:,inds(ii,2));

end
[odor_ordered,~,odor_order]=intersect(odorList,odor','stable');
figure;
imagesc(response_mat(odor_order,:))
ax=gca;
ax.XTick=1:size(response_mat,2);
ax.YTick=1:size(response_mat,1);
ax.XTickLabel=infoORNList;
ax.XTickLabelRotation=-45;
ax.XAxisLocation='Top';
ax.YTickLabel=cellfun(@(x,y)sprintf('%s %s',x,y),conc(odor_order)',odor_ordered,...
    'UniformOutput',false);
colormap(jet)
colorbar


