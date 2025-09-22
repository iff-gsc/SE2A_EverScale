function Delta_z_d = gyro2velocity( y_gyros, gyros, varargin )
% gyro2velocity computes the vertical wing velocity from gyro measurements
%   in span direction assuming that to local wing rotation is always
%   parallel to the wing bending curve.
% 
% Syntax:
%   Delta_z_d = strain2displacement( y_gyros, gyros )
%   Delta_z_d = strain2displacement( y_gyros, gyros, y_eval )
% 
% Inputs:
%   y_gyros         Gyro stations / distances from the wing root
%                   (1xn array; from wing root to tip), in m
%   gyros           Gyros values at gyro stations (1xn array; from wing
%                   root to tip), in rad/s
%   y_eval          (Optional) Stations, where the vertical velocity should
%                   be evaluated (1xm array), in m
% 
% Outputs:
%   Delta_z_d       Vertical velocity at the gyro stations (1xn array; from
%                   wing root to tip) or at the specified locations
%                   (1xm array), in m

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
    y_eval = y_gyros;
end

center_node_idx = find( y_gyros == 0 );
if isempty(center_node_idx)
    error('Please define an IMU at y=0.')
end

Delta_z_d_tmp = - cumtrapz( y_gyros, gyros );
Delta_z_d_tmp  = Delta_z_d_tmp - Delta_z_d_tmp(center_node_idx);

% Interpolate/extrapolate if requested
if is_eval_different
    Delta_z_d = interp1( y_gyros, Delta_z_d_tmp, y_eval, 'pchip', 'extrap' );
else
    Delta_z_d = Delta_z_d_tmp;
end

end
