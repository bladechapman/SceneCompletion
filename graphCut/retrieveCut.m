function [ cut_mask ] = retrieveCut(im1, im2, boundary_mask, inclusive_mask) 
    cost_image = generateCostImage(im1, im2, boundary_mask);
    
    points = getStartEndPts(cost_image);
    
    tic
    cut_path = dijktraPath(cost_image, boundary_mask, points(1, :), points(2, :));
    disp(toc);
    
    tic
    cut_mask = generateMaskFromPath(cut_path, inclusive_mask, boundary_mask);
    disp(toc);
end

function [cut_mask] = generateMaskFromPath(cut_path, inclusive_mask, boundary_mask)
    comparison_image = inclusive_mask * 2;
    comparison_image = comparison_image + cut_path * 2;
    comparison_image = comparison_image + boundary_mask;
    fill_start = findZeroCoord(comparison_image);
    
    [h, w] = size(comparison_image);
    
    disp('filling mask')
    import java.util.LinkedList
    q = LinkedList();
    q.add(fill_start);
    comparison_image(fill_start(1), fill_start(2)) = -1;
    
    i = 0;
    while q.size() ~= 0
        pixel = q.remove();
        x = pixel(2);
        y = pixel(1);
        
        north = pixel(1) + 1;
        south = pixel(1) - 1;
        east = pixel(2) + 1;
        west = pixel(2) - 1;
        
        i = i + 1;
        disp([i, q.size()]);
        
        if north <= h && (comparison_image(north, x) == 1 || comparison_image(north, x) == 0)
            q.add([north, x]);
            comparison_image(north, x) = -1;
        end
        
        if south >= 1 && (comparison_image(south, x) == 1 || comparison_image(south, x) == 0)
            q.add([south, x]);
            comparison_image(south, x) = -1;
        end
        
        if east <= w && (comparison_image(y, east) == 1 || comparison_image(y, east) == 0)
            q.add([y, east]);
            comparison_image(y, east) = -1;
        end
        
        if west >= 1 && (comparison_image(y, west) == 1 || comparison_image(y, west) == 0)
            q.add([y, west]);
            comparison_image(y, west) = -1;
        end
    end
    disp('done')
    
    disp('correcting vals')
    comparison_image = comparison_image + 1;
    comparison_image = ceil(comparison_image / 3);
    disp('done')
    
    cut_mask = comparison_image;
end

function [zero_coord] = findZeroCoord(image)
    [h, w] = size(image);
    found_flag = 0;
    for x = 1:w
        for y = 1:h
            if (image(y, x) == 0)
                zero_coord = [y, x];
                found_flag = 1;
                break;
            end
        end
        if found_flag == 1;
            break;
        end
    end
end

function [ cost_image ] = generateCostImage( im1, im2, boundary_mask )
%RETRIEVE_CUT Summary of this function goes here
%   Detailed explanation goes here
    cost_image = imcomplement(boundary_mask) * 500;
    rgb_boundary_mask = repmat(boundary_mask, [1, 1, 3]);
    im1_masked = rgb_boundary_mask .* im1;
    im2_masked = rgb_boundary_mask .* im2;
    
    ssd = sum((im1_masked - im2_masked).^2, 3);
    cost_image = cost_image + ssd;
end

function [cut_path] = dijktraPath(cost_image, boundary_mask, start_point, end_point)
    javaaddpath './graphCut';
    import java.util.PriorityQueue;
    
    [h, w] = size(cost_image);
    nodes(1:h, 1:w) = GraphNode();
    disp('Generating cut nodes');
    for y = 1:h
        for x = 1:w
            nodes(y, x) = GraphNode(x, y, 10000);
            
        end
    end
    disp('Done!') 
    nodes(start_point(1), start_point(2)).weight = 0;
   
    q = PriorityQueue();
    q.add(nodes(start_point(1), start_point(2)));
    cut_path = zeros(h, w);
    
    disp('Computing dijsktra');
    while q.size() ~= 0
        pixel = q.remove();
        x = pixel.x;
        y = pixel.y;
        p_w = pixel.weight;
        
        disp([y, x, q.size()]);
        
        if y == end_point(1) && x == end_point(2)
            disp('found!')
            disp([y, x])
            
            cut_path = constructPath(nodes(y, x), h, w);
            break;
        end
        
        % for each neighbor of pixel
        if y < h && boundary_mask(y + 1, x) == 1
            north = nodes(y + 1, x);
            alt = p_w + cost_image(y + 1, x);
            if alt < north.weight
                north.weight = alt;
                north.prev = pixel;
                if ~q.contains(north)
                    q.add(north);
                end
            end
        end
        if y > 1 && boundary_mask(y - 1, x) == 1
            south = nodes(y - 1, x);
            alt = p_w + cost_image(y - 1, x);
            if alt < south.weight
                south.weight = alt;
                south.prev = pixel;
                if ~q.contains(south)
                    q.add(south);
                end
            end
        end
        if x < w && boundary_mask(y, x + 1) == 1
            east = nodes(y, x + 1);
            alt = p_w + cost_image(y, x + 1);
            if alt < east.weight
                east.weight = alt;
                east.prev = pixel;
                if ~q.contains(east)
                    q.add(east);
                end
            end
        end
        if x > 1 && boundary_mask(y, x - 1) == 1
            west = nodes(y, x - 1);
            alt = p_w + cost_image(y, x - 1);
            if alt < west.weight
                west.weight = alt;
                west.prev = pixel;
                if ~q.contains(west)
                    q.add(west);
                end
            end
        end
    end
end

function [cut_mask] = constructPath(end_node, height, width)
    cut_mask = zeros(height, width);
    iter_node = end_node;
    while(~isempty(iter_node.prev))
        x = iter_node.x;
        y = iter_node.y;
        
        cut_mask(y, x) = 1;
        
        iter_node = iter_node.prev;
    end
end
