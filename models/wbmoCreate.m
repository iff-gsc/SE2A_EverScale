function [WBMO,WBMO_notune] = wbmoCreate( structure_red, varargin )
% wbmoCreate creates the parameters of the wing bending mode observer
% 
% Syntax:
%   [WBMO,WBMO_notune] = wbmoCreate( structure_red )
%   [WBMO,WBMO_notune] = wbmoCreate( structure_red, Name, Value )
% 
% Inputs:
%   structure_red 	Modal structural dynamics model parameters struct, see
%                   structureCreate
%   Name            Name of name-value arguments:
%                       - 'ModeIdxUse': Vector of all used mode numbers for
%                           mode shape inversion (important for estimation
%                           the mode acceleration), for example [1] or
%                           [1,5], default: [1]
%                       - 'ModeIdxUse': Vector of indices which mode of
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
%   WBMO            Wing bending mode observer parameters struct (tunable
%                   part)
%   WBMO            Wing bending mode observer parameters struct
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
WBMO_notune.mode_idx_use = 1;
% Vector of indices which mode of mode_idx_use is to be observed
WBMO_notune.mode_idx_obs = 1;
% Observer sample time, s (non-tunable)
WBMO_notune.sample_time = 1/400;

% Observer gains
% Circular frequency, rad/s
WBMO.omega = 10.0;
% Damping ratio
WBMO.d = 0.7;

% High-pass filter time constant for gyro integration (if no strain sensors
% are available)
WBMO.T = 1.0;

% Parse and assign optional name-value arguments
if ~isempty(varargin)
    for i = 1:length(varargin)
        if strcmp(varargin{i},'ModeIdxUse')
            WBMO_notune.mode_idx_use = varargin{i+1};
        elseif strcmp(varargin{i},'ModeIdxObs')
            WBMO_notune.mode_idx_obs = varargin{i+1};
        elseif strcmp(varargin{i},'SampleTime')
            WBMO_notune.sample_time = varargin{i+1};
        elseif strcmp(varargin{i},'omega')
            WBMO.omega = varargin{i+1};
        elseif strcmp(varargin{i},'d')
            WBMO.d = varargin{i+1};
        end
    end
end


% eta (modal coordinates) to z (vertical deflection) - only needed by the
% observer if no strain sensors are available
WBMO.PhiZ = structure_red.modal.T(3:6:end,6+WBMO_notune.mode_idx_use);
% eta (modal coordinates) to p (roll rate)
PhiRoll = -structure_red.modal.T(5:6:end,6+WBMO_notune.mode_idx_use);

% Delta deflections with respect to wing center
num_nodes = size(structure_red.xyz,2);
center_node_idx = num_nodes/2+0.5;
WBMO.PhiZ = WBMO.PhiZ - WBMO.PhiZ(center_node_idx,:);
WBMO.PhiZ(center_node_idx,:) = [];
WBMO.pinvPhiZ = pinv(WBMO.PhiZ);
PhiRoll = PhiRoll - PhiRoll(center_node_idx,:);
PhiRoll(center_node_idx,:) = [];
WBMO.pinvPhiP = pinv(PhiRoll);

% Number of strain sensors (to do: dummy value)
num_strain_sensors = 12;
% Matrix for mapping strains -> z (to do: currently only dummy values so
% that wbmo.Strain2z*pinv(wbmo.Strain2z) = E)
WBMO.Strain2z = rand(num_nodes-1,num_strain_sensors);
% Pseudo-inverse is needed for conversion of gyros to strains (if no strain
% sensors are available)
WBMO.pinvS2z = pinv(WBMO.Strain2z);

end
