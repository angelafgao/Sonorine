function b = is_edge(num_rows, num_cols, i)
    if mod(i, num_cols) == 1
        b = true;
    elseif mod(i, num_cols) == 0
        b = true;
    elseif i < num_cols
        b = true;
    elseif i > (num_rows-1) * num_cols
        b = true;
    else 
        b = false;
    end
    if b == false
        %fprintf('%d %d \n', i, j);
    end
end