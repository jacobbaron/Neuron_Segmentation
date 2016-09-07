function [patches]=add_patches_to_plot(t,odor_seq,ax,add_legend)
    load('odor_inf.mat')
    %global odor_concentration_list odor_list odor_colormap
    odor_starts=[find(abs(diff(odor_seq))>0)+1];
    odor_ends=[odor_starts(2:end);length(odor_seq)];
    odor_ends=odor_ends(odor_seq(odor_starts)~=0);
    odor_starts=odor_starts(odor_seq(odor_starts)~=0);
    
    odor_orders=odor_list(floor(odor_seq(odor_starts)/length(odor_concentration_list))+1);
    conc_orders=odor_concentration_list(rem(odor_seq(odor_starts),length(odor_concentration_list)));
    odor_info=cellfun(@(x,y)sprintf('%s %s',y,x),odor_orders,conc_orders,...
        'UniformOutput',false);
    
    
    y=[ax.YLim(1),ax.YLim(1),ax.YLim(2),ax.YLim(2)];
    [unique_odors,unique_odor_idx]=unique(odor_seq(odor_starts));
    for ii=1:length(odor_starts)
        x=[t(odor_starts(ii)),t(odor_ends(ii)),t(odor_ends(ii)),t(odor_starts(ii))];
        patches(ii)=patch(x,y,odor_colormap(odor_seq(odor_starts(ii)),:),...
            'EdgeColor','none','FaceAlpha',0.4);
        hold on;        
    end
    
        [leg,BLicons]=legend(patches(sort(unique_odor_idx)),odor_info(sort(unique_odor_idx)),...
        'Location','northeastoutside');
        PatchInLegend = findobj(BLicons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.4)
    if ~add_legend
        leg.Visible='off';
    end