function [odors,nm_sig_mat,nm_peak_sig_mat,...
    s2n_mat,s2n_peak_mat,neuron_fire,neuron_fire_mat]=...
    calc_nm_sig(odor_seq,sig,odor_inf)

    if ~exist('odor_inf','var')
        odor_inf=load('odor_inf.mat');            
    end
    
    odor_list=odor_inf.odor_list;
    odor_concentration_list=odor_inf.odor_concentration_list;
    
    nm_sig_mat=cell(length(odor_concentration_list),...
        length(odor_list),length(sig));
    nm_peak_sig_mat=zeros(length(odor_concentration_list),...
        length(odor_list),length(sig));
    s2n_mat=cell(length(odor_concentration_list),...
        length(odor_list),length(sig));
    s2n_peak_mat=zeros(length(odor_concentration_list),...
        length(odor_list),length(sig));
    neuron_fire_mat=zeros(length(odor_concentration_list),...
        length(odor_list),length(sig));
    odor_changes=find(diff(odor_seq));
    %odor_starts=find(+1;
    %odor_ends=find(diff(odor
    odor_ends=odor_changes(find(odor_seq(odor_changes)~=0));
    odor_starts=odor_changes(find(odor_seq(odor_changes+1)~=0))+1;
    for jj=1:length(sig)
        nm_peak_sig=nan(length(odor_concentration_list),length(odor_list));
        nm_sig=cell(length(odor_concentration_list),length(odor_list));
        s2n=cell(length(odor_concentration_list),length(odor_list));
        s2n_peak=nan(length(odor_concentration_list),length(odor_list));
        neuron_fire_matSM=nan(length(odor_concentration_list),length(odor_list));
        %create a matrix of NaNs/cell array, rows are concentrations, columns are odors
        %sig_diff=[0,zscore(diff(sig{jj}))];
        sig_diff=[0,0,zscore(sig{jj}(3:end)-sig{jj}(1:end-2))];
        last_neuron_fire=0;
        for ii=1:length(odor_starts)
            if ii>1
                t_NoOdor=(odor_starts(ii)-1)-(odor_ends(ii-1)+1);
                if t_NoOdor<5
                    t_avg=odor_ends(ii-1)+1:odor_starts(ii)-1;
                else
                    t_avg=(odor_starts(ii)-6):(odor_starts(ii)-1);
                end
                if ~last_neuron_fire %if last odor made neuron fire, do not 
                                     %use dead time to calculate f0
                    f0_noise=std(sig{jj}(t_avg));
                    f0=mean(sig{jj}(t_avg));
                end
            else %i.e. case for first odor
                t_avg=1:odor_starts(ii);
                %set noise to be std of points before odor delivered. 
                f0_noise=std(sig{jj}(t_avg));
                f0=mean(sig{jj}(t_avg));
            end
            
            if ii==length(odor_starts)
                odor_period=odor_starts(ii):length(odor_seq);
            else
                odor_period=odor_starts(ii):odor_starts(ii+1)-1;
            end
            [odors{ii,1}, odors{ii,2}, inds ] = compute_odor_conc(odor_seq(odor_starts(ii)),odor_inf);
            nm_sig{inds(2),inds(1)} = ( sig{jj}(odor_period) - f0) / f0;
          
            s2n{inds(2),inds(1)}=(sig{jj}(odor_period)-f0)/f0_noise;
            s2n_peak(inds(2),inds(1)) = max(s2n{inds(2),inds(1)});
            %disp(s2n_peak(inds(2),inds(1)));
            neuron_fire(jj,ii)=any(sig_diff(odor_period)>1.5);
            if last_neuron_fire && ~neuron_fire(jj,ii) %if the last neuron fired, but this neuron didn't
                nm_peak_sig(inds(2),inds(1)) = 0;
            else                
                nm_peak_sig(inds(2),inds(1)) = max(nm_sig{inds(2),inds(1)});
            end
            
            
            last_neuron_fire=neuron_fire(jj,ii);
            neuron_fire_matSM(inds(2),inds(1))=neuron_fire(jj,ii);
        end
        nm_peak_sig_mat(:,:,jj)=nm_peak_sig;
        nm_sig_mat(:,:,jj)=nm_sig;
        s2n_mat(:,:,jj)=s2n;
        s2n_peak_mat(:,:,jj)=s2n_peak;
        neuron_fire_mat(:,:,jj) = neuron_fire_matSM;
    end
