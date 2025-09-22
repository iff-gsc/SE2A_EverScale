function [ y_strain, z_strain ] = strainPosFunray()
% strainPosFunray returns the positions of the strains sensors attached to
%   the Funray wing
%   The spanwise position y_strain is given with high accuracy.
%   The offset from the neutral axis z_strain was determined for one
%   reference position and then scaled by the local wing chord.
% Outputs:
%   y_strain            Strain sensor spanwise positions, in m
%   z_strain            Strain sensor offsets from neutral axis, in m

y_segments      = [ 0, 0.085, 0.29, 0.475, 0.685, 0.895, 1 ];
c_segments      = [ 0.235, 0.235, 0.228, 0.198, 0.164, 0.12, 0.09 ];
y_strain        = [ 0.07, 0.15:0.1:0.85 ];
c_strain        = interp1( y_segments, c_segments, y_strain, 'pchip' ); % chord at strain sensor positions
z_strain_ref    = 0.0095 + 0.010/2; % reference offset from neutral axis
c_ref           = 0.232; % reference chord
z_strain        = c_strain * z_strain_ref / c_ref;

end