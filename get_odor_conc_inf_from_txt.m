function [odor_conc_inf]=get_odor_conc_inf_from_txt(fname_log)
    fid = fopen(fname_log);
    allText = textscan(fid,'%s','delimiter','\n');
    fclose(fid);

    % strain name
    numberOfLines = length(allText{1});
    neuron_type = allText{1,1}{1,1};

    % the odor information
    num_ = 3;
    odor_inf = cell(numberOfLines-num_, 2);
    fmt='%s\t %d\t';
    for i = 1:numberOfLines-num_
        odor_inf(i, :) = textscan(allText{1,1}{i+num_,1}, ...
            fmt, 'Delimiter','\t');
    end
    odor_inf(:,1)=cellfun(@(x)x{1},odor_inf(:,1),'UniformOutput',false);
    not_water=~strcmp(odor_inf(:,1),'Water');
    space=cellfun(@(x)strfind(x,' '),odor_inf(not_water,1),'UniformOutput',false);
    first_space=cellfun(@(x)x(1),space,'UniformOutput',false);
    odor_conc_inf(:,1)=cellfun(@(x)' ',odor_inf(:,1),'UniformOutput',false);
    odor_conc_inf(:,2)=odor_inf(:,1);
    odor_conc_inf(not_water,1)=cellfun(@(x,y)y(1:x-1),first_space,odor_inf(not_water,1),...
        'UniformOutput',false);
    odor_conc_inf(not_water,2)=cellfun(@(x,y)y(x+1:end),first_space,odor_inf(not_water,1),...
        'UniformOutput',false);
    odor_conc_inf(:,3)=odor_inf(:,2);
    any_phenylethanol=strcmp(odor_conc_inf(:,2),'2-phenyl ethanol');
    if any(any_phenylethanol)
        phenylethanols=find(any_phenylethanol);
        for ii=1:length(find(any_phenylethanol))
            odor_conc_inf{phenylethanols(ii),:}='2-phenylethanol'; 
        end
    end
    
end