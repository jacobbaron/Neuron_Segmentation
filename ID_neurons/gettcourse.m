tCourseNeuron.t=cell(length(sigs),1);
tCourseNeuron.odorSeq=cell(length(sigs),1);
tCourseNeuron.sig=cell(length(sigs),1);
j0=1;
for ii=1:length(sig_expts)
    jf=j0+length(sig_expts{ii})-1;
    tCourseNeuron.sig(j0:jf)=sig_expts{ii};
    tCourseNeuron.t(j0:jf)=cellfun(@(x)t_expts{ii},sig_expts{ii},'UniformOutput',false);
    tCourseNeuron.odor_seq(j0:jf)=cellfun(@(x)odor_seq{ii},sig_expts{ii},'UniformOutput',false);
    j0=jf+1;
end