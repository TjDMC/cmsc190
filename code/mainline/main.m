clear
clc
clf

% -----------------------
% Main Variables
% -----------------------

space_min = -5.12;
space_max = 5.12;

iterations = 300;
population = 100;
dimension = 3;
prides_length = 5;

percent_nomad = 0.2;
percent_roam = 0.5;
percent_sex = 0.8;

mating_rate = 0.3;
mutation_prob = 0.1;

immigration_rate = 0.4;

adapt_fun = @(x) fit_fun(x);

nomad_group = Group;
pride_groups = Group.empty(0, prides_length);

% -----------------------
% Initialize Lions
% -----------------------

rand_lio = rand(dimension, population).*(space_max-space_min)+space_min;

rand_pop = Lion.empty(0,population);
for i=1:population
    rand_cli = Lion;
    rand_cli.init(rand_lio(:,i), adapt_fun);
    rand_pop(i) = rand_cli;
end

nomd_siz = round(percent_nomad * population);
nomd_ind = randperm(population, nomd_siz);

nomad_group.type = 'n';
nomad_group.maxsize = nomd_siz;

nomd_tmg = Lion.empty(0,nomd_siz);
for i=1:nomd_siz
    nomd_tmg(i) = rand_pop(nomd_ind(i));
end

rand_pop(nomd_ind) = [];

nomd_fms = round((1-percent_sex)*nomd_siz);
nomd_fid = randperm(nomd_siz, nomd_fms);

nomad_group.females = Lion.empty(0, nomd_fms);
for i=1:nomd_fms
    nomd_ths = nomd_tmg(nomd_fid(i));
    nomd_ths.sex = 'f';
    nomad_group.females(i) = nomd_ths;
end

nomd_tmg(nomd_fid) = [];

nomad_group.males = nomd_tmg;
nomad_group.configure();

prid_rem = population-nomd_siz;
prid_szs = ceil(prid_rem/prides_length);
prid_end = prides_length;
for i=1:prid_end
    if i ~= prid_end
        prid_grp = Lion.empty(0,prid_szs);
    else
        prid_grp = Lion.empty(0,length(rand_pop));
    end
    for j=1:prid_szs
        if length(rand_pop) <= 0
            break;
        end
        prid_ths = rand_pop(1);
        prid_grp(j) = prid_ths;
        rand_pop(1) = [];
    end
    prid_gln = length(prid_grp);
    prid_fml = round(prid_gln*percent_sex);
    prid_fin = randperm(prid_gln, prid_fml);

    prid_fgr = Lion.empty(0, prid_fml);
    for j=1:prid_fml
        prid_tfe = prid_grp(prid_fin(j));
        prid_tfe.sex = 'f';
        prid_fgr(j) = prid_tfe;
    end
    prid_grp(prid_fin) = [];
    prid_thg = Group;
    prid_thg.type = 'p';
    prid_thg.females = prid_fgr;
    prid_thg.males = prid_grp;
	prid_thg.maxsize = length(prid_thg.all_lions());
    prid_thg.configure();
    pride_groups(i) = prid_thg;
end

global_best_fitness = nomad_group.lbestval;
global_best = nomad_group.lbest;

for j=1:prides_length
    iter_gpr = pride_groups(j);
    if iter_gpr.lbestval < global_best_fitness
        global_best_fitness = iter_gpr.lbestval;
        global_best = iter_gpr.lbest;
    end
end

% -----------------------
% Start Generations
% -----------------------

for i=1:44
    cla
    hold on
    fprintf('Iteration %d\n', i)
    
    for j=1:prides_length
        iter_gpr = pride_groups(j);
        iter_gpr.recount();
        iter_gpr.do_pride_fem(percent_roam, adapt_fun);
        iter_gpr.do_pride_mal(percent_roam, adapt_fun);
        iter_gpr.mate(mating_rate,mutation_prob,space_min,space_max,adapt_fun);
        iter_gpr.equilibriate(nomad_group,percent_sex);
        pride_groups(j) = iter_gpr;
    end
    
    nomad_group.recount();
    nomad_group.do_nomad_all(space_min, space_max, adapt_fun);
	nomad_group.mate(mating_rate,mutation_prob,space_min,space_max,adapt_fun);
	nomad_group.invade(pride_groups);
    
    for j=1:prides_length
		iter_gpr = pride_groups(j);
		iter_gpr.emigrate(percent_sex,immigration_rate,nomad_group);
    end
    
 	nomad_group.immigrate(pride_groups,percent_sex);
	nomad_group.equilibriate(nomad_group,percent_sex);
    
    % CHECK FITNESS
    if nomad_group.lbestval < global_best_fitness
        global_best_fitness = nomad_group.lbestval;
        global_best = nomad_group.lbest;
    end
    for j=1:prides_length
        iter_gpr = pride_groups(j);
        if iter_gpr.lbestval < global_best_fitness
            global_best_fitness = iter_gpr.lbestval;
            global_best = iter_gpr.lbest;
        end
    end
    
    % PRINT ALL
    for j=1:prides_length
        iter_gpr = pride_groups(j);
        iter_gpr.print();
    end
    nomad_group.print();
    fprintf('- Best Fitness: %g\n', global_best_fitness);
    axis([space_min space_max space_min space_max space_min space_max]);
    if dimensions == 3
        view([45 45 45]); % 3D angle
    end
    
%     % SAVE
%     print(['loa-iter-' num2str(i)], '-dpng');
    
    hold off;
    pause(0.0001)
end

matcl = num2cell(global_best);
fprintf('Best Position: [');
fprintf('%g; ', matcl{1:end});
fprintf(']\n');

% % PRINT ONLY LAST
% for j=1:prides_length
%     iter_gpr = pride_groups(j);
%     iter_gpr.print();
% end
% nomad_group.print();

% -----------------------
% Fitness Function
% -----------------------

% BASIC
function fitness = fit_fun(pos)
    fitness = (pos(1))^2 + (pos(2))^2 + (pos(3))^2;
end

% % RASTRIGIN (0, 0) minima
% function fitness = fit_fun(pos)
%     dimensions = length(pos);
%     fitness = 10*dimensions;
%     for i=1:dimensions
%         xi = pos(i);
%         fitness = fitness + xi ^ 2 - 10 * cos(2*pi*xi);
%     end
% end

% ROSENBROCK 2D (a, a^2) minima
% function fitness = fit_fun(pos)
%     a = 2;
%     b = 100;
%     fitness = (a-pos(1))^2+b*(pos(2)-pos(1)^2)^2;
% end