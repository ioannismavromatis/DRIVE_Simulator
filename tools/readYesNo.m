function output = readYesNo(text, default,loadStr)
% readYesOrNo Ask the user to input yes or no from the keyboard. If nothing
% is pressed in 20s, then the default value is chosen.
%
%  Input  :
%     text     : The text that will be printed on the command window.
%     default  : The default value to be selected if nothing is chosen.
%     loadStr  : If loadStr is given, then it is checked whether the input
%                from the user will be skipped choosing the default value.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com
    
    global SIMULATOR
    
    if SIMULATOR.load~=2 && SIMULATOR.load~=1 && SIMULATOR.load~=0
        fprintf('The value for SIMULATOR.load is not correct!\n')
        error('Please, check the given value in the settings.m file.');
    end
    
    if nargin>2
        if SIMULATOR.load == 2
            output = defaultToValue(default);
            return;
        elseif SIMULATOR.load == 0
            output = 0;
            return;
        end
    end
    
    if strcmp(default,'y') || strcmp(default,'Y')
        default = 'Yes';
    elseif strcmp(default,'n') || strcmp(default,'N')
        default = 'No';
    else
        fprintf('The chosen input value is incorrect!\n')
        error('Please, give either Y/y or N/n when calling the readYesNo function!.');
    end
    
    title = [ '"' default '" is chosen after: ' ];
    dlgQuestion = text;
    choise = questdlg_timer(10,dlgQuestion,title,'Yes','No', default);
    
    while isempty(choise)
        disp('Something went wrong. Please choose again.');
        choise = questdlg_timer(10,dlgQuestion,title,'Yes','No', default);
    end
    
    if strcmp(choise,'Yes')
        output = 1;
    else
        output = 0;
    end
end

function v = defaultToValue(default)
    if isequal(default,'Y') || isequal(default,'y')
        v = 1;
    else
        v = 0;
    end
end
