unique_expts= unique(neuronsListDay(:,[2,3]),'rows');

sig_bool=sigs>2;
numNeuronsRespond=zeros(size(unique_expts,1),size(sig_bool,2));
for ii=1:size(unique_expts,1)
    
    
    
    idx=neuronsListDay(:,2)==unique_expts(ii,1) & neuronsListDay(:,3)==unique_expts(ii,2);
%     figure('Name',sprintf('%d',unique_expts(ii,1)*100+unique_expts(ii,2)));
%     imagesc(sigs(idx,:))
%     colorbar    
%     ax=gca;
%     ax.XTick=1:size(sigs,2);
%     ax.XTickLabel=odors;
%     ax.XTickLabelRotation=90;
%     title(sprintf('%d',unique_expts(ii,1)*100+unique_expts(ii,2)))
    numNeuronsRespond(ii,:)=sum(sig_bool(idx,:),1);
    
end
neuronrespondTable=array2table(numNeuronsRespond,'VariableNames',cellfun(@matlab.lang.makeValidName,odors,'UniformOutput',false));
%[sigs,odors]=dispNeuronSignals(nmPeakSigDay,neuronsListDay);
figure(1);
bar(numNeuronsRespond')
ax=gca;
ax.XTickLabel=odors;
ax.XTickLabelRotation=90;
hold on
avg_neurons_respond=mean(numNeuronsRespond);
er=errorbar(mean(numNeuronsRespond,1),std(numNeuronsRespond)/size(numNeuronsRespond,1),'o');