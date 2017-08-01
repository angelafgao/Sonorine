function row = make_row1(num_cols)
    row = zeros(1, num_cols*3);
    row(num_cols + 1) = 2/8;
    row(num_cols + 3) = -2/8;
    row(1) = 1/8;
    row(3) = -1/8;
    row(num_cols*2 + 1) = 1/8;
    row(num_cols*2 + 3) = -1/8;
    row = sparse(row);
end