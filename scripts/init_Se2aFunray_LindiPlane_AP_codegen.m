% Funray parameter initialization for C++ code generation for ArduPlane

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% Clear workspace and console
addPathFunray();
clc_clear;

%% Init airplane parameters
airplane = conventionalAirplaneLoadParams( 'airplane_params_Se2aFunray' );

%% Compute LindiPlane parameters
[lindi,lindi_notune] = lindiPlaneAutoCreate( airplane, 'SensFilt', [50,0.71], ...
    'AgilityAtti', 1.2, 'AgilityPos', 1.0, 'ServoBoost', 0.5, 'MlaUse', 0 );
lindi.ceb.scale = 1.2;
lindi.gust.len = 20;
lindi.gust.mag = -3;
lindi.flex.m = [1,2,3,3];
lindi.flex.m = 0.44/sum(lindi.flex.m) * lindi.flex.m;

lindi = structDouble2Single(lindi);
lindi_notune = structDouble2Single(lindi_notune);

%% Init ArduPlane custom controller interface buses
clearAllBuses();
ardupilotCreateInputBusesSe2a();

%% Open model
open_model('ArduPlane_LindiPlane');
