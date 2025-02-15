function [history] = parseVSPAero_history(filename)
%
% Function to parse a VSPAero .history file into a structure of
% coefficients
%
% Coefficients are laid out with beta rows and alpha columns
%
% Copyright Tristan Sherman 2020-2022

%Open log file
fid = fopen(filename,'rt');

%Initialize
tline = fgetl(fid);
nlines = 1;
first_pt = 1;


%% Get Run Parameters
 while ~contains(tline,'# Name')
      tline = fgetl(fid);
 end
 tline = fgetl(fid);   
 history.S = str2num(tline(6:34));
 tline = fgetl(fid);   
 history.Cref = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Bref = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Xcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Ycg = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Zcg = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Mach = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.AoA = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Beta = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.rho = str2num(tline(6:34));
 tline = fgetl(fid); 
 history.Vinf = str2num(tline(6:34));
 
%% Collect Aero Data
while ischar(tline)
    
      if contains(tline, 'Iter')
          for Iter = 1:5
              tline = fgetl(fid);
          end
          
          AoA = str2num(tline(21:29));
          Beta = str2num(tline(31:39));
          if ~ismember(AoA,history.AoA)
              history.AoA(end+1) = AoA;
          end
          if ~ismember(Beta,history.Beta)
              history.Beta(end+1) = Beta;
          end
          
          AoA_idx = find(history.AoA == AoA);
          Beta_idx = find(history.Beta == Beta);
          
          try
          
          history.CL(Beta_idx,AoA_idx) = str2num(tline(40:49));
          history.CDo(Beta_idx,AoA_idx) = str2num(tline(50:59));
          history.CDi(Beta_idx,AoA_idx) = str2num(tline(60:69));
          history.CDtot(Beta_idx,AoA_idx) = str2num(tline(70:79));
          history.CS(Beta_idx,AoA_idx) = str2num(tline(80:89));
          history.CFx(Beta_idx,AoA_idx) = str2num(tline(110:119));
          history.CFy(Beta_idx,AoA_idx) = str2num(tline(120:129));
          history.CFz(Beta_idx,AoA_idx) = str2num(tline(130:139));
          history.CMx(Beta_idx,AoA_idx) = str2num(tline(140:149));
          history.CMy(Beta_idx,AoA_idx) = str2num(tline(150:159));
          history.CMz(Beta_idx,AoA_idx) = str2num(tline(160:169));
          
          catch
              msg = sprintf('Error reading line %d',nlines)
              %error(msg);
          end
          
      end
          
    tline = fgetl(fid);
    nlines = nlines+1;

end
  fclose('all');
end