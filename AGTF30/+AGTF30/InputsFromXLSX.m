function inputs = InputsFromXLSX(FileName, Default_inputs)


% *************************************************************************
% written by Jeffryes Chapman
% NASA Glenn Research Center, Cleveland, OH
% Aug 15th, 2016
%
% *************************************************************************


inputs = Default_inputs;

[A,B,C] = xlsread(FileName);
for i = 2:size(C,1)
    Nm = C(i,2);
    Tm = C(i,3);
    Name = Nm{1};
    TVecNm = Tm{1};
    TVGood = 0;
    if prod(~isnan(Name))
        Name = strtrim(Name);
    end
    if prod(~isnan(TVecNm))
        TVecNm = strtrim(TVecNm);
        TVGood = 1;
    end
    
    RdNxt = 1;
    
    if isfield(inputs,Name)
        
    elseif isvarname(Name) && prod(~isnan(Name))
        Data = C(i,4:end);
        for ii = 1: length(Data)
            % Begin reading Data
            if prod(~isnan(Data{ii})) && RdNxt && isnumeric(Data{ii})
                inputs.(Name)(ii) = Data{ii};
                if TVGood == 1
                    TStr.(Name) = TVecNm;
                else
                    TStr.(Name) = 'BadName';
                end
            elseif prod(~isnan(Data{ii})) && RdNxt && iscellstr(Data(ii))
                inputs.(Name) = char(Data(ii));
                RdNxt = 0;
            else
                RdNxt = 0;
            end
        end
    end
    
end

List = fields(TStr);
for i = 1: length(List)
    ItNm = char(List(i));
    CurTVecNm = TStr.(ItNm);
    if isfield('inputs',ItNm)
        if length(inputs.(ItNm)) == length(inputs.(CurTVecNm))
            inputs.(ItNm) = [inputs.(ItNm); inputs.(CurTVecNm)];
        else
            fprintf('Check time vector length in excel sheet')
        end
    end
end

