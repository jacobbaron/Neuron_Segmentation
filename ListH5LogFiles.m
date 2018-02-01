function logH5FileList = ListH5LogFiles( path )

allFiles = dir(path); 

%list all the log, .mat file 
logH5FileList = cell(0);
for i = 1:length(allFiles)
    if strcmp(allFiles(i).name(max(end-2, 1):end),'.h5') && ...
            strcmp(allFiles(i).name(1:4), 'log_')
        logH5FileList = [logH5FileList; allFiles(i).name];
    end
end

end
