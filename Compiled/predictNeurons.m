function [prediction,nmPeakSigMatTest]=predictNeurons(nmPeakSigMat,...
    odors2exclude,ORNs2use,test_odor_inf)

compiled_data=load('compiled_data.mat');

odor_inf=reconcile_odor_infs(test_odor_inf,compiled_data.odor_inf);
testPeakSigMat=updateSigMats(nmPeakSigMat,test_odor_inf,...
    odor_inf);

training_data=prepare_data4classifier(compiled_data,odor_inf);
[test_data,nmPeakSigMatTest]=prepare_test_data(testPeakSigMat, odor_inf, odors2exclude);
prediction_num=SVMpredict(training_data, test_data, ORNs2use);
prediction=ORNs2use(prediction_num);
