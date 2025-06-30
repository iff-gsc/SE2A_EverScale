% Example for the Wing Bending Mode Observer (WBMO)
% 
% In this example, the IMUs are placed at the nodes of a beam-element
% model. Strain sensors are not included yet. Instead, they are replaced by
% (high-pass filtered) integration of the gyros.
% The WBMO observes the first bending modes of the beam-element model.

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024-2025 Yannic Beyer
%   Copyright (C) 2024-2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFunray();
clc_clear;


%% Structural dynamics model

% Create beam-element model specified in the parameters file
% structure = structureCreate('structure_params_imu_beam');
structure = structureCreate('structure_params_Funray_soft');

num_nodes = length(structure.xyz(1,:));
% Create reduced-order modal model for the beam-element model
num_modes = 10;
structure_red = structureGetReduced(structure,num_modes);

% eta to z (vertical deflection)
Phi_z_sim = structure_red.modal.T(3:6:end,7:end);
% eta to p (roll rate)
Phi_roll_sim = -structure_red.modal.T(4:6:end,7:end);

% Initial conditions for rigid-body motion (currently not used)
ic.omega_Kb = zeros(3,1);
ic.q_bg = [1;0;0;0];
ic.V_Kb = zeros(3,1);
ic.s_Kg = zeros(3,1);

% Sensor errors (currently de-activated)
rng(0);
imu_acc_bias = (rand(num_nodes,1) - 0.5) * 0;
imu_gyro_bias = (rand(num_nodes,1) - 0.5) * 0;
imu_acc_bias_gain = 0;
imu_gyro_bias_gain = 0;
imu_acc_noise_gain = 0;
imu_gyro_noise_gain = 0;


%% Observer parameters

% Load/create WBMO parameters structs
% [1,4,9] are the 1st, 2nd, and 3rd symmetric bending mode
[WBMO,WBMO_notune] = wbmoCreate( structure_red, 'ModeIdxUse', [1,4,9], ...
    'ModeIdxObs', 1 );


%% Visualization of the used mode shapes

% figure
% % subplot(2,1,1)
% plot( structure_red.xyz(2,[1:end/2-0.5,end/2+1.5:end]), WBMO.PhiZ, 'x-' )
% xlabel('Node y position (without center), m')
% ylabel('Delta vertical displacement, m')
% Legend = {};
% for i = 1:size(WBMO.PhiZ,2)
%     Legend{i} = ['Mode ',num2str(i)];
% end
% legend(Legend{:},'location','north')
% grid on
% % title('Mode shapes for eta=1')
% % subplot(2,1,2)
% % plot( structure_red.xyz(2,[1:end/2-0.5,end/2+1.5:end]), pinv(WBMO.pinvPhiP), 'x-' )
% % xlabel('Node y position (without center), m')
% % ylabel('Delta roll angle, rad')
% % grid on


%% Export figure to TikZ

% if true
%     tikzwidth = '\figurewidth';
%     tikzheight = '\figureheight';
%     tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
%     extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','ticklabel style={/pgf/number format/fixed}','legend style={font=\tikzfontsize}'};
%     filename = 'wing_bending_modes.tex';
%     matlab2tikz(filename,'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
% end


%% Simulink model

open('Wing_bending_mode_observer_sim_example')

