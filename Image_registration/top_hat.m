
function [F]=top_hat(x,xdata)
F=zeros(size(xdata));
peak_pts=abs(xdata-x(3))<x(2)/2;
F(peak_pts)=x(1);
F(~peak_pts)=x(4);



end