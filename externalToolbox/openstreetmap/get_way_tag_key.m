function [key, val] = get_way_tag_key(tag)
% get tags and key values for ways
%
% 2010.11.21 (c) Ioannis Filippidis, jfilippidis@gmail.com
%
% See also PLOT_WAY, EXTRACT_CONNECTIVITY.
%
% Modified Ioannis Mavromatis 2017

strToCmp = {'building','amenity','shop','highway','natural','landuse','leisure'};

if isstruct(tag) == 1
    key = tag.Attributes.k;
    val = tag.Attributes.v;
elseif iscell(tag) == 1
    loop = 0;
    cnt = 1;
    while ~loop
        key = tag{cnt}.Attributes.k;
        val = tag{cnt}.Attributes.v;
        if cnt==length(tag)
            loop = 1;
        else
            loop = ismember(key,strToCmp);
            cnt = cnt + 1;
        end
        

    end
else
    if isempty(tag)
        warning('Way has NO tag.')
    else
        warning('Way has tag which is not a structure nor cell array, but:')
        disp(tag)
    end
    
    key = '';
    val = '';
end
