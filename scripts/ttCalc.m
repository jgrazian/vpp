function times = ttCalc(U, theta, Vs)
% Ship speed benchmark on 4-legged reggata
% U are wind speeds on the course in m/s
% theta is vector of wind angles in deg
% V is array boat speed at wind angles in m/s

X = 1000; %Leg length, m

times = zeros(length(U), 1);
for i = 1:length(U)
    V = Vs(:, i);
    if length(theta) ~= length(V)
        error("Theta and V lengths are not the same!")
    end
    
    % ---- SETTING UP ----
    % Get speed at max upwind (Close)
    index = find(V);
    thetaClose = theta(index(1));
    VClose = V(index(1));
    
    % Get speed at ~90deg wind angle (REACH)
    [~, index] = min(abs(theta - 90));
    thetaReach = theta(index);
    %if thetaReach == 90
    %    thetaReach = 0;
    %end
    VReach = V(index);
    
    % Get speed at ~135deg wind angle (Broad)
    [~, index] = min(abs(theta - 135));
    thetaBroad = theta(index);
    VBroad = V(index);
    
    % Get speed downwind (Run)
    [~, index] = min(abs(theta - 180));
    thetaRun = theta(index);
    VRun = V(index);
    
    % ---- BEGIN RUNNING COURSE ----
    t = 0; %Time to run course
    dt = 2; %time step, s
    tTack = 10; %time to tack, s
    
    totalDist = 0; %total distance traveled, m
    offCourse = 0; %Distance traveled off of course
    offCourseLimit = 100; 
    
    while totalDist < X*4
        
        if totalDist < X %Close Hauled
            %disp(["Close", totalDist])
            dDist = abs(VClose * cosd(thetaClose)) * dt;
            offCourse = offCourse + VClose * sind(thetaClose) * dt;
            
            if offCourse >= offCourseLimit
                %disp("Tacking!")
                offCourse = 0;
                t = t + tTack;
            end
            
        elseif totalDist > X && totalDist < 2*X %Beam Reach
            dDist = abs(VReach * sind(thetaReach)) * dt;
        elseif totalDist > 2*X && totalDist < 3*X %Broad Reach
            dDist = abs(VBroad * cosd(thetaBroad)) * dt;
        else %Downwind
            dDist = abs(VRun * cosd(thetaRun)) * dt;
        end
        
        t = t + dt;
        totalDist = totalDist + dDist;
        %disp(totalDist)
    end
    disp("Done course at " + string(U(i)) + "m/s in " + string(t) + "s!")
    
    times(i) = t;
end

end