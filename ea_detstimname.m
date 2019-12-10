function [stimname,preexist]=ea_detstimname(options)
preexist = 0;

% check if previous stimulations have been stored
if ~isfield(options,'root') % called from lead group
    stimname = ['gs_',options.groupid];
    return
end

directory = [options.root,options.patientname,filesep];
stimname = cell(0);
if exist([directory,'stimulations'],'dir')
    stimdir = dir([directory,'stimulations']);
    [~, ind] = sort([stimdir(:).datenum], 'descend'); % show the latest modified first
    stimdir = stimdir(ind);
    stimname = {stimdir(cell2mat({stimdir.isdir})).name};
    stimname = stimname(cellfun(@(x) ~strncmp(x,'.',1) && ~strncmp(x,'gs_',3), stimname));
end

if ~isempty(stimname)
    preexist = 1;
end

if isempty(stimname) || (isfield(options, 'gen_newstim') && options.gen_newstim==1)
    stimname{end+1} = ea_getnewstimname;
end

% add commands
stimname{end+1} = ' => New stimulation';
stimname{end+1} = ' => Rename stimulation';
stimname{end+1} = ' => Delete stimulation';
stimname = stimname';


function stimname=ea_getnewstimname
try
    stimname=datestr(datevec(now), 'yyyymmddHHMMSS' );
catch
    import java.util.UUID;

    uid = char(UUID.randomUUID());
end
while 1
    stimc = inputdlg('Please enter a label for this stimulation','Stimulation Label',1,{stimname});
    if length(stimc{1})<3
        break
    else
        if strcmp(stimc{1}(1:3),'gs_')
            msgbox('Please do not choose a stimulation label that starts with "gs_". These are reserved letters used in stimulations programmed inside Lead Group.')
        else
            break
        end
    end
end
stimname=stimc{1};
