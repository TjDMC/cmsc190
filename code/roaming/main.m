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
fit=@(x,y) (x-1).^2+(y-1).^2;

a=rand(2,len).*(maxsp-minsp)+minsp;

hndl = [];
pop=[];

for i=1:len
    p = Lion;
    p.position = a(1:end,i);
    p.best = p.position;
    p.fitness = feval(fit, p.best(1), p.best(2));
    pop = [pop p];
end

% Make Groups
nmds = fix(len * nper);
grps = [];

for i=1:nmds 
    g = Group;
    g.type = 'n';
    g.content = pop(1);
    pop(1) = [];
    grps = [grps g];
end

pridenumber = fix(length(pop)/plen);

for i=1:pridenumber
    g = Group ;
    g.type = 'p';
    g.content = [];
    for j=1:plen
        g.content = [g.content pop(1)];
        pop(1) = [];
    end
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
    
    % Looping
    parfor j=1:length(grps)
        type = grps(j).type;
        if type == 'n' % Nomad
            lstpos = grps(j).content.best;
            newpos = lstpos + (rand(2,1).*2-1)*rnddis;

            lstfit = feval(fit, lstpos(1), lstpos(2));
            newfit = feval(fit, newpos(1), newpos(2));

            if newfit < lstfit
                lionsupdated = lionsupdated + 1;
                grps(j).content.best = newpos;
            end

            grps(j).content.position = newpos;
            
        else % Prides
            pridesize = length(grps(j).content);

            for k=1:length(grps(j).content)
                selectable = grps(j).content;
                visitablenumber = fix(vper*pridesize);

                source = grps(j).content(k);
                updated = 0; % check

                for l=1:visitablenumber
                    select = randi([1 length(selectable)]);

                    lstpos = source.position;
                    target = selectable(select);

                    distance = (target.best - lstpos); % direction vector times D distance between best and source
                    p1 = 2 * rand() * distance; % represents second term in formula

                    angle = rand() * pi / 3 - pi / 6; % represents tan(theta) * U(-1, 1)
                    p2 = [-distance(2); distance(1)] * angle; % represents third term in formula
                    % [] represents new perpendicular direction vector times D distance

                    newpos = lstpos + p1 + p2;

                    lstfit = feval(fit, lstpos(1), lstpos(2));
                    newfit = feval(fit, newpos(1), newpos(2));

                    if newfit < lstfit
                        updated = 1; % check
                        source.best = newpos;
                    end

                    source.position = newpos;

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
        if grps(j).type == 'n' % Nomad
            % -- Print
            printn1 = grps(j).content.best;
            printn2 = grps(j).content.position;
            
            plot(printn1(1), printn1(2), '*r');
            hold on;
            plot(printn2(1), printn2(2), '+r');
            hold on;
        else
             for k=1:length(grps(j).content)
                source = grps(j).content(k);
                
                % -- Print
                printp1 = source.best;
                printp2 = source.position;

                plot(printp1(1), printp1(2), '*b');
                hold on;
                plot(printp2(1), printp2(2), '+b');
                hold on;
             end
        end
    end
    
    axis([minsp maxsp minsp maxsp])
    

    legend(hndl, 'Nomad Best', 'Nomad Pos', 'Pride Lion Best', 'Pride Lion Pos', 'Location', 'southoutside')
    hold off;
    
    print(['roam-iter-' num2str(i)],'-dpng')
    
    fprintf('Iteration %d: %d of %d lions moved.\n', i, lionsupdated, len)
    
end

 