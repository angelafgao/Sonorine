function v = make_sonorine_mask(w, h, eps)
    cx = w/2;
    cy = h/2;
    r1 = w/4;
    r2 = w/2;
    m = ones(w, h)*eps;
    for i = 1:w
        for j = 1:h
            dx = abs(i - cx);
            dy = abs(j - cy);
            distance = (dx^2 + dy^2)^0.5;
            if (distance < r1)
                m(i, j) = 1;
            elseif(distance > r2) 
                m(i, j) = 1;
            end
        end
    end
    v = reshape(m, w*h, 1);
end