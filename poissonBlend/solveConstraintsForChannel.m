function [blended_region] = solve_constraints_for_channel( source, source_mask, background, channel )
    %% solve for blending constraints
    [min_x, max_x, min_y, max_y] = determineMaskBounds(source_mask);
    
    % 2: Preallocate Matrices
    iteration_height = max_y - min_y + 1;
    iteration_width = max_x - min_x + 1;
    
    num_equations = 4 * iteration_height * iteration_width + 1;
    num_variables_x = (max_x - min_x + 1);
    num_variables_y = (max_y - min_y + 1); 
    num_variables = num_variables_y * num_variables_x;
    
    im2var = zeros(num_variables_y, num_variables_x);
    im2var(1:num_variables) = 1:num_variables;
    A = sparse([], [], [], num_equations, num_variables, 0);
    c = zeros(num_equations, 1);
    e = 1;

    A(e, im2var(1, 1)) = 1;
    c(e) = background(1, 1);
    e = e + 1;
    
    % 3: Iterate over iteration space
    % downward-right diagonal gradient
    for y = (min_y):(max_y - 1)
        adjusted_y = (y - min_y) + 1;
        for x = (min_x):(max_x - 1)
            adjusted_x = (x - min_x) + 1;
            
            % equation 1 (horizontal gradient +x)
            if (source_mask(y, x) >= 0.0001 || source_mask(y, x + 1) >= 0.0001)  % needs calculation
                if (source_mask(y, x) >= 0.0001 && source_mask(y, x + 1) < 0.0001)  % on horizontal boundary
                    A(e, im2var(adjusted_y, adjusted_x)) = 1;
                    c(e) = source(y, x, channel) - source(y, x + 1, channel) + background(y, x + 1, channel);
                elseif (source_mask (y, x) < 0.0001 && source_mask(y, x + 1) >= 0.0001)
                    A(e, im2var(adjusted_y, adjusted_x + 1)) = 1;
                    c(e) = source(y, x + 1, channel) - source(y, x, channel) + background(y, x, channel);
                else  % inside mask
                    A(e, im2var(adjusted_y, adjusted_x + 1)) = 1;
                    A(e, im2var(adjusted_y, adjusted_x)) = -1;
                    c(e) = source(y, x + 1, channel) - source(y, x, channel);
                end
                
                e = e + 1;
            end
            
            % equation 2 (vertical gradient +y)
            if (source_mask(y, x) >= 0.0001 || source_mask(y + 1, x) >= 0.0001)  % needs calculation
                
                if (source_mask(y, x) >= 0.0001 && source_mask(y + 1, x) < 0.0001)   % on horizontal boundary
                    A(e, im2var(adjusted_y, adjusted_x)) = 1;
                    c(e) = source(y, x, channel) - source(y + 1, x, channel) + background(y + 1, x, channel);
                elseif (source_mask (y, x) < 0.0001 && source_mask(y + 1, x) >= 0.0001)
                    A(e, im2var(adjusted_y + 1, adjusted_x)) = 1;
                    c(e) = source(y + 1, x, channel) - source(y, x, channel) + background(y, x, channel);
                else  % inside mask
                    A(e, im2var(adjusted_y + 1, adjusted_x)) = 1;
                    A(e, im2var(adjusted_y, adjusted_x)) = -1;
                    c(e) = source(y + 1, x, channel) - source(y, x, channel);
                end
                
                e = e + 1;
            end
        end
        
        % handle unvisited column (+y gradient)
        if (source_mask(y, max_x) >= 0.0001 || source_mask(y + 1, max_x) >= 0.0001)  % needs calculation
            adjusted_max_x = max_x - min_x + 1;

            if (source_mask(y, max_x) >= 0.0001 && source_mask(y + 1, max_x) < 0.0001)
                A(e, im2var(adjusted_y, adjusted_max_x)) = 1;
                c(e) = source(y, max_x, channel) - source(y + 1, max_x, channel) + background(y + 1, max_x, channel);
            elseif (source_mask (y, max_x) < 0.0001 && source_mask(y + 1, max_x) >= 0.0001)  % on horizontal boundary        
                A(e, im2var(adjusted_y + 1, adjusted_max_x)) = 1;
                c(e) = source(y + 1, max_x, channel) - source(y, max_x, channel) + background(y, max_x, channel);
            else  % inside mask
                A(e, im2var(adjusted_y + 1, adjusted_max_x)) = 1;
                A(e, im2var(adjusted_y, adjusted_max_x)) = -1;
                c(e) = source(y + 1, max_x, channel) - source(y, max_x, channel);
            end
            
            e = e + 1;
        end
    end
    % handle unvisited row (+x gradient)
    for x = min_x:(max_x - 1)
        adjusted_max_y = max_y - min_y + 1;
        if (source_mask(max_y, x) >= 0.0001 || source_mask(max_y, x + 1) >= 0.0001)  % needs calculation

            if (source_mask(max_y, x) >= 0.0001 && source_mask(max_y, x + 1) < 0.0001)  % on horizontal boundary
                A(e, im2var(adjusted_max_y, adjusted_x)) = 1;
                c(e) = source(max_y, x, channel) - source(max_y, x + 1, channel) + background(max_y, x + 1, channel);
            elseif (source_mask (max_y, x) < 0.0001 && source_mask(max_y, x + 1) >= 0.0001)
                A(e, im2var(adjusted_max_y, adjusted_x + 1)) = 1;
                c(e) = source(max_y, x + 1, channel) - source(max_y, x, channel) + background(max_y, x, channel);
            else  % inside mask
                A(e, im2var(adjusted_max_y, adjusted_x + 1)) = 1;
                A(e, im2var(adjusted_max_y, adjusted_x)) = -1;
                c(e) = source(max_y, x + 1, channel) - source(max_y, x, channel);
            end

            e = e + 1;
        end
    end

    % upward-left diagonal gradient
    for y = (min_y + 1):(max_y)
        adjusted_y = y - min_y + 1;
        for x = (min_x + 1):(max_x)
            adjusted_x = x - min_x + 1;
            
            % equation 3 (horizontal gradient -x)
            if (source_mask(y, x) >= 0.0001 || source_mask(y, x + 1) >= 0.0001)  % needs calculation
                if (source_mask(y, x) >= 0.0001 && source_mask(y, x - 1) < 0.0001)  % on horizontal boundary
                    A(e, im2var(adjusted_y, adjusted_x)) = 1;
                    c(e) = source(y, x, channel) - source(y, x - 1, channel) + background(y, x - 1, channel);
                elseif (source_mask (y, x) < 0.0001 && source_mask(y, x - 1) >= 0.0001)
                    A(e, im2var(adjusted_y, adjusted_x - 1)) = 1;
                    c(e) = source(y, x - 1, channel) - source(y, x, channel) + background(y, x, channel);
                else  % inside mask
                    A(e, im2var(adjusted_y, adjusted_x - 1)) = 1;
                    A(e, im2var(adjusted_y, adjusted_x)) = -1;
                    c(e) = source(y, x - 1, channel) - source(y, x, channel);
                end
                
                e = e + 1;
            end
            
            % equation 4 (vertical gradient -y)
            if (source_mask(y, x) >= 0.0001 || source_mask(y - 1, x) >= 0.0001)  % needs calculation
                
                if (source_mask(y, x) >= 0.0001 && source_mask(y - 1, x) < 0.0001)   % on horizontal boundary
                    A(e, im2var(adjusted_y, adjusted_x)) = 1;
                    c(e) = source(y, x, channel) - source(y - 1, x, channel) + background(y - 1, x, channel);
                elseif (source_mask (y, x) < 0.0001 && source_mask(y - 1, x) >= 0.0001)
                    A(e, im2var(adjusted_y - 1, adjusted_x)) = 1;
                    c(e) = source(y - 1, x, channel) - source(y, x, channel) + background(y, x, channel);
                else  % inside mask
                    A(e, im2var(adjusted_y - 1, adjusted_x)) = 1;
                    A(e, im2var(adjusted_y, adjusted_x)) = -1;
                    c(e) = source(y - 1, x, channel) - source(y, x, channel);
                end
                
                e = e + 1;
            end
        end
        
        % handle unvisited column (-y gradient)
        if (source_mask(y, max_x) >= 0.0001 || source_mask(y - 1, max_x) >= 0.0001)  % needs calculation
            adjusted_max_x = 1;

            if (source_mask(y, max_x) >= 0.0001 && source_mask(y - 1, max_x) < 0.0001)
                A(e, im2var(adjusted_y, adjusted_max_x)) = 1;
                c(e) = source(y, max_x, channel) - source(y - 1, max_x, channel) + background(y - 1, max_x, channel);
            elseif (source_mask (y, max_x) < 0.0001 && source_mask(y - 1, max_x) >= 0.0001)  % on horizontal boundary        
                A(e, im2var(adjusted_y - 1, adjusted_max_x)) = 1;
                c(e) = source(y - 1, max_x, channel) - source(y, max_x, channel) + background(y, max_x, channel);
            else  % inside mask
                A(e, im2var(adjusted_y - 1, adjusted_max_x)) = 1;
                A(e, im2var(adjusted_y, adjusted_max_x)) = -1;
                c(e) = source(y - 1, max_x, channel) - source(y, max_x, channel);
            end
            
            e = e + 1;
        end
    end
    % handle unvisited row (-x gradient)
    for x = (min_x + 1):(max_x - 1)
        adjusted_max_y = 1;
        if (source_mask(max_y, x) >= 0.0001 || source_mask(max_y, x - 1) >= 0.0001)  % needs calculation

            if (source_mask(max_y, x) >= 0.0001 && source_mask(max_y, x - 1) < 0.0001)  % on horizontal boundary
                A(e, im2var(adjusted_max_y, adjusted_x)) = 1;
                c(e) = source(max_y, x, channel) - source(max_y, x - 1, channel) + background(max_y, x - 1, channel);
            elseif (source_mask (max_y, x) < 0.0001 && source_mask(max_y, x - 1) >= 0.0001)
                A(e, im2var(adjusted_max_y, adjusted_x - 1)) = 1;
                c(e) = source(max_y, x - 1, channel) - source(max_y, x, channel) + background(max_y, x, channel);
            else  % inside mask
                A(e, im2var(adjusted_max_y, adjusted_x - 1)) = 1;
                A(e, im2var(adjusted_max_y, adjusted_x)) = -1;
                c(e) = source(max_y, x - 1, channel) - source(max_y, x, channel);
            end

            e = e + 1;
        end
    end
    
    v = A \ c;
    blended_region = zeros(num_variables_y, num_variables_x);
    blended_region(1:num_variables) = v(1:num_variables);

end