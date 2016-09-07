ORN_filt=load('filter_data_4_Jacob.mat');
tFilt=ORN_filt.t(ORN_filt.t>0);
filt=ORN_filt.nf_ave(ORN_filt.t>0);
dtFilt=diff(tFilt(1:2));
tBig=tFilt(1):dtFilt:max(t);

sigInterpBig=interp1(t,nm_sigs_interp',tBig,'linear','extrap')';

noise=random('normal',zeros(size(tBig)),0.2*ones(size(tBig)));
testneuron=8;
figure(1);
subplot(3,1,1)
plot(t,nm_sigs_interp(testneuron,:))
subplot(3,1,2)
plot(tBig,sigInterpBig(testneuron,:))
subplot(3,1,3)
filt_big=zeros(1,size(sigInterpBig,2));
filt_big(1:length(filt))=filt;
SigFFT=fft(sigInterpBig')';
FiltFFT=fft(filt_big);
NoiseFFT=fft(noise);
subplot(3,1,3)
deconv=(conj(FiltFFT).*SigFFT(testneuron,:))./...
    (abs(FiltFFT).^2.*SigFFT(testneuron,:)+NoiseFFT);
plot(tBig,smooth(real(fft(deconv))));

% 
%% 
 A=zeros(size(sigInterpBig,2)-length(filt),size(sigInterpBig,2));
 
 for ii=1:size(A,1)-length(filt)
    
   
        A(ii,ii:ii+length(filt)-1)=fliplr(filt');
 end
 testneuron=6;
 figure(1);
 
 soln=sigInterpBig(testneuron,length(filt)+1:end)'\A;
 
 
plotyy(t,nm_sigs_interp(testneuron,:),tBig,smooth(soln,50))

 
 
 
 xlim([0 max(t)])
 %nm_sigs_deconv=A^(-1)*(A) * sigInterpBig(1,:)';