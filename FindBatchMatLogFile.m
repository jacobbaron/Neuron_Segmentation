function pairedLogFileList = FindBatchMatLogFile(movieFileList, logMatFileList)
    % show a wait bar for log file searching
    h = waitbar(0, 'Paring the movie files and log files.');

    pairedLogFileList = cell(1, length(movieFileList));
    for i = 1:length(movieFileList)
        waitbar(i / length(movieFileList))
        movieFileName = movieFileList{i};
        
        % look for log file for each movie files
        logFileName = FindSingleH5LogFile(movieFileName, logMatFileList);
        
        % save the log files into a list
        pairedLogFileList{i} = logFileName;
    end

    % display for debuging
    debugFLag = 0;
    if debugFLag
        disp('Found log files for selected movies:');
        for i = 1:length(movieFileList)
            disp([movieFileList{i}, '---', pairedLogFileList{i}]);
        end 
    end
    
    %close the wait bar
    close(h);
end