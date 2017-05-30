function [sig_mat_out, odor_inf_out] = merge_sig_mats(sig_mat1,sig_mat2,...
    odor_inf1,odor_inf2)
if ~isempty(sig_mat1)
    odor_inf_out = reconcile_odor_infs(odor_inf1,odor_inf2);

    sigMat1new = updateSigMats(sig_mat1,odor_inf1,odor_inf_out);
    sigMat2new = updateSigMats(sig_mat2,odor_inf2,odor_inf_out);

    sig_mat_out = cat(3,sigMat1new,sigMat2new);
else
    sig_mat_out = sig_mat2;
    odor_inf_out = odor_inf2;
end