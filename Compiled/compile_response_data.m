%% list of folders to include

folders={'20160719';'20160813';'20160817'};
%paths=cellfun(@(x)strcat('..\',x,'\
for ii=1:length(folders)
   cd(strcat('../',folders{ii}))
   
   [neuronsListDay,nmPeakSigDay,nmSigDay,neuronCoMDay,neuronVarDay,...
    tCourseNeuron,neuronFireDay]=load_sig_from_day();
   
   cd ../Compiled
   save(strcat(folders{ii},'_data.mat'))
end




%% 

clearvars
load odor_inf.mat
datafiles=dir('*.mat');
nmPeakSig=[];
neuronList=[];
neuronFire=[];
for ii=1:length(datafiles)
    
    x=load(datafiles(ii).name);
    nmPeakSig=cat(3,nmPeakSig,x.nmPeakSigDay);
    neuronList=[neuronList;x.neuronsListDay];
    neuronFire=cat(3,neuronFire,x.neuronFireDay);
end
%% 
[nmSigList,odorsList,neuronFireList,f]=dispNeuronSignals(nmPeakSig,neuronFire,'');

save('compiled_data.mat','nmPeakSig','neuronList','neuronFire',...
    'nmSigList','odorsList','neuronFireList')
%% 
sigs=nmSigList;
odors=odorsList;

sig_bool=sigs>2;

unique_expts=unique(neuronList(:,1:3),'rows');
numNeuronsRespond=zeros(size(unique_expts,1),size(sig_bool,2));
unique_days=unique(neuronList(:,1));
for ii=1:length(unique_expts)
     idx=ismember(neuronList(:,1:3),unique_expts(ii,1:3),'rows');
      numNeuronsRespond(ii,:)=sum(sig_bool(idx,:),1);
      temp=isnan(mean(sigs(idx,:),1));
      numNeuronsRespond(ii,temp)=nan;
      
end
%% 

for jj=1:length(unique_days)
    figure(6+jj)
    for ii=1:length(odors)
       subplot(5,5,ii)
        histogram(numNeuronsRespond(unique_expts(:,1)==unique_days(jj),ii))
        title(odors{ii})


    end
    annotation('textbox',[0 0.9 1 0.1],...
        'String',num2str(unique_days(jj)),...
        'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center');
end