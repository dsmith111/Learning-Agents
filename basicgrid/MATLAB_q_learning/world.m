
classdef World < handle
    %WORLD Create world for agent to explore
    %   This class will create a world in the form of a matrix to allow the
    %   agent to explore. The class will also include methods that will
    %   create the agent's avatar as well as methods which allow for it to
    %   move

    properties
        player = [1, 1];
        mapsize = 20;
        special
        mapsizer = [20, 1];
        mapsizec = [20, 1];
        walk_reward = -0.04
        walls = [[2, 2]; [2, 3]; [3, 2]; [7, 1]; [12, 5]; [13, 10];...
            [16, 18]; [1, 7]; [10, 10];[1,6];[2,6];[3,6];[3,7];...
            [6,12];[7,12];[8,12];[6,4];[7,4];[9,15];[]]
        score = 1;
        wall_thickness = 2*(10^2)
        actions = {'up','down','left','right'}
        restart = false;
        iteration = 1;
        agent_color = [.5 .5 1];

    end

    methods
        function obj = World()
            obj.special = containers.Map({'green', 'red'}, {[14, 14, 10], [10, 11, -10]});
        end

        function render(obj)
            hold on;
            % Plot map
            scatter(obj.mapsizec, obj.mapsizer, "white")
            scatter(obj.walls(:,2)+.5, obj.walls(:,1)+.5, "black", 'square', ...
                    "filled","SizeData",obj.wall_thickness*2)
            % Plot agent
            scatter(obj.player(2)+.5, obj.player(1)+.5, [], obj.agent_color,"filled",'square', ...
                "SizeData",obj.wall_thickness/2)

            %Plot end
            green = obj.special('green');
            red = obj.special('red');
            scatter(green(2)+.5, green(1)+.5, 'green', "filled", 'square',"SizeData", ...
                obj.wall_thickness)
            scatter(red(2)+.5, red(1)+.5, 'red', "filled", 'square',"SizeData", ...
                obj.wall_thickness)

        end

        function try_move(obj, dr, dc)

            if obj.restart == true
                obj.restart_program()
            end

            new_row = obj.player(1) + dr;
            new_col = obj.player(2) + dc;
            obj.score = obj.score + obj.walk_reward;

           if (new_row >= 1) && (new_row <= obj.mapsize) && (new_col >= 1)...
                   && (new_col <= obj.mapsize) && ~obj.check(new_row, new_col)
            obj.player = [new_row, new_col];


           end

           colorkeys = obj.special.keys;
           for i = 1:length(obj.special)
               temp_info = obj.special(colorkeys{i});

               if new_row == temp_info(1) && new_col == temp_info(2)
                   obj.score = obj.score + temp_info(3) - obj.walk_reward;
                       if obj.score < 0
                            disp("Failed. Score:")
                             disp(obj.score)
                             obj.restart = true;

                       else
                           disp("Success. Score:")
                           disp(obj.score)
                           obj.restart = true;
                       end

               end


           end



        end

        function inside = check(obj, new_row, new_col)
            inside = false;
            for i = 1:length(obj.walls)
                if isequal([new_row, new_col], obj.walls(i,:))
                    inside = true;
                    return
                end
             end
        end

        function restart_program(obj)
            obj.player = [1, 1];
            obj.score = 1;
            obj.restart = false;
            obj.iteration = obj.iteration + 1;
            temp = randi(3);
            obj.agent_color(temp) = rand;
        end
    end
end
