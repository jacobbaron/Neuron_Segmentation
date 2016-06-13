function [group_labels]=lsbdc_elki(data,k,alpha)
%k, number of points in cluster
%alpha, density drop threshold

save data.out data -ASCII
if nargin==1
    k=50;
    alpha=.8;
end

elki_dir=fileparts(which('elki.bat'));
elki_path=strcat(elki_dir,filesep,'elki',filesep,'elki-0.7.1.jar');
dep_path=strcat(elki_dir,filesep,'dependency',filesep,'*');
elki_dir_path=strcat(elki_dir,filesep,'*');
in_path=fullfile(pwd,'data.out');
out_path=fullfile(pwd,'output');
elki_script_path=strcat(elki_dir,filesep,'elki_script.bat');
fileID=fopen(elki_script_path,'w');
elki_script=fprintf(fileID,...
    ['@echo off \r\nstart "ELKI" "javaw.exe" -cp "%s;%s;%s" de.lmu.ifi.dbs.elki.application.KDDCLIApplication ^\r\n',...
    '-verbose ^\r\n-dbc.in "%s" ^\r\n',...
    '-algorithm clustering.gdbscan.LSDBC ^\r\n',...
    '-lsdbc.k %0.0f ^\r\n',...
    '-lsdbc.alpha %0.1f ^\r\n',...
    '-resulthandler ResultWriter ^\r\n',...
    '-out "%s" ^\r\n',...
    '-out.silentoverwrite'],elki_path,elki_dir_path,dep_path,in_path,k,alpha,out_path);
fclose(fileID);

[status,cmdout]=system(elki_script_path);
disp(cmdout);
rehash toolbox;
output_dir=dir(strcat(out_path,filesep,'cluster_*'));
group_labels=zeros(size(data,1),1);
for ii=0:length(output_dir)-1
   cluster_fn=strcat(out_path,filesep,'cluster_',num2str(ii),'.txt');
   
   fileID=fopen(cluster_fn,'r');
   cluster_id=fscanf(fileID,'%*s %*s %*s %d',1);
   cluster_size=fscanf(fileID,'%*s %*s %*s %*s\n%*s %*s %*s %*s %*s\n%*s %*s %*s %d\n',1);
   idx=fscanf(fileID,strcat('ID=%d',repmat(' %*s',1,size(data,2)),'\n'),[cluster_size,1]);
   group_labels(idx)=cluster_id+1;
   fclose(fileID);
end

% 
delete(in_path);
% 
% rehash toolbox;
rmdir(out_path,'s');




end
