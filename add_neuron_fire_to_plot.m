function add_neuron_fire_to_plot(t,odor_seq,ax,neuron_fire)
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
        
        %x=[t(odor_starts(ii)),t(odor_ends(ii)),t(odor_ends(ii)),t(odor_starts(ii))];
        dim=[t(odor_starts(ii)),ax.YLim(1),t(odor_ends(ii))-t(odor_starts(ii)),...
            ax.YLim(2)-ax.YLim(1)];
        if neuron_fire(ii)
            text(t(odor_starts(ii)),ax.YLim(1),'\uparrow','fontsize',20)
            hold on;        
        end
    end
