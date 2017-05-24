function [signal,labels]=reduce_training_data(training_data,odors2use,ORNs2use)


neurons2use=ismember(training_data.labels,ORNs2use);
labels2use=training_data.labels(neurons2use);

ORNs2use_num=1:length(ORNs2use);
ORNs2num=containers.Map(ORNs2use,ORNs2use_num);

odors2use_num=ismember(training_data.odors,odors2use);

%reduce data size based on ORNs2use and odors2use
labels=cellfun(@(x)ORNs2num(x),labels2use);
signal=training_data.signal(neurons2use,odors2use_num);