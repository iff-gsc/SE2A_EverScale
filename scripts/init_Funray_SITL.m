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
airplane = conventionalAirplaneLoadParams( 'airplane_params_Se2aFunray' );
airplane.ic.s_Kg(3) = -5;

channel_idx = [1,2,7,8,9,10,11];
channel_idx = 1:11;

% environment parameters
envir = envirLoadParams( 'envir_params_default', 'envir',0 );

% open simulink model
open_model('AirplaneSimModel_SITL')

