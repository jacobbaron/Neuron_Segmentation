function [prediction]=SVMpredict(training_data,testData,ORNs2use)

%test_data is struct array 
odors=testData.odors;
test_data=testData.signal;

[train_signal,labels]=reduce_training_data(training_data,odors,ORNs2use);
train_signal=impute(train_signal,labels);

path=which('SVMPredict.py');
folder=fileparts(path);

save('training_test_data.mat','train_signal','labels','test_data','folder');

[status,cmdout]=system(sprintf('python %s',path));
if status
    errordlg(cmdout);
end
ld=load('predictions.mat');
prediction=ld.predict_class;
delete('predictions.mat','training_test_data.mat');