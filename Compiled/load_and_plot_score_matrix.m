load('score_matrix.mat')
figure(1);
score_percent=score_matrix./repmat(sum(score_matrix,2),1,length(score_matrix));

figure(1);imagesc(score_percent)
ax=gca;
ax.XTick=1:size(score_matrix,2);
ax.YTick=1:size(score_matrix,1);
ax.XTickLabel=unique_labels(1:end-1);
ax.XTickLabelRotation=-45;
ax.XTickLabelRotation=45;
ax.YTickLabel=unique_labels(1:end-1);
xlabel('Actual')
ylabel('Prediction')
colorbar
colormap('Jet')