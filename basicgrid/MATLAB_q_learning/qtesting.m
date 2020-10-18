clear
clc
qkeys = {};
qvalues = {};
world.mapsize = 5;
actions = {'up','down','left','right'};
player = [1, 1];

for r = 1:world.mapsize

    for c = 1:world.mapsize
        % Assign coordinates, action and q to a dictionary
        % Q('ij')('action')||('q')
        index = sub2ind([world.mapsize, world.mapsize], r, c);
        qkeys{r, c} = index;
        temp = ones([1, length(actions)]) * 0.1;
        qvalues{r, c} = containers.Map(actions, temp);

    end

end

global Q
Q = containers.Map(qkeys, qvalues);

% q = 0;
% action = "";

[q, action] = maxQ(player);
q
action



function [val, act] = maxQ(player)
    global Q
    index = sub2ind([5, 5], player(1), player(2));
    val = inf;
    act = "";
    for action = Q(index).keys
        temp = Q(index);
        taction = string(action);
        if val == inf || temp(taction) > val
            val = temp(taction);
            act = string(taction);
        end
    end

end
