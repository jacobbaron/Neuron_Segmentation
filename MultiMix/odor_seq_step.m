function [odorSeqStep] = odor_seq_step(odor_seq,t)
tCum = cumsum(odor_seq.t);
startIdx = 2:2:length(tCum);
endIdx = 3:2:length(tCum);
odorSeqStep = zeros(size(t));
for ii=1:length(startIdx)
    idx = t>tCum(startIdx(ii)) & t<tCum(endIdx(ii));
    odorSeqStep(idx) = ii;
end
1;



end