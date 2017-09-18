% column 1 is image000
% column 2 is image090
% column 3 is image180
% column 4 is image270

function [align, w_alinged, h_aligned] = get_aligned_dims(w, h, trans_info)
    align = zeros(4);
    align(3, 1) = w;
    align(4, 1) = h;
    for i = 1:4
        % determines x' values
        align(1, i) = max(0, trans_info(1, i));
        % determines y' values
        align(2, i) = max(0, trans_info(2, i));    
        % determines w' values
        align(3, i) = w - abs(trans_info(1, i));
        % determines h' values
        align(4, i) = h - abs(trans_info(2, i));
    end
    
    % finds the new w and h values for all images
    w_alinged = min(align(3, :));
    h_aligned = min(align(4, :));
    % saves align as just the start x' and y' values
    align = align(1:2, :) + 1;
end