function [test_data]=prepare_test_data(nmPeakSigMat,odors2exclude_idx)
if ~isempty(odors2exclude_idx)
    nmPeakSigMat(odors2exclude_idx(1,:),odors2exclude_idx(2,:),:)=NaN;
end


%% reformat so each neuron is a column vector


load odor_inf.mat

[O,C]=meshgrid(1:size(nmPeakSigMat,2),1:size(nmPeakSigMat,1));
OdorConcMat=cellfun(@(x,y)sprintf('%s %s',x,y),odor_concentration_list(C),...
    odor_list(O),'UniformOutput',false);
OdorConcList=OdorConcMat(:)';
nmPeakSigList=squeeze(reshape(nmPeakSigMat,...
    size(nmPeakSigMat,1)*size(nmPeakSigMat,2),1,size(nmPeakSigMat,3)))';
usedOdorConc_idx=find(~all(isnan(nmPeakSigList),1));
usedOdorConc=OdorConcList(usedOdorConc_idx);

usedSig=nmPeakSigList(:,usedOdorConc_idx);


test_data.odors=usedOdorConc;
test_data.signal=usedSig;
