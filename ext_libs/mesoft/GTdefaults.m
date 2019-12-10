function [params dispParams] = GTdefaults

% regularizers
params.conpot_lambda = 0.3;
params.data_lambda = 500;
params.c_likli = 1; 0.5;                    % likeliniess that a connection occurs
params.p_chempot = 0.1;  0.3;               % cost of a particle (L0-regularizer)
params.p_expnump = 1;                   % lambda of Poisson process



params.fiberSmooth = 0;
params.voxelSmooth_vf = 0; 
params.voxelSmooth_Ds = 0; 
params.voxelSmooth_Ds_range = 20;
params.penalty_SW = 0*0.01;
params.curv_hardthres =  cos(80/180*pi);
params.trackingguide_strength = 0;

% tracking guide diffusion model
%params.fixedTissueMode = [1 0 1 -1 1];  % [ D_para D_perp vfi -1 weightscale]
params.fixedTissueMode = [2 0.5 0.5 -1 1];  % [ D_para D_perp vfi -1 weightscale]

% iteration parameters
params.Tstart = 0.1;
params.Tend = 0.003;
params.numstep = 100;
params.numiterations = -4;% -4;

% distribution of proposal types
params.prop_p_birth = 0.4;
params.prop_p_death = 0.1;		
params.prop_p_shift = 2;
params.prop_p_Dmod = 0.2;     
params.prop_p_vfmod = 0; 
params.prop_p_conprob = 0.2;


% particle related parameters
params.p_weight = 1.5; %1.2;                 % maximum weight
params.p_len = 2;                       % length of segment
params.p_wid = 3;                       % oversampling factor

% connection related parameters
params.c_kappa = 0.5;                   % trade-off between angular and distance penalty (dist 0...1 ang)
params.c_bound_attract = 0*0.5;            % wm/gm-boundary attracts open fiber terminals

% diffusion model
params.lmax = 6;
params.maxbval = 4000;                  % all data beyond this bvalue is neglected
params.b_weighting = 0.05;              % relative weighting of b0-images
params.restrictions = 0*2^0 +0*2^1;        % if 0x01 is set D_para_ex == D_orth_ex
                                        % if 0x10 is set D_para_ex == D_para_int
params.nonshell = true;
params.nmax = 2;
params.bfun = @(b,n) exp(-b).*b.^(n+1);


% accumulator
params.accum_numits = 10^9;
params.accum_numavg = 30;
params.accum_Temp = 0.01;

                                        
                                        
params.trace_equality_constraint = 0.005;% 0.01;

% approximation model parameters
params.alpha = 0;                       % alpha==1: sw implicitly modeled, alpha==0: no sw
params.ordermax = [6 2 4 2];            % [order_MM kappa_MM order_MS kappa_MS]

% length thresholds of extracted fibers 
params.fibrange = [3 inf];

% still experimental
params.directional_propsal_distrib = 0;

% sphere discretization
params.sphericalDiscNumber = 128; % possible values 32,48,64,128,256
        % note that, if you change this you have recompile (or just delete /tmp/mesoFT/sinterp*)
        
        
        
        
        
% number of cores used
params.numcores = 2;  % if ==1, openMP free compile

% just a  string of additonal compiler parameters
params.compilerparams = '-fopenmp' ;
params.libs = '-lgomp' ;
        

% parameters shown in the GUI
cnt = 1;
dispParams(cnt).tag = 'Tstart';
dispParams(cnt).name = 'starting Temp';
cnt = cnt +1;
dispParams(cnt).tag = 'Tend';
dispParams(cnt).name = 'stopping Temp';
cnt = cnt +1;
dispParams(cnt).tag = 'numiterations';
dispParams(cnt).name = '#its';
cnt = cnt +1;
dispParams(cnt).tag = 'numstep';
dispParams(cnt).name = 'number of ir';
cnt = cnt +1;
dispParams(cnt).tag = 'p_len';
dispParams(cnt).name = 'Segment length';
cnt = cnt +1;
dispParams(cnt).tag = 'p_wid';
dispParams(cnt).name = 'oversampling';
cnt = cnt +1;
dispParams(cnt).tag = 'p_chempot';
dispParams(cnt).name = 'Segment Cost';
cnt = cnt +1;
dispParams(cnt).tag = 'c_likli';
dispParams(cnt).name = 'Con. Potential';
cnt = cnt +1;
dispParams(cnt).tag = 'c_kappa';
dispParams(cnt).name = 'Curv/Dist balance';
cnt = cnt +1;
dispParams(cnt).tag = 'numcores';
dispParams(cnt).name = '#Threads';
cnt = cnt +1;
