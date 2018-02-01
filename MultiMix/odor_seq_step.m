function [odorSeqStep] = odor_seq_step(odor_seq,t)
tCum = cumsum(odor_seq.t);
startIdx = 1:2:length(tCum)-1;
endIdx = 2:2:length(tCum);
odorSeqStep = zeros(size(t));
for ii=1:length(startIdx)
    idx = t>tCum(startIdx(ii)) & t<tCum(endIdx(ii));
    odorSeqStep(idx) = ii;
end
1;



end