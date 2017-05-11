function [sigMatNew,oldOdorInf]=updateSigMats(sigMatOld,oldOdorInf,newOdorInf)
    
    
    OdorListOld=oldOdorInf.odor_list;
    ConcListOld=oldOdorInf.odor_concentration_list;
    OdorListNew=newOdorInf.odor_list;
    ConcListNew=newOdorInf.odor_concentration_list;
    
    if length(unique(OdorListOld))~=length(OdorListOld) %means there are duplicates! :(
        [~,idx]=unique(OdorListOld,'stable');
        dupe_odor_idx=idx(find(diff(idx)>1))+1;
        dupe_odors=OdorListOld(idx(find(diff(idx)>1))+1);
        for ii=1:length(dupe_odors)
           odor_pos=find(cellfun(@(x)strcmp(x,dupe_odors(ii)),OdorListOld));
           data_in_odor=any(any(sigMatOld(:,odor_pos,:),3),1);
           if any(data_in_odor)
              odor2remove=odor_pos(~data_in_odor);
           else
               odor2remove=odor_pos(2:end);
           end
           sigMatOld(:,odor2remove,:)=[];
           OdorListOld(odor2remove)=[]; 
        end
    end
    oldOdorInf.odor_list=OdorListOld;
    if length(unique(ConcListOld))~=length(ConcListOld) %means there are duplicates! :(
        [~,idx]=unique(OdorListOld,'stable');
        dupe_odor_idx=idx(find(diff(idx)>1))+1;
        dupe_odors=ConcListOld(idx(find(diff(idx)>1))+1);
        for ii=1:length(dupe_odors)
           odor_pos=find(cellfun(@(x)strcmp(x,dupe_odors(ii)),ConcListOld));
           data_in_odor=any(any(sigMatOld(odor_pos,:,:),1),3);
           if any(data_in_odor)
              odor2remove=odor_pos(~data_in_odor);
           else
               odor2remove=odor_pos(2:end);
           end
           sigMatOld(odor2remove,:,:)=[];
           ConcListOld(odor2remove)=[]; 
        end
    end
    oldOdorInf.odor_concentration_list=ConcListOld;
    [concExist,concExist_idx]=ismember(ConcListNew,ConcListOld);
    [odorExist,odorExist_idx]=ismember(OdorListNew,OdorListOld);
    sigMatNew=nan(length(ConcListNew),length(OdorListNew),size(sigMatOld,3));
    sigMatNew(concExist,odorExist,:)=...
        sigMatOld(concExist_idx(concExist),odorExist_idx(odorExist),:);