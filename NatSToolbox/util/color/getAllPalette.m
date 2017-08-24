function palette = getAllPalette()

    %-------------------
    % Predefined color 
    % palettes named by
    % population
    %-------------------
    % Descending Blue
    %-------------------
    palette(1).name = 'DESC';
    palette(1).fc = [0 162 232];
    palette(1).bc = [0 80  192];
    %-------------------
    % 200Hz Burgundy Red
    %-------------------
    palette(2).name = '200Hz';
    palette(2).fc = [255 0  0];
    palette(2).bc = [176 0  0];
    %-------------------
    % 100Hz Orange
    %-------------------
    palette(3).name = '100Hz';
    palette(3).fc = [255 128 0];
    palette(3).bc = [128 64  0];
    %-------------------
    % Pyramid Claret
    %-------------------
    palette(4).name = 'L3';
    palette(4).fc = [153 51 0];
    palette(4).bc = [204 126 0];
    %-------------------
    % Pyramid Green
    %-------------------
    palette(5).name = 'L2';
    palette(5).fc = [0 128 0];
    palette(5).bc = [150 208 150];
    %-------------------
    % 0Hz Purple
    %-------------------
    palette(6).name = '10Hz';
    palette(6).fc = [149 0 255];
    palette(6).bc = [129 0 235];
    %-------------------
    % Complex Red
    %-------------------
    palette(10).name = 'COMP';
    palette(10).fc   = [255,0,0];
    palette(10).bc   = [255,0,0];
    %-------------------

    %-------------------
    % Histogram palette
    % without specific
    % name
    %-------------------
    % Neongreen-yellow
    %-------------------
    palette(7).name = 'Neon green';
    palette(7).fc   = [158,177,65];
    palette(7).bc   = [230,248,62];
    %-------------------
    % Cyan blue
    %-------------------
    palette(8).name = 'Cyan';
    palette(8).fc   = [43,217,194];
    palette(8).bc   = [22,148,132];
    %-------------------
    % Default
    %-------------------
    palette(9).name = 'DEFAULT';
    palette(9).fc   = [0,0,255];
    palette(9).bc   = [0,0,255];
    %-------------------

end