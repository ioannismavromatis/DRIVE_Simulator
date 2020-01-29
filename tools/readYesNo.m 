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
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
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
    
    textInput = [ text ' Y/N [' default ']:'  ];
      
    t = timer('ExecutionMode', 'singleShot', 'StartDelay', 20, 'TimerFcn', @pressEnter);
    start(t)
    if java.lang.System.getProperty( 'java.awt.headless' )
        output = default;
    else
        output = input(textInput, 's');
    end
    
    if isempty(output)
        if (default == 'Y')
            output = 'y';
        else
            output = 'n';
        end
    end
    
    while ~(isequal(output,'Y') || isequal(output,'y')  || isequal(output,'N') || isequal(output,'n'))
        output = input('Invalid input. Please input either "Y/y" or "N/n": ', 's');
    end
    
    if isequal(output,'Y') || isequal(output,'y')
        output = 1;
    else
        output = 0;
    end
    stop(t)
    delete(t)
end

function pressEnter(hObj, event)
  import java.awt.*;
  import java.awt.event.*;
  rob = Robot;
  rob.keyPress(KeyEvent.VK_ENTER)
  rob.keyRelease(KeyEvent.VK_ENTER)
  pause(0.5)
  verbose('Input timer timeout. The default value was chosen.')
end

function v = defaultToValue(default)
    if isequal(default,'Y') || isequal(default,'y')
        v = 1;
    else
        v = 0;
    end
end
