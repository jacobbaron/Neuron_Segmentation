function [odorInds] = get_odor_inds(odor_seq)

for ii=1:length(odor_seq.odors)
        odorInds(ii,1) = find(strcmp(odor_seq.odors{ii},odor_seq.odor_inf.odor_list));
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