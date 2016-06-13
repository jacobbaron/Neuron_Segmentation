function [peaksig,halfmax,foreground]=determine_background(img)

close all;
figure
h1=histogram(reshape(img,[],1),'normalization','probability');
hold on
h2=histogram(reshape(img(1:20,1:20,:),[],1),'normalization','probability');
h1.BinEdges=h2.BinEdges;
figure
edgez=h1.BinEdges(1:end-1);
diffz=h1.Values-h2.Values;
gtz=diffz>0;
diffz=smooth(diffz,100)';
plot(edgez,smooth(diffz,100))


peaksig=edgez(find(diffz==max(diffz),1));

halfmax=edgez(find(diffz<=max(diffz)/2 & edgez>peaksig,1));

if ~exist(halfmax)
    foreground=any(img>halfmax,4);
end