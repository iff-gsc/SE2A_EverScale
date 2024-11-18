%  ** SE2A MRV4S brushless direct current motor (HET 800-55-675) parameters **

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% torque constant of the motor (KT=60/(2*pi*KV)), N.m/A
% with KV = 675 RPM/V
param.KT = 60/(2*pi*675);
% motor internal resistance, Ohm (estimated from TMotor MT2216 900Kv)
param.R = 0.1;