function A = fill_matrix_fun(num_rows, num_cols, eps)
    total = num_rows*num_cols;
    A = sparse(3*total, total);
    one = ones(total, 1);
    columns = [one, -one, one*2, one*(-2), one, -one];
    start1 = -(num_cols + 2)+1;
    start2 = start1+2;
    d = [start1 start2 start1+num_cols start2+num_cols start1+2*num_cols start2+2*num_cols];
    A(1:total, :) = spdiags(columns, d, total, total);
    
    columns = [one, one*2, one, -one, one*(-2),-one];
    start1 = -(num_cols + 2)+1;
    start2 = start1 + 2*num_cols;
    d = [start1 start1+1 start1+2 start2 start2+1 start2+2];
    A(total+1:total*2, :) = spdiags(columns, d, total, total);
    
    A(total*2+1:total*3, :) = spdiags(one*eps, 0, total, total);
end