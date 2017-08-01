function v = make_sonorine_mask(h, w, eps)
    cx = 2900; 
    cy = 2900;
    r1 = 500; 
    r2 = 2800;
    m = ones(w, h)*eps;
    for i = 1:w
        for j = 1:h
            dx = abs(i-cx);
            dy = abs(j-cy);
            distance = (dx^2 + dy^2)^0.5;
            if distance < r1
                m(i, j) = 1;
            elseif distance > r2
                m(i, j) = 1;
            end
        end
    end
    v = reshape(m, w*h, 1);
end
    