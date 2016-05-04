function [ ap ] = create_segments_from_labels( num_actions, trials, envs, predicates, all_labels, MARGIN, NUM_LEVELS)
%CREATE_SEGMENTS Break up demonstrations into smaller units based on a
%provided model
%   num_actions = number of primitives to find (aka max(all_labels))
%   trials = trial data (x,y,w,etc)
%   envs = game levels
%   predicates = computed predicates
%   all_labels = labels produced by something else

% create one cell for each of the different action primitives
ap = cell(num_actions,1);

if nargin < 7
    NUM_LEVELS = 6; % limit ourselves to the first 6 levels
end

% loop over every cluster k
for k=1:num_actions
    next_sample = 1;
    samples = [];
    
    %% training data and frames
    idx = 0;
    for i = 1:NUM_LEVELS
        for j = 1:length(trials{i})
            %% compute the labels for this trial and use them to determine
            % what each motion will be
            idx = idx + 1;
            fprintf('action=%d env=%d trial=%d (seq=%d)\n',k,i,j,idx);
            
            labels = all_labels{i}{j};

            if sum(labels==k) == 0
                continue;
            end
            
            seq = [trials{i}{j}.x; ...
                trials{i}{j}.y; ...
                trials{i}{j}.w; ...
                trials{i}{j}.movement;
                trials{i}{j}.rotation];
            
            [segs, sst, sen] = split_seq(seq,labels,k,MARGIN);
            segp = split_seq(predicates{i}{j},labels,k,MARGIN);
            
            %% compute the next frame for each time step
            [goals, opts] = next_goal(trials{i}{j},envs{i});
            
            goals = split_seq(goals,labels,k,MARGIN);
            opts = split_seq(opts,labels,k,MARGIN);
            
            %% create training example
            for ex=1:length(segs)
                
                next_opt = opts{ex}(1,:);
                prev_opt = opts{ex}(2,:);
                
                %assert(all(next_opt==next_opt(1)));
                %assert(all(prev_opt==prev_opt(1)));
                
                next_opt = mode(next_opt);
                prev_opt = mode(prev_opt);
                
                if sen{ex} - sst{ex} < 2
                    %fprintf(' ---> Segment %d only had %d examples, skipping!\n',ex,size(segs{ex},2));
                    continue;
                end
                
                origin_x = segs{ex}(1,1);
                origin_y = segs{ex}(2,1);
                origin_w = segs{ex}(3,1);
                
                exit = [envs{i}.width-origin_x;(envs{i}.height / 2)-origin_y;0];
                exit = rotate_trajectory(exit,-origin_w);
                samples(next_sample).orig_exit = [envs{i}.width;(envs{i}.height / 2);0];

                %effort_features = [abs(segs{ex}(5,:))];
                effort_features = abs(segs{ex}(4:5,:));
                
                samples(next_sample).originalData = segs{ex};
                segs{ex}(1,:) = segs{ex}(1,:) - origin_x;
                segs{ex}(2,:) = segs{ex}(2,:) - origin_y;
                segs{ex} = rotate_trajectory(segs{ex},-origin_w);
                
                w = segs{ex}(3,:);
                w(w < 0) = w(w < 0) + (2*pi);
                w(w > 2*pi) = w(w > 2*pi) - (2*pi);
                segs{ex}(3,:) = w;
                
                t = (0:(size(segs{ex},2)-1)) / (size(segs{ex},2)-1);
                exit_features = get_end_distance(segs{ex},exit);
                
                [nx,ny,nw] = needle_update(segs{ex}(1,:),segs{ex}(2,:),segs{ex}(3,:),segs{ex}(4,:),segs{ex}(5,:),envs{i});
                
                samples(next_sample).in_tissue = in_tissue([nx;ny;nw],envs{i}.surfaces);
                samples(next_sample).trainingData = [nx;ny;nw];
                samples(next_sample).data = segs{ex};
                samples(next_sample).predicates = segp{ex};
                samples(next_sample).goals = goals{ex};
                samples(next_sample).exit = exit;
                samples(next_sample).exit_features = exit_features;
                samples(next_sample).start = sst{ex};
                samples(next_sample).end = sen{ex};
                samples(next_sample).effort_features = effort_features;
                
                if  goals{ex}(sst{ex}) <= length(envs{i}.gates)
                    samples(next_sample).orig_gate = envs{i}.gates{goals{ex}(sst{ex})}{next_opt};
                    samples(next_sample).gate = relative_gate(origin_x, ...
                        origin_y, -origin_w, ...
                        envs{i}.gates{goals{ex}(sst{ex})}{next_opt});
                    samples(next_sample).has_gate = true;
                    samples(next_sample).gate_features = ...
                        get_gate_distances( ...
                        samples(next_sample).data(1:3,:), ...
                        samples(next_sample).gate);
                    samples(next_sample).use_exit = false;
                else
                    samples(next_sample).has_gate = false;
                    samples(next_sample).use_exit = true;
                end
                
                if goals{ex}(sst{ex}) > 1
                    samples(next_sample).orig_prev_gate = envs{i}.gates{goals{ex}(sst{ex})-1}{prev_opt};
                    samples(next_sample).prev_gate = relative_gate(origin_x, ...
                        origin_y, -origin_w, ...
                        envs{i}.gates{goals{ex}(sst{ex})-1}{prev_opt});
                    samples(next_sample).has_prev_gate = true;
                    samples(next_sample).prev_gate_features = ...
                        get_gate_distances( ...
                        samples(next_sample).data(1:3,:), ...
                        samples(next_sample).prev_gate);
                else
                    samples(next_sample).has_prev_gate = false;
                end
                
                samples(next_sample).env = i;
                samples(next_sample).t = t*1000;
                next_sample = next_sample + 1;
            end
        end
    end
    ap{k} = samples;
end
end
