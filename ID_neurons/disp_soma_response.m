function []=disp_soma_response(odor_conc_inf)

load AveSomaResponses.mat


idx_ORN=[3;6;8;18;15;9;13;10;1;4;7;12;11;14;2;5;16;17];
idx_odor=[15;12;14;7;8;6;19;9;1;10;5;17;4;3;11;2;16;18;13];

dataMean=dataMean(idx_odor,idx_ORN,:);
dataSEM=dataSEM(idx_odor,idx_ORN,:);
odorList=odorList(idx_odor);
infoORNList=infoORNList(idx_ORN);

not_water=cellfun(@(x)~strcmp(x,'water'),odor_conc_inf(:,2));
odor_conc=odor_conc_inf(not_water,1:2);
%make odor_conc converable to double
%odor_conc=cellfun(@(x)strrep(x,'10^','e'),odor_conc(:,1),'UniformOutput',false);

conc_num=cellfun(@(x)str2num(x),odor_conc(:,1),'UniformOutput',false);
if any(cellfun(@isempty,conc_num))
    conc_num{cellfun(@isempty,conc_num)}=NaN;
end
conc_num_log=(round(log10([conc_num{:}])));
concListLog=log10(concList);

[conc_tf,conc_id] = ismember(conc_num_log',concListLog);
[odor_tf, odor_id] = ismember(odor_conc(:,2),odorList);
odor_conc_tf = conc_tf & odor_tf;

odor_conc_list=odor_conc(odor_conc_tf,:);
odor_conc_id=[conc_id(odor_conc_tf),odor_id(odor_conc_tf)];
%odor_conc_str=cellfun(@(x,y)sprintf('%s %s',x,y),odor_conc_list(:,1),odor_conc_list(:,2),...
%    'UniformOutput',false);

unique_odor_conc_id=fliplr(unique(fliplr(odor_conc_id),'rows'));
response_mat=zeros(size(unique_odor_conc_id,1),size(dataMean,2));
for ii=1:length(unique_odor_conc_id)
    response_mat(ii,:)=dataMean(unique_odor_conc_id(ii,2),:,unique_odor_conc_id(ii,1));

end
%[odor_ordered,~,odor_order]=intersect(odorList,odor','stable');
%response_mat_ordered=[];
% %conc_order=[];
% for ii=1:length(odor_ordered)
%     new_conc=find(strcmp(odor,odor_ordered{ii}));
%     conc_order=[conc_order,new_conc];
%     response_mat_ordered=[response_mat_ordered;response_mat(new_conc,:)];  
% end
f=figure;
imagesc(response_mat)
ax=gca;
ax.XTick=1:size(response_mat,2);
ax.YTick=1:size(response_mat,1);
ax.XTickLabel=infoORNList;
ax.XTickLabelRotation=-45;
ax.XAxisLocation='Top';

conc_str=cellfun(@(x)num2str(x,'%0.0e'),num2cell(concList),'UniformOutput',false);


ax.YTickLabel=cellfun(@(x,y)sprintf('%s %s',x,y),...
    conc_str(unique_odor_conc_id(:,1)),odorList(unique_odor_conc_id(:,2)),...
    'UniformOutput',false);
colormap(jet) 
colorbar
ax.Units='pixels';
ratio=size(response_mat,2)/size(response_mat,1);
ax_width=ax.Position(3);
fig_width=f.Position(3);
margins=fig_width-ax_width;
f.Position(3)=ax_width*ratio+margins;
ax.Position(3)=ax_width*ratio;
ax.Units='normalized';
axis equal; 
grid on;

