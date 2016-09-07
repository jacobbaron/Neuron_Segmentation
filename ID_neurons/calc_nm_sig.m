function [odors,nm_sig_mat,nm_peak_sig_mat]=calc_nm_sig(odor_seq,sig)
    load odor_inf.mat     
    nm_sig_mat=cell(length(odor_concentration_list),...
        length(odor_list),length(sig));
    nm_peak_sig_mat=zeros(length(odor_concentration_list),...
        length(odor_list),length(sig));
    
    odor_changes=find(diff(odor_seq));
    %odor_starts=find(+1;
    %odor_ends=find(diff(odor
    odor_ends=odor_changes(find(odor_seq(odor_changes)~=0));
    odor_starts=odor_changes(find(odor_seq(odor_changes+1)~=0))+1;
    for jj=1:length(sig)
        nm_peak_sig=nan(length(odor_concentration_list),length(odor_list));
        nm_sig=cell(length(odor_concentration_list),length(odor_list));

        %create a matrix of NaNs/cell array, rows are concentraitons, columns are odors
        for ii=1:length(odor_starts)
            if ii>1
                t_NoOdor=(odor_starts(ii)-1)-(odor_ends(ii-1)+1);
                if t_NoOdor<5
                    t_avg=odor_ends(ii-1)+1:odor_starts(ii)-1;
                else
                    t_avg=(odor_starts(ii)-6):(odor_starts(ii)-1);
                end
            else
                t_avg=1:odor_starts(ii);
            end

            f0=mean(sig{jj}(t_avg));


            [odors{ii,1}, odors{ii,2}, inds ] = compute_odor_conc(odor_seq(odor_starts(ii)));
            nm_sig{inds(2),inds(1)} = ( sig{jj}(odor_starts(ii):odor_ends(ii)) - f0) / f0;
            nm_peak_sig(inds(2),inds(1)) = max(nm_sig{inds(2),inds(1)});
        end
        nm_peak_sig_mat(:,:,jj)=nm_peak_sig;
        nm_sig_mat(:,:,jj)=nm_sig;
    end
