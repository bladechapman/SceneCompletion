function [ points ] = getStartEndPts( cost_image )

[height width] = size(cost_image);

min_edges = zeros(4,3);

%top
min_top_value = min(cost_image(1,:));
min_top_index = find(cost_image(1,:)==min_top_value);
min_edges(1, 1) = 1;
min_edges(1, 2) = min_top_index(1);
min_edges(1, 3) = min_top_value;

%bottom
min_bottom_value = min(cost_image(height,:));
min_bottom_index = find(cost_image(height,:)==min_bottom_value);
min_edges(2, 1) = height;
min_edges(2, 2) = min_bottom_index(1);
min_edges(2, 3) = min_bottom_value;

%left
min_left_value = min(cost_image(2:height-1,1));
min_left_index = find(cost_image(2:height-1,1)==min_left_value);
min_edges(3, 1) = min_left_index(1);
min_edges(3, 2) = 1;
min_edges(3, 3) = min_left_value;

%right
min_right_value = min(cost_image(2:height-1,width));
min_right_index = find(cost_image(2:height-1,width)==min_right_value);
min_edges(4, 1) = min_right_index(1);
min_edges(4, 2) = width;
min_edges(4, 3) = min_right_value;

min_edges = unique(min_edges, 'rows');
min_edges = sortrows(min_edges, 3);

points = min_edges(1:2, 1:2);

end

