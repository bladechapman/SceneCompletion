function [ cut_mask ] = retrieveCut(im1, im2, boundary_mask) 
    cost_image = generateCostImage(im1, im2, boundary_mask);
    
    figure(2), imagesc(cost_image);
    pause;
    
    figure(3), imshow(boundary_mask);
    pause;
    
    tic
    dijktraPath(cost_image, boundary_mask, [300, 1], [300, 450]);
    disp(toc);
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

function dijktraPath(cost_image, boundary_mask, start_point, end_point)
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
