Fpass = 1;
Fstop = 1.1;
Apass = 0.5;
Astop = 65;
tbig=linspace(t(1),t(end),1000);
%Fs = 1/(t(2)-t(1));
fsBig=1/(tbig(2)-tbig(1));
%nm_sigs_interpBig=interp1(t,nm_sigs_interp',linspace(t(1),t(end),1000),'spine')';
d = designfilt('lowpassiir', ...
  'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
  'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
  'DesignMethod','butter','SampleRate', fsBig);


%nm_sigs_filt=filter(d,nm_sigs_interpBig')';
t_filt_interp=t(1):1/fsBig:t(end);
filt_interp=interp1(t,nf_ave,t_filt_interp);
for ii=1:size(nm_sigs_interpBig,1)
   nm_sigs_filt(ii,:)=smooth(nm_sigs_interpBig(ii,:),30); 
   nm_sigs_deconv(ii,:)=deconv(nm_sigs_interpBig(ii,:),filt_interp);
end

%% 
A=zeros(size(nm_sigs_interpBig,2));
for ii=1:(size(nm_sigs_interpBig,2)-length(t_filt_interp))
   A(ii,ii:ii+length(t_filt_interp)-1)=filt_interp;
end
nm_sigs_deconv=A^(-1)*(A) * nm_sigs_interpBig(1,:);

%% 

% nm_sig_deriv=central_difference(nm_sigs_filt',tbig')';
% odor_seq_big=interp1(t,odor_seq_interp,tbig,'nearest')';
% odor_starts=find(diff(odor_seq_big)>0)+1;
% for ii=1:length(odor_starts)
%    odor_ends(ii)=find(t>=t(odor_starts(ii))+5,1);
%     
% end
% nm_sig_peak=zeros(size(nm_sigs_interp,1),length(odor_starts));
% for ii=1:size(nm_sigs_interp,1)
%     for jj=1:length(odor_starts)
%        nm_sig_peak(ii,jj)=max(nm_sigs_interp(ii,odor_starts(jj):odor_ends(jj)));         
%     end    
% end

%
testNeuron=10;
figure(3);
subplot(3,1,1)
plot(tbig,nm_sigs_filt(testNeuron,:))
add_patches_to_plot(tbig,interp1(t,odor_seq_interp,tbig,'nearest')',gca,1)
subplot(3,1,2)
semilogy(nm_sigs_deconv(testNeuron,1:750)')
add_patches_to_plot(tbig,interp1(t,odor_seq_interp,tbig,'nearest')',gca,0)
subplot(3,1,3)
spectrogram(nm_sigs_interpBig(testNeuron,:),20,1,50,fsBig,'yaxis')

figure(4);
imagesc(nm_sigs_interp)
figure(5);
imagesc(central_difference(nm_sigs_filt',tbig'/60)')

% %vtool(d)