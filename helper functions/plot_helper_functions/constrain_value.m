function output = constrain_value(val, low, up)
    output = max([low,min([val,up])]);
end