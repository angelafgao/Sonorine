function b = is_edge(num_rows, num_cols, i, j)
    x = i*num_cols + j;
    if mod(x, num_cols) == 1
        b = true;
    elseif mod(x, num_cols) == 0
        b = true;
    elseif x < num_cols
        b = true;
    elseif x > (num_rows-1) * num_cols
        b = true;
    else 
        b = false;
    end
    if b == false
        %fprintf('%d %d \n', i, j);
    end
end