function home = ea_gethome

if ispc
    home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
    home = getenv('HOME');
end

if ~strcmp(home(end), filesep)
    home = [home, filesep];
end

if isdeployed
   mkdir([ctfroot, filesep, 'home', filesep]);
   home = [ctfroot, filesep, 'home', filesep];
end
