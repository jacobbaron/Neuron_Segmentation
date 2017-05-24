compiled_data=load('compiled_data.mat');
[training_data]=prepare_training_data(compiled_data);
[SVM_result]=test_SVM(training_data);