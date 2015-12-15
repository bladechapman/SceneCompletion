function [ out ] = normalize( in )
%i dont wanna type this out 3 times but it scales the values in in to [0,1]

out = (in - min(in))/(max(in) - min(in));

end

