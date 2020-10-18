

classdef World
    %WORLD Create world for agent to explore
    %   This class will create a world in the form of a matrix to allow the
    %   agent to explore. The class will also include methods that will
    %   create the agent's avatar as well as methods which allow for it to
    %   move

    properties
        player = [1, 1];
        mapsize = 5;
        special
        mapsizer = [mapsize, 1];
        mapsizec = [mapsize, 1];
        walk_reward = -0.01
        walls = [[2, 2]; [2, 3]; [3, 2]; [3, 3]]
        score = 1;
        wall_thickness = 8*(10^3)
        actions = {'up','down','left','right'}
        restart = false;

    end

    methods
        function obj = World()
            obj.special = containers.Map({'green', 'red'}, {[4, 1, 1], [4, 1, -1]});
        end

        function render(obj)
            clf
            hold on;
            % Plot map
            scatter(obj.mapsizer, obj.mapsizec, "white")
            scatter(obj.walls(:,1), obj.walls(:,2), "black", 'square', ...
                    "filled","SizeData",obj.wall_thickness)
            % Plot agent
            scatter(obj.player(1), obj.player(2), 'red')
        end

        function try_move(obj, dr, dc)

            if obj.restart == true
                obj.restart_program()
            end
            new_row = obj.player(1) + dr;
            new_col = obj.player(2) + dc;
            obj.score = obj.score + obj.walk_reward;
           %Check for obstacles
           if (new_row >= 1) && (new_row <= obj.mapsize) && (new_col >= 1)...
                   && (new_col <= obj.mapsize) && ~check(new_row, new_col)
            obj.player = [new_row, new_col];
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

        function restart_program(obj)L

        end
    end
end
