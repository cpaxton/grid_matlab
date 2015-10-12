function T = twist2pose(t)
  % TWIST2POSE
  %   t: twist 6x1
  %
  %   T: pose 4x4

  xyz = t(1:3);
  ax = t(4);
  ay = t(5);
  az = t(6);

  Ts = [0, -az, ay;
        az, 0, -ax;
        -ay, ax, 0];

  T = [expm(Ts), xyz; 
       0, 0, 0, 1];
end
