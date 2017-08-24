% - parameters - structure containing the parameters
%    - triggerType - type of trigger, possible values 
%       'marker' - the trigger will be an individual marker of a chan.
%       'sectionst' - start of a section
%       'sectionend' - end of a section
%    - triggerName - name of trigger channel. If the type is 'marker', the
%    exact name of the channel have to be given. If the type is 'sectionst' or
%    'sectionend', then the name of channel have to be given (without _st
%    or _end).