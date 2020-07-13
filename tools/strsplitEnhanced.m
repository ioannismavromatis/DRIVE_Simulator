function [pathCell] = strsplitEnhanced(path,delimiter)
%strsplitEnhanced DRIVE uses several path construction strings. Windows- and
% Unix-based systems behave differently when reading a path (forward and
% backward slashes). This functions overcomes the limitations introduced by
% the user's operating system.
%
%  Input  :
%     path       : Read the given path at the function.
%     delimiter  : Read the given delimeter.
% 
%  Output :
%     pathCell   : The constructed cell that contains all the strings
%                  coming from the splitting function.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    if strcmp(delimiter,'/')
        if ismac || isunix
            delimiter = '/';
        elseif ispc
            delimiter = '\';
        else
            error('Unknown operating system. DRIVE is intended to be used with macOS, Linux and Windows OSs.')
        end
    end
    
    pathCell = strsplit(path,delimiter);
end

