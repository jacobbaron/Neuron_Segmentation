function []=find_coefs_for_ORN(ORNnames,unique_labels,coeffs,odorConcNames)
num_orns=length(ORNnames);
num_labels=length(unique_labels);
% ORN2num=containers.Map(unique_labels,1:num_labels);
% orn_combos=nchoosek(ORNnames,2);
% orn_comboComb=cellfun(@(x,y)sprintf('%s %s',x,y),orn_combos(:,1),...
%     orn_combos(:,2),'UniformOutput',false);

labelvec=1:num_labels;
support_vec_names=unique_labels(nchoosek(labelvec,2));
supportVecNamesComb=cellfun(@(x,y)sprintf('%s %s',x,y),support_vec_names(:,1),...
    support_vec_names(:,2),'UniformOutput',false);

vecNeurons=find(ismember(support_vec_names(:,1),ORNnames)&ismember(support_vec_names(:,2),ORNnames));
% vecNeurons=zeros(size(coeffs,1),1);
% for ii=1:length(ORNnames)
%     vecNeurons=vecNeurons | any(strcmp(support_vec_names,ORNnames(ii)),2);
% end

figure;
imagesc(cov(coeffs(vecNeurons,:)))
ax=gca;
ax.YTick=1:length(odorConcNames);
ax.YTickLabel=odorConcNames;
ax.XTick=1:length(odorConcNames);
ax.XTickLabel=odorConcNames;
ax.XTickLabelRotation=90;
[coef_var,var_idx]=sort(var(coeffs(vecNeurons,:)));
figure
barh(coef_var)
ax=gca;
ax.YTick=1:length(odorConcNames);
ax.YTickLabel=odorConcNames(var_idx);


odor_importance=mean(abs(coeffs(vecNeurons,:)),1);
[odor_import_sort,idx]=sort(odor_importance);
figure;barh(odor_import_sort)
ax=gca;
ax.YTick=1:length(odorConcNames);
ax.YTickLabel=odorConcNames(idx);

title(strjoin(ORNnames,' '))

figure;imagesc(coeffs(vecNeurons,fliplr(idx)));
ax=gca;
ax.YTick=1:length(vecNeurons);
ax.YTickLabel=supportVecNamesComb(vecNeurons);
ax.XTick=1:length(odorConcNames);
ax.XTickLabel=odorConcNames(fliplr(idx));
ax.XTickLabelRotation=-90;
colorbar