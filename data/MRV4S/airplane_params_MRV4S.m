%  ** conventional airplane parameters of SE2A MRV4S **

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% mass, kg
airplane.body.m = 25.0;
% inertia matrix, kg*m^2
airplane.body.I = [ ...
        1.58, 0.000, -0.118; ...
        0.000, 4.52, 0.000; ...
        -0.118, 0.000, 5.99 ...
        ];

% center of gravity in c frame, m
airplane.config.cg = [-1.1469;0;0.0148];
% collision points in c frame, m
airplane.config.hitPoints = [ [0;0;0],[-2.20;0;0],[-1.31;-1.23;0.015],[-1.31;1.23;0.015],...
    [-0.1;0;0.11],[-1.8;0;0.11],[-2.0;0;0.05],[-2.0;0;-0.52],...
    [-2.09;-0.37;-0.12],[-2.09;0.37;-0.12] ];

% aerodynamics parameters
airplane.aero = conventionalAirplaneAeroLoadParams( ...
    'airplaneAeroSimple_params_MRV4S' );

% propeller parameters
airplane.prop = propMapLoadParams( 'propMap_params_Funray' );
% airplane.prop.map_fit = 0;
% airplane.prop.I = 7.3e-5;
% airplane.prop.dir = 1;
% airplane.prop.k = 1e-5;
% airplane.prop.d = 0.03*airplane.prop.k;

% propeller configuration parameters
airplane.prop.config.Pos = [0;0;0];
airplane.prop.config.Rot = euler2Dcm(deg2rad([0 0 0]));

% motor parameters
airplane.motor = loadParams( 'motorBldc_params_MRV4S' );

% actuator parameters
airplane.act.ailerons = loadParams('actuatorsPt2_params_MRV4S');
airplane.act.ailerons.deflectionMax = deg2rad(28);
airplane.act.ailerons.deflectionMin = -deg2rad(28);
airplane.act.elevator = loadParams('actuatorsPt2_params_MRV4S');
airplane.act.elevator.deflectionMax = deg2rad(21);
airplane.act.elevator.deflectionMin = -deg2rad(21);
airplane.act.rudder = loadParams('actuatorsPt2_params_MRV4S');
airplane.act.rudder.deflectionMax = deg2rad(27);
airplane.act.rudder.deflectionMin = -deg2rad(27);
airplane.act.htpTrim = loadParams('actuatorsPt2_params_MRV4S');
airplane.act.htpTrim.deflectionMax = deg2rad(5);
airplane.act.htpTrim.deflectionMin = deg2rad(-5);

% battery parameters
airplane.bat = loadParams( 'battery_params_MRV4S' );

% cmd struct/bus
num_flaps = length(airplane.aero.wingMain.flap.y_cp_wing)/2;
airplane.cmd = struct('aileron_left',0.5*ones(1,num_flaps),'aileron_right',0.5*ones(1,num_flaps),'elevator',0.5,'rudder',0.5,'throttle',0,'htp_trim',0.5);
struct2slbus(airplane.cmd,'cmd');

% reference position
airplane.posRef = posRefLoadParams( 'reference_position_params_default' );

% ground contact parameters
airplane.grnd = groundLoadParams( 'params_ground_default' );

%% initial conditions (IC)
% kinematic rotational velocity, rad/s
airplane.ic.omega_Kb = zeros(3,1);
% quaternion attitude from NED to body frame
airplane.ic.q_bg = [1;0;0;0];
% kinematic velocity in body frame, m/s
airplane.ic.V_Kb = [0;0;0];
% NED position relative to posRef, m
airplane.ic.s_Kg = [0; 0; -1];
% motor angular velocity, rad/s
airplane.ic.motor_speed = 0;