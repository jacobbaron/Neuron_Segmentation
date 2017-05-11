function [rect] = keep_in_bounds(rect,img_size)
        if rect(1)>img_size(2)
            rect(1)=img_size(2);
        end
        if rect(2)>img_size(1)
            rect(2)=img_size(1);
        end
        if rect(1)+rect(3)>img_size(2)
           rect(3)=img_size(2)-rect(1);
        end
        if rect(2)+rect(4)>img_size(1)
            rect(4)=img_size(1)-rect(2);
        end
end