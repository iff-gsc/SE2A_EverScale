%  ** conventional airplane aerodynamics (simple) parameters for SE2A MRV4S **

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024 Yannic Beyer
%   Copyright (C) 2024 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% fuselage parameters
% fuselage volume, m^3 
fuse.V = 0.075;
aero.fuse = simpleFuselageCreate( 'simpleFuselage_params_MRV4S', fuse.V );

%% main wing parameters
aero.wingMain = simpleWingCreate( 'wing_params_MRV4SMain', 'simpleWing_params_MRV4SMainWing' );

%%  horizontal tailplane parameters
aero.wingHtp = simpleWingCreate( 'wing_params_MRV4SHtp', 'simpleWing_params_MRV4SHtp' );

%% vertical tailplane parameters
aero.wingVtp = simpleWingCreate( 'wing_params_MRV4SVtp', 'simpleWing_params_MRV4SVtp' );

%% downwash
wing_main = wingCreate( 'wing_params_MRV4SMain', 40 );
wing_htp = wingCreate( 'wing_params_MRV4SHtp', 20 );

aero.downwash = wingGetDownwashDerivs( wing_main, wing_htp );

%% configuration parameters
% incidence angle of main wing, rad
aero.config.wingMainIncidence = deg2rad(0.77);
% position of main wing (l/4 at the root) in c frame, m
aero.config.wingMainPos = [ -1.0270; 0; 0.0810 ];
% position of horizontal tailplane (l/4 at the root)  in c frame, m
aero.config.wingHtpPos = [ -1.9052; 0; -0.0712 ];
% position of vertical tailplane (l/4 at the root)  in c frame, m
aero.config.wingVtpPos = [ -1.9575; 0; -0.3545 ];
% rotation matrix of vertical tailplane (relative to c frame)
aero.config.wingVtpRot = euler2Dcm( [pi/2;0;0] );
