function varargout = IVGui(varargin)
% IVGUI MATLAB code for IVGui.fig
%      IVGUI, by itself, creates a new IVGUI or raises the existing
%      singleton*.
%
%      H = IVGUI returns the handle to a new IVGUI or the handle to
%      the existing singleton*.
%
%      IVGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVGUI.M with the given input arguments.
%
%      IVGUI('Property','Value',...) creates a new IVGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IVGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IVGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IVGui

% Last Modified by GUIDE v2.5 23-Jul-2018 15:19:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IVGui_OpeningFcn, ...
                   'gui_OutputFcn',  @IVGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before IVGui is made visible.
function IVGui_OpeningFcn(hObject, ~, handles, datasumEntry, selectedX, datasumIdx, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IVGui (see VARARGIN)

% Choose default command line output for IVGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IVGui wait for user response (see UIRESUME)
% uiwait(handles.mainfigure);
guimodel = IVGuiModel();
guimodel.datasumEntry = datasumEntry;
guimodel.selectedX = selectedX;
guimodel.datasumIdx = datasumIdx;
handles.mainfigure.UserData = guimodel;

handles.mainfigure.Name = ['IVGui for selected index: ', num2str(selectedX), ', datasum index: ', num2str(datasumIdx)];
iv = datasumEntry.iv;
if isfield(iv,'realtime')
    [h,m,s] = realtime2hms(iv.realtime(1));
    handles.realtimeEdit.String = sprintf('%02d:%02d:%02.4f',h,m,s);
else
    [h,m,s] = realtime2hms(iv.timertime(1));
    handles.realtimeEdit.String = sprintf('%02d:%02d:%02.4f',h,m,s);
end
[h,m,s] = realtime2hms(iv.timertime(1));
% handles.timertimeEdit.String = sprintf('%02d:%02d:%02.4f',h,m,s);
handles.timertimeEdit.String = datasumEntry.ID;
if isfield(iv,'channellabel')
    handles.channellabelEdit.String = iv.channellabel;
else
    handles.channellabelEdit.String ='not specified';
end
if isfield(iv,'preamplnum')
    handles.preamplnumEdit.String = num2str(iv.preamplnum);
else
    handles.preamplnumEdit.String = 'not specified';
end
handles.holdingEdit.String = num2str(iv.holding);
% if isfield(iv,'recordingmode')
%     handles.recordingmodeEdit.String = iv.recordingmode;
% else
%     handles.recordingmodeEdit.String = 'not specified';
% end
handles.recordingmodeEdit.String = datasumEntry.fname;
if isfield(iv,'AmplifierID')
    handles.amplifierIdEdit.String = iv.AmplifierID;
else
    handles.amplifierIdEdit.String = 'not specified';
end
handles.sweepnumEdit.String = num2str(iv.sweepnum);
handles.segmentEdit.String = ['[', num2str(iv.segment(1)), ',', num2str(iv.segment(2)), ',', num2str(iv.segment(3)), ']'];
handles.bridgedRSEdit.String = datasumEntry.class;

handles.ivList.String = cellstr(num2str(transpose(1:iv.sweepnum)));
handles.ivList.Value = 1:numel(handles.ivList.String);

drawIvOnAxes(handles, handles.mainaxes);

handles.rinEdit.String = datasumEntry.rin;
handles.rsEdit.String = datasumEntry.RS;
handles.restingEdit.String = datasumEntry.resting;
handles.rheobaseEdit.String = datasumEntry.rheobase;
handles.thresholdMedianEdit.String = datasumEntry.thresholdmedian;
handles.apAmplMedianEdit.String = datasumEntry.apamplitudemedian;
handles.apHalfWidthMedianEdit.String = datasumEntry.aphalfwidthmedian;
handles.apMaxvMedianEdit.String = datasumEntry.apMaxVmedian;
handles.apAmpl1Edit.String = datasumEntry.apamplitude1;
handles.apHalfWidth1Edit.String = datasumEntry.aphalfwidth1;
handles.apMaxv1Edit.String = datasumEntry.apMaxV1;
handles.holding2Edit.String = iv.holding;





% --- Outputs from this function are returned to the command line.
function varargout = IVGui_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;



function realtimeEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function realtimeEdit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timertimeEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function timertimeEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ivList.
function ivList_Callback(~, ~, handles)
drawIvOnAxes(handles, handles.mainaxes);


% --- Executes during object creation, after setting all properties.
function ivList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channellabelEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function channellabelEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preamplnumEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function preamplnumEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function recordingmodeEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function recordingmodeEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amplifierIdEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function amplifierIdEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sweepnumEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function sweepnumEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segmentEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function segmentEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function holdingEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function holdingEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function drawIvOnAxes(handles, ax)
model = handles.mainfigure.UserData;
iv = model.datasumEntry.iv;
cla(ax);
ax.NextPlot = 'add';
sigma = model.gaussFilterSigma;
for i = handles.ivList.Value
    filteredIV = iv.(['v',sprintf('%d',i)]);
    if sigma>0
%         filteredIV = conv(filteredIV, fspecial('gaussian', [ceil(6*sigma-1), 1], sigma), 'same');
        filteredIV = imfilter(filteredIV, fspecial('gaussian', [ceil(6*sigma-1), 1], sigma), 'replicate');
    end
    plot(ax, iv.time, filteredIV, 'Color', 'blue');
end


% --- Executes on button press in selectAllBtn.
function selectAllBtn_Callback(~, ~, handles)
handles.ivList.Value = 1:numel(handles.ivList.String);
drawIvOnAxes(handles, handles.mainaxes)


% --- Executes on button press in popoutBtn.
function popoutBtn_Callback(~, ~, handles)
fig = figure;
ax = axes(fig);
drawIvOnAxes(handles, ax);



function gaussFilterSigmaEdit_Callback(hObject, ~, handles)
model = handles.mainfigure.UserData;
value = str2double(get(hObject,'String'));
if ~isnan(value)
    model.gaussFilterSigma = value;
    drawIvOnAxes(handles, handles.mainaxes);
end


% --- Executes during object creation, after setting all properties.
function gaussFilterSigmaEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rinEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rinEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rsEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rsEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function restingEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function restingEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rheobaseEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rheobaseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdMedianEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function thresholdMedianEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apAmplMedianEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function apAmplMedianEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apHalfWidthMedianEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function apHalfWidthMedianEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apMaxvMedianEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function apMaxvMedianEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apAmpl1Edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function apAmpl1Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apHalfWidth1Edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function apHalfWidth1Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apMaxv1Edit_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>


% --- Executes during object creation, after setting all properties.
function apMaxv1Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function holding2Edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function holding2Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bridgedRSEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function bridgedRSEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in putAxesToWorkspace.
function putAxesToWorkspace_Callback(~, ~, handles)
assignin('base', 'ivguiMainaxes', handles.mainaxes);
