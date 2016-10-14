function [test_data,nmPeakSigMat]=prepare_test_data(nmPeakSigMat,odor_inf,...
    odors2exclude)

odor_list=odor_inf.odor_list;
odor_concentration_list=odor_inf.odor_concentration_list;

if ~isempty(odors2exclude)
    conc2exclude = cellfun(@(x)find(strcmp(x,odor_concentration_list)),...
        odors2exclude(:,1));
    odor2exclude = cellfun(@(x)find(strcmp(x,odor_list)),odors2exclude(:,2));
    
    nmPeakSigMat(conc2exclude,odor2exclude,:)=NaN;
end


%% reformat so each neuron is a column vector




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
