function parallel_progress(N,h)
filename=fullfile(tempdir,'progress.bin');
    if ~exist(filename,'file')
        fid=fopen(filename,'w');
        fwrite(fid,1,'uint8');
        ii=1;
    else        
        fid=fopen(filename,'r+');
        ii=fread(fid)+1;
        frewind(fid);
        fwrite(fid,ii,'uint8');
    end
    fclose(fid);
    if ii==N
        delete(filename);
    end
    fprintf('Progress %d/%d',ii,N);
    end
    