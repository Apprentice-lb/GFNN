function g = gauss( x, x_aver, sigma )
%GAUSSIAN ��˹����
%   ��˹������aĬ��Ϊ1

g = exp(-(x-x_aver).^2./sigma.^2);

end

