function add2TrainingDataset(nmPeakSigNew,filenameNew,labelsNew)

    runidx=strfind(filenameNew,'run')+3;
    dotidx=strfind(filenameNew,'.nd2')-1;
    animal=floor(str2double(filenameNew(runidx:dotidx))/100);
    expt=rem(str2double(filenameNew(runidx:dotidx)),animal*100);
    neuronsListNew=[str2double(date)*ones(length(labelsNew),1),...
        animal*ones(length(labelsNew),1),expt*ones(length(labelsNew),1),...
        (1:length(labelsNew))'];
    
    compiled_data_path=which('compiled_data.mat');
    compiled_data_folder=fileparts(compiled_data_path);
    C=load('compiled_data.mat');
    last_animal=sprintf('%0.0f_%0.0f',C.neuronList(end,1),...
        C.neuronList(end,2)*100+C.neuronList(end,3));
    save(fullfile(compiled_data_folder,'Compiled_data_backup','compiled_data_backup.mat'),...
        '-struct','C');
    C.neuronList=[C.neuronList;neuronsListNew];
    C.labels=[C.labels;labesNew];
    C.nmPeakSig=cat(3,C.nmPeakSig,nmPeakSigNew);
    
    save('compiled_data.mat','-struct','C');
    
    