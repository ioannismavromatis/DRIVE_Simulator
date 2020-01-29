function verbose(text, value)
%verbose Print the given text if the existing verbose level is above a
%certain level.
%
%  Input  :
%     text  : The test to be displayed.
%     value : The value to be displayed (optional).
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global VERBOSELEVEL
    
    if nargin == 1
        value = [];
    end
    
    if VERBOSELEVEL>=1
        fprintf([text '\n'],value);
    end
end

