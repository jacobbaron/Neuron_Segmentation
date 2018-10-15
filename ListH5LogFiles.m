function logH5FileList = ListH5LogFiles( path )
ext = '.h5l';
allFiles = dir(fullfile(path,['*',ext])); 

%list all the log, .mat file 
logH5FileList = cell(0);

for i = 1:length(allFiles)
    if strcmp(allFiles(i).name(end-length(ext)+1:end),'.h5l') && ...
            strcmp(allFiles(i).name(1:4), 'log_')
        logH5FileList = [logH5FileList; allFiles(i).name];
    end
end

end
