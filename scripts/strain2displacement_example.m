% Example for wing bending computation from strain measurements

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2025 Yannic Beyer
%   Copyright (C) 2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% Init

addPathWbme();

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




