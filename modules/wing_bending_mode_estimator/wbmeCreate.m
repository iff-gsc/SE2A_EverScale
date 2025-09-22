function [WBME,WBME_notune] = wbmeCreate( structure_red, y_IMUs, y_strains, z_strains, varargin )
% wbmeCreate creates the parameters of the wing bending mode estimator
% 
% Syntax:
%   [WBME,WBME_notune] = wbmeCreate( structure_red, y_IMUs, y_strains, z_strains )
%   [WBME,WBME_notune] = wbmeCreate( structure_red, y_IMUs, y_strains, z_strains, Name, Value )
% 
% Inputs:
%   structure_red 	Modal structural dynamics model parameters struct, see
%                   structureCreate and structureGetReduced
%   y_IMUs          y positions of the IMUs (1xn array for N IMUs), in m
%   y_strains       y positions of the strain sensors (1xm array for M
%                   strain sensors); one (artificial) strain sensor should
%                   be located at y=0, in m
%   z_strain        Distances from the neutral axis to the surface
%                   strain-sensing stations (1xm array), in m
%   Name            Name of name-value arguments:
%                       - 'ModeIdxUse': Vector of all used mode numbers for
%                           mode shape inversion (important for estimation
%                           the mode acceleration), for example [1] or
%                           [1,5], default: [1]
%                       - 'ModeIdxObs': Vector of indices which mode of
%                           ModeIdxUse is to be observed, for example [1]
%                           or [1,2] (non-tunable), default: [1]
%                       - 'SampleTime': Sample time, s, default: 1/400
%                       - 'omega': Eigenfrequency of the feedback
%                           controller, rad/s, default: 10
%                       - 'd': Damping ratio of the feedback controller,
%                           default: 0.7
%   Value           value of Name-Value Arguments (see input Name)
% 
% Outputs:
%   WBME            Wing bending mode estimator parameters struct (tunable
%                   part)
%   WBME            Wing bending mode estimator parameters struct
%                   (non-tunable part)
% 
% See also:
%   structureCreate, structureGetReduced

% Disclaimer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2024-2025 Yannic Beyer
%   Copyright (C) 2024-2025 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% Vector of all used mode numbers for mode shape inversion (important for
% estimation of eta_dd)
WBME_notune.mode_idx_use = 1;
% Vector of indices which mode of mode_idx_use is to be observed
WBME_notune.mode_idx_obs = 1;
% Observer sample time, s (non-tunable)
WBME_notune.sample_time = 1/400;

% Observer gains
% Circular frequency, rad/s
WBME.omega = 10.0;
% Damping ratio
WBME.d = 0.7;

% High-pass filter time constant for gyro integration (if no strain sensors
% are available)
WBME.T = 1.0;

% Parse and assign optional name-value arguments
if ~isempty(varargin)
    for i = 1:length(varargin)
        if strcmp(varargin{i},'ModeIdxUse')
            WBME_notune.mode_idx_use = varargin{i+1};
        elseif strcmp(varargin{i},'ModeIdxObs')
            WBME_notune.mode_idx_obs = varargin{i+1};
        elseif strcmp(varargin{i},'SampleTime')
            WBME_notune.sample_time = varargin{i+1};
        elseif strcmp(varargin{i},'omega')
            WBME.omega = varargin{i+1};
        elseif strcmp(varargin{i},'d')
            WBME.d = varargin{i+1};
        end
    end
end


% eta (modal coordinates) to z (vertical deflection) - only needed by the
% observer if no strain sensors are available
WBME.PhiZ = interp1(structure_red.xyz(2,:),structure_red.modal.T(3:6:end,6+WBME_notune.mode_idx_use),y_IMUs(:),'linear','extrap');
% eta (modal coordinates) to p (roll rate)
PhiRoll = -interp1(structure_red.xyz(2,:),structure_red.modal.T(4:6:end,6+WBME_notune.mode_idx_use),y_IMUs(:),'linear','extrap');

% Delta deflections with respect to wing center
center_IMU_idx = length(y_IMUs)/2+0.5;
WBME.PhiZ = WBME.PhiZ - WBME.PhiZ(center_IMU_idx,:);
WBME.PhiZ(center_IMU_idx,:) = [];
WBME.pinvPhiZ = pinv(WBME.PhiZ);
PhiRoll = PhiRoll - PhiRoll(center_IMU_idx,:);
PhiRoll(center_IMU_idx,:) = [];
WBME.pinvPhiP = pinv(PhiRoll);

% Number of strain sensors
num_strain_sensors = length(y_strains);
% Matrix for mapping strains -> z
WBME.Strain2z = zeros(length(y_IMUs),num_strain_sensors);
for i = 1:length(y_strains)
    strains = zeros(1,num_strain_sensors);
    strains(i) = 0.001;
    WBME.Strain2z(:,i) = 1/0.001 * ...
        strain2displacement( y_strains, z_strains, strains, y_IMUs );
end
% Pseudo-inverse is needed for conversion of gyros to strains (if no strain
% sensors are available)
WBME.pinvS2z = pinv(WBME.Strain2z);

end
