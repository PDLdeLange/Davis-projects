function output = H_bikeplusrider(u,X)
        global Kphi Kphid Kdelta Kpsi Ky;


    % Parameters
    Kphi    = X(1); %#ok<*NASGU>
    Kphid   = X(2);
    Kdelta  = X(3);
    Kpsi    = X(4);
    Ky      = X(5);

    global Kphi Kphid Kdelta Kpsi Ky;

    
    Kn = 0;

    Gnm     = tf(900,[1 2*.707*30  900]);

    A = [0 1 0 0; 7.9468 -0.1505 -19.4598  -1.1604; 0 0 0 1; 19.8927 7.6349 -29.5611 -17.3444];
    B = [0 0; 0.0117 -0.0867; 0 0; -0.0867 4.4005];
    C = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1];
    bike = ss(A,B,C,[]);

    sim('model_rider');

    output.z = z;
    output.y = y;
    output.u = u;


