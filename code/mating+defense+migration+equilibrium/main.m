clear
clc

iter=300; % algorithm iterations

len=50; % population size
plen=4; % number of prides
nper=0.2; % nomad percentage

maxsp=2; % maximum value per dimension
minsp=0; % minimum value per dimesnion
dim = 2; % dimensions
fit=@(x,y) (x-1).^2+(y-1).^2; % fitness function

a=rand(dim,len).*(maxsp-minsp)+minsp; % initial lion positions

pop=[]; % population

srate = 0.8; %sex rate
maprob = 0.3; % mating probability
muprob = 0.2; % mutate probability

irate = 0.4; %immigration rate

%initialization of population
for i=1:len
    p = Lion;
    p.vector = a(1:end,i);
    vectorCells = num2cell(p.vector);
    p.fitness = feval(fit,vectorCells{:});
    p.best = p.vector;
    pop = [pop p];
end

% Make Groups
nmds = fix(len * nper); % number of nomads
fprintf('Number of nomads: %i\n',nmds);
grps = []; % groups

%for nomads
nmdgrp = Group; %nomad group
nmdgrp.type = 'n';
nmdgrp.maxsize = nmds;
for i=1:nmds 
    nmdgrp.content = [nmdgrp.content pop(1)];
    pop(1) = [];
end
grps = [grps nmdgrp];

%for prides
pridesize = fix((len-nmds)/plen); % minimum number of lions per pride
remainder = mod(len-nmds,plen); % remaining number of lions
for i=1:plen
    g = Group ;
    g.type = 'p';
    g.content = [];
    g.maxsize=pridesize;
    if remainder>0
        g.maxsize=g.maxsize+1;
        remainder = remainder-1;
    end
    j=1;
    while j<=g.maxsize
        g.content = [g.content pop(1)];
        pop(1) = [];
        j=j+1;
    end
    grps = [grps g];
    fprintf('Pride %i Size: %i\n',i,length(g.content));
end

%Gender Grouping
for i=1:length(grps)
    if grps(i).type == 'p'
        fem = srate*grps(i).maxsize; % number of females in the pride
    elseif grps(i).type == 'n'
        fem = (1-srate)*grps(i).maxsize; % number of female nomads
    end
    ifem = randperm(grps(i).maxsize,fix(fem+0.001)); % indices of lions to be females
    for i2=1:length(ifem)
        grps(i).content(ifem(i2)).sex = 'f';
        grps(i).fcount=grps(i).fcount+1;
    end
end

