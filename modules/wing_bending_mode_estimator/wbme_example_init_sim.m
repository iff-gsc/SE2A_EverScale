% Example for the Wing Bending Mode Estimator (WBME)
% 
% In this example, the IMUs are at the spanwise positions y_IMUs. Strain
% sensors are placed at the spanwise positions y_strains.
% The WBME estimates the first bending mode of the beam-element model.

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024-2025 Yannic Beyer
%   Copyright (C) 2024-2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathWbme();

%% Structural dynamics model

% Create beam-element model specified in the parameters file
% structure = structureCreate('structure_params_imu_beam');
structure = structureCreate('structure_params_Funray_soft');

num_nodes = length(structure.xyz(1,:));
% Create reduced-order modal model for the beam-element model
num_modes = 10;
structure_red = structureGetReduced(structure,num_modes);

% Sensor positions
y_IMUs = [-0.9:0.2:-0.3, 0, 0.3:0.2:0.9 ];
[ y_strains, z_strains ] = strainPosFunray();
y_strains = [-flip(y_strains),0,y_strains];
z_strains = [flip(z_strains),z_strains(1),z_strains];

num_IMUs = length(y_IMUs);
num_strain_sensors = length(y_strains);

% eta to z (vertical deflection)
Phi_az_sim = interp1(structure_red.xyz(2,:), structure_red.modal.T(3:6:end,7:end), y_IMUs(:));
% eta to p (roll rate)
Phi_roll_sim = interp1(structure_red.xyz(2,:), -structure_red.modal.T(4:6:end,7:end), y_IMUs(:));

% Initial conditions for rigid-body motion (currently not used)
ic.omega_Kb = zeros(3,1);
ic.q_bg = [1;0;0;0];
ic.V_Kb = zeros(3,1);
ic.s_Kg = zeros(3,1);

% Sensor errors (currently de-activated)
rng(0);
imu_acc_bias = (rand(num_IMUs,1) - 0.5) * 0;
imu_gyro_bias = (rand(num_IMUs,1) - 0.5) * 0;


%% Estimator parameters

S2z = zeros( num_IMUs, num_strain_sensors );
for i = 1:length(y_strains)
    strains = zeros(1,num_strain_sensors);
    strains(i) = 0.001;
    S2z(:,i) = 1/0.001 * strain2displacement(y_strains,z_strains,strains,y_IMUs);
end
Phi_s_sim = pinv(S2z)*Phi_az_sim;

% Load/create WBME parameters structs
% [1,4,8] are the 1st, 2nd, and 3rd symmetric bending mode
[WBME,WBME_notune] = wbmeCreate( structure_red, y_IMUs, y_strains, z_strains, ...
    'ModeIdxUse', [1,4,8], 'ModeIdxObs', 1 );


%% Simulink model

open('wbme_example_sim')

