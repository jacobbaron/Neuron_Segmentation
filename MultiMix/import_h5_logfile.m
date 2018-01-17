 function [odorSeq,flowData] = import_h5_logfile(varargin)

if nargin==1
    fname = varargin{1};
else
    [fname,pathname] = uigetfile('log_*.h5');
end

%fname = 'log_MultMixFlowTest_run101.h5';
fileInf = h5info(fname);

odorSeq.concs = h5read(fname,'/concentration Names');
odorSeq.odors = h5read(fname,'/odorNames');

odorSeq.t = h5read(fname,'/seqTime');
seqArr = h5read(fname,'/sequenceArray');
odorSeq.seqArr = cellfun(@(x)strcmp(x,'True'),seqArr);

flowData.t = h5read(fname,'/t');
flowData.P = h5read(fname,'/pressures');
flowData.F = h5read(fname,'/flowRates');