C=load('compiled_data.mat');
orns={'Or33b','Or45a','Or83a','Or35a','Or42a','Or59a','Or1a','Or45b','Or24a','Or67b','Or85c','Or13a','Or30a','Or82a','Or22c','Or42b','Or74a','Or94a'};
odors={'1-pentanol';'3-pentanol';'6-methyl-5-hepten-2-ol';'3-octanol';'trans-3-hexen-1-ol';'methyl phenyl sulfide';'anisole';'2-acetylpyridine';'2,5-dimethylpyrazine';'pentyl acetate';'geranyl acetate';'2-methoxyphenyl acetate';'trans,trans-2,4-nonadienal';'4-methyl-5-vinylthiazole';'4,5-dimethylthiazole';'4-hexen-3-one';'2-nonanone';'acetal';'2-phenylethanol'};

orns=cellfun(@(x)strtrim(strrep(x,'Or','')),orns,'UniformOutput',false);

concList=(-8:-4);
idx_ORN=[3;6;8;18;15;9;13;10;1;4;7;12;11;14;2;5;16;17];
idx_odor=[15;12;14;7;8;6;19;9;1;10;5;17;4;3;11;2;16;18;13];
ornsorder=orns(idx_ORN);
odorsorder=odors(idx_odor);
[ismem,idx]=ismember(ornsorder',uniqueORNs);
uniqueORNs=unique(C.labels);
[usedConcIdx,usedOdorIdx] = find(~all(isnan(C.nmPeakSig),3));
usedOdorConcIdx=find(~all(isnan(C.nmPeakSig),3));
usedOdor=C.odor_inf.odor_list(usedOdorIdx);
usedConc=C.odor_inf.odor_concentration_list(usedConcIdx);
usedOdorConc=cellfun(@(x,y)sprintf('%s %s',x,y),usedConc,usedOdor,'UniformOutput',false);

[ismemodor,idxodor]=ismember(usedOdor,odorsorder);
[odorsort,odorIdxSort]=sort(idxodor);

%for ii=1:length(uniqueORN)
ornSigMat=cellfun(@(x)nanmean(C.nmPeakSig(:,:,find(strcmp(x,C.labels))),3),uniqueORNs,'UniformOutput',false);
ornSig=cell2mat(cellfun(@(x)x(usedOdorConcIdx'),ornSigMat,'UniformOutput',false));



figure;
imagesc(ornSig(idx,odorIdxSort)')
ax=gca;
ax.XTick=1:length(uniqueORNs);
ax.XTickLabel=uniqueORNs(idx);
ax.YTick=1:length(usedOdorConc);
ax.YTickLabel=usedOdorConc(odorIdxSort);
ax.XTickLabelRotation=-90;
colormap(jet);
colorbar;
