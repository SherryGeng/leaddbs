function ea_refresh_lg_connectome(handles)

ea_busyaction('on',handles.leadfigure,'group');

% get analysis data
M=getappdata(handles.leadfigure,'M');

if strcmp(get(handles.groupdir_choosebox,'String'),'Choose Group Directory') % not set yet.
    ea_busyaction('off',handles.leadfigure,'group');
    return
end

if ~isfield(M,'guid') % only done once, legacy support.
    M.guid=datestr(datevec(now), 'yyyymmddHHMMSS' );
end

disp('Refreshing group list...');
% refresh group list
set(handles.grouplist,'String',M.patient.group);
if max(M.ui.listselect) > length(M.patient.group)
    M.ui.listselect = 1;
end
try set(handles.grouplist,'Value',M.ui.listselect); end

disp('Refreshing patient list...');
% refresh patient list
set(handles.patientlist,'String',M.patient.list);
try set(handles.patientlist,'Value',M.ui.listselect); end

disp('Refreshing clinical list...');
% refresh clinical list
set(handles.clinicallist,'String',M.clinical.labels);
try set(handles.clinicallist,'Value',M.ui.clinicallist); end


if get(handles.clinicallist,'Value')>length(get(handles.clinicallist,'String'))
    set(handles.clinicallist,'Value',length(get(handles.clinicallist,'String')));
end

try set(handles.labelpopup,'Value',M.ui.labelpopup); end

disp('Adding graph metrics to connectome popup...');
% add graph metrics to connectome graph-metrics popup:
thisparc=get(handles.labelpopup,'String');

if get(handles.labelpopup,'Value')>length(get(handles.labelpopup,'String'))
    useparc=length(get(handles.labelpopup,'String'));
else
    useparc=get(handles.labelpopup,'Value');
end

thisparc=thisparc{useparc};
try
    gms = dir([M.patient.list{1},filesep,'connectomics',filesep,thisparc,filesep,'graph',filesep,'*.nii']);
    gms = cellfun(@(x) {strrep(x, '.nii', '')}, {gms.name});

    if ~isempty(gms)
        gms=ea_appendpairs(gms);
        set(handles.lc_graphmetric, 'String', gms);
    else
        set(handles.lc_graphmetric, 'Value', 1);
        set(handles.lc_graphmetric, 'String', 'No graphic metric found');
    end
end

%% modalities for VAT metrics:

% dMRI:
cnt=1;
options.prefs=ea_prefs('');
options.earoot=ea_getearoot;
try
    directory=[M.patient.list{1},filesep];
    modlist=ea_genmodlist(directory,thisparc,options);
    if ~ismember('Patient''s fiber tracts' ,modlist)
        modlist{end+1}='Patient''s fiber tracts';
    end
    modlist{end+1}='Do not calculate connectivity stats';
    set(handles.fiberspopup,'String',modlist);
    if get(handles.fiberspopup,'Value') > length(modlist)
        set(handles.fiberspopup,'Value',1);
    end
end

% update UI
disp('Updating UI...');

% update checkboxes:
try set(handles.normregpopup,'Value',M.ui.normregpopup); end
try set(handles.lc_normalization,'Value',M.ui.lc.normalization); end
try set(handles.lc_smooth,'Value',M.ui.lc.smooth); end

% update selectboxes:
fiberspopup = get(handles.fiberspopup,'String');
if ~(ischar(fiberspopup) && strcmp(fiberspopup, 'Fibers'))
    try set(handles.fiberspopup,'Value',M.ui.fiberspopup); end
end

lc_graphmetric = get(handles.lc_graphmetric,'String');
if ~(ischar(lc_graphmetric) && strcmp(lc_graphmetric, 'No graphic metric found'))
    try set(handles.lc_graphmetric,'Value',M.ui.lc.graphmetric); end
end

%% patient specific part:
if ~isempty(M.patient.list)

    % add modalities to NBS stats metric popup:
    disp('Adding modalities to NBS popup...');

    tryparcs=dir([M.patient.list{1},filesep,'connectomics',filesep,thisparc,filesep,'*_CM.mat']);
    if isempty(tryparcs)
        set(handles.lc_metric, 'Value', 1);
        set(handles.lc_metric, 'String', 'No data found');
    else
        avparcs=ones(length(tryparcs),1);
        for sub=1:length(M.patient.list)
            for parc=1:length(tryparcs)
                if ~exist([M.patient.list{1},filesep,'connectomics',filesep,thisparc,filesep,tryparcs(parc).name],'file')
                    avparcs(parc)=0;
                end
            end
        end

        tryparcs=tryparcs(logical(avparcs));
        pcell=cell(length(tryparcs),1);
        restcnt=1;
        restcell=cell(0);
        for p=1:length(pcell)
            [~,pcell{p}]=fileparts(tryparcs(p).name);
            if strcmp(pcell{p}(1:4),'rest')
                ix=strfind(pcell{p},'_');
               restcell{restcnt}=pcell{p}(ix(1)+1:ix(2)-1);
               restcnt=restcnt+1;
            end
        end
        for restii=1:length(restcell)
            for restjj=1:length(restcell)
                if restii>restjj
                   pcell{end+1}=['rest_',restcell{restii},'&',restcell{restjj},'_fMRI_CM'];
                end
            end
        end
        set(handles.lc_metric,'String',pcell);
    end
end

% store everything
setappdata(handles.leadfigure,'M',M);

disp('Done.');

ea_busyaction('off',handles.leadfigure,'group');


function gms=ea_appendpairs(gms)
cnt=1;
for g=1:length(gms)
    pfxs=strfind(gms{g},'_');
    pfx=gms{g}(1:pfxs(1));
    others=1:length(gms);
    others(g)=[];
    for h=others
        if strcmp(gms{h}(1:length(pfx)),pfx)
          toappend{cnt}=[gms{g},'>',gms{h}];
          toappend{cnt+1}=[gms{h},'>',gms{g}];
          cnt=cnt+2;
        end
    end

end

gms=[gms,toappend];



