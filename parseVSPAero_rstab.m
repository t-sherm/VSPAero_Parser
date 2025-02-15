function [rstab] = parseVSPAero_rstab(filename)
%
% Function to parse a VSPAero unsteady file into a structure of
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
 rstab.S = str2num(tline(6:34));
 tline = fgetl(fid);   
 rstab.Cref = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Bref = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Xcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Ycg = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Zcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Mach = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.AoA = str2num(tline(6:34));
 AoA = rstab.AoA;
 tline = fgetl(fid); 
 rstab.Beta = str2num(tline(6:34));
 Beta = rstab.Beta;
 tline = fgetl(fid); 
 rstab.rho = str2num(tline(6:34));
 tline = fgetl(fid); 
 rstab.Vinf = str2num(tline(6:34));
 
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
        
        if ~ismember(AoA,rstab.AoA)
          rstab.AoA(end+1) = AoA;
        end
        
        if ~ismember(Beta,rstab.Beta)
            rstab.Beta(end+1) = Beta;
        end
    end
    
      
    % Log Coefficients
    if contains(tline, 'Yaw___Rate')
        
        for Iter = 1:3
          tline = fgetl(fid);
        end
        
        % Determine which AoA and Beta the coefs are for
        AoA_idx = find(rstab.AoA == AoA);
        Beta_idx = find(rstab.Beta == Beta);   
        

        % Unsteady Coefficients
        rstab.CFx_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CFy_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CFz_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMx_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMy_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMz_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CL_axis_betaDot(Beta_idx, AoA_idx)  = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CD_axis_betaDot(Beta_idx, AoA_idx)  = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CS_axis_betaDot(Beta_idx, AoA_idx)  = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMl_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMm_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));
        tline = fgetl(fid);
        rstab.CMn_axis_betaDot(Beta_idx, AoA_idx) = str2double(tline(25:34));

    end
          
    tline = fgetl(fid);
    nlines = nlines+1;

end
  fclose('all');
end