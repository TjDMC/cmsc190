classdef Group < handle
    properties
        type
        
        lbest % local best
        lbestval % local best value
        
        males = [];
        females = [];
        
        improved = 0;
    end
    methods
        function lions = all_lions(me)
            lions = [me.males me.females];
        end
        
        function do_pride_fem(me, roam_per, fit_fun)
                fem_len = length(me.females);
                
                roam_len = floor(roam_per * fem_len);
                roam_ind = randperm(fem_len, roam_len);
                
                hunt_ers = me.females;
                for i=1:length(roam_ind)
                    hunt_ers( roam_ind(i) ) = [];
                end
                
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
                        hunt_cli.position = hunt_pry.position + hunt_rnd .* (hunt_pry - hunt_cli.position);
                    end
                    
                    hunt_cli.evaluate(fit_fun);
                    
                    if hunt_cli.pbestval < hunt_lst
                        hunt_pim = (hunt_cli.pbestval - hunt_lst) / hunt_lst;
                        hunt_prn = rand();
                        hunt_pry = hunt_pry + hunt_prn .* hunt_pim .* (hunt_pry - hunt_cli.position);
                    end
                end
                
                roam_all = me.all_lions();
                roam_tsiz = max(2, ceil(me.improved/2));
                for i=1:length(roam_ind)
                    roam_cli = me.females(roam_ind(i));
                    roam_tin = randperm(length(roam_all), roam_tsiz);
                    roam_chs = roam_all(roam_tin(1));
                    for j=2:length(roam_tin)
                        roam_oth = roam_all(roam_tin(i));
                        if roam_oth.pbestval < roam_chs.pbestval
                            roam_chs = roam_oth;
                        end
                    end
                    roam_cli.go_toward(roam_chs);
                    roam_cli.evaluate(fit_fun);
                end
        end
        
        function do_pride_mal(me, roam_per, fit_fun)
            roam_all = me.all_lions();
            roam_len = floor(roam_per * male_len);
            
            for i=1:length(me.males)
                roam_cli = me.males(i);
                roam_tin = randperm(length(roam_all), roam_len);
                roam_chs = roam_all(roam_tin(1));
                for j=2:length(roam_tin)
                    roam_oth = roam_all(roam_tin(i));
                    if roam_oth.pbestval < roam_chs.pbestval
                        roam_chs = roam_oth;
                    end
                end
                roam_cli.go_toward(roam_chs);
                roam_cli.evaluate(fit_fun);
            end
        end
        
        function do_nomad_all(me, min_val, max_val, fit_fun)
            nomd_all = me.all_lions();
            nomd_len = length(nomd_all);
            nomd_bft = me.lbestval;
            for i=1:nomd_len
                nomd_cli = nomd_all(i);
                nomd_dim = length(nomd_cli.position);
                nomd_imp = (nomd_lft - nomd_bft) / nomd_bft;
                nomd_prb = 0.1 + min(0.5, nomd_imp);
                
                if rand() < nomd_prb
                    nomd_lft = nomd_cli.pbestval;
                    nomd_cli.position = min_val + rand(nomd_dim,1)*(max_val-min_val);
                    nomd_cli.evaluate(fit_fun);
                    nomd_nft = nomd_cli.pbestval;
                    if and(nomd_nft < nomd_lft, nomd_nft < nomd_bft)
                        me.lbestval = nomd_nft;
                        me.lbest = nomd_cli.position;
                    end
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