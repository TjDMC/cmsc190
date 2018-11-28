clear all
clc

space_min = -100;
space_max = 100;

iterations = 300;
population = 50;
dimension = 2;
prides_length = 5;

percent_nomad = 0.2;
percent_roam = 0.2;
percent_sex = 0.8;

lion_groups = [];

%Initialize Lions
rand_lio = rand(dimension, population).*(space_max-space_min)+space_min;

rand_pop = zeros(1, population);
for i=1:population
    rand_cli = Lion;
    rand_cli.position = rand_lio(:,i);
    rand_cli.init(position, fit_fun);
    rand_pop(i) = rand_cli;
end

nomd_siz = round(percent_nomad * population);
nomd_ind = randperm(population, nomd_siz);

nomad_group = Group;
nomad_group.type = 'n';

nomd_tmg = zeros(1, nomd_siz);

nomd_fms = round((1-percent_sex)*nomd_siz);
for i=1:nomd_siz
    nomd_ths = rand_pop(nomd_ind(i));
    
end

nomd_fid = randperm(nomd_siz, nomd_fms);


function fitness = fit_fun(pos)
    fitness = 0;
end