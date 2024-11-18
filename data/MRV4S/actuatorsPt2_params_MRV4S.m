%  ** second order actuator parameters (SE2A MRV4S) **

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% natural frequency, rad/s
param.naturalFrequency = 150;
% damping ratio, 1
param.dampingRatio = 1;
% maximum deflection, rad
param.deflectionMax = deg2rad(25);
% minimum deflection, rad
param.deflectionMin = deg2rad(-25);
% maximum deflection rate, rad/2
param.deflectionRateMax = deg2rad(60/0.08);