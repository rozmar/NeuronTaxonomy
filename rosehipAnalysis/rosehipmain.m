function varargout = rosehipmain(varargin)
% ROSEHIPMAIN MATLAB code for rosehipmain.fig
%      ROSEHIPMAIN, by itself, creates a new ROSEHIPMAIN or raises the existing
%      singleton*.
%
%      H = ROSEHIPMAIN returns the handle to a new ROSEHIPMAIN or the handle to
%      the existing singleton*.
%
%      ROSEHIPMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROSEHIPMAIN.M with the given input arguments.
%
%      ROSEHIPMAIN('Property','Value',...) creates a new ROSEHIPMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rosehipmain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rosehipmain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rosehipmain

% Last Modified by GUIDE v2.5 05-Sep-2016 17:18:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rosehipmain_OpeningFcn, ...
                   'gui_OutputFcn',  @rosehipmain_OutputFcn, ...
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


% --- Executes just before rosehipmain is made visible.
function rosehipmain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rosehipmain (see VARARGIN)

% Choose default command line output for rosehipmain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rosehipmain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rosehipmain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  isInCorrect = checkParams(handles);
  
  [locations]=marcicucca_locations;
  path=[locations.matlabstuffdir,'20130227_xlwrite/'];
  javaaddpath([path 'poi_library/poi-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/poi-ooxml-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/xmlbeans-2.3.0.jar']);
  javaaddpath([path 'poi_library/dom4j-1.6.1.jar']);
  path=[locations.matlabstuffdir,'20130227_xlwrite/'];
  javaaddpath([path 'poi_library/poi-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/poi-ooxml-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
  javaaddpath([path 'poi_library/xmlbeans-2.3.0.jar']);
  javaaddpath([path 'poi_library/dom4j-1.6.1.jar']);
  
  if isInCorrect==0
  
      parameters.dataFile = get(handles.datadirpath, 'String');
      parameters.dataSums = get(handles.dsdirpath, 'String');
      parameters.cutInterval = str2double(get(handles.edit1, 'String'));
      parameters.nMinAp = str2double(get(handles.edit2, 'String'));
      runClassification(parameters);
  
  else
    errorText = '';
    switch isInCorrect
        case 1
            errorText = 'Data file directory is empty'; 
        case 2
            errorText = 'Datasum file directory is empty';
        case 3
            errorText = 'Cut interval is invalid';
        case 4
            errorText = 'Min. AP number is invalid';
    end
    
    errordlg(errorText);
  end


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  close gcf;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dsdirbutton.
function dsdirbutton_Callback(hObject, eventdata, handles)
% hObject    handle to dsdirbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 folder_name = uigetdir;
 if folder_name==0
   set(handles.dsdirpath, 'String', '');
 else
   set(handles.dsdirpath, 'String', folder_name);
 end


% --- Executes on button press in datadirbutton.
function datadirbutton_Callback(hObject, eventdata, handles)
% hObject    handle to datadirbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 folder_name = uigetdir;
 if folder_name==0
   set(handles.datadirpath, 'String', '');
 else
   set(handles.datadirpath, 'String', folder_name);
 end


% --- Executes during object creation, after setting all properties.
function dsdirpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dsdirpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function datadirpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datadirpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function isInCorrect = checkParams(handles)
  isInCorrect = 0;
  if isempty(get(handles.datadirpath, 'String'))
    isInCorrect = 1;
  elseif isempty(get(handles.dsdirpath, 'String'))
    isInCorrect = 2;
  else
    cutInterval = str2double(get(handles.edit1, 'String'));
    if isnan(cutInterval) || cutInterval<0 || cutInterval>1
      isInCorrect = 3;
    end
    nMinAp = str2double(get(handles.edit2, 'String'));
    if isnan(nMinAp) || nMinAp<4
      isInCorrect = 4; 
    end
  end
