clear
clc

iter=300;

len=50;
plen=5;
nper=0.5;

vper=0.8;
rnddis = 0.1;

maxsp=2;
minsp=0;


a=rand(2,len).*(maxsp-minsp)+minsp;

hndl = [];
pop=[];

for i=1:len
    p = Lion;
    p.position = a(1:end,i);
    p.best = p.position;
    p.fitness = fiteval(p.best);
    pop = [pop p];
end

% Make Groups
nmds = fix(len * nper);
grps = [];

nmdgrp = Group;
g.type = 'n';
nmdgrp.content = [];

bestpos = [];
bestgfit = Inf;

for i=1:nmds 
    lion = pop(1);
    pop(1) = [];
    
    nmdgrp.content = [nmdgrp.content lion];
    myfit = fiteval(lion.position);
    if myfit < bestgfit
        bestgfit = myfit;
        bestpos = lion.position;
    end
end

nmdgrp

nmdgrp.gbest = bestpos;
grps = [grps nmdgrp];

pridenumber = ceil(length(pop)/plen);
for i=1:pridenumber
    g = Group ;
    g.type = 'p';
    g.content = [];
    
    bestpos = [];
    bestgfit = Inf;
    
    for j=1:plen
        lion = pop(1);
        g.content = [g.content lion];
        pop(1) = [];
        
        myfit = fiteval(lion.position);
        if myfit < bestgfit
            bestgfit = myfit;
            bestpos = lion.position;
        end
    end
    
    g.gbest = bestpos;
    grps = [grps g];
end

hndl(1) = plot(minsp-1, minsp-1, '*r');
hold on;
hndl(2) = plot(minsp-1, minsp-1, '+r');
hold on;
hndl(3) = plot(minsp-1, minsp-1, '*b');
hold on;
hndl(4) = plot(minsp-1, minsp-1, '+b');
hold on;

for i=1:iter
    lionsupdated = 0;
    rsnmupdated = 0;
    
    % Looping
    for j=1:length(grps)
        type = grps(j).type;
        gsize = length(grps(j).content);
        gfit = fiteval(grps(j).gbest);

        for k=1:length(grps(j).content)
            if type == 'n' % Nomad
                lstpos = grps(j).content(k).position;
                bstfit = fiteval(grps(j).content(k).best);
                
                % random probability
                impro = (bstfit - gfit)/gfit; %improvement
                probrate = 0.1 + min(0.5, impro);
                
                rndm = rand();
                if rndm < probrate
                    newpos = rand(2,1).*(maxsp-minsp)+minsp;
                    newfit = fiteval(newpos);
                    rsnmupdated = rsnmupdated + 1;
                    
                    if newfit < bstfit
                        lionsupdated = lionsupdated + 1;

                        grps(j).content(k).best = newpos;

                        if newfit < gfit
                            gfit = newfit;
                            grps(j).gbest = newpos;
                        end
                    end

                    grps(j).content(k).position = newpos;
                end
            else
                selectable = grps(j).content;
                visitablenumber = fix(vper*gsize);
                
                selectable(k) = [];

                source = grps(j).content(k);
                updated = 0; % check
                
                for l=1:visitablenumber
                    select = randi([1 length(selectable)]);

                    lstpos = source.position;
                    target = selectable(select);
                    
                    if target.best ~= lstpos
                        random = rand();
                        direction = (target.best - lstpos); % direction vector times D distance between best and source
                        extend = 2 * random * direction; % represents second term in formula

                        normals = null(direction(:).').*norm(direction); % get all vectors normal to direction vector
                        newpos = lstpos + extend; % push female to direction
                        deviate = random * pi / 6; % extent to which the point can deviate from the direction

                        for z = 1:size(normals, 2) % get all 'dimensions' or direction the point can deviate from
                            newpos = newpos + normals(:,z) * deviate * (rand() * 2 - 1); % deviate point in direction perpendicular to original direction
                            %           ^ normal vct  ^ extnt of deviate ^ -1 to 1 times of deviation
                        end

    %                     random = rand();
    %                     random2 = rand();
    % 
    %                     distance = (target.best - lstpos); % direction vector times D distance between best and source
    %                     p1 = 2 * random * distance; % represents second term in formula
    % 
    %                     angle = random * pi / 6 * (random2 * 2 - 1); % represents tan(theta) * U(-1, 1)
    %                     p2 = [-distance(2); distance(1)] * angle; % represents third term in formula
    % 
    %                     newpos = lstpos + p1 + p2;

                        lstfit = fiteval(lstpos);
                        newfit = fiteval(newpos);

                        if newfit < lstfit
                            updated = 1; % check
                            source.best = newpos;

                            if newfit < gfit
                                gfit = newfit;
                                grps(j).gbest = newpos;
                            end
                        end

                        source.position = newpos;
                    end

                    

                    selectable(select) = []; % Remove from possible selections
                end
                
                grps(j).content(k) = source;

                if updated == 1
                    lionsupdated = lionsupdated + 1;
                end
            end
        end

    end
    
    for j=1:length(grps)
        for k=1:length(grps(j).content)
            source = grps(j).content(k);

            % -- Print
            print1 = source.best;
            print2 = source.position;
            if grps(j).type == 'n' % Nomad
                plot(print1(1), print1(2), '*r');
                hold on;
                plot(print2(1), print2(2), '+r');
                hold on;
            else
                plot(print1(1), print1(2), '*b');
                hold on;
                plot(print2(1), print2(2), '+b');
                hold on;
            end
        end
    end
    
    axis([minsp maxsp minsp maxsp])
    

    legend(hndl, 'Nomad Best', 'Nomad Pos', 'Pride Lion Best', 'Pride Lion Pos')
    hold off;
    
    % print(['roam-iter-' num2str(i)],'-dpng')
    
    fprintf('Iteration %d: %d of %d lions improved. %d resets.\n', i, lionsupdated, len, rsnmupdated)
    pause(0.066)
    
end

function fit = fiteval(vector)
    fnc=@(x,y) (x-1).^2+(y-1).^2;
    vec = num2cell(vector);
    fit = feval(fnc, vec{:});
end
 