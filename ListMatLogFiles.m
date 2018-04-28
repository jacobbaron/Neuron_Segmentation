function logMatFileList = ListLogFiles( path )

allFiles = dir(path); 
possibleExt = {'.mat','.h5l'};
%list all the log, .mat file 
logMatFileList = cell(0);
for i = 1:length(allFiles)
    if (strcmp(allFiles(i).name(max(end-3, 1):end),'.h5l') || strcmp(allFiles(i).name(max(end-3, 1):end),'.mat')) && ...
            strcmp(allFiles(i).name(1:4), 'log_')
        logMatFileList = [logMatFileList; allFiles(i).name];
    end
end

end
