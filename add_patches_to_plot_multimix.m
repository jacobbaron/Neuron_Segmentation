function [patches,leg]=add_patches_to_plot_multimix(odor_seq,ax,add_legend,odor_inf)
%     if ~exist('odor_inf','var')
%         odor_inf=load('odor_inf.mat');
%     end
    rng = [-4,-8];
    numLevels = 5; % number of saturation levels
    satVal = linspace(.2,1,numLevels);
     cmap = hsv(length(odor_seq.odors));
     for ii=1:size(cmap,1)
         col = rgb2hsv(cmap(ii,:));
         concVal = rng(1)-log10(str2num(odor_seq.concs{ii}))+1;
         col(2) = satVal(concVal);
         cmap(ii,:) = hsv2rgb(col);
     end
    tCum = cumsum(odor_seq.t);
    odorStartIdx = 1:2:length(tCum);
    odorEndIdx = 2:2:length(tCum);
    yLims = ax.YLim;
    %[ax.YLim(1),ax.YLim(1),ax.YLim(2),ax.YLim(2)];
   % [unique_odors,unique_odor_idx]=unique(odor_conc_inf(odor_starts));
   patches = gobjects(size(odor_seq.concs));
    for ii=1:size(odor_seq.seqArr,2)
        
        odorIdx = odor_seq.seqArr(:,ii);
        
        odorIdxNum = find(odorIdx);
        numOdors = sum(double(odorIdx));
        odorStrs = cellfun(@(x,y)[x,' ',y],odor_seq.concs(odorIdx),odor_seq.odors(odorIdx),...
           'UniformOutput',false);
       odorStrs = [num2str(numOdors),' odors';odorStrs];
       odorTxt = sprintf('%s\n',odorStrs{:});
        %odorStrs = cellfun(@(x,y)[x,' ',y],odor_seq.concs(odorIdx),...
        %    odor_seq.odors(odorIdx),'UniformOutput',false);
        yRnges = linspace(yLims(1),yLims(2),numOdors+1);
        color_seq = cmap(odorIdx,:);
        
        for jj=1:numOdors
            x=[tCum(odorStartIdx(ii)),tCum(odorEndIdx(ii)),...
                tCum(odorEndIdx(ii)),tCum(odorStartIdx(ii))];
            y = [yRnges(jj),yRnges(jj),yRnges(jj+1),yRnges(jj+1)];
            patches(odorIdxNum(jj))=patch(x,y,color_seq(jj,:),...
                'EdgeColor','none','FaceAlpha',0.4,'Tag',odorTxt);
            hold on;    
        end
    end
    odorsUsed = isgraphics(patches);
    odorStrs = cellfun(@(x,y)[x,' ',y],odor_seq.concs,...
            odor_seq.odors,'UniformOutput',false);
     if add_legend==1
        [leg,BLicons]=legend(patches(odorsUsed),odorStrs(odorsUsed),...
        'Location','northeastoutside');
        PatchInLegend = findobj(BLicons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.4)
     elseif add_legend==-1
        [leg,BLicons]=legend(patches(odorsUsed),odorStrs(odorsUsed),...
        'Location','northeastoutside');
        PatchInLegend = findobj(BLicons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.4)
        leg.Visible='off';
     end