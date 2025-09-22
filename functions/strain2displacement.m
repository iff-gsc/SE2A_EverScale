function [ Delta_z, slope ] = strain2displacement( y_strain, z_strain, strain, varargin )
% strain2displacement computes the vertical wing displacement from strain
%   measurements in span direction using the distance from the neutral axis
%   according to Ko et al. [1]
% 
% Syntax:
%   [ Delta_z, slope ] = strain2displacement( y_strain, z_strain, strain )
%   [ Delta_z, slope ] = strain2displacement( y_strain, z_strain, strain, y_eval )
% 
% Inputs:
%   y_strain        Strain-sensing stations / distances from the wing root
%                   (1xn array; from wing root to tip), in m
%   z_strain        Distances from the neutral axis to the surface
%                   strain-sensing stations (1xn array; from wing root to
%                   tip), in m
%   strain          Bending strains at strain-sensing stations (1xn array;
%                   from wing root to tip), dimensionless
%   y_eval          (Optional) Strain-sensing stations, where the
%                   deflections should be evaluated (1xm array), in m
% 
% Outputs:
%   Delta_z         Vertical deflections at the strain-sensing stations
%                   (1xn array; from wing root to tip) or at the specified
%                   locations (1xm array), in m
%   slope           Slopes at the strain-sensing stations (1xn array; from
%                   wing root to tip) or at the specified locations
%                   (1xm array), dimensionless
%                   (deflection angles: angles=atan(slope))
% 
% Literature:
%   [1] Ko, W. L., Richards, W. L., & Tran, V. T. (2007). Displacement
%       Theories for In-Glight Deformed Shape Predictions of Aerospace
%       Structures. NASA Dryden Flight Research Center, Rept. 214612,
%       Hampton, Virginia, 2007.

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2025 Yannic Beyer
%   Copyright (C) 2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

is_eval_different = false;
if ~isempty(varargin)
    y_eval = varargin{1};
    is_eval_different(:) = true;
else
    y_eval = y_strain;
end

curvature = strain ./ z_strain;

center_node_idx = find( y_strain == 0 );
if isempty(center_node_idx)
    error('Please define a strain sensor at y=0.')
end

% [1], Eq. (6):
slope_tmp = cumtrapz( y_strain, curvature );
slope_tmp  = slope_tmp - slope_tmp(center_node_idx);
% [1], Eeq. (9):
Delta_z_tmp = cumtrapz( y_strain, sin(slope_tmp) );
Delta_z_tmp = Delta_z_tmp - Delta_z_tmp(center_node_idx);

% Interpolate/extrapolate if requested
if is_eval_different
    slope = interp1( y_strain, slope_tmp, y_eval, 'linear', 'extrap' );
    Delta_z = interp1( y_strain, Delta_z_tmp, y_eval, 'linear', 'extrap' );
else
    slope = slope_tmp;
    Delta_z = Delta_z_tmp;
end

end
