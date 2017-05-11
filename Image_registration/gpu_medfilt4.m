function [ img_filt ] = gpu_medfilt4( img_stack, txt ,maxiter,useGPU)
if gpuDeviceCount>0 && useGPU
    useGPU=1;
else
    useGPU=0;
end
if useGPU
    gpu=gpuDevice(1);
    reset(gpu);
    gbox_gpu=gpuArray(img_stack);
else
    gbox_gpu=img_stack;
end
    gbox_gpu2=gbox_gpu;
    h=waitbar(0,'Median Filtering');

for ii=1:maxiter
    if rem(ii,2) %odd
        clear gbox_gpu2;

        if useGPU
            wait(gpu);
        end
        [gbox_gpu2,h]=medfilt4D(gbox_gpu,[],[],h,ii,maxiter,txt); 
    else %even
        clear gbox_gpu;
        if useGPU
            wait(gpu);
        end
        [gbox_gpu,h]=medfilt4D(gbox_gpu2,[],[],h,ii,maxiter,txt); 
    end
%     if all(gbox_gpu(:)==gbox_gpu2(:))
%         break;
%     end
end
close(h);
img_filt=gather(gbox_gpu2);

%end

