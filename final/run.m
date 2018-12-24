close all

func_num=0;
D=2;
Xmin=-5;
Xmax=5;
pop_size=50;
iter_max=50;
fhd = @fit_fun;

[gbest,gbestval,FES]= LOA_func(fhd,D,pop_size,iter_max,Xmin,Xmax,func_num)

% RASTRIGIN (0, 0) minima
% function fitness = fit_fun(pos, n)
%     dimensions = length(pos);
%     fitness = 10*dimensions;
%     for i=1:dimensions
%         xi = pos(i);
%         fitness = fitness + xi ^ 2 - 10 * cos(2*pi*xi);
%     end
% end

% ROSENBROCK2d (0, 0) minima
function fitness = fit_fun(pos, n)
    fitness = (1-pos(1))^2 + 100*(pos(2) - pos(1)^2)^2;
end

% function fitness = fit_fun(pos, n)
%     dimensions = length(pos);
%     fitness = 0;
%     for i=1:dimensions
%         xi = pos(i);
%         fitness = fitness + cos(xi);
%     end
% end