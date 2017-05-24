function [patches,leg]=add_patches_to_plot(odor_conc_inf,ax,add_legend,odor_inf)
    if ~exist('odor_inf','var')
        odor_inf=load('odor_inf.mat');
    end
     odor_list=odor_inf.odor_list;
     odor_concentration_list=odor_inf.odor_concentration_list;
     odor_colormap=odor_inf.odor_colormap;
     not_water=~strcmp(cellfun(@lower,odor_conc_inf(:,2),'UniformOutput',false),...
         'water');
     t_cum=[0,cumsum([odor_conc_inf{:,3}])];
     
     conc_id=cellfun(@(x)find(strcmp(odor_concentration_list,x)),odor_conc_inf(not_water,1));
     odor_id=cellfun(@(x)find(strcmp(odor_list,x)),odor_conc_inf(not_water,2));
     odor_starts=t_cum(not_water);
     odor_ends=t_cum(find(not_water)+1);
     odor_conc_id = (odor_id-1)*length(odor_concentration_list)+conc_id;
     color_seq = odor_colormap(odor_conc_id,:);
    %global odor_concentration_list odor_list odor_colormap
%     odor_starts=[find(abs(diff(odor_seq))>0)+1];
%     odor_ends=[odor_starts(2:end);length(odor_seq)];
%     odor_ends=odor_ends(odor_seq(odor_starts)~=0);
%     odor_starts=odor_starts(odor_seq(odor_starts)~=0);
%     
%     odor_orders=odor_list(floor(odor_seq(odor_starts)/length(odor_concentration_list))+1);
%     conc_orders=odor_concentration_list(rem(odor_seq(odor_starts),length(odor_concentration_list)));
%     odor_info=cellfun(@(x,y)sprintf('%s %s',y,x),odor_orders,conc_orders,...
%         'UniformOutput',false);
    
    
    y=[ax.YLim(1),ax.YLim(1),ax.YLim(2),ax.YLim(2)];
   % [unique_odors,unique_odor_idx]=unique(odor_conc_inf(odor_starts));
    for ii=1:length(odor_starts)
        x=[odor_starts(ii),odor_ends(ii),odor_ends(ii),odor_starts(ii)];
        patches(ii)=patch(x,y,color_seq(ii,:),...
            'EdgeColor','none','FaceAlpha',0.4);
        hold on;        
    end
    odor_conc_str=cellfun(@(x,y)strtrim(sprintf('%s %s',x,y)),odor_conc_inf(:,1),...
        odor_conc_inf(:,2),'UniformOutput',false);
     if add_legend==1
        [leg,BLicons]=legend(patches,odor_conc_str(not_water),...
        'Location','northeastoutside');
        PatchInLegend = findobj(BLicons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.4)
     elseif add_legend==-1
        [leg,BLicons]=legend(patches,odor_conc_str(not_water),...
        'Location','northeastoutside');
        PatchInLegend = findobj(BLicons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.4)
        leg.Visible='off';
     end