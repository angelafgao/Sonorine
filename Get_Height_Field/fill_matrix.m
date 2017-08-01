function A = fill_matrix1(num_cols, num_rows)
    total = num_rows*num_cols;
    A = sparse(3*total, total);
    A(2*total+1: 3*total, :) = speye(total); % fill bottom of A with identity
    A = A*eps;
    row1 = make_row1(num_cols);
    row2 = make_row2(num_cols);

    for i = 1:total % fill top and middle of A with sobel filter
        col = mod(i, num_cols);
        row = floor(i/num_cols);
        if (is_edge(num_rows, num_cols, i) == false)
            start = (row - 1) * num_cols + col-1;
            A(i, start: start + 3*num_cols - 1) = row1;
            A(i + total, start: start + 3*num_cols - 1) = row2;
        end
    end


end