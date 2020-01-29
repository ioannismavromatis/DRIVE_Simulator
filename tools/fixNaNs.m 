function polygons = fixNaNs(polygons)
%FIXNANS After merging and simplifying, some polygons end up with some NaN
%  values. This functions removes these blemishes.
%
%  Input  :
%     polygons : The polygons given in a three-column format [ ID, Latitude,
%                Longitude ].
%
%  Output :
%     polygons : The merged polygons after the processing.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    idx = find(isnan(polygons(:,3)));

    newPolygon = [];
    idxToRemove = [];

    for i = 1:length(idx)
        idPolygon = polygons(idx(i),1);
        arrayPos = find(polygons(:,1)==idPolygon);
        idxTmp = find(arrayPos == idx(i));

        maxPolygonID = max(polygons(:,1));
        polygonTmp = polygons(polygons(:,1)==idPolygon,:);
        polygonTmp = polygonTmp(idxTmp+1:end,:);
        moreIdxToRemove = find(isnan(polygonTmp(:,3)));
        polygonTmp(moreIdxToRemove,:) = [];
        newPolygon = [ newPolygon ; repmat(maxPolygonID + i,[length(polygonTmp),1]) polygonTmp(:,2:3) ];

        
        idxToRemove = [ idxToRemove ; arrayPos(idxTmp:end) ];
    end

    polygons(idxToRemove,:) = [];
    polygons = [ polygons ; newPolygon ];
end
