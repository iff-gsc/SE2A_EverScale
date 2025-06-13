
% spanwise coordinates of wing parts (1x(s+1) array), in -
yi = [0,0.085,0.29,0.475,0.685,0.895,1]';
% wing chord (1x(s+1) array), in m
ci           = [0.235,0.235,0.228,0.196,0.164,0.12,0.09]';

y = linspace(0,1,6)';
c = interp1(yi,ci,y,'makima');
figure
hold on

plot( y, c, '-x' )
ylim([0,inf])

yf = [0;y(1:end-1)+diff(y)/2];
f = [0;c(1:end-1)+diff(c)/2];
f = f/sum(f);
% f(:) = 0.1;

plot(yf,f,'-x')

M = zeros(1,length(y));
P = zeros(length(y),length(y));
for i = 1:length(M)-1
    P(i,i+1:end) = f(i+1:end) .* ( yf(i+1:end) - y(i) );
end

M = P*f;

plot(y,M,'-x')

grid on
box on
xlabel('Spanwise location')
legend('Local chord, m','Local lift, N','Local bending moment, Nm')


D0 = 0.006;
t = 0.003;
D = zeros(1,length(y));
d = zeros(1,length(y));
D(1) = D0;
d(1) = D0-t;
Iy0 = stiffness(D0,t);
Iyd = Iy0 * M/M(1);
for i = 2:length(D)
    D(i) = sparDiameter(Iyd(i),D0,t);
end



figure
hold on
stairs(y,D)
stairs(y,D-t)
grid on
box on
xlabel('Spanwise location')
ylabel('Spar diameter, m')



function D = sparDiameter(Iyd,D0,t)
    D = D0;
    while true
        Iy = stiffness(D,t);
        if abs(Iyd-Iy) < 1e-20
            break;
        else
            grad = stiffnessGrad(D,t);
            D = D + (Iyd-Iy) * 1/grad * t;
        end
    end

end

function Iy = stiffness(D,t)
    Iy = pi/4*((D/2)^4-((D-t)/2)^4);
end

function grad = stiffnessGrad(D,t)
    Iy1 = stiffness(D,t);
    Iy2 = stiffness(D + 1e-8,t);
    grad = (Iy2-Iy1)/(1e-8);
end

