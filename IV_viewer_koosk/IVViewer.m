function varargout = IVViewer(varargin)
% IVVIEWER MATLAB code for IVViewer.fig
%      IVVIEWER, by itself, creates a new IVVIEWER or raises the existing
%      singleton*.
%
%      H = IVVIEWER returns the handle to a new IVVIEWER or the handle to
%      the existing singleton*.
%
%      IVVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVVIEWER.M with the given input arguments.
%
%      IVVIEWER('Property','Value',...) creates a new IVVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IVViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IVViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IVViewer

% Last Modified by GUIDE v2.5 26-Nov-2018 13:06:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IVViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @IVViewer_OutputFcn, ...
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


% --- Executes just before IVViewer is made visible.
function IVViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IVViewer (see VARARGIN)

% Choose default command line output for IVViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initData(handles);

% UIWAIT makes IVViewer wait for user response (see UIRESUME)
% uiwait(handles.ivViewerFig);


% --- Outputs from this function are returned to the command line.
function varargout = IVViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function initData(handles)
model = IVViewerModel();
model.datasum = evalin('base', 'datasum');
model.includeIdx = evalin('base', 'includeIdx');
model.humanOnlyIdx = evalin('base', 'humanOnlyIdx');
model.ratOnlyIdx = evalin('base', 'ratOnlyIdx');
handles.ivViewerFig.UserData = model;
refreshMaxIdxText(handles);



% --- Executes on selection change in idxChooserPopupmenu.
function idxChooserPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to idxChooserPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns idxChooserPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from idxChooserPopupmenu
refreshMaxIdxText(handles);

function refreshMaxIdxText(handles)
model = handles.ivViewerFig.UserData;
selectedIdx = getSelectedIdx(handles);
switch selectedIdx
    case 1
        handles.maxIdxText.String = ['/', num2str(nnz(model.includeIdx))];
    case 2
        handles.maxIdxText.String = ['/', num2str(nnz(model.ratOnlyIdx))];
    case 3
        handles.maxIdxText.String = ['/', num2str(nnz(model.humanOnlyIdx))];
end
handles.shownIdxEdit.String = '';



function selectedIdx = getSelectedIdx(handles)
selectedIdx = get(handles.idxChooserPopupmenu,'Value');

% --- Executes during object creation, after setting all properties.
function idxChooserPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idxChooserPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prevBtn.
function prevBtn_Callback(hObject, eventdata, handles)
% hObject    handle to prevBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model = handles.ivViewerFig.UserData;
selectedIdx = getSelectedIdx(handles);
switch selectedIdx
    case 1
        selectedIdxList = model.includeIdx;
    case 2
        selectedIdxList = model.ratOnlyIdx;
    case 3
        selectedIdxList = model.humanOnlyIdx;
end
numSelected = nnz(selectedIdxList);
cIdx = str2double(handles.shownIdxEdit.String);
if isnan(cIdx)
    cIdx = numSelected;
end
newIdx = cIdx - 1;

if newIdx < 1
    newIdx = numSelected;
end
if numSelected ~= 0
    handles.shownIdxEdit.String = num2str(newIdx);
    
    nnzIndices = find(selectedIdxList);
    datasumIdx = nnzIndices(newIdx);
    datasumEntry = model.datasum(datasumIdx);
    IVGui(datasumEntry, newIdx, datasumIdx);
end

% --- Executes on button press in nextBtn.
function nextBtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model = handles.ivViewerFig.UserData;
cIdx = str2double(handles.shownIdxEdit.String);
if isnan(cIdx)
    cIdx = 0;
end
newIdx = cIdx + 1;
selectedIdx = getSelectedIdx(handles);
switch selectedIdx
    case 1
        selectedIdxList = model.includeIdx;
    case 2
        selectedIdxList = model.ratOnlyIdx;
    case 3
        selectedIdxList = model.humanOnlyIdx;
end
numSelected = nnz(selectedIdxList);
if newIdx > numSelected
    newIdx = 1;
end
if numSelected ~= 0
    handles.shownIdxEdit.String = num2str(newIdx);
    
    nnzIndices = find(selectedIdxList);
    datasumIdx = nnzIndices(newIdx);
    datasumEntry = model.datasum(datasumIdx);
    IVGui(datasumEntry, newIdx, datasumIdx);
end


function shownIdxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to shownIdxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shownIdxEdit as text
%        str2double(get(hObject,'String')) returns contents of shownIdxEdit as a double

model = handles.ivViewerFig.UserData;
newIdx = str2double(handles.shownIdxEdit.String);
if isnan(newIdx)
    handles.shownIdxEdit.String = '#';
end
selectedIdx = getSelectedIdx(handles);
switch selectedIdx
    case 1
        selectedIdxList = model.includeIdx;
    case 2
        selectedIdxList = model.ratOnlyIdx;
    case 3
        selectedIdxList = model.humanOnlyIdx;
end
numSelected = nnz(selectedIdxList);
if newIdx > numSelected
    newIdx = numSelected;
    handles.shownIdxEdit.String = num2str(newIdx);
end
if newIdx < 1
    newIdx = 1;
    handles.shownIdxEdit.String = num2str(newIdx);
end
if numSelected ~= 0
    handles.shownIdxEdit.String = num2str(newIdx);
    
    nnzIndices = find(selectedIdxList);
    datasumIdx = nnzIndices(newIdx);
    datasumEntry = model.datasum(datasumIdx);
    IVGui(datasumEntry, newIdx, datasumIdx);
end

% --- Executes during object creation, after setting all properties.
function shownIdxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shownIdxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
