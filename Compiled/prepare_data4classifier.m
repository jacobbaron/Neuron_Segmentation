function [training_data]=prepare_data4classifier(compiled_data,new_odor_inf)

labels=compiled_data.labels;
neuronList=compiled_data.neuronList;
if exist('new_odor_inf','var')
    nmPeakSig=updateSigMats(compiled_data.nmPeakSig,compiled_data.odor_inf,...
        new_odor_inf);
    odor_inf=new_odor_inf;
else
    nmPeakSig=compiled_data.nmPeakSig;
    odor_inf=compiled_data.odor_inf;
end


% [~,labels]=xlsread('labels.csv');
% label_questions=labels(:,2);
% labels=labels(:,1);
% labels(strcmp(labels,'?'))=cellfun(@(x)'NaN',labels(strcmp(labels,'?')),'UniformOutput',false);
% labels(strcmp(labels,'noise'))=cellfun(@(x)'NaN',labels(strcmp(labels,'noise')),'UniformOutput',false);
% labels(strcmp(labels,'nosie'))=cellfun(@(x)'NaN',labels(strcmp(labels,'nosie')),'UniformOutput',false);
% labels(strcmp(labels,'--'))=cellfun(@(x)'NaN',labels(strcmp(labels,'--')),'UniformOutput',false);
% labels(strcmp(labels,'85a'))=cellfun(@(x)'85c',labels(strcmp(labels,'85a')),'UniformOutput',false);
unique_labels=[unique(labels(~strcmp(labels,'NaN')));'NaN'];
labels_num=[1:length(unique_labels)-1,NaN];
ORN2num=containers.Map(unique_labels,labels_num);
% 
labels_idx=cellfun(@(x)ORN2num(x),labels);



%% reformat so each neuron is a column vector
odor_list=odor_inf.odor_list;
odor_concentration_list=odor_inf.odor_concentration_list;


[O,C]=meshgrid(1:size(nmPeakSig,2),1:size(nmPeakSig,1));
OdorConcMat=cellfun(@(x,y)sprintf('%s %s',x,y),odor_concentration_list(C),...
    odor_list(O),'UniformOutput',false);
OdorConcList=OdorConcMat(:)';
nmPeakSigList=squeeze(reshape(nmPeakSig,size(nmPeakSig,1)*size(nmPeakSig,2),1,size(nmPeakSig,3)))';
usedOdorConc_idx=find(~all(isnan(nmPeakSigList),1));
usedOdorConc=OdorConcList(usedOdorConc_idx);
usedLabels_idx=find(~isnan(labels_idx));
usedLabels=labels(usedLabels_idx);
usedLabels_num=labels_idx(usedLabels_idx);
usedSig=nmPeakSigList(usedLabels_idx,usedOdorConc_idx);


%% perform imputation to remove missing data


% usedSig_impute=impute(usedSig,usedLabels_num);

%%
training_data.labels=usedLabels;
training_data.odors=usedOdorConc;
training_data.unique_labels=unique_labels(~strcmp(unique_labels,'NaN'));
training_data.signal=usedSig;
training_data.ORN2num=ORN2num;
training_data.neuronList=neuronList(usedLabels_idx,:);


%% save
%save('training_data.mat','usedSig_impute','usedLabels_num','-v7.3');
