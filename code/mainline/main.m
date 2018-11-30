clear
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

adapt_fun = @(x) fit_fun(x);

lion_groups = Group.empty(0, prides_length+1);

%Initialize Lions
rand_lio = rand(dimension, population).*(space_max-space_min)+space_min;

rand_pop = Lion.empty(0,population);
for i=1:population
    rand_cli = Lion;
    rand_cli.init(rand_lio(:,i), adapt_fun);
    rand_pop(i) = rand_cli;
end

nomd_siz = round(percent_nomad * population);
nomd_ind = randperm(population, nomd_siz);

nomad_group = Group;
nomad_group.type = 'n';

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
lion_groups(1) = nomad_group;

prid_rem = population-nomd_siz;
prid_szs = ceil(prid_rem/prides_length);
prid_end = prides_length+1;
for i=2:prid_end
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
        prid_fgr(j) = prid_grp(prid_fin(j));
    end
    prid_grp(prid_fin) = [];
    prid_thg = Group;
    prid_thg.type = 'p';
    prid_thg.females = prid_fgr;
    prid_thg.males = prid_grp;
    lion_groups(i) = prid_thg;
end




function fitness = fit_fun(pos)
    fitness = 0;
end