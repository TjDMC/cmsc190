classdef Group < handle
    properties
        type

        lbest % local best
        lbestval % local best value

        males = [];
        females = [];

        improved = 0;

		maxsize = 0;
    end
    methods
        function lions = all_lions(me)
            lions = [me.males me.females];
        end

        function recount(me)
            me.improved = 0;
        end

        function configure(me)
            lions = me.all_lions();
            me.lbestval = Inf;
            for i=1:length(lions)
                lion_ith = lions(i);
                if lion_ith.pbestval < me.lbestval
                    me.lbest = lion_ith.pbest;
                    me.lbestval = lion_ith.pbestval;
                end
            end
        end

        function do_pride_fem(me, roam_per, fit_fun)
                fem_len = length(me.females);

                roam_len = floor(roam_per * fem_len);
                roam_ind = randperm(fem_len, roam_len);

                hunt_ers = me.females;
                hunt_ers( roam_ind ) = [];
                
                [~, indices]=sort([hunt_ers.pbestval]);
                hunt_ers(indices(1)).role = 'c';
                hunt_len = length(hunt_ers);

                hunt_pry = sum([hunt_ers.position],2)/hunt_len;
                for i=1:hunt_len
                    hunt_cli = hunt_ers(i);
                    hunt_rnd = rand();
                    hunt_lst = hunt_cli.pbestval;

                    if hunt_ers(i).role == 'c'
                        hunt_cli.position = hunt_cli.position + hunt_rnd .* (hunt_pry - hunt_cli.position);
                    else
                        hunt_cli.position = hunt_pry + hunt_rnd .* (hunt_pry - hunt_cli.position);
                    end

                    hunt_cli.evaluate(fit_fun);

                    if hunt_cli.pbestval < hunt_lst
                        hunt_pim = (hunt_cli.pbestval - hunt_lst) / hunt_lst;
                        hunt_prn = rand();
                        hunt_pry = hunt_pry + hunt_prn .* hunt_pim .* (hunt_pry - hunt_cli.position);
                        me.improved = me.improved + 1;

                        if hunt_cli.pbestval < me.lbestval
                            me.lbest = hunt_cli.pbest;
                            me.lbestval = hunt_cli.pbestval;
                        end
                    end
                end

                roam_all = me.all_lions();
                roam_tsiz = max(2, ceil(me.improved/2));
                for i=1:length(roam_ind)
                    roam_cli = me.females(roam_ind(i));
                    roam_tin = randperm(length(roam_all), roam_tsiz);
                    roam_chs = roam_all(roam_tin(1));
                    for j=2:length(roam_tin)
                        roam_oth = roam_all(roam_tin(j));
                        if roam_oth.pbestval < roam_chs.pbestval
                            roam_chs = roam_oth;
                        end
                    end
                    roam_cli.go_toward(roam_chs);
                    roam_lfi = roam_cli.pbestval;
                    roam_cli.evaluate(fit_fun);
                    if roam_cli.pbestval < roam_lfi
                        me.improved = me.improved + 1;
                        if roam_cli.pbestval < me.lbestval
                            me.lbest = roam_cli.pbest;
                            me.lbestval = roam_cli.pbestval;
                        end
                    end
                end
        end

        function do_pride_mal(me, roam_per, fit_fun)
            male_len = length(me.males);

            roam_all = me.all_lions();
            roam_len = ceil(roam_per * male_len);

            if roam_len > 0
                for i=1:male_len
                    roam_cli = me.males(i);
                    roam_tin = randperm(length(roam_all), roam_len);
                    roam_chs = roam_all(roam_tin(1));
                    for j=2:roam_len
                        roam_oth = roam_all(roam_tin(j));
                        if roam_oth.pbestval < roam_chs.pbestval
                            roam_chs = roam_oth;
                        end
                    end
                    roam_cli.go_toward(roam_chs);
                    roam_lfi = roam_cli.pbestval;
                    roam_cli.evaluate(fit_fun);
                    if roam_cli.pbestval < roam_lfi
                        me.improved = me.improved + 1;
                        if roam_cli.pbestval < me.lbestval
                            me.lbest = roam_cli.pbest;
                            me.lbestval = roam_cli.pbestval;
                        end
                    end
                end
            end
        end

        function do_nomad_all(me, min_val, max_val, fit_fun)
            nomd_all = me.all_lions();
            nomd_len = length(nomd_all);
            nomd_bft = me.lbestval;
            for i=1:nomd_len
                nomd_cli = nomd_all(i);
                nomd_lft = nomd_cli.pbestval;
                nomd_dim = length(nomd_cli.pbest);
                nomd_imp = (nomd_lft - nomd_bft) / nomd_bft;
                nomd_prb = 0.1 + min(0.5, nomd_imp);

                if rand() < nomd_prb
                    nomd_cli.position = min_val + rand(nomd_dim,1)*(max_val-min_val);
                    nomd_cli.evaluate(fit_fun);
                    nomd_nft = nomd_cli.pbestval;
                    if nomd_nft < nomd_lft
                        me.improved = me.improved + 1;
                        if nomd_nft < nomd_bft
                            me.lbestval = nomd_nft;
                            me.lbest = nomd_cli.pbest;
                        end
                    end
                end
            end
        end

		function invade(me,pride_grps)
			if me.type == 'p'
				return;
			end
			%nomad defense
			for i=1:length(me.males) % for each nomads
				for j=1:length(pride_grps)
					if rand(1)<=0.5 % 50% probability that nomad will attack pride
						nm = me.males(i); % nomad male
						ipride = pride_grps(j);% invaded pride
						for k=1:length(ipride.males)
							rm =  ipride.males(k); % resident male
							if rm.pbestval>nm.pbestval % true if nomad male is stronger than resident
								% switch places of resident and nomad
								ipride.males(k) = nm;
								me.males(i) = rm;
								break;
							end
						end
					end
				end
			end
		end

		function emigrate(me,sex_rate,im_rate,nomad_grp)
			if me.type == 'n'
				return;
			end

			maxfem = sex_rate*me.maxsize; %maximum females in this pride
			imfem = fix(im_rate*maxfem); % immigrating females

			mifem = fix(length(me.females)-maxfem + imfem);% number of migrating females (surplus + migrating)

			imifem = randperm(length(me.females),mifem); %indices of migrating females
			imifem = sort(imifem,'descend');

			% remove females from pride and add to nomad group
			for i=1:length(imifem)
				nomad_grp.females = [nomad_grp.females me.females(i)];
				me.females(i)=[];
			end
		end

		function mate(me,mating_rate,mutation_prob,space_min,space_max,fit_fun)
			fheat = mating_rate*length(me.females);% number of females in heat
			ifheat = randperm(length(me.females),fix(fheat)); % indices of females in heat

			for i=1:length(ifheat)
				if me.type == 'p' % for pride
					imheat = randperm(length(me.males),randi(length(me.males))); % indices of males in heat
					mheat = Lion.empty(0,length(imheat)); %males in heat
					for j=1:length(imheat)
						mheat(j) = me.males(imheat(j));
					end
					offsprings = me.females(ifheat(i)).mate(mheat, mutation_prob, space_min, space_max); % mate
				else
					offsprings = me.females(ifheat(i)).mate(me.males(randi(length(me.males))), mutation_prob, space_min, space_max);
				end

				%set offspring fitness
				offsprings(1).init(offsprings(1).position,fit_fun);
				offsprings(2).init(offsprings(2).position,fit_fun);

				if offsprings(1).sex == 'm'
					me.males = [me.males offsprings(1)];
					me.females = [me.females offsprings(2)];
				else
					me.males = [me.males offsprings(2)];
					me.females = [me.females offsprings(1)];
				end
			end
        end

        function equilibriate(me,nomad_group,sex_rate)
            if me.type == 'p'
                %internal defense
				todrout = (length(me.males))-fix((1-sex_rate)*me.maxsize);%number of males to drive out (internal defense)

				%sort males from weakest to strongest
				[~, ind] = sort([me.males.pbestval],'descend');
				me.males = me.males(ind);
				%drive out
				for i=1:todrout
					nomad_group.males = [nomad_group.males me.males(1)];
					me.males(1)=[];
				end
            else
                %kill the weak
				mtokill = length(me.males)-me.maxsize*sex_rate; % number of males to kill
				ftokill = length(me.females)-me.maxsize*(1-sex_rate);% number of females to kill

				%sort nomad females from weakest to strongest
				[~, ind] = sort([me.females.pbestval],'descend');
				me.females = me.females(ind);

				%sort nomad males from weakest to strongest
				[~, ind] = sort([me.males.pbestval],'descend');
				me.males = me.males(ind);

				for i=1:mtokill
					me.males(1)=[];
				end
				for i=1:ftokill
					me.females(1)=[];
				end
            end
        end

		function immigrate(me,pride_grps,sex_rate,im_rate)
			if me.type == 'p'
				return;
			end

			%sort nomad females from weakest to strongest
			[~, ind] = sort([me.females.pbestval],'descend');
			me.females = me.females(ind);

			%female nomad distribution
			for i=1:length(pride_grps)
				pgrp = pride_grps(i);
				maxfem = sex_rate*pgrp.maxsize; %maximum females for this pride
				imfem = fix(im_rate*maxfem); %number of females to be put in this pride

				ifem = randperm(length(me.females),imfem); %indices of females to be put into this pride
				ifem = sort(ifem,'descend');

				for j=1:length(ifem) %replace the migrated females in a pride
					pgrp.females = [pgrp.females me.females(j)];
					me.females(j)=[];
				end
			end

		end

        function print(me)
            if me.type == 'p'
                style = '*';
            else
                style = '+';
            end
            for i=1:length(me.males)
                me.males(i).print(style);
            end
            for i=1:length(me.females)
                me.females(i).print(style);
            end

        end
    end
end
