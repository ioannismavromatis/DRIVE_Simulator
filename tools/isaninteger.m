function boolType = isaninteger(x)
%ISANINTEGER Check if the given number x is an integer
%
%  Input  :
%     x        : The given number.
%
%  Output :
%     boolType : A logical value showing whether it is a integer or not.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    boolType = isfinite(x) & x==floor(x);
end
