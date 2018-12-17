func_num=0;
D=2;
Xmin=-5;
Xmax=5;
pop_size=100;
iter_max=300;
runs=10;
fhd = @fit_fun;

worst = 0;
best = 0;
total = 0;
stotal = 0;
fifth=0;
sixth=0;
for i=1:runs
    [gbest,gbestval,FES]= LOA_func(fhd,D,pop_size,iter_max,Xmin,Xmax,func_num);
    if i==1
        worst = gbestval;
        best = gbestval;
    elseif gbestval>worst
        worst = gbestval;
    elseif gbestval<best
        best = gbestval;
    end
    total = total+gbestval;
    stotal = stotal+gbestval^2;
    
    if i==5
        fifth=gbestval;
    end
    if i==6
        sixth = gbestval;
    end
end

fprintf('\nbest,worst,best,std,median: %d %d %d %d\n',worst,best,(stotal-2*(total/runs)*total+(total/runs)^2)^(1/2),(fifth+sixth)/2);

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