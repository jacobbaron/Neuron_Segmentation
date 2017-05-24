
function [y]=top_hat(x,A,w,c,b)


if abs(x-c)<w/2
    y=A;
else
    x=b;
end