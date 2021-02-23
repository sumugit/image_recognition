function [y1, y2] = getMinDisIndex(A, DB)
    %列のサイズが一致するかどうか
    if length(A) ~= length(DB(1,:))
        disp('size does not match.');
        return
    end
    A = repmat(A, size(DB, 1), 1);
    B = sqrt(sum((A - DB).^2, 2));
    
    [min_value, min_index] = min(B);
    y1 = min_index;
    y2 = min_value;
end