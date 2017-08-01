function A = foo()
    num_rows = 320;
    num_cols = 320;
    eps = 0.5;
    total = num_rows*num_cols;
    
    A = sparse(total, total);
    one = ones(total, 1);
    two_coloums = [one, -one];
    %A1(1, :) = one;
    A = spdiags(two_coloums, [0, 2], total, total);
end