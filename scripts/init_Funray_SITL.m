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

% Peine-Eddesse
airplane.posRef.lat = 52.402816;
airplane.posRef.lon = 10.228787;
airplane.posRef.alt = 72;

channel_idx = 1:7;
channel_idx = 1:11;

% environment parameters
envir = envirLoadParams( 'envir_params_default', 'envir',0 );

% open simulink model
open_model('AirplaneSimModel_SITL')

