% Wing parameters (SE2A MRV4S main wing)

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% basic parameters

% wing span (scalar), in m
prm.b         	= 2.449;
% is the wing symmetrical to the xz-plane (scalar bolean)?
prm.is_symmetrical = true;

%% wing segments (s segments)

% spanwise coordinates of wing parts (1x(s+1) array), in -
prm.eta_segments_wing = [0,0.29,0.5,0.68,1];
% wing chord (1x(s+1) array), in m
prm.c           = [0.3612,0.243,0.19805,0.159865,0.092186];
% quarter chord line sweepback angle for each section (1xs array), in rad
prm.lambda    	= deg2rad([11.7,13.7,13.7,13.7]);
% wing section twist with respect to root (1xs array), in rad
prm.epsilon   	= deg2rad([0,-1,-4,-4]);
% prm.epsilon   	= deg2rad([-1,-1.2,-1.3,-1.5]);
% prm.epsilon   	= deg2rad([-1,-1.3,-2.4,-3.0]);
% dihedral angle (abs(nu)<pi/2 !) for each section (1xs array), in rad
prm.nu       	= deg2rad([0,3,3,3]); 

%% wing device segments (d device segments)

% spanwise coordinates of wing device segments (1x(d+1) array), in -
prm.eta_segments_device = [0,0.1307,0.2409,0.2797,0.4512,0.6227,0.7942,0.9657,1];
% section name (dx? char array); two airfoil projects available:
%   1) "airfoilAnalyticSimple..." (see airfoilAnalyticSimpleCreate) <-- recommended!
%   2) "airfoilAnalytic0515..." (see airfoilAnalytic0515LoadParams) <-- good luck!
prm.section = char(repmat(["airfoilAnalyticSimple_params_default"],8,1));
% relative flap depth for each device segment (1xd array), in -
prm.flap_depth          = [ 0, 0.20, 0, 0.20, 0.20, 0.20, 0.20, 0 ];
% second actuator type (dx? char array); available options:
%   1) "none" no second actuator
%   2) "airfoilMicroTab..." (see airfoilMicroTabLoadParams)
prm.actuator_2_type = char(repmat(["none"],8,1));
% index of the control input (0 means no control input) (1x(2*d) array), in -  
prm.control_input_index = [ 0, 1, 2, 3, 4, 0, 5, 0, 0, 6, 0, 7, 8, 9, 10, 0; ...
                            zeros(1,16) ];

%% coordinates in reference frame

% wing incidence relative x-y-plane of reference frame, in rad
prm.i = deg2rad(0.53);
% wing rotation about x axis of reference frame, in rad
prm.rot_x = 0;
% x position of the wing (leading edge at wing root) in reference frame (scalar), in m
prm.x = -0.917; 
% z position of the wing (leading edge at wing root) in reference frame (scalar), in m
prm.z = 0.0931;
