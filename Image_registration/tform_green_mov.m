function [alignedGreenImg] = tform_green_mov(fname,r,side,tform1,tform2)
    logMatFileList = ListMatLogFiles( pwd );
    f_list_log = FindBatchMatLogFile({fname}, logMatFileList);
     img_data = import_h5_file(1,fname,f_list_log{1});
     if 



end