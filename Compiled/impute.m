function [signal_imputed]=impute(signal,labels)
    unique_labels=unique(labels);
    signal_imputed=signal;
    for ii=1:length(unique_labels)
        sig_label=signal(labels==ii,:);
        for jj=1:size(sig_label,2)
            missing=isnan(sig_label(:,jj));
            if all(missing)
               sig_label(:,jj)=0; 
            else
               sig_label(missing,jj) = mean(sig_label(~missing,jj));
            end
        end
        signal_imputed(labels==ii,:)=sig_label;
    end



end