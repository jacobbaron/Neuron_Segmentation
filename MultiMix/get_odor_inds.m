function [odorInds] = get_odor_inds(odor_seq)
%finds indicies in odor_inf file corresponding to odor/concentration
for ii=1:length(odor_seq.odors)
    try
        odorInds(ii,1) = find(strcmp(odor_seq.odors{ii},odor_seq.odor_inf.odor_list));
    catch
        1;
    end
%[~,~,odorInds(:,1)] = intersect(odor_seq.odors,odor_seq.odor_inf.odor_list,'stable');
%[~,~,id] =intersect(odor_seq.concs,odor_seq.odor_inf.odor_concentration_list,'stable');
end
concsNum = cellfun(@str2num,odor_seq.concs);
concListNum = cellfun(@str2num,odor_seq.odor_inf.odor_concentration_list,...
    'UniformOutput',false);

for ii=1:length(concsNum)
    tmp = cellfun(@(x)log10(concsNum(ii))==log10(x),...
        concListNum,'UniformOutput',false);
    odorInds(ii,2) = find(cellfun(@(x) length(x)==1 && all(x),tmp));
 
end
1;