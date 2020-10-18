clear
clc
clf

import World
global world
world = World;
player = world.player;
world.render()
iterations = 1000;
t = 1;
actions = world.actions;
global Q
global discount
global learning_rate
discount = 0.3;
learning_rate = 1;


% Initialize Q-Table

% For loop adding each state to the Q-table
qkeys = {};
qvalues = {};


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

Q = containers.Map(qkeys, qvalues);



% While loop to indefintely run the agent
for i = 1:iterations

    % Pick Action
    [maxq, maxaction] = maxQ(player);
    [player, action, reward, newplayer] = take_action(maxaction);

    % Update Q
    [maxq, maxaction] = maxQ(newplayer);
    update_q(player, action, learning_rate, (r + (discount*maxq)))

    % Check if restart
    t = t + 1;
    if world.restart

    end

    % Update learning rate
    learning_rate = learning_rate/10;

    % Pause for readability
    pause(1)
end


% Select action based on max q

%

% At the end, render map





function [val, act] = maxQ(player)
    global Q
    index = sub2ind([world.mapsize, world.mapsize], player(1), player(2));
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


function [player, retaction, reward, newplayer] = take_action(action)
    global world
    actions = world.actions;
    player = world.player;
    reward = world.score;

    if action == string(actions{1})
        world.try_move(-1, 0)

    elseif action == string(actions{2})
        world.try_move(1, 0)

    elseif action == string(actions{3})
        world.try_move(0, -1)

    elseif action == string(actions{4})
        world.try_move(0, 1)

    else
        return
    end
    retaction = action;
    newplayer = world.player;
    reward = reward + world.score;

end
