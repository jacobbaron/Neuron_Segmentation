function [sigMatNew]=updateSigMats(sigMatOld,oldOdorInf,newOdorInf)
    OdorListOld=oldOdorInf.odor_list;
    ConcListOld=oldOdorInf.odor_concentration_list;
    OdorListNew=newOdorInf.odor_list;
    ConcListNew=newOdorInf.odor_concentration_list;
    [concExist,concExist_idx]=ismember(ConcListNew,ConcListOld);
    [odorExist,odorExist_idx]=ismember(OdorListNew,OdorListOld);
    sigMatNew=nan(length(ConcListNew),length(OdorListNew),size(sigMatOld,3));
    sigMatNew(concExist,odorExist,:)=...
        sigMatOld(concExist_idx(concExist),odorExist_idx(odorExist),:);