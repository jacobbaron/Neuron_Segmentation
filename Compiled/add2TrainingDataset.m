function add2TrainingDataset(nmPeakSigNew,filenameNew,labelsNew,neuronIdx,odor_inf)
    [~,date,~]=fileparts(pwd);
    runidx=strfind(filenameNew,'run')+3;
    dotidx=strfind(filenameNew,'.nd2')-1;
    animal=floor(str2double(filenameNew(runidx:dotidx))/100);
    expt=rem(str2double(filenameNew(runidx:dotidx)),animal*100);
    neuronsListNew=[str2double(date)*ones(length(labelsNew),1),...
        animal*ones(length(labelsNew),1),expt*ones(length(labelsNew),1),...
        neuronIdx'];
    
    compiled_data_path=which('compiled_data.mat');
    compiled_data_folder=fileparts(compiled_data_path);
    C=load('compiled_data.mat');
    added=any(ismember(C.neuronList(:,1:3),neuronsListNew(:,1:3),'rows'));
    if added
        replace = questdlg('This experiment has been added already. Replace?',...
            'Replace?','Replace','Do nothing','Do nothing');
        
    else
        replace = 'Replace';
    end
    switch replace
        case 'Replace'
            %save backup
            
            
            if ~all(size(C.nmPeakSig(:,:,1))==size(nmPeakSigNew(:,:,1)))
                odor_inf_all=reconcile_odor_infs(odor_inf,C.odor_inf);
                nmPeakSigNew=updateSigMats(nmPeakSigNew,odor_inf,odor_inf_all);
                C.nmPeakSig=updateSigMats(C.nmPeakSig,C.odor_inf,odor_inf_all);
                C.odor_inf=odor_inf_all;
            end
            
            last_animal=sprintf('%0.0f_%0.0f',C.neuronList(end,1),...
                C.neuronList(end,2)*100+C.neuronList(end,3));
            backupfilename=sprintf('compiled_data_backup%s.mat',last_animal);
            save(fullfile(compiled_data_folder,'Compiled_data_backup',backupfilename),...
                '-struct','C');
            
            %delete existing data from this experiment.
            items2delete=ismember(C.neuronList(:,1:3),neuronsListNew(1,1:3),'rows');
            C.labels(items2delete)=[];
            C.neuronList(items2delete,:)=[];
            C.nmPeakSig(:,:,items2delete)=[];
            C.nmSigList(items2delete)=[];
            
            
            
            C.neuronList=[C.neuronList;neuronsListNew];
            C.labels=[C.labels;labelsNew'];
            C.nmPeakSig=cat(3,C.nmPeakSig,nmPeakSigNew);
            [C.nmSigList,C.odorsList]=dispNeuronSignals(C.nmPeakSig,C.odor_inf);
            save(compiled_data_path,'-struct','C');
    end    
    