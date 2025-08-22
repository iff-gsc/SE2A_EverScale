% Example for wing bending computation from strain measurements

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2025 Yannic Beyer
%   Copyright (C) 2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% Init

addPathFunray();
clc_clear;

% Define strain sensor positions of Funray, in m
[ y_strain, z_strain ] = strainPosFunray();

% Define IMU positions of Funray, in m
y_IMU = [ 0.3 ,0.5, 0.7, 0.9 ];

% Define strain measurements, dimensionless
strain = 0.002*ones(size(y_strain));

%% Compute wing bending

% Extension: Add virtual strain sensor at airplane center and wing tip
y_strain_ext = [ 0, y_strain, 1 ];
z_strain_ext = [ z_strain(1), z_strain, z_strain(end) ];
strain_ext = [ strain(1), strain, strain(end) ];

% Wing bending at extended strain sensor positions
[Delta_z_ext, slope_ext] = strain2displacement( y_strain_ext, z_strain_ext, strain_ext );

% Wing bending at IMU positions
[Delta_z_IMU, slope_IMU] = strain2displacement( y_strain_ext, z_strain_ext, strain_ext, y_IMU );


figure

subplot(1,2,1)
hold on
plot( y_strain_ext(2:end-1), atand(slope_ext(2:end-1)), 'x' )
plot( y_strain_ext([1,end]), atand(slope_ext([1,end])), 'c*' )
plot( y_IMU, atand(slope_IMU), 'ro' )
plot( y_strain_ext, atand(slope_ext), 'k-' );
xlabel('Span position, m')
ylabel('Bending angle, deg')
legend('Strain sensor positions','Virtual strain sensor positions','IMU positions',...
    'location', 'northwest' )
grid on
box on

subplot(1,2,2)
hold on
plot( y_strain_ext(2:end-1), Delta_z_ext(2:end-1), 'x' )
plot( y_strain_ext([1,end]), Delta_z_ext([1,end]), 'c*' )
plot( y_IMU, Delta_z_IMU, 'ro' )
plot( y_strain_ext, Delta_z_ext, 'k-' )
xlabel('Span position, m')
ylabel('Vertical displacement, m')
grid on
box on



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
