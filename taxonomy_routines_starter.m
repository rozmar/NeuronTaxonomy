function varargout = taxonomy_routines_starter(varargin)
% TAXONOMY_ROUTINES_STARTER MATLAB code for taxonomy_routines_starter.fig
%      TAXONOMY_ROUTINES_STARTER, by itself, creates a new TAXONOMY_ROUTINES_STARTER or raises the existing
%      singleton*.
%
%      H = TAXONOMY_ROUTINES_STARTER returns the handle to a new TAXONOMY_ROUTINES_STARTER or the handle to
%      the existing singleton*.
%
%      TAXONOMY_ROUTINES_STARTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAXONOMY_ROUTINES_STARTER.M with the given input arguments.
%
%      TAXONOMY_ROUTINES_STARTER('Property','Value',...) creates a new TAXONOMY_ROUTINES_STARTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before taxonomy_routines_starter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to taxonomy_routines_starter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help taxonomy_routines_starter

% Last Modified by GUIDE v2.5 11-Mar-2019 14:45:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @taxonomy_routines_starter_OpeningFcn, ...
                   'gui_OutputFcn',  @taxonomy_routines_starter_OutputFcn, ...
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


% --- Executes just before taxonomy_routines_starter is made visible.
function taxonomy_routines_starter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to taxonomy_routines_starter (see VARARGIN)

% Choose default command line output for taxonomy_routines_starter
handles.output = hObject;

handles.projects=varargin{1};
set(handles.listbox1,'String',{handles.projects.Name});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes taxonomy_routines_starter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = taxonomy_routines_starter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outputt.projectnum=get(handles.listbox1,'Value');
handles.outputt.importrawdata=get(handles.checkbox1,'Value');
handles.outputt.collectfeatures=get(handles.checkbox2,'Value');
handles.outputt.exportivs=get(handles.checkbox3,'Value');
handles.outputt.doPCA=get(handles.checkbox4,'Value');
handles.outputt.doRosehipanal=get(handles.checkbox5,'Value');
handles.outputt.generateXLSfile=get(handles.checkbox6,'Value');
handles.outputt.ivpercell=get(handles.checkbox7,'Value');
handles.outputt.reexportALLHEKAfiles=get(handles.checkbox8,'Value');
handles.outputt.IV_viewer=get(handles.checkbox9,'Value');
if ~handles.outputt.ivpercell
    handles.outputt.ivpercell='export every damn IV';
end
assignin('base', 'projectdata', handles.outputt);
close(handles.figure1);
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject.Value
    handles.checkbox1.Enable='off';
    handles.checkbox2.Enable='off';
    handles.checkbox3.Enable='off';
    handles.checkbox5.Enable='off';
    handles.checkbox6.Enable='off';
    handles.checkbox7.Enable='off';
    handles.checkbox8.Enable='off';
    handles.checkbox9.Enable='off';
else
    handles.checkbox1.Enable='on';
    handles.checkbox2.Enable='on';
    handles.checkbox3.Enable='on';
    handles.checkbox5.Enable='on';
    handles.checkbox6.Enable='on';
    handles.checkbox7.Enable='on';
    handles.checkbox8.Enable='on';
    handles.checkbox9.Enable='on';
end
% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject.Value
    handles.checkbox1.Enable='off';
    handles.checkbox2.Enable='off';
    handles.checkbox3.Enable='off';
    handles.checkbox4.Enable='off';
    handles.checkbox5.Enable='off';
    handles.checkbox6.Enable='off';
    handles.checkbox7.Enable='off';
    handles.checkbox8.Enable='off';
else
    handles.checkbox1.Enable='on';
    handles.checkbox2.Enable='on';
    handles.checkbox3.Enable='on';
    handles.checkbox4.Enable='on';
    handles.checkbox5.Enable='on';
    handles.checkbox6.Enable='on';
    handles.checkbox7.Enable='on';
    handles.checkbox8.Enable='on';
end
% Hint: get(hObject,'Value') returns toggle state of checkbox9
