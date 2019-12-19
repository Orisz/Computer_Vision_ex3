% HW3 ex 2
 
inl1;
 
%% Build matrix A:
 
u_vec = pts2d(1,:)./pts2d(3,:);
v_vec = pts2d(2,:)./pts2d(3,:);
 
NumOfPointsIn3d = size(pts3d,2);
 
A = [];
valid_ind = 0;
zero_vec = zeros(1,4);
 
% Original caclulation - order of points as given to us, giving det(P(1:3,1:3)) < 0:
% for point_ind = 1:NumOfPointsIn3d    
 
% We changed order of points, and got a new P, with det(P(1:3,1:3)) > 0:
for point_ind = NumOfPointsIn3d:-1:1    
    if isnan(u_vec(point_ind))  
        continue
    end
    valid_ind = valid_ind+1;
    currAInd = 2*(valid_ind-1) + 1;
    point3d = pts3d(:,point_ind);
    u = u_vec(point_ind);
    v = v_vec(point_ind);
    
    A(currAInd,1:12)   = [point3d.' zero_vec  -u*point3d.'];
    A(currAInd+1,1:12) = [zero_vec  point3d.' -v*point3d.'];
end
 
[U,D,V] = svd(A);
 
v_min = V(:,12);
 
P = reshape(v_min,4,3).';
 
%% b. 
% Re-project all the real world point X to their estimated corresponded points x on the
% image plane using the estimated matrix P . Define a way to calculate the estimation error
% based on x . Explain the error measure you defined. What are its units?
 
PcamEstimationVarXX = 0;
PcamEstimationVarXY = 0;
PcamEstimationVarYY = 0;
NumValidPoints = 0;
 
for point_ind = 1:NumOfPointsIn3d
    p_gal(:,point_ind) = P*pts3d(:,point_ind);    
    p_gal(:,point_ind) = p_gal(:,point_ind)./p_gal(3,point_ind);    
    
    if ~isnan(u_vec(point_ind))
        dx = (p_gal(1,point_ind) - u_vec(point_ind));
        dy = (p_gal(2,point_ind) - v_vec(point_ind));
        PcamEstimationVarXX = PcamEstimationVarXX + dx*dx;
        PcamEstimationVarXY = PcamEstimationVarXY + dx*dy;
        PcamEstimationVarYY = PcamEstimationVarYY + dy*dy;
        NumValidPoints = NumValidPoints+1;
    end
end
 
PcamEstimationCovar = [PcamEstimationVarXX PcamEstimationVarXY
                       PcamEstimationVarXY PcamEstimationVarYY] ./ NumValidPoints;
 
PcamEstimationRMS = sqrt([PcamEstimationCovar(1,1); PcamEstimationCovar(2,2)]);

figure(1);
plot(p_gal(1,:),p_gal(2,:),'or');
legend('Ancore points','Transformed  points');
 
% 3 different methode to calculate K and R:
 
% Methode 1:
[K1 R1] = rq(P(1:3,1:3));
 
% Methode 2:
[R_inv,K_inv] = qr(inv(P(1:3,1:3)));
K2 = inv(K_inv);
R2 = inv(R_inv);
 
% Methode 3:
[Q3,R3] = qr(rot90(P(1:3,1:3),3));
R3 = rot90(R3,2).';
Q3 = rot90(Q3);
 
% We use the first methode:
K = K1;
R = R1;
 
K_homogenic = K ./ K(3,3);

theta = -asin(R(3,1))/pi*180
psi = atan2(R(3,2),R(3,3))/pi*180
phi = atan2(R(2,1)/cosd(theta),R(3,3)/cosd(theta))/pi*180
 
t = inv(K)*P(1:3,4);
c = -inv(R)*t;

Vector_From_Camera_To_Goal_Frame = c-[-3.66;0;2.44];
Distance_From_Camera_To_Goal_Frame = sqrt(Vector_From_Camera_To_Goal_Frame.'*Vector_From_Camera_To_Goal_Frame);

figure(2);
plot3(c(1),c(2),c(3),'sr');
grid;
 
%%
% h. Using all the above information, can you determine if the ball actually crossed the goal line?
% If yes, give an explanation and calculation. If not, explain why.
 
w = 0.0005455;
 
ball_most_left_point = [1580; 675; 1];
b1 = ball_most_left_point * w - P(1:3,4);
ball_most_left_coordinates = inv(P(1:3,1:3)) * b1 
 
ball_most_right_point = [1626; 680; 1];
b2 = ball_most_right_point * w - P(1:3,4);
ball_most_right_point_coordinates = inv(P(1:3,1:3)) * b2
 
ball_most_top_point = [1599; 662; 1];
b3 = ball_most_top_point * w - P(1:3,4);
ball_most_top_coordinates = inv(P(1:3,1:3)) * b3 
 
ball_most_bottom_point = [1599; 697; 1];
b4 = ball_most_bottom_point * w - P(1:3,4);
ball_most_bottom_point_coordinates = inv(P(1:3,1:3)) * b4
 
players_foot_point = [1617;930;1];
b5 = players_foot_point * w - P(1:3,4);
players_foot_coordinates = inv(P(1:3,1:3)) * b5 
 
f = figure(1);
legend off
plot(ball_most_left_point(1),ball_most_left_point(2),'xr');
plot(ball_most_right_point(1),ball_most_right_point(2),'xr');
plot(ball_most_top_point(1),ball_most_top_point(2),'xr');
plot(ball_most_bottom_point(1),ball_most_bottom_point(2),'xr');
plot(players_foot_point(1),players_foot_point(2),'xr');

