function pathOut = strcatEnhanced(path)
%strcatEnhanced DRIVE uses several path construction strings. Windows- and
% Unix-based systems behave differently when constructing a path (forward and
% backward slashes). This functions overcomes the limitations introduced by
% the user's operating system.
%
%  Input  :
%     path    : Read the given path strings array.
% 
%  Output :
%     pathOut : The constructed path to be returned to the main program.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    if ispc
        pathOut = strrep(path,'/','\');
    elseif ismac || isunix
        pathOut = path;
    else
        error('Unknown operating system. DRIVE is intended to be used with macOS, Linux and Windows OSs.')
    end
end

