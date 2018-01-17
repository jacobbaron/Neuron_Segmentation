function [odor_seq] =  correct_spelling_dumbass(odor_seq)
incorrectSpelling = [{'methyl phenyl sulphide'},{'4-methyl-5-vinithiazole'},{'2-phenyl ethanol'},...
    {'2,5 dimethylpyrazine'}];
correctSpelling =  [{'methyl phenyl sulfide'},{'4-methyl-5-vinylthiazole'},{'2-phenylethanol'},...
    {'2,5-dimethylpyrazine'}];
for ii=1:length(incorrectSpelling)
    idx = strcmp(odor_seq.odors,incorrectSpelling{ii});
    if any(idx)
        odor_seq.odors{idx} = correctSpelling{ii};
    end
    
end