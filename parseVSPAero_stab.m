function [stab] = parseVSPAero_stab(filename)
%
% Function to parse a VSPAero .stab file into a structure of
% coefficients
%
% Copyright Tristan Sherman 2020-2022


%Open log file
fid = fopen(filename,'rt');

%Initialize
tline = fgetl(fid);
nlines = 1;
first_run = true;


%% Get Run Parameters
 while ~contains(tline,'# Name')
      tline = fgetl(fid);
 end
 tline = fgetl(fid);   
 stab.S = str2num(tline(6:34));
 tline = fgetl(fid);   
 stab.Cref = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Bref = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Xcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Ycg = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Zcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Mach = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.AoA = str2num(tline(6:34));
 AoA = stab.AoA;
 tline = fgetl(fid); 
 stab.Beta = str2num(tline(6:34));
 Beta = stab.Beta;
 tline = fgetl(fid); 
 stab.rho = str2num(tline(6:34));
 tline = fgetl(fid); 
 stab.Vinf = str2num(tline(6:34));
 
%% Collect Aero Data
while ischar(tline)
    
    % Log Beta and AoA
    if contains(tline, '# Name')
        for Iter = 1:8
          tline = fgetl(fid);
        end
          
        AoA = str2num(tline(6:34));
        tline = fgetl(fid); 
        Beta = str2num(tline(6:34));
        
        if ~ismember(AoA,stab.AoA)
          stab.AoA(end+1) = AoA;
        end
        
        if ~ismember(Beta,stab.Beta)
            stab.Beta(end+1) = Beta;
        end
    end
    
      
    % Log Coefficients
    if contains(tline, 'Coef')
        
        % Determine which AoA and Beta the coefs are for
        AoA_idx = find(stab.AoA == AoA);
        Beta_idx = find(stab.Beta == Beta);   
        
        for Iter = 1:4
          tline = fgetl(fid);
        end
        
        % Split data
        data = split(tline);

        % Count number of control surfaces used
        N_CS = length(data)-10;

        % CFX Coefficients
        stab.CFx_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CFx_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CFx_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CFx_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CFx_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CFx_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CFx_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS>0
            % In this case there are additional control surfaces
            for CS = 1:N_CS
                stab.CFx_ds(Beta_idx, AoA_idx, CS) = str2double(data(9+CS));
            end
        end
        

        % CFy Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CFy_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CFy_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CFy_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CFy_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CFy_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CFy_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CFy_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS>0
            % In this case there are additional control surfaces
            for CS = 1:N_CS
                stab.CFy_ds(Beta_idx, AoA_idx, CS) = str2double(data(9+CS));
            end
        end

        % CFz Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CFz_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CFz_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CFz_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CFz_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CFz_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CFz_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CFz_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CFz_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMx Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMx_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMx_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMx_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMx_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMx_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMx_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMx_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMx_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMy Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMy_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMy_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMy_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMy_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMy_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMy_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMy_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMy_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMz Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMz_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMz_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMz_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMz_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMz_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMz_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMz_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMz_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CL Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CL_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CL_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CL_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CL_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CL_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CL_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CL_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CL_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CD Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CD_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CD_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CD_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CD_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CD_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CD_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CD_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CD_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CS Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CS_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CS_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CS_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CS_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CS_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CS_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CS_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CS_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMl Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMl_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMl_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMl_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMl_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMl_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMl_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMl_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMl_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMm Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMm_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMm_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMm_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMm_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMm_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMm_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMm_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMm_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end
        
        % CMn Coefficients
        tline = fgetl(fid);
        data = split(tline); % Split data
        stab.CMn_base(Beta_idx, AoA_idx) = str2double(data(2));
        stab.CMn_alpha(Beta_idx, AoA_idx) = str2double(data(3));
        stab.CMn_beta(Beta_idx, AoA_idx) = str2double(data(4));
        stab.CMn_p(Beta_idx, AoA_idx) = str2double(data(5));
        stab.CMn_q(Beta_idx, AoA_idx) = str2double(data(6));
        stab.CMn_r(Beta_idx, AoA_idx) = str2double(data(7));
        stab.CMn_M(Beta_idx, AoA_idx) = str2double(data(8));
        % Control surface effects
        if N_CS > 0
            for CS = 1:N_CS
                stab.CMn_ds(Beta_idx, AoA_idx, CS) = str2double(data(9 + CS));
            end
        end

        for Iter = 1:5
            tline = fgetl(fid);
        end
        
        stab.SM(Beta_idx, AoA_idx) = str2num(tline(24:34));
        tline = fgetl(fid);
        stab.X_np(Beta_idx, AoA_idx) = str2num(tline(24:34));

    end
          
    tline = fgetl(fid);
    nlines = nlines+1;

end
  fclose('all');
end