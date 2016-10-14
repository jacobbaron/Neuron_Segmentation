function [odor_inf_all]=reconcile_odor_infs(odor_inf1,odor_inf2)
    if length(odor_inf1.odor_list)~=length(odor_inf2.odor_list)
        odor_inf_all.odor_list=unique([odor_inf1.odor_list;odor_inf2.odor_list],...
            'stable');
    else
        odor_inf_all.odor_list=odor_inf1.odor_list;
    end
    if length(odor_inf1.odor_concentration_list)~=length(odor_inf2.odor_concentration_list)
        odor_inf_all.odor_concentration_list=unique([odor_inf1.odor_concentration_list;...
            odor_inf2.odor_concentration_list]);
    else
        odor_inf_all.odor_concentration_list=odor_inf1.odor_concentration_list;
    end
    odor_inf_all.odor_colormap=gen_odor_colormap(odor_inf_all.odor_list,...
        odor_inf_all.odor_concentration_list);
    1;