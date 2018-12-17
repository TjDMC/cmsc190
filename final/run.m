func_num=0;
D=2;
Xmin=-5;
Xmax=5;
pop_size=100;
iter_max=300;
runs=10;
fhd = @fit_fun;

for i=1:runs
    [gbest,gbestval,FES]= LOA_func(fhd,D,pop_size,iter_max,Xmin,Xmax,func_num);
end

% sphere 1d (0,0) minima
% function fitness = fit_fun(pos, n)
%     fitness = pos(1)^2;
% end

% sphere 2d (0,0) minima
% function fitness = fit_fun(pos, n)
%     fitness = pos(1)^2 + pos(2)^2;
% end

% sphere 3d (0,0) minima
% function fitness = fit_fun(pos, n)
%     fitness = pos(1)^2+pos(2)^2+pos(3)^2;
% end

% RASTRIGIN (0, 0) minima
% function fitness = fit_fun(pos, n)
%     dimensions = length(pos);
%     fitness = 10*dimensions;
%     for i=1:dimensions
%         xi = pos(i);
%         fitness = fitness + xi ^ 2 - 10 * cos(2*pi*xi);
%     end
% end

% ROSENBROCK (a=2, b=100) (2, 4) minima
function fitness = fit_fun(pos, n)
    dimensions = length(pos);
    fitness = 10*dimensions;
    for i=1:dimensions
        xi = pos(i);
        fitness = fitness + xi ^ 2 - 10 * cos(2*pi*xi);
    end
    fitness = (2-pos(1))^2+100*(pos(2)-pos(1)^2)^2;
end

% ROSENBROCK (a=9, b=100) (2, 4) minima
% function fitness = fit_fun(pos, n)
%     dimensions = length(pos);
%     fitness = 10*dimensions;
%     for i=1:dimensions
%         xi = pos(i);
%         fitness = fitness + xi ^ 2 - 10 * cos(2*pi*xi);
%     end
%     fitness = (2-pos(1))^2+100*(pos(2)-pos(1)^2)^2;
% end