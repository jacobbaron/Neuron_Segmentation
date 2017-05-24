function logFileName = FindSingleMatLogFile(movieFileName, logMatFileList)

    %figure out the name domain and index domain of the movie file name
    markIndMovie1 = strfind(movieFileName, 'run');
    markIndMovie2 = strfind(movieFileName, '.');
    nameDomainMovie = movieFileName(1 : markIndMovie1 - 1);
    indDomainMovie = movieFileName(markIndMovie1 + 3: markIndMovie2-1);

    %Frstly check the index domain, if there is only one index, use the one
    %found, if there are multiple check if the name domain match
    pairLogFileNameTemp = cell(0);
    for i = 1:length(logMatFileList)
        logFileName = logMatFileList{i};
        markIndLog1 = strfind(logFileName, 'run');
        markIndLog2 = strfind(logFileName, '.');
        indDomainLog = logFileName(markIndLog1 + 3: markIndLog2-1);

        if strcmp(indDomainLog, indDomainMovie)
            nameDomainLog = logFileName(5 : markIndLog1-1);
            if strncmpi(nameDomainLog, nameDomainMovie, 4)
                pairLogFileNameTemp = [pairLogFileNameTemp; logMatFileList{i}];
            end
        end
    end
    
    if length(pairLogFileNameTemp) ~= 1  % if can not find one log file
        % manually chose one
        if ismac  % mac version 'uigetfile' has a bug on shwoing the dialog title
        	disp(['Select log file for movie: ', movieFileName]);
        end
        
        logFileName = uigetfile('log_*.mat', ['Select log file for movie: ', movieFileName]);
    else
        logFileName = pairLogFileNameTemp{1};
    end

end