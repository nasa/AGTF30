%Remove engine path
if exist('MWS','var')
    if isfield('MWS','top_level')
        rmpath(MWS.top_level);
    else
        rmpath(pwd)
    end
else
    rmpath(pwd);
end
