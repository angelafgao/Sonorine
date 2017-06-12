% column 1 is image000
% column 2 is image090
% column 3 is image180
% column 4 is image270

function [alignment, w_alinged, h_aligned] = get_aligned_dims(w, h, trans_info)
    alignment = zeros(4, 2);
    min_x = abs(min(trans_info(:, 1)));
    min_y = abs(min(trans_info(:, 2)));
    alignment(1, 1) = min_x;
    alignment(1, 2) = min_y; 
    for i = 1:3
        % determines x' values
        alignment(i + 1, 1) = trans_info(i+1, 1) + min_x;
        % determines y' values
        alignment(i + 1, 2) = trans_info(i+1, 2) + min_y;  
    end
    
    % finds the new w and h values for all images
    w_alinged = w - max(alignment(:, 1));
    h_aligned = h - max(alignment(:, 2));
    % saves align as just the start x' and y' values
    alignment = alignment + 1;
end