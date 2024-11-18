%  ** init Funray with ArduPlane SITL **

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% set path
addPathFunray();
clc_clear;

% init airplane parameters
airplane = conventionalAirplaneLoadParams( 'airplane_params_MRV4S' );
airplane.body.m = airplane.body.m/2;
airplane.body.I = airplane.body.I/2;
airplane.ic.s_Kg(3) = -5;

channel_idx = 1:13;

% environment parameters
envir = envirLoadParams( 'envir_params_default', 'envir',0 );

% open simulink model
open_model('AirplaneSimModel_SITL')

