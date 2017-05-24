function [SVM_result]=test_SVM(training_data,varargin)
%signals should be - row corresponding to different neuron, column
%corresponding to different odor. 
if any(strcmp(varargin,'ORNs2use'))
   ORNs2use=varargin{find(strcmp(varargin,'ORNs2use'))+1}; 
else
    ORNs2use=training_data.unique_labels;
end
if any(strcmp(varargin,'odors2use'))
   odors2use=varargin{find(strcmp(varargin,'odors2use'))+1}; 
else
    odors2use=training_data.odors;
end
[signal,labels]=reduce_training_data(training_data,odors2use,ORNs2use);

if any(isnan(signal(:)))
    signal=impute(signal,labels);
end

save('training_data.mat','signal','labels');
system('python testMultiClassSVM.py');
%rehash toolbox;
SVM_result=load('score_matrix.mat');
score_matrix=SVM_result.score_matrix;
figure;
score_prob=score_matrix./repmat(sum(score_matrix,2),1,size(score_matrix,2));
imagesc(-log(1-score_prob));

ax=gca;
ax.XTick=1:length(score_matrix);
ax.YTick=ax.XTick;
ax.XTickLabel=ORNs2use;
ax.XTickLabelRotation=90;
ax.YTickLabel=ORNs2use;
h=colorbar;
h.TickLabels=cellfun(@(x)sprintf('%0.3f',x),num2cell(1-exp(-h.Ticks)),'UniformOutput',false);
% c=logspace(-.2,0,10);
% clim=[c(1) c(length(c))];
% colorbar('YTick',log(c),'YTickLabel',round(c,2));
colormap(jet);
% caxis(log([c(1),c(end)]));
%colorbar('FontSize',11,'YTick',log(c),'YTickLabel',round(c,2));

figure;
imagesc(score_prob);

ax=gca;
ax.XTick=1:length(score_matrix);
ax.YTick=ax.XTick;
ax.XTickLabel=ORNs2use;
ax.XTickLabelRotation=90;
ax.YTickLabel=ORNs2use;
h=colorbar;
% c=logspace(-.2,0,10);
% clim=[c(1) c(length(c))];
% colorbar('YTick',log(c),'YTickLabel',round(c,2));
colormap(jet);


figure
bar(100*(1-diag(score_prob)))
ylabel('% incorrect')
ax=gca;
ax.XTick=1:length(score_matrix);
ax.XTickLabel=ORNs2use;

1;