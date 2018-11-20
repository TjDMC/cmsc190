clear
clc
hold off;

len=8;
tsize=4;
maxsp=2;
minsp=0;
fit=@(x,y) (x-1).^2+(y-1).^2;

a=rand(2,len).*(maxsp-minsp)+minsp;
fem=rand(2,1).*(maxsp-minsp)+minsp;

hndl = [];

hndl(1) = plot(fem(1), fem(2), '+b');
hold on

pop=[];

for i=1:len
    p = Lion;
    p.vector = a(1:end,i); 
    p.fitness = feval(fit, p.vector(1), p.vector(2));
    pop = [pop p];
end

% SELECTING INDIVIDUALS
rmpop=pop

ind  = randi([1 length(rmpop)]);
best = rmpop(ind)
rmpop(ind) = [];

for i = 1:(tsize-1)
    
    % select from pool and remove it
    ind  = randi([1 length(rmpop)]);
    next = rmpop(ind);
    rmpop(ind) = [];
    
    vct = next.vector;
    if next.fitness < best.fitness
        % print last best
        vct = best.vector;
        
        best = next
    end
    hndl(2) = plot(vct(1), vct(2), 'ob');
end

vct = best.vector;
hndl(3) = plot(vct(1), vct(2), 'or');

a = [rmpop.vector];
hndl(4) = scatter(a(1,:),a(2,:), 'og');

% tester for comparing methods
% for q = 1:1000
    random = rand();
    direction = (vct - fem); % direction vector times D distance between best and source
    p1 = 2 * random * direction; % represents second term in formula

    normals = null(direction(:).').*norm(direction); % get all vectors normal to direction vector
    out = fem + p1; % push female to direction
    angle = random * pi / 6; % extent to which the point can deviate from the direction

    for z = 1:size(normals, 2) % get all 'dimensions' or direction the point can deviate from
        mo = normals(:,z);
        out = fem + mo * angle * (rand() * 2 - 1); % deviate point in direction perpendicular to original direction
        %           ^ normal vct  ^ extnt of deviate ^ -1 to 1 times of deviation
    end
% 
%     plot(out(1), out(2), '*g');
% end
%
% try 2 dimension
%
% for q=1:1000
%     random = rand();
%     random2 = rand();
% 
%     distance = (vct - fem); % direction vector times D distance between best and source
%     p1 = 2 * random * distance; % represents second term in formula
% 
%     angle = random * pi / 6 * (random2 * 2 - 1); % represents tan(theta) * U(-1, 1)
%     p2 = [-distance(2); distance(1)] ; % represents third term in formula
% 
%     out = fem + p1 + p2 * angle;
%     plot(out(1), out(2), '+r');
%     
% end
% 
% oss = vct + [-distance(2); distance(1)];
% 
% plot([vct(1) fem(1)], [vct(2) fem(2)])
% plot([vct(1) oss(1)], [vct(2) oss(2)])

hndl(5) = plot(out(1), out(2), '+r');
axis([min(minsp, out(1)) max(maxsp, out(1)) min(minsp, out(2)) max(maxsp, out(2))])
print(['move-out'],'-dpng')
legend(hndl, 'Source', 'Selected', 'Selected, Best Fit', 'Not selected', 'Output', 'Location', 'southoutside')
print(['move-out-legend'],'-dpng')

hold off

