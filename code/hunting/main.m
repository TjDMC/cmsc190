clc

iter=100;
len=8;
max=2;
min=0;
fit=@(x,y) (x-1).^2+(y-1).^2;
cln=2;

a=rand(2,len).*(max-min)+min;
prey=sum(a,2)/len;

scatter(a(1,:),a(2,:), '*r')
hold on
fcontour(fit, [min max*2 min max*2])
plot(prey(1), prey(2), 'ob')
axis([min max*2 min max*2])
hold off

pop=[];

for i=1:len
    p = Lion;
    p.vector = a(1:end,i); 
    p.fitness = feval(fit, p.vector(1), p.vector(2));
    pop = [pop p];
end

best = pop(ind(1)) % statistic

[~, ind]=sort([pop.fitness]); % sort by fitness

% label all others center
for i=1:cln
    pop(ind(i)).type = 'c';
end

% label all others wing
for i=(cln+1):len
    id = ind(i);
    pop(id).type = 'w';
end

% fprintf('The Population\n\n');
% for i=1:len
%    disp(pop(i))
% end

print(['hunt-init'],'-dpng') % printer

pause(5)

fprintf('The Algorithm\n\n');
for i=1:iter % iterate
    improved = 0;
    for j=1:len % for each lion
        pos = pop(j).vector; % get current pos
        lastpos = pos;
        rnd = rand();
        
        % determine method
        if pop(j).type == 'c'
            pos = pos + rnd .* (prey - pos); % relative to lion position
        else
            pos = prey + rnd .* (prey - pos); % relative to prey position (simplified)
        end
        
        % update fitness
        lastfit = pop(j).fitness;
        nextfit = feval(fit, pos(1), pos(2));
        pop(j).fitness = nextfit;
        
        lastprey = prey; % statistic purposes
        
        if lastfit-nextfit > 0
            % escape the prey
            pi = (nextfit-lastfit)/lastfit;
            prnd = rand(); 
            prey = prey + prnd * pi * (prey - pos); 
            improved = 1;
        end
        fprintf('-(%d, %d, %c) fitness %f to %f; improved %f; prey distance %f to %f\n', i, j, pop(j).type, lastfit, nextfit, pi, norm(lastprey-lastpos), norm(prey-pos)) % statistic
        
        pop(j).vector = pos;
    end
    ppos = [pop.vector];
    
    % plot figure
    scatter(ppos(1,:),ppos(2,:), '*r')
    hold on
    fcontour(fit, [min max*2 min max*2])
    plot(prey(1), prey(2), 'ob')
    axis([min max*2 min max*2])
    hold off
    
    % print figure
    print(['hunt-iter-' num2str(i)],'-dpng')
    
    % statistic
    prey
    if improved == 0
        break;
    end
    
    pause(0.066)
end
