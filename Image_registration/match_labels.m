function [labels2_reassigned]=match_labels(tform,label1,label2,red_img1)
%red_img1=movie1.aligned_red_img;
%red_img2=movie2.aligned_red_img;
%label1=movie1_tsne.tsne_data.labels;
%label2=movie2_tsne.tsne_data.labels;

label2_reg=imwarp(label2,tform,'OutputView',imref3d(size(label1)),'Interp','nearest');

unique_label1=unique(label1(label1>0));
unique_label2=unique(label2(label2>0));

pw_labels=combvec(unique_label1',unique_label2')';
dist=zeros(size(pw_labels,1),1);
for ii=1:length(dist)
    
    
    dist(ii)=length(find(...
        label1==pw_labels(ii,1) &...
        label2_reg==pw_labels(ii,2)));
    
end
[dist_sort, dist_sort_idx]=sort(dist,'descend');
pw_sorted_labels=pw_labels(dist_sort_idx,:);

label1_assigned=zeros(size(unique_label1));
label2_assigned=zeros(size(unique_label2));

ii=1;
labels2_reassigned=zeros(size(label2));
labels2_reassigned(label2==1)=1;
label1_assigned(1)=1;
label2_assigned(1)=1;
while (~all(label1_assigned))||(~all(label2_assigned))||ii>size(pw_sorted_labels,1)
    close all;
    %if neither label reassigned
    if ~label1_assigned(pw_sorted_labels(ii,1)) && ~label2_assigned(pw_sorted_labels(ii,2))
        f1=figure(1);
        plot_3d_stuff(label1,pw_sorted_labels(ii,1),...
            red_img1,movie1_tsne.tsne_data.cmap(pw_sorted_labels(ii,1),:))
        f2=figure(2);
        f2.Position(1)=f1.Position(1)+f1.Position(3);
        plot_3d_stuff(label2_reg,pw_sorted_labels(ii,2),...
            red_img1,movie1_tsne.tsne_data.cmap(pw_sorted_labels(ii,1),:))
        button = questdlg('Do the neurons match?');
        switch button
            case 'Yes'
                labels2_reassigned(label2==pw_sorted_labels(ii,2))=pw_sorted_labels(ii,1);
                label1_assigned(pw_sorted_labels(ii,1))=1;
                label2_assigned(pw_sorted_labels(ii,2))=1;
            case 'Cancel'
                break;
        end
    end
    ii=ii+1;
end
if (all(label1_assigned) && all(label2_assigned))
    msgbox('Labels from both matched perfectly.');
else
    if (all(label1_assigned))
        leftover_labels=find(~label2_assigned);
        msgbox(sprintf('All labels from movie 1 matched. %d leftover from movie 2',length(leftover_labels)));
        for jj=1:length(leftover_labels)
           labels2_reassigned(label2==leftover_labels(jj))=max(labels2_reassigned(:))+1; 
        end
    end
    if (all(label2_assigned))
        leftover_labels=find(~label1_assigned);
        msgbox(sprintf('All labels from movie 2 matched. %d leftover from movie 1',length(leftover_labels)));
    end
end
