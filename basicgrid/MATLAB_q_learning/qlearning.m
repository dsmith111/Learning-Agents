clear
clc
clf

import World
global world
world = World;
world.render()
iterations = 10000000;
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
while true
    % Pick Action
    [maxq, maxaction] = maxQ(world.player);
    [player, action, reward, newplayer] = take_action(maxaction);

    % Update Q
    [maxq, maxaction] = maxQ(newplayer);
    update_q(player, action, learning_rate, (reward + (discount*maxq)))
    % Check if restart
    t = t + 1;
    if world.restart
        world.restart_program()
        discount = 0.3;
    end

    % Update learning rate
    learning_rate = power(t,-0.01);
%     discount = (discount*1.01);
%     if discount > 1
%         discount = 0.3;
%     end
%
    % At the end, render map

    if world.iteration >= 600
        world.render()
    end
    tr = world.player(1);
    tc = world.player(2);
    tall = sub2ind([world.mapsize, world.mapsize], tr, tc);
    temp = Q(tall);

    % Pause for readability

    pause(10^-9)
%     drawnow
    if world.iteration >= 750
        break
    end
end


function update_q(player, action, learning_rate, temporal_dif)
    global Q
    global world
    r = player(1);
    c = player(2);
    index = sub2ind([world.mapsize, world.mapsize], r, c);
    temp_state = Q(index);
    temp_action = temp_state(action);
    temp_action = temp_action * (1 - learning_rate);
    temp_action = temp_action + (learning_rate * temporal_dif);
    temp_state(action) = temp_action;
    Q(index) = temp_state;


end





function [val, act] = maxQ(player)
    global Q
    global world
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
    reward = -world.score;
    player = world.player;

    if action == string(actions{1})
        world.try_move(1, 0)

    elseif action == string(actions{2})
        world.try_move(-1, 0)

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
