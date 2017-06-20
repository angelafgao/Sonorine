% finds the normal vector of the Canon LIDE 220 scanner to find the light
% vector
% assumes there is no x component in the scanner light
% returns a unit normal vector


% dir = direction of rotation
% hyp = length of hypotenuse in pixels
% height = length of short leg of triangle in inches
function [unit_n] = get_normal(dir, length, height)
    % calculate the different measurements needed to get the normal
    dpi = 800;
    height = height*dpi;
    
    % calculates the normal using the tangent line, which is produced by
    % the card itself
    % differentiates between card rotated in the y direction and the cards
    % rotated in the x direction
    if dir(1) ~= 0
        n = [dir(1)/length  , 0, dir(3)/height];
    elseif dir(2) ~= 0
        n = [0, dir(2)/length, dir(3)/height];
    end 
    unit_n = n./norm(n);   
end