%Mating + Defense + Migration + Equilibrium
for h=1:iter
    %plotting
    fprintf('Initial\n');
    axis([minsp maxsp minsp maxsp]);
    figure(1);
    plotLions(dim,grps,[minsp maxsp],[minsp maxsp],'Initial');
    
    %Mating
    for i=1:length(grps)
        males = [];
        females = [];
        
        %get males and females in the group
        for i2=1:length(grps(i).content)
            l = grps(i).content(i2);
            if l.sex == 'm'
                males = [males l];
            else
                females = [females l];
            end
        end
        
        fheat = maprob*size(females,2);% number of females in heat
        ifheat = randperm(length(females),fix(fheat+0.001)); % indices of females in heat
        
        for i2=1:size(ifheat,2)
            if grps(i).type == 'p' % for pride
                imheat = randperm(length(males),randi(length(males))); % indices of males in heat
                mheat = []; %males in heat
                for i3=1:length(imheat)
                    mheat = [mheat males(imheat(i3))];
                end
                offsprings = mate(females(ifheat(i2)), mheat, muprob, maxsp, minsp); % mate
            elseif grps(i).type == 'n'
                offsprings = mate(females(ifheat(i2)), males(randi(size(males,2))), muprob, maxsp, minsp);
            end
            %set offspring fitness
            vectorCells = num2cell(offsprings(1).vector);
            offsprings(1).fitness = feval(fit,vectorCells{:});
            offsprings(1).best = offsprings(1).vector;
            
            vectorCells = num2cell(offsprings(2).vector);
            offsprings(2).fitness = feval(fit,vectorCells{:});
            offsprings(2).best = offsprings(2).vector;
            
            %add to group
            grps(i).content = [grps(i).content offsprings];
            grps(i).fcount=grps(i).fcount+1;
        end
    end
    %End Mating
    
    %plotting
    fprintf('Mating\n');
    figure(2);
    plotLions(dim,grps,[minsp maxsp],[minsp maxsp],'Mating');
    
    %Defense
    for i=1:length(grps)
        %skip if nomad
        if grps(i).type == 'n' 
            continue;
        end
        
        todrout = (length(grps(i).content)-grps(i).fcount)-fix((1-srate)*grps(i).maxsize+0.001);%number of males to drive out (internal defense)
        
        %get males in the group
        males = [];
        for i2=length(grps(i).content):-1:1
            l = grps(i).content(i2);
            if l.sex=='m'
                males = [males l];
                grps(i).content(i2) = []; % temporarily remove from pride
            end
        end
        
        %sort males from weakest to strongest
        [~, ind] = sort([males.fitness],'descend');
        sorted = males(ind);
        
        %drive out
        for i2=1:todrout
            nmdgrp.content = [nmdgrp.content sorted(1)];
            sorted(1)=[];
        end
        
        %add back to pride
        for i2=1:size(sorted,2)
            grps(i).content = [grps(i).content,sorted(i2)];
        end
        
        %nomad defense
        for i2=1:length(nmdgrp.content) % for each nomads
            if nmdgrp.content(i2).sex=='m' && rand(1)<=0.5 % 50% probability that nomad will attack pride
                nm = nmdgrp.content(i2); % nomad male
                for i3=1:length(grps(i).content)
                    rm =  grps(i).content(i3); % resident male
                    if rm.sex == 'm' && rm.fitness>nm.fitness % true if nomad male is stronger than resident
                        % switch places of resident and nomad
                        grps(i).content(i3) = nm;
                        nmdgrp.content(i2) = rm; 
                        break;
                    end
                end
            end
        end
    end
    %End Defense
    
    %plotting
    fprintf('Defense\n');
    figure(3);
    plotLions(dim,grps,[minsp maxsp],[minsp maxsp],'Defense');
    
    %Migration
    for i=1:length(grps)
        if grps(i).type == 'n'
            continue;
        end
        
        maxfem = srate*grps(i).maxsize; %maximum females in this pride
        imfem = fix(irate*maxfem); % immigrating females
        
        mifem = fix(grps(i).fcount-maxfem + imfem);% number of migrating females (surplus + migrating)
        ifem = []; %indices of females
        for i2=1:length(grps(i).content)
            if grps(i).content(i2).sex=='f'
                ifem = [ifem i2];
            end
        end
        imifem = datasample(ifem,mifem,'Replace',false); %indices of migrating females
        imifem = sort(imifem,'descend');
        
        % remove females from pride and add to nomad group
        for i2=1:length(imifem)
            nmdgrp.content = [nmdgrp.content grps(i).content(imifem(i2))];
            grps(i).content(imifem(i2))=[];
            grps(i).fcount=grps(i).fcount-1;
        end
        
    end
    fnomads = [];%female nomads
    for i=length(nmdgrp.content):-1:1
        if nmdgrp.content(i).sex=='f'
            fnomads = [fnomads nmdgrp.content(i)];
            nmdgrp.content(i)=[]; %temporarily remove from nmdgrp
        end
    end
    
    %sort nomad females from weakest to strongest
    [~, ind] = sort([fnomads.fitness],'descend');
    fsorted = fnomads(ind);
    
    %female nomad distribution
    for i=1:length(grps)
        if grps(i).type == 'n'
            continue;
        end
        maxfem = srate*grps(i).maxsize; %maximum females per pride
        imfem = fix(irate*maxfem); % immigrating females
        dfem = imfem*plen;%number of female nomads to be distributed to this pride
        sindex = length(fsorted)-dfem+1;%starting index for female selection
        
        for i2=1:imfem %replace the migrated females in a pride
            findex = randi([sindex length(fsorted)]);
            grps(i).content = [grps(i).content fsorted(findex)];
            grps(i).fcount = grps(i).fcount+1;
            fsorted(findex)=[];
        end
    end
    
    % return remaining females to nomad group
    for i=1:size(fsorted,2)
        nmdgrp.content = [nmdgrp.content fsorted(i)];
    end
    %End Migration
    
    %plotting
    fprintf('Migration\n');
    figure(4);
    plotLions(dim,grps,[minsp maxsp],[minsp maxsp],'Migration')
    
    %Equilibrium
    %separate males and females
    nmales = [];
    nfemales = [];
    for i=length(nmdgrp.content):-1:1
        if nmdgrp.content(i).sex=='m'
            nmales = [nmales nmdgrp.content(i)];
            nmdgrp.content(i)=[];
        else
            nfemales = [nfemales nmdgrp.content(i)];
            nmdgrp.content(i)=[];
            nmdgrp.fcount = nmdgrp.fcount-1;
        end
    end
    
    %sort nomad lions from weakest to strongest
    [~, ind] = sort([nmales.fitness],'descend');
    [~, ind1] = sort([nfemales.fitness],'descend');
    snmales = nmales(ind);
    snfemales = nfemales(ind1);
    
    %killing nomads
    mtokill = length(nmales)-nmdgrp.maxsize*srate; % number of males to kill
    ftokill = length(nfemales)-nmdgrp.maxsize*(1-srate);% number of females to kill
    for i=1:mtokill
        snmales(1)=[];
    end
    for i=1:ftokill
        snfemales(1)=[];
    end
    
    %surviving nomads
    nmdgrp.content = [nmdgrp.content snmales snfemales];
    nmdgrp.fcount = length(snfemales);
    %End Equilibrium
    
    %plotting
    fprintf('Equilibrium\n');
    figure(5);
    plotLions(dim,grps,[minsp maxsp],[minsp maxsp],'Equilibrium');
    pause(1);
end

function plotLions(dim,grps,xbounds,ybounds,plottitle)
    if dim==2
        clf
        hold on;
        title(plottitle);
        xlim(xbounds);
        ylim(ybounds);
        xlabel('y') ;
        ylabel('x'); 
        ctrm=0;
        ctrf=0;
        for i2=1:length(grps)
           for i3=1:length(grps(i2).content)
               l = grps(i2).content(i3);
               if grps(i2).type == 'p'
                   if l.sex == 'm'
                       ctrm=ctrm+1;
                       plot(l.vector(1),l.vector(2),'*b')
                   else
                       ctrf=ctrf+1;
                       plot(l.vector(1),l.vector(2),'*r')
                   end
               elseif grps(i2).type == 'n'
                   if l.sex == 'm'
                       ctrm=ctrm+1;
                       plot(l.vector(1),l.vector(2),'+b')
                   else
                       ctrf=ctrf+1;
                       plot(l.vector(1),l.vector(2),'+r')
                   end
               end
           end
           fprintf(' %i ',length(grps(i2).content));
        end
        hold off;
        fprintf('\n%i %i %i\n',ctrm,ctrf,ctrm+ctrf);
    end
end