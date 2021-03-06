classdef Lion < handle
    
    properties
        position=[]
        pbest
        pbestval
        sex='m'
        role=''
        plotted=false
        pplot
    end
    
    methods
        function init(me,position,fit_fun)
            me.position = position;
            me.pbest = position;
            me.pbestval = fit_fun.eval(position);
        end
        
        function offsprings = mate(me,males,muprob,minval,maxval)
            if me.sex ~= 'f'
                offsprings = [];
                return
            end
            
            beta = normrnd(0.5,0.1); % crossover point
            o1 = Lion;
            o2 = Lion;
            
            msum = mean([males.position], 2);
            mbeta = 1-beta;
            
            o1.position = beta.*me.position + mbeta .* msum;
            o2.position = mbeta.*me.position + beta .* msum;
            
            % mutate
            if rand(1) <= 0.5 % only 1 can undergo mutation
                tomutate = o1;
            else
                tomutate = o2;
            end
            
            for i=1:length(tomutate.position)
                if rand(1) <= muprob
                    tomutate.position(i,1) = (maxval-minval)*rand()+minval;
                end
            end
            
            % select gender, arrange by sex
            if rand(1) <= 0.5
                o1.sex = 'm';
                o2.sex = 'f';
                offsprings = [o1 o2];
            else
                o2.sex = 'm';
                o1.sex = 'f';
                offsprings = [o2 o1];
            end
            
            
        end
        
        function go_toward(me,other)
            if me.position == other.position
                return % no change
            end
            mypos = me.position;
            direction = (other.pbest - mypos); % direction vector times D distance between best and source
            random = rand();
            mypos = mypos + 2 * random * direction; % push lion to direction, part 1
            normals = null(direction(:).').*norm(direction); % get all vectors normal to direction vector
            deviate = random * pi / 6; % extent to which the point can deviate from the direction
            for z = 1:size(normals, 2) % for all 'dimensions' or direction the point can deviate from, part 2
                mypos = mypos + normals(:,z) .* deviate * (rand() * 2 - 1); % deviate point in direction perpendicular to original direction
                %             ^ this norm vct ^ extnt of deviate ^ -1 to 1 times of deviation
            end
            
            me.position = mypos;
        end
        
        
        function did_update = evaluate(me, fit_fun, space_min, space_max)
            did_update = false;
            if me.position == me.pbest
                return
            end
            
            for i=1:length(me.position)
                me.position(i) = min(space_max, max(space_min, me.position(i)));
            end
            
            newbestval = fit_fun.eval(me.position);
            
            if newbestval < me.pbestval
                me.pbest = me.position;
                me.pbestval = newbestval;
                did_update = true;
            end
        end
        
        function print(me, style)
            if me.plotted
                delete(me.pplot);
            else
                me.plotted = true;
            end
            
            if me.sex == 'm'
                color = 'b';
            else
                color = 'r';
            end
            me.pplot = dispos([me.pbest; me.pbestval], [style color]);
            
        end
    end
end

