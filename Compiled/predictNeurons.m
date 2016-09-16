function [prediction]=predictNeurons(nmPeakSigMat,odors2exclude_idx,ORNs2use)

compiled_data=load('compiled_data.mat');
training_data=prepare_data4classifier(compiled_data);
test_data=prepare_test_data(nmPeakSigMat,odors2exclude_idx);
prediction_num=SVMpredict(training_data,test_data,ORNs2use);
prediction=ORNs2use(prediction_num);